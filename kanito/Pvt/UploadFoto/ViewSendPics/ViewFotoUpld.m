//
//  ViewSendPics.m
//  Kanito
//
//  Created by Luciano Lc on 22/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewFotoUpld.h"
#import "ClsSettings.h"
#import "ClsFotoUpld.h"

@interface ViewFotoUpld  () {
    IBOutlet UILabel *lblLoc;
    IBOutlet UILabel *lblAct;

    IBOutlet UITableView *tblPicLoc;
    IBOutlet UITableView *tblPicAct;
    
    NSArray *arrPicLoc;
    NSArray *arrPicAct;
    
    NSInteger selectedLoc;
    NSInteger selectedAct;
}
@end

@implementation ViewFotoUpld

- (void)viewDidLoad {
    [super viewDidLoad];

    lblLoc.attributedText = [ClsUtil attributedStringWithLeftImageName:@"MapMarker"
                                                               MaxSize:16
                                                             RightText:keyLang(@"viewFotoOpts.Loc")];
    lblAct.attributedText = [ClsUtil attributedStringWithLeftImageName:@"Runner"
                                                               MaxSize:16
                                                             RightText:keyLang(@"viewFotoOpts.Act")];

    selectedLoc = [ClsSettings getValForKey:userPhotoLocLastSelected].integerValue;
    selectedAct = [ClsSettings getValForKey:userPhotoActLastSelected].integerValue;
    arrPicLoc =  (NSArray *)[ClsSettings getValForKey:userPhotoLoc];
    arrPicAct =  (NSArray *)[ClsSettings getValForKey:userPhotoAct];
    if ([arrPicAct isKindOfClass:[NSArray class]] == NO)
        arrPicAct = nil;
    if ([arrPicLoc isKindOfClass:[NSArray class]] == NO)
        arrPicLoc = nil;
    
    NSDate *d = (NSDate *) [ClsSettings getObjForKey:userPhotoLastDownload];
    BOOL reloadData = YES;
    if (d) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                       fromDate:d
                                                                         toDate:[NSDate date]
                                                                        options:0];
        if (components.day < 15)
            reloadData = NO;
    }

    if (reloadData || arrPicLoc.count == 0) {
        MyHttpRequest *request = [MyHttpRequest pvtRequest];
        request.view = tblPicLoc;
        request.page = @"photo-feature-list";
        request.json = @{
                         @"lang_id" : [ClsLang langId],
                         @"feature" : @"location_types",
                        };
        
        [MyHttp httpRequest:request
                 completion:^(BOOL succeeded, NSDictionary *resultDict) {
                     arrPicLoc = [resultDict getArray:@"Features"];
                     [ClsSettings setObj:arrPicLoc ForKey:userPhotoLoc];
                     [ClsSettings setObj:[NSDate date] ForKey:userPhotoLastDownload];
                     [tblPicLoc reloadData];
                 }];
    }
    if (reloadData || arrPicAct.count == 0) {
        MyHttpRequest *request = [MyHttpRequest pvtRequest];
        request.view = tblPicAct;
        request.page = @"photo-feature-list";
        request.json = @{
                         @"lang_id" : [ClsLang langId],
                         @"feature" : @"action_types",
                         };
        
        [MyHttp httpRequest:request
                 completion:^(BOOL succeeded, NSDictionary *resultDict) {
                     arrPicAct = [resultDict getArray:@"Features"];
                     [ClsSettings setObj:arrPicAct ForKey:userPhotoAct];
                     [ClsSettings setObj:[NSDate date] ForKey:userPhotoLastDownload];
                     [tblPicAct reloadData];
                 }];
    }
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblPicAct)
        return arrPicAct.count;
    else
        return arrPicLoc.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [MyFont fontSize:15];
        cell.textLabel.textColor = [MyColor myGreyDark];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSInteger num;
//    NSString *strPrefix;
    if (tableView == tblPicAct) {
        NSDictionary *dic = arrPicAct[indexPath.row];
        cell.textLabel.text = [dic getString:@"Feature.name"].uppercaseString;
        num = [dic getString:@"Feature.id"].integerValue;
//        strPrefix = @"A";
        if (num == selectedAct) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        NSDictionary *dic = arrPicLoc[indexPath.row];
        cell.textLabel.text = [dic getString:@"Feature.name"].uppercaseString;
        num = [dic getString:@"Feature.id"].integerValue;
//        strPrefix = @"L";
        if (num == selectedLoc) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
//    NSString *s = [NSString stringWithFormat:@"%@%02ld", strPrefix, (long)num];
//    UIImage *img = [UIImage imageNamed:s];
//    if (img == nil) {
//        img = [UIImage imageNamed:@"00"];
//    }
//    cell.imageView.image = [ClsUtil imageResize:img MaxSize:16.0f];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark - Image Picker Controller

- (void) showHUB {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)btnSend {
    self.view.userInteractionEnabled = NO;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    v.backgroundColor = [MyColor myGreyLight];
    v.layer.cornerRadius = 10;
    v.layer.borderColor = [MyColor myGreyDark].CGColor;
    v.layer.borderWidth = 4;
    v.center = self.view.center;
    [self.view addSubview:v];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 280, 50)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 2;
    lbl.font = [MyFont fontSize:20];
    lbl.textColor = [MyColor myOrange];
    lbl.text = @"Keep playing while your pic is uploading";
    [v addSubview:lbl];
    
    [UIView animateWithDuration:2.0
                     animations:^{
                         v.alpha = 0.95;
                     }
                     completion:^(BOOL fine) {
                         [self sendPicInBackground];
                         [self closeAnimation:v];
                     }];
}

- (void) closeAnimation:(UIView *) v {
    [UIView animateWithDuration:0.5
                     animations:^{
                         v.alpha = 0.3;
                     }
                     completion:^(BOOL fine) {
#if TARGET_IPHONE_SIMULATOR
                         [self.navigationController popToRootViewControllerAnimated:YES];
#else
                         [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
#endif
                     }];
}

- (void) sendPicInBackground {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.dicPhoto];
    NSIndexPath *idx;
    idx = tblPicLoc.indexPathForSelectedRow;
    if (idx) {
        NSDictionary *dicTmp = arrPicLoc[idx.row];
        NSString *s = [dicTmp getString:@"Feature.id"];
        dic[@"location_type"] = s;
        [ClsSettings setVal:s ForKey:userPhotoLocLastSelected];
    }
    idx = tblPicAct.indexPathForSelectedRow;
    if (idx) {
        NSDictionary *dicTmp = arrPicAct[idx.row];
        NSString *s = [dicTmp getString:@"Feature.id"];
        dic[@"action_type"] = s;
        [ClsSettings setVal:s ForKey:userPhotoActLastSelected];
    }
    NSArray *arr = (NSArray *) [ClsSettings getObjForKey:userArrayDataForPicsToUpload];
    ClsFotoUpld *fotoUpld = [[ClsFotoUpld alloc] init];
    [fotoUpld uploadArrayOfPicsInBackground:arr DicPost:dic];
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@", dic);
#endif
}
@end
