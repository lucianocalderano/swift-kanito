//
//  ViewSrchByAddr.m
//  Kanito
//
//  Created by Luciano Calderano on 04/06/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ViewSrchByAddr.h"
#import "ViewMaps.h"
#import "ClsPetSrv.h"

@interface ViewSrchByAddr () < UISearchBarDelegate > {
    IBOutlet UIButton *btnStart;
    IBOutlet UITableView *tblAddrList;
    IBOutlet UISearchBar *srchAddr;
    IBOutlet UITextView *txtSelectedAddress;
    NSArray *arrRecivedData;
    NSArray *arrAddrList;
    CLLocationCoordinate2D coordinate;
}
@end

@implementation ViewSrchByAddr
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [btnStart setTitle:keyLang(@"petSrvSrcByAddr.StartSrch") forState:UIControlStateNormal];
    [btnStart setTitle:keyLang(@"petSrvSrcByAddr.SelStartPos") forState:UIControlStateDisabled];
    btnStart.enabled = NO;
    [srchAddr becomeFirstResponder];
    
    txtSelectedAddress.text = @"";
    txtSelectedAddress.font = [MyFont fontSize:20];
    txtSelectedAddress.textColor = [MyColor myGreyDark];
    txtSelectedAddress.textAlignment = NSTextAlignmentCenter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = @"#petSrvSrcByAddr.Title";
}

- (IBAction)btnStart:(id)sender {
    ClsPetSrv *cls = [ClsPetSrv getClassId];
    cls.coordinateStart = coordinate;
    cls.fltMaxDistance = 20;

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Maps" bundle:nil];
    ViewMaps *ctrl = [sb instantiateInitialViewController];
    [self.navigationController showViewController:ctrl sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAddrList.count;
}

static NSString *CellIdentifier = @"CellList";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [MyFont fontSize:14];
    }
    cell.textLabel.text = arrAddrList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [srchAddr resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dic = arrRecivedData[indexPath.row];
    NSString *strAddress = dic[@"description"];
    NSArray *arr = dic[@"terms"];
    txtSelectedAddress.text = @"";
    for (dic in arr) {
        txtSelectedAddress.text = [txtSelectedAddress.text stringByAppendingString:dic[@"value"]];
        txtSelectedAddress.text = [txtSelectedAddress.text stringByAppendingString:@"\n"];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:strAddress completionHandler:^(NSArray* placemarks, NSError* error) {
        [hud hideAnimated:YES];
        if ( error ) {
            txtSelectedAddress.text = [txtSelectedAddress.text stringByAppendingFormat:@"Coordinate error %@", error.localizedDescription];
        }
        else {
            CLPlacemark *place = placemarks[0];
            coordinate = place.location.coordinate;
            txtSelectedAddress.text = [txtSelectedAddress.text stringByAppendingFormat:@"\nLat.%.6f - Lng.%.6f\n",
                                       coordinate.latitude, coordinate.longitude];
            btnStart.enabled = YES;
        }
    }];
}

#pragma mark - Search delegate

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *s = [defUrlGoogleMaps stringByReplacingOccurrencesOfString:@"$$" withString:searchText];
    NSURL *url = [NSURL URLWithString:[s stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
    NSData *dat = [NSData dataWithContentsOfURL:url];
    if (dat == nil)
        return;
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dat
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    arrRecivedData = dic[@"predictions"];
    NSMutableArray *arrTmp = [[NSMutableArray alloc] init];
    for (dic in arrRecivedData) {
        s = dic[@"description"];
        [arrTmp addObject:s];
    }
    arrAddrList = arrTmp;
    [tblAddrList reloadData];
    /*
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(37.33233141, -122.03121860) radius:100 identifier:@"San Francisco"];
    [geocoder geocodeAddressString:searchText inRegion:region completionHandler:^(NSArray* placemarks, NSError* error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ( error ) {
            NSLog(@"Coordinate error %@", error.localizedDescription);
        }
        else {
            for (CLPlacemark *place in placemarks) {
                NSDictionary *dic = place.addressDictionary;
                NSString *str = @"";
                for (NSString *s in dic[@"FormattedAddressLines"])
                    str = [str stringByAppendingFormat:@"%@ - ", s];
                NSLog(@"%@", str);
            }
        }
    }];
*/
}

@end
