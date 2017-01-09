//
//  ViewAlbumLst.m
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewRegBizAct.h"

@interface ViewRegBizAct () {
    IBOutlet UITableView *tblActs;
    
    NSArray *arrActs;
    NSMutableSet *setSelectedIdx;
    IBOutlet UIButton *btnSelected;
    ClsRegUserBiz *clsRegUserBiz;
    id delegate;
}
@end

@implementation ViewRegBizAct

- (void)viewDidLoad {
    [super viewDidLoad];
    setSelectedIdx = [[NSMutableSet alloc] init];
    btnSelected.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = keyLang(@"regUserBizOpts.TitleActivities");
}

- (void) clsRegUserBizId:(ClsRegUserBiz *)cls Delegate:(id)delegateMain {
    clsRegUserBiz = cls;
    delegate = delegateMain;

    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"biz/activities";
    request.json = @{
                     @"lang_id" : [ClsLang langId]
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 [self httpResponse:resultDict];
             }];
}

- (void) httpResponse:(NSDictionary *) dicExit {
    NSMutableArray *arrItems = [[NSMutableArray alloc] init];
    NSArray *arr = dicExit[@"activities"];
    for (NSDictionary *dicGrp in arr) {
        for (NSString *s in dicGrp.allKeys) {
            NSDictionary *dic = dicGrp[s];
            if ([s isEqualToString:@"group_name"])
                continue;
            dic = @{ @"Activity" : @{
                             @"id"   : dic[@"id"],
                             @"name" : dic[@"name"]
                             }
                     };
            [arrItems addObject:dic];
        }
    }
    arrActs = [arrItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1[@"Activity"][@"name"] compare:obj2[@"Activity"][@"name"]];
    }];
    [tblActs reloadData];
}

#pragma mark - Table view data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrActs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [MyFont fontSize:17];
    }
    cell.accessoryType = [setSelectedIdx containsObject:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    NSDictionary *dic = arrActs[indexPath.row];
    cell.textLabel.text = [dic getString:@"Activity.name"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([setSelectedIdx containsObject:indexPath])
        [setSelectedIdx removeObject:indexPath];
    else
        [setSelectedIdx addObject:indexPath];
    if (setSelectedIdx.count == 0) {
        btnSelected.hidden = YES;
    }
    else {
        btnSelected.hidden = NO;
        NSString *s = keyLang(@"regUserBizOpts.SelActivities");
        s = [s stringByReplacingOccurrencesOfString:@"$$"
                                         withString:(@(setSelectedIdx.count)).stringValue];
        [btnSelected setTitle:s forState:UIControlStateNormal];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Activities list

- (IBAction) saveActivitiesSelected {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in setSelectedIdx) {
        NSDictionary *dic = arrActs[indexPath.row];
        [arr addObject:[dic getString:@"Activity.id"]];
    }
    clsRegUserBiz.activity.arrId = arr;
    [delegate exitViewRegBizAct];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
