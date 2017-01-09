//
//  ViewAlbumLst.m
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewAdFilter.h"
#import "ViewAdFltSel.h"

@interface ClsFilter : NSObject {
}
@property (nonatomic, strong) NSString *strHead;
@property (nonatomic, strong) NSString *strFeat;
@property (nonatomic, strong) NSArray  *arrList;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSString *strSelectedId;
@property (nonatomic, strong) NSString *strSelDescri;
@end

@implementation ClsFilter {
    
}
@end

@interface ViewAdFilter () <ViewAdFltSelDelegate, MyNavigationBarDelegate> {
    IBOutlet UITableView *tblAdFilter;
    IBOutlet UIView *viewM;
    IBOutlet UIView *viewF;
    
    NSMutableArray *arrAdFilter;
    NSInteger numResponse;
}
@end

@implementation ViewAdFilter {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    viewM.layer.cornerRadius = viewM.frame.size.width / 2;
    viewF.layer.cornerRadius = viewF.frame.size.width / 2;
    viewM.layer.borderColor = [MyColor myOrange].CGColor;
    viewF.layer.borderColor = [MyColor myOrange].CGColor;
    [self imgTapF];
    [self imgTapM];
    
    arrAdFilter= [[NSMutableArray alloc] init];
    [arrAdFilter addObject:[self addCls:keyLang(@"FilterAg") Feature:@"ages"]];
    [arrAdFilter addObject:[self addCls:keyLang(@"FilterSz") Feature:@"sizes"]];
    [arrAdFilter addObject:[self addCls:keyLang(@"FilterBr") Feature:@"breeds"]];

    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapM)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [viewM addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapF)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [viewF addGestureRecognizer:tap];
}

- (void) imgTapM {
    viewM.tag = (viewM.tag == 0) ? 1 : 0;
    viewM.layer.borderWidth = viewM.tag * 3;
}
- (void) imgTapF {
    viewF.tag = (viewF.tag == 0) ? 1 : 0;
    viewF.layer.borderWidth = viewF.tag * 3;
}

- (ClsFilter *) addCls:(NSString *)strHead Feature:(NSString *)strFeat {
    ClsFilter *cls = [[ClsFilter alloc] init];
    cls.strHead = strHead;
    cls.strFeat = strFeat;
    cls.strSelectedId = @"";
    cls.arrList = nil;
    cls.selectedRow = -1;
    return cls;
}

- (void) myNavigatorOptionButtonTapped {
    ClsFilter *cls;

    NSString *strGen = @"";
    if (viewM.tag == 1 && viewF.tag == 0)
        strGen = @"0";
    if (viewM.tag == 0 && viewF.tag == 1)
        strGen = @"1";
    cls = arrAdFilter[0];
    NSString *strAge = cls.strSelectedId;
    cls = arrAdFilter[1];
    NSString *strSiz = cls.strSelectedId;
    cls = arrAdFilter[2];
    NSString *strBrd = cls.strSelectedId;
//    cls = arrAdFilter[3];
//    NSString *strPed = cls.strSelectedId;
//    cls = arrAdFilter[4];
//    NSString *strPri = cls.strSelectedId;
    
    [self.delegate exitViewAdFilterSetGender:strGen
                                         Age:strAge
                                        Size:strSiz
                                       Breed:strBrd
                                       Price:@"" //strPri
                                    Pedigree:@"" //strPed
     ];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnReset {
    for (int i = 0; i < arrAdFilter.count; i++) {
        ClsFilter *cls = arrAdFilter[i];
        cls.strSelectedId = @"";
        arrAdFilter[i] = cls;
    }
    [tblAdFilter reloadData];
}

#pragma mark - Table view data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAdFilter.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdFilter"];
    ClsFilter *cls = arrAdFilter[indexPath.row];
    cell.textLabel.text = cls.strHead;
    if (cls.strSelectedId.length == 0)
        cell.detailTextLabel.text = keyLang(@"FilterNo");
    else
        cell.detailTextLabel.text = cls.strSelDescri;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClsFilter *cls = arrAdFilter[indexPath.row];
    cls.strSelectedId = @"";
    arrAdFilter[indexPath.row] = cls;
    ViewAdFltSel *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewAdFltSel"];
    ctrl.delegate = self;
    [self.navigationController showViewController:ctrl sender:self];
    [ctrl configFilter:cls.strHead Feature:cls.strFeat];
}

- (void) exitAdFltSelId:(NSString *)strId Descri:(NSString *) strDescri {
    NSIndexPath *indexPath = tblAdFilter.indexPathForSelectedRow;
    ClsFilter *cls = arrAdFilter[indexPath.row];
    cls.strSelectedId = strId;
    cls.strSelDescri = strDescri;
    arrAdFilter[indexPath.row] = cls;
    [tblAdFilter deselectRowAtIndexPath:indexPath animated:YES];
    [tblAdFilter reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
