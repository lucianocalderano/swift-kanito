//
//  ViewPvtStart.m
//  Kanito
//
//  Created by Luciano Calderano on 10/04/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ViewPetSrvCityList.h"
#import "ClsPetSrv.h"
#import "ClsSettings.h"
#import "MyRefreshControl.h"

@interface ViewPetSrvCityList () < UITextFieldDelegate > {
    IBOutlet UITableView *tblListCity;
    IBOutlet UITextField *txtSrch;

    NSArray *arrListCity;
    NSArray *arrListCityFull;
    MyRefreshControl *myRefreshControl;
}

@end

@implementation ViewPetSrvCityList

- (void)viewDidLoad {
    [super viewDidLoad];
    arrListCityFull = (NSArray *)[ClsSettings getObjForKey:userArrayListCities];
    if (arrListCityFull.count > 0)
        arrListCity = arrListCityFull;
    else
        [self loadListCity];
    myRefreshControl = [MyRefreshControl addToView:tblListCity
                                            target:self
                                          selector:@selector(loadListCity)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = keyLang(@"petSrvCityList.Title");
}

- (void) loadListCity {
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"retrieve-provinces";
    request.json = @{
                     @"lang_id"       : [ClsLang langId],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 [self httpResponse:resultDict];
             }];
    [myRefreshControl endRefreshing];
}

- (void) httpResponse:(NSDictionary *) dicExit {
    arrListCityFull = [dicExit getArray:@"provinces"];
    arrListCity = arrListCityFull;
    [tblListCity reloadData];
    [ClsSettings setObj:arrListCityFull ForKey:userArrayListCities];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrListCity.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dic = arrListCity[indexPath.row];
    cell.textLabel.text = [dic getString:@"Province.name"];
    cell.textLabel.font = [MyFont fontSize:17];
    return cell;
}

#pragma mark - Table view delegate

static NSString *strSegue = @"ViewPetSrvLst";

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *idx = tblListCity.indexPathForSelectedRow;
    NSDictionary *dic = arrListCity[idx.row][@"Province"];
    ClsPetSrv *cls = [ClsPetSrv getClassId];
    cls.dicSelectedCity = dic;
    
//    [ClsPetSrv setPetSrvSelectedCity:dic];
    [tblListCity deselectRowAtIndexPath:idx animated:NO];
    if ([UIDevice currentDevice].systemVersion.floatValue < 8)
        [self pushViewCtrl:@"ViewPetSrvList"];
    else
        [self performSegueWithIdentifier:strSegue sender:self];
}

- (void) pushViewCtrl:(NSString *) strViewCtrl {
    UIViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:strViewCtrl];
    [self.navigationController showViewController:ctrl sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [txtSrch resignFirstResponder];
    return YES;
}

- (IBAction)textSrchChanged {
    if (txtSrch.text.length == 0) {
        arrListCity = arrListCityFull;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Province.name contains[c] %@", txtSrch.text ];
        arrListCity = [arrListCityFull filteredArrayUsingPredicate:predicate];
    }
    [tblListCity reloadData];
}
@end
