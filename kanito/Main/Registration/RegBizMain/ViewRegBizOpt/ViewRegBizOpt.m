//
//  ViewAlbumLst.m
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewRegBizOpt.h"

@interface ViewRegBizOpt () < UISearchBarDelegate > {
    IBOutlet UITableView *tblOpts;
    IBOutlet UISearchBar *srch;
    
    NSArray *arrOpts;
    NSArray *arrOptsFull;
    regUserBiz_Items nextItem;
    regUserBiz_Items itemList;
    NSString *strIdRegion;
    NSString *strDicKeySub;
    NSString *pageTitle;
    
    NSMutableSet *setSelectedIdx;
    UIButton *btnSelected;
    
    ClsRegUserBiz *clsRegUserBiz;
    id delegate;
}
@end

@implementation ViewRegBizOpt

- (void)viewDidLoad {
    [super viewDidLoad];
    setSelectedIdx = [[NSMutableSet alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = pageTitle;
}

- (void) clsRegUserBizId:(ClsRegUserBiz *)cls Delegate:(id)delegateMain Item:(regUserBiz_Items)item {
    clsRegUserBiz = cls;
    delegate = delegateMain;
    [self startWithItem:item];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        arrOpts = arrOptsFull;
    }
    else {
        NSString *s = [NSString stringWithFormat:@"%@.name", strDicKeySub];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", s, searchText];
        arrOpts = [arrOptsFull filteredArrayUsingPredicate:predicate];
    }
    [tblOpts reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void) startWithItem:(regUserBiz_Items)item {
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    itemList = item;

    NSString *strMainDicKey;
    nextItem = regUserBiz_None;
    switch (item) {
        case regUserBiz_Region:
            nextItem = regUserBiz_City;
            pageTitle = keyLang(@"regUserBizOpts.TitleRegions");
            request.page = @"regions-list";
            strMainDicKey = @"regions";
            strDicKeySub = @"Region";
            request.json = @{ };
            break;
        case regUserBiz_City:
            pageTitle = keyLang(@"regUserBizOpts.TitleCity");
            request.page = @"cities-list";
            strMainDicKey = @"cities";
            strDicKeySub = @"City";
            request.json = @{
                             @"region_id" : strIdRegion
                             };
            break;
        case regUserBiz_Country:
            pageTitle = keyLang(@"regUserBizOpts.TitleCountries");
            request.page = @"countries-list";
            strMainDicKey = @"countries";
            strDicKeySub = @"Country";
            request.json = @{
                             @"list_type" : @"iso"
                             };
            break;
        default:
            return;
    }
    
    self.myNavigationBar.titolo = pageTitle;

    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 [self httpResponse:resultDict item:item key:strMainDicKey];
             }];
}

- (void) httpResponse:(NSDictionary *) dicExit item:(regUserBiz_Items)item key:(NSString *) strMainDicKey{
    arrOptsFull = dicExit[strMainDicKey];
    arrOpts = arrOptsFull;
    [tblOpts reloadData];
}

#pragma mark - Table view data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrOpts.count;
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
    NSDictionary *dic = arrOpts[indexPath.row];
    dic = dic[strDicKeySub];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = arrOpts[indexPath.row];
    dic = dic[strDicKeySub];
    if (nextItem == regUserBiz_None) {
        switch (itemList) {
            case regUserBiz_City:
                clsRegUserBiz.city.strId = dic[@"id"];
                clsRegUserBiz.city.strName = dic[@"name"];
                break;
            case regUserBiz_Country:
                clsRegUserBiz.country.strIso = dic[@"iso"];
                clsRegUserBiz.country.strName = dic[@"name"];
                break;
            default:
                break;
        }
        [delegate exitViewRegBizOptWithItem:itemList];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        strIdRegion = dic[@"id"];
        [self startWithItem:nextItem];
    }
}

@end
