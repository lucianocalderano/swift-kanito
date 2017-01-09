//
//  ViewAnnounce.m
//  Kanito
//
//  Created by Luciano Lc on 08/09/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewPetSrvList.h"
#import "ViewPetSrvDett.h"
#import "ClsPetSrv.h"
#import "CellPetSrvList.h"
#import "PetServiceTypeCtrl.h"

@interface ViewPetSrvList () < CellPetSrvListDelegate, MyNavigationBarDelegate, PetServiceTypeCtrlDelegate > {
    IBOutlet UITableView *tblPetSrvList;
    IBOutlet UILabel *lblFooter;
    NSArray *arrPetSrvList;
    NSInteger pagNum;
    NSInteger maxRec;
    NSString *strMyId;
    ClsPetSrv *clsPetSrv;
    BOOL lastPage;
}
@end

@implementation ViewPetSrvList

- (void)viewDidLoad {
    [super viewDidLoad];
    pagNum = 1;
    maxRec = 10;
    if (clsPetSrv == nil) {
        lastPage = NO;
        clsPetSrv = [ClsPetSrv getClassId];
    }

    NSString *strSelCity = clsPetSrv.dicSelectedCity[@"id"];
    if (strSelCity.length > 0)
        [self loadPetServiceList];
    else
        [self footerLabelWitString:@(arrPetSrvList.count).stringValue];
    strMyId = [ClsUser userId];
    self.myNavigationBar.barDelegate = self;
}

- (void) exitPetServiceType {
    lastPage = NO;
    pagNum = 1;
    [self loadPetServiceList];
}

- (void) loadPetServiceList {
    [ClsPetSrv loadPetSrvListPagNum:pagNum
                           mainView:self.view
                          MaxRecord:maxRec
                           Complete:^(NSString *strNumRec) {
                               [self loadResult:strNumRec];
                           }];
}

- (void) loadResult:(NSString *) strNumRec {
    if (pagNum == 1)
        arrPetSrvList = clsPetSrv.arrPetServices;
    else
        arrPetSrvList = [arrPetSrvList arrayByAddingObjectsFromArray:clsPetSrv.arrPetServices];
    if (clsPetSrv.arrPetServices.count < maxRec)
        lastPage = YES;
    [tblPetSrvList reloadData];
    [self footerLabelWitString:strNumRec];
}

- (void) footerLabelWitString:(NSString *)strNumRec {
    lblFooter.text = [keyLang(@"petSrv.Found") stringByReplacingOccurrencesOfString:@"#"
                                                                         withString:strNumRec];
}

- (void) showListFromMap:(NSArray *) arrListFromMap {
    clsPetSrv = [ClsPetSrv getClassId];
    arrPetSrvList = clsPetSrv.arrPetServices;
    lastPage = YES;
    [tblPetSrvList reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrPetSrvList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellPetSrvList *cell = [tableView dequeueReusableCellWithIdentifier:[CellPetSrvList cellId]];
    cell.delegate = self;
    cell.dicPetSrv = arrPetSrvList[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewPetSrvDett *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewPetSrvDett"];
    ctrl.dicPetService = arrPetSrvList[indexPath.row];
    [self.navigationController showViewController:ctrl sender:self];
    [tblPetSrvList deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Cell delegate

- (void)followTapped:(CellPetSrvList *) cell {
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"follow-function";
    request.json = @{
                     @"action"         : @"follow",
                     @"followed_id"    : [cell.dicPetSrv getString:@"Svcsection.id"],
                     @"followed_type"  : defUserBiz,
                     @"follower_id"    : [ClsUser userId],
                     @"follower_type"  : [ClsUser userType],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     cell.followStatus = YES;
                 }
             }];
}


- (void) myNavigatorOptionButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:keyLang(@"petSrvList.ActionTitle")
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action;
    action = [UIAlertAction actionWithTitle:keyLang(@"cancel")
                                             style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action) {
                                           }];
    [alert addAction:action];
    
    action = [UIAlertAction actionWithTitle:keyLang(@"petSrvList.ActionModFilt")
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               PetServiceTypeCtrl *ctrl = [self.storyboard instantiateInitialViewController];
                                               ctrl.delegate = self;
                                               [self.navigationController showViewController:ctrl sender:self];
                                           }];
    [alert addAction:action];
    
    action = [UIAlertAction actionWithTitle:keyLang(@"petSrvList.ActionModCity")
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
    [alert addAction:action];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
