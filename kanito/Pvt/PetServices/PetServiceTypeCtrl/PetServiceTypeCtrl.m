//
//  ViewTypeList.m
//  Kanito
//
//  Created by Luciano Calderano on 10/04/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "PetServiceTypeCtrl.h"
#import "ViewPetSrvList.h"

#import "ClsPetSrv.h"
#import "MyRefreshControl.h"

#import "PetServiceTypeCell.h"
#import "PetServiceTypeHeader.h"

@interface PetServiceTypeCtrl () {
    MyRefreshControl *myRefreshControl;
}
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSArray *groupArray;

@end

static NSString *strKeyGrp = @"group_name";
static NSString *strKeyAct = @"activities";

@implementation PetServiceTypeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedArray = [NSMutableArray arrayWithArray:[ClsPetSrv getPetServicesIdSelected]];
    myRefreshControl = [MyRefreshControl addToView:self.collectionView
                                            target:self
                                          selector:@selector(downloadPetSetvicesList)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSDictionary *dic = [ClsPetSrv getSavedPetServicesList];
    if (dic) {
        [self loadCollectionWithDict:dic];
    }
    else {
        [self downloadPetSetvicesList];
    }
}

- (void) downloadPetSetvicesList {
    [self.selectedArray removeAllObjects];
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"biz/activities";
    request.json = @{
                     @"lang_id" : [ClsLang langId],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 [self httpResponse:resultDict];
             }];
    [myRefreshControl endRefreshing];
}

- (void) httpResponse:(NSDictionary *) dicExit {
    [ClsPetSrv setPetSrvListAndSaveImages:dicExit];
    [self loadCollectionWithDict:dicExit];
}

- (void) loadCollectionWithDict:(NSDictionary *) dic {
    self.groupArray = [self arrayFromDic:dic];
    [self.collectionView reloadData];
}

- (NSArray *) arrayFromDic:(NSDictionary *) dic {
    NSArray *activitiesArray = [self getArrayFromDic:dic];
    NSMutableArray *groupArray = [NSMutableArray arrayWithCapacity:activitiesArray.count];
    for (NSDictionary *dic in activitiesArray) {
        NSArray *sortedKeys = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
        }];
        
        NSMutableArray *array = [NSMutableArray array];
        NSString *groupName = @"?";
        for (NSString *key in sortedKeys) {
            if ([key isEqualToString:strKeyGrp]) {
                groupName = [dic getString:key];
            }
            else {
                [array addObject:[dic getDictionary:key]];
            }
        }
        NSDictionary *dic = @{
                              strKeyGrp : groupName,
                              strKeyAct : array.mutableCopy
                              };
        [groupArray addObject:dic];
    }
    return groupArray.mutableCopy;
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groupArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = self.groupArray[section];
    return [self getArrayFromDic:dic].count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PetServiceTypeHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PetServiceTypeHeader" forIndexPath:indexPath];
    
    NSDictionary *dic = self.groupArray[indexPath.section];
    headerView.title.text = [NSString stringWithFormat:@" %@ ", [dic getString:strKeyGrp]];
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PetServiceTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PetServiceTypeCell" forIndexPath:indexPath];

    cell.dict = [self dicAtIndexPath:indexPath];
    cell.selected = [self.selectedArray containsObject:cell.idService];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PetServiceTypeCell *cell = (PetServiceTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectedArray containsObject:cell.idService])
        [self.selectedArray removeObject:cell.idService];
    else
        [self.selectedArray addObject:cell.idService];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}


- (IBAction) selectAll:(id)sender {
    NSDictionary *dic;
    NSInteger tot = 0;
    for (dic in self.groupArray) {
        tot += [self getArrayFromDic:dic].count;
    }
    
    NSInteger selected = self.selectedArray.count;
    [self.selectedArray removeAllObjects];
    if (selected < tot) {
        for (dic in self.groupArray) {
            for (NSDictionary *serviceDic in [self getArrayFromDic:dic]) {
                [self.selectedArray addObject:[serviceDic getString:@"id"]];
            }
        }
    }
    [self.collectionView reloadData];
}

- (NSDictionary *) dicAtIndexPath:(NSIndexPath *) indexPath {
    NSDictionary *dic = self.groupArray[indexPath.section];
    NSArray *arr = [self getArrayFromDic:dic];
    return  arr[indexPath.row];
}

- (NSArray *) getArrayFromDic:(NSDictionary *) dic {
    return [dic getArray:strKeyAct];
}

- (IBAction) startSrch:(id)sender {
    if (self.selectedArray.count == 0)
        return;
    [ClsPetSrv setPetSrvSelected:self.selectedArray.mutableCopy];
    
    if (self.delegate) {
        [self.delegate exitPetServiceType];
        [self.navigationController popViewControllerAnimated:YES];
        self.delegate = nil;
    }
    else {
        UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPetSrvSrchType"];
        [self.navigationController showViewController:ctrl sender:self];
    }
}
@end
