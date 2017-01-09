//
//  ViewAnnounce.m
//  Kanito
//
//  Created by Luciano Lc on 08/09/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewAdopList.h"
#import "CellAdopList.h"
#import "ViewAdFilter.h"
#import "ViewAdopDett.h"

@interface ViewAdopList ()  < ViewAdFilterDelegate , MyNavigationBarDelegate > {
    int menuClicked;
    NSArray *arrAdvsList;
    IBOutlet UITableView *tblAdvsList;
    
    NSInteger pagNum;
    NSInteger maxRec;

    NSString *strFilterGen;
    NSString *strFilterAge;
    NSString *strFilterSiz;
    NSString *strFilterPri;
    NSString *strFilterPed;
    NSString *strFilterBrd;
}
@end

@implementation ViewAdopList

- (void)viewDidLoad {
    [super viewDidLoad];
    pagNum = 1;
    maxRec = 10;
    
    strFilterGen = @"";
    strFilterAge = @"";
    strFilterSiz = @"";
    strFilterPri = @"";
    strFilterPed = @"";
    strFilterBrd = @"";
    
    [self retriveAdvsList];
}

- (void) myNavigatorOptionButtonTapped {
    ViewAdFilter *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewAdFilter"];
    ctrl.delegate = self;
    ctrl.arrAd = arrAdvsList;
    [self.navigationController showViewController:ctrl sender:self];
}

- (void) retriveAdvsList {
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"cldsection/retrive-ads";
    request.json = @{
                     @"lang_id"       : [ClsLang langId],
                     @"page"          : @(pagNum),
                     @"maxrecords"    : @(maxRec),
                     @"img_width"     : @"130",
                     @"img_height"    : @"100",
                     @"img_crop"      : @"2",
                     @"img_bg"        : @"ffffff", // @"e7edef",
                     @"size_id"       : strFilterSiz,
                     @"breed_id"      : strFilterBrd,
                     @"gender_id"     : strFilterGen,
                     @"price_id"      : strFilterPri,
                     @"age_id"        : strFilterAge,
                     @"pedigree_id"   : strFilterPed,
                     @"type"          : @"adoption", // "sale"
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     [self httpResponse:resultDict];
                 }
             }];
}

- (void) httpResponse:(NSDictionary *)dicResult {
    if (dicResult == nil)
        return;
    NSArray *arr = dicResult[@"classifieds"];
    if (pagNum == 1)
        arrAdvsList = arr;
    else
        arrAdvsList = [arrAdvsList arrayByAddingObjectsFromArray:arr];
    if (arr.count < maxRec)
        pagNum = 0;
    [tblAdvsList reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAdvsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CellAdopList *cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdopList"];
    [cell loadWithDic:arrAdvsList[indexPath.row]];
    if (indexPath.row == arrAdvsList.count - 1 && pagNum > 0) {
        pagNum++;
        [self retriveAdvsList];
    }
    return cell;
}

#pragma mark - Table view delegate

#define nextCtrl @"ViewAdopDett"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:nextCtrl sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewAdFilter"]) {
        ViewAdFilter *ctrl = segue.destinationViewController;
        ctrl.delegate = self;
        ctrl.arrAd = arrAdvsList;
    }
    if ([segue.identifier isEqualToString:nextCtrl]) {
        ViewAdopDett *ctrl = segue.destinationViewController;
        NSIndexPath *indexPath = tblAdvsList.indexPathForSelectedRow;
        NSDictionary *dic = arrAdvsList[indexPath.row];
        ctrl.dicAd = dic[@"Cldsection"];
        [tblAdvsList deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void) exitViewAdFilterSetGender:(NSString *)strGen
                               Age:(NSString *)strAge
                              Size:(NSString *)strSiz
                             Breed:(NSString *)strBrd
                             Price:(NSString *)strPri
                          Pedigree:(NSString *)strPed {
    strFilterGen = strGen;
    strFilterAge = strAge;
    strFilterSiz = strSiz;
    strFilterBrd = strBrd;
    strFilterPri = strPri;
    strFilterPed = strPed;
    pagNum = 1;
    [self retriveAdvsList];
}
@end
