//
//  ViewPetSrvSrchMyPos
//  Kanito
//
//  Created by Luciano Calderano on 10/04/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ViewPetSrvSrchMyPos.h"
#import "ViewMaps.h"
#import "ClsPetSrv.h"
#import "ClsMaps.h"

@interface ViewPetSrvSrchMyPos () < ClsMapsDelegate > {
    IBOutlet UILabel *lblSlider;
    IBOutlet UISlider *slider;
    MBProgressHUD *hud;
    ClsMaps *clsMaps;
}
@end

@implementation ViewPetSrvSrchMyPos
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = @"#petSrvSrcAround.Title";
}

- (IBAction)btnStart:(id)sender {
    clsMaps = [[ClsMaps alloc] initWithCurrentLocation];
    clsMaps.delegate = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)sliderMove:(id)sender {
    lblSlider.text = [NSString stringWithFormat:@"%.1f00 km", slider.value * 19 + 1];
}

- (void) exitClsMapsWithLocation:(CLLocation *)currentLocation {
    [hud hideAnimated:YES];
#if TARGET_IPHONE_SIMULATOR
    currentLocation = [[CLLocation alloc] initWithLatitude:41.8919300
                                                 longitude:12.5113300];
#endif
    if (currentLocation == nil)
        return;
    
    ClsPetSrv *cls = [ClsPetSrv getClassId];
    cls.coordinateStart = currentLocation.coordinate;
    cls.fltMaxDistance = slider.value * 19 + 1;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Maps" bundle:nil];
    ViewMaps *ctrl = [sb instantiateInitialViewController];
    [self.navigationController showViewController:ctrl sender:self];
}

@end
