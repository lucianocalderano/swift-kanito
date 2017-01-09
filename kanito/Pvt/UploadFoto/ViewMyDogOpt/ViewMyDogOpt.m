//
//  ViewAlbumLst.m
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewMyDogOpt.h"

@interface ClsList : NSObject
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *Name;
@end
@implementation ClsList
@end


@interface ViewMyDogOpt () {
    IBOutlet UITableView *tblOptPhoto;
    NSArray *arrOptions;
    NSInteger opzNum;
    NSInteger typeRequest;
    NSDictionary *dicAlfabeto;
}
@end

@implementation ViewMyDogOpt {

}

- (void) configNewDog:(enum enumMyNewDog)opzSelected {
    opzNum = opzSelected;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"dog-feature-list";
    request.json = @{
                     @"lang_id" : [ClsLang langId],
                     @"feature" : [self getFeature],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 arrOptions = [resultDict getArray:@"Features"];
                 [tblOptPhoto reloadData];
             }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = [self getTitle];
}

- (NSString *) getTitle {
    switch (opzNum) {
        case optNewDogBrd:
            return keyLang(@"selBreed");
        case optNewDogAge:
            return keyLang(@"selAgess");
        case optNewDogSiz:
            return keyLang(@"selSizes");
    }
    return @"";
}

- (NSString *) getFeature {
    switch (opzNum) {
        case optNewDogBrd:
            return @"breeds";
        case optNewDogAge:
            return @"ages";
        case optNewDogSiz:
            return @"sizes";
    }
    return @"";
}


#pragma mark - Table view data

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (arrOptions.count < 30)
        return nil;
    NSInteger pos = -1;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dicArr in arrOptions) {
        pos++;
        NSString *s = [dicArr getString:@"Feature.name"];
        s = [s substringToIndex:1];
        if (dic[s])
            continue;
        dic[s] = @(pos);
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
    [tblOptPhoto scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return 1;
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [self getDataAtRow:indexPath.row].Name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClsList *list = [self getDataAtRow:indexPath.row];
    [self.delegate exitOptPhotoId:list.Id Descri:list.Name];
    [self.navigationController popViewControllerAnimated:YES];
}

- (ClsList *) getDataAtRow:(NSInteger) row {
    NSDictionary *dic = arrOptions[row];
    ClsList *clsList = [[ClsList alloc]init];
    clsList.Id = [dic getString:@"Feature.id"];
    clsList.Name = [dic getString:@"Feature.name"];
    return clsList;
}
@end
