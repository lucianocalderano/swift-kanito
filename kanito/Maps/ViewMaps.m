//
//  ViewMaps.m
//  Kanito
//
//  Created by Luciano Calderano on 26/05/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ViewMaps.h"
#import "ClsMaps.h"
#import "ClsPetSrv.h"
#import "ViewPetSrvList.h"
#import "ViewPetSrvDett.h"
#import "MyBaseViewController+ShowAlert.h"

@interface ViewMaps () < MKMapViewDelegate > {
    IBOutlet MKMapView *myMapView;
    IBOutlet MyLabel *lblInfo;
    
    ClsMaps *clsMaps;
    ClsPetSrv *clsPetSrv;
    NSArray *arrSelectedActivities;
}
@end

@implementation ViewMaps

- (void)viewDidLoad {
    [super viewDidLoad];
    clsMaps = [[ClsMaps alloc] init];
    clsPetSrv = [ClsPetSrv getClassId];
    clsPetSrv.dicSelectedCity = nil;

    myMapView.showsUserLocation = NO;
    arrSelectedActivities = [ClsPetSrv getPetServicesIdSelected];
    
    [self foundOnMapLabel:@"0"];
    
    myMapView.centerCoordinate = clsPetSrv.coordinateStart;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance (clsPetSrv.coordinateStart, clsPetSrv.fltMaxDistance * 1000 * 3, clsPetSrv.fltMaxDistance * 1000 * 3);
    MKCoordinateRegion adjustedRegion = [myMapView regionThatFits:viewRegion];
    [myMapView setRegion:adjustedRegion animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = clsPetSrv.coordinateStart;
    point.title = @"Me";
    [myMapView addAnnotation:point];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:clsPetSrv.coordinateStart
                                                     radius:clsPetSrv.fltMaxDistance * 1000];
    [myMapView addOverlay:circle];

    [self loadListPetServices];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myNavigationBar.titolo = @"#maps.Title";
}


- (void) loadListPetServices {
    [ClsPetSrv loadPetSrvListPagNum:1
                           mainView:self.view
                          MaxRecord:999
                           Complete:^(NSString *strNumRec) {
                               [self petServicesList:strNumRec];
                           }];
}

- (void) petServicesList:(NSString *) strNumRec {
    if (clsPetSrv.arrPetServices.count == 0) {
        [self showAlertWithTitle:keyLang(@"maps.NoResult") message:nil];
    }
    else {
        [self foundOnMapLabel:strNumRec];
        [self createAnnotationsPoints];
    }
}

- (void) foundOnMapLabel:(NSString *) found {
    lblInfo.text = [NSString stringWithFormat:@"\n%@",
                    [keyLang(@"maps.Found") stringByReplacingOccurrencesOfString:@"#"
                                                                      withString:@"0"]];
    lblInfo.textAlignment = NSTextAlignmentCenter;
}

- (IBAction)btnList:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PetServices" bundle:nil];
    ViewPetSrvList *ctrl = [sb instantiateViewControllerWithIdentifier:@"ViewPetSrvList"];
    [self.navigationController showViewController:ctrl sender:self];
    [ctrl showListFromMap:clsPetSrv.arrPetServices];
}

- (void) createAnnotationsPoints {
    UIImage *kImg = [ClsUtil imageResize:[UIImage imageNamed:@"icoKanito"] MaxSize:40];
    for (NSDictionary *dicPetSrv in clsPetSrv.arrPetServices) {
        NSArray *arrAct = dicPetSrv[@"Activity_habtm"];
        NSMutableArray *arrImg = [[NSMutableArray alloc] init];
        for (NSDictionary *dicAct in arrAct) {
            [arrImg addObject:dicAct[@"id"]];
        }
        
        UIImage *img = [self creaWithImgArray:arrImg];
        [clsMaps addNewAnnotationWithDictionary:dicPetSrv
                                       ImagePin:img
                                      ImageInfo:kImg
                                     myPosition:clsPetSrv.coordinateStart];
    }

    for (ClsMapAnnotation *mapAnnotation in clsMaps.arrMapAnnotations)
        [myMapView addAnnotation:mapAnnotation];
}

static CGFloat maxSize = 20;

- (UIImage *) creaWithImgArray:(NSArray *) arrPetSrvActivities {
    CGRect rect = CGRectMake(0, 0, maxSize + 2, maxSize + 4);
    UIView *v = [[UIView alloc] initWithFrame:rect];
    v.backgroundColor = [UIColor whiteColor];
    CGFloat x = 2;
    CGFloat y = 2;
    for (NSString *strIdActivity in arrPetSrvActivities) {
        if ([arrSelectedActivities containsObject:strIdActivity] == NO)
            continue;
        UIImage *img = [ClsPetSrv getIconPetActivityWithId:strIdActivity MaxSize:maxSize];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, maxSize, maxSize)];
        imv.image = img;
        [v addSubview:imv];
        x += maxSize + 2;
    }
    rect.size.width = x;
    v.frame = rect;
    
    UIGraphicsBeginImageContextWithOptions(v.bounds.size, v.opaque, 0.0);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - Annotation View

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.fillColor = [MyColor myGreyLight];
    circleView.strokeColor = [MyColor orangeColor];
    circleView.alpha = 0.33f;
    return circleView;
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil; // [clsMaps showMyPosition:map viewForAnnotation:annotation];
    }
    else {
        return [clsMaps showAnnotation:map viewForAnnotation:annotation];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)viewPin {
    ClsMapAnnotation *annotation = (ClsMapAnnotation *) viewPin.annotation;
    CLLocation *myPos = [[CLLocation alloc] initWithLatitude:clsPetSrv.coordinateStart.latitude longitude:clsPetSrv.coordinateStart.longitude];
    CLLocation *other = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];

    float distance = [myPos distanceFromLocation:other] / 1000;
    lblInfo.text = [NSString stringWithFormat:@"%@\n%.2f km.", annotation.title, distance];
    lblInfo.textAlignment = NSTextAlignmentLeft;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    lblInfo.text = @"";
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    ClsMapAnnotation *annotation = (ClsMapAnnotation *) view.annotation;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PetServices" bundle:nil];
    ViewPetSrvDett *vc = [sb instantiateViewControllerWithIdentifier:@"ViewPetSrvDett"];
    vc.dicPetService = annotation.dicPetSrv;
    [self.navigationController showViewController:vc sender:self];
}

@end
