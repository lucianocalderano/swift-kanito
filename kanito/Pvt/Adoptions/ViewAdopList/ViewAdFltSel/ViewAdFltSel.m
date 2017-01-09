//
//  ViewAlbumLst.m
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewAdFltSel.h"

@interface ViewAdFltSel () <UITextFieldDelegate> {
    IBOutlet UITableView *tblAdFltSel;
    NSArray *arrOptions;
    NSArray *arrOptFull;
    NSDictionary *dicAlfabeto;

    NSString *strFeature;
    NSString *strSrch;
    IBOutlet UITextField *txtSrch;
    IBOutlet UIImageView *imvSrch;
    IBOutlet UIView *viewBreed;
    IBOutlet NSLayoutConstraint *viewBreedHeight;
}
@end

@implementation ViewAdFltSel {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewBreed.hidden = YES;
    viewBreedHeight.constant = 0;
    [tblAdFltSel needsUpdateConstraints];

//    tblAdFltSel.contentInset = UIEdgeInsetsMake(-20.0f, 0.0f, 0.0f, 0.0f);
}

- (void) configFilter:(NSString *)strTitle Feature:(NSString *) feature{
    self.titolo = strTitle;
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page =@"dog-feature-list";
    request.json = @{
                     @"lang_id" : [ClsLang langId],
                     @"feature" : feature,
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 [self responseDogFeatureList:resultDict];
             }];
}

- (void) responseDogFeatureList:(NSDictionary *)dicResult {
    NSArray *arr = dicResult[@"Features"];
    NSDictionary *dicTmp = @{
                             @"Feature" : @{
                                     @"id"   : @"",
                                     @"name" : keyLang(@"FilterNo"),
                                     },
                             };
    arrOptions = [@[dicTmp] arrayByAddingObjectsFromArray:arr];
    arrOptFull = [NSArray arrayWithArray:arrOptions];
    [tblAdFltSel reloadData];
    if ([self.titolo isEqualToString:keyLang(@"FilterBr")]) {
        viewBreed.hidden = NO;
        viewBreedHeight.constant = 65;
        [tblAdFltSel needsUpdateConstraints];
        
    }
}

#pragma mark - Text search delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [txtSrch resignFirstResponder];
    return YES;
}

- (IBAction)textSrchChanged {
    strSrch = txtSrch.text;
    if (txtSrch.text.length == 0) {
        arrOptions = arrOptFull;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"Feature.name", txtSrch.text];
        arrOptions = [arrOptFull filteredArrayUsingPredicate:predicate];
    }
    [tblAdFltSel reloadData];
}


#pragma mark - Table view data

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (arrOptions.count < 30)
        return nil;
    NSInteger pos = 0;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dicArr in arrOptions) {
        pos++;
        NSDictionary *dicTmp = dicArr[@"Feature"];
        NSString *s = dicTmp[@"name"];
        s = [s substringToIndex:1];
        if (dic[s])
            continue;
        dic[s] = [NSString stringWithFormat:@"%ld", (long)pos];
    }
    dicAlfabeto = dic;
    NSArray *arr = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    return arr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *s = dicAlfabeto[title];
    NSIndexPath *idx = [NSIndexPath indexPathForRow:s.integerValue inSection:0];
    [tblAdFltSel scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdFltSel"];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = arrOptions[indexPath.row];
    dic = dic[@"Feature"];
    cell.textLabel.text = dic[@"name"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = arrOptions[indexPath.row];
    dic = dic[@"Feature"];
    [self.delegate exitAdFltSelId:dic[@"id"]  Descri:dic[@"name"]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
