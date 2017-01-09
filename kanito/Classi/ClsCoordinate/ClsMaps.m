//
//  ClsCoordinate.m
//  Kanito
//
//  Created by Luciano Calderano on 26/05/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ClsMaps.h"

@interface ClsMaps () < CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation* prevLocation;
}
@end

@implementation ClsMaps

- (instancetype) initWithCurrentLocation {
    self = [super init];
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
    return self;
}

- (void) addNewAnnotationWithDictionary:(NSDictionary *)dicPetSrv
                               ImagePin:(UIImage *)imgPin
                              ImageInfo:(UIImage *)imgInfo
                             myPosition:(CLLocationCoordinate2D) myPos {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.arrMapAnnotations];
    ClsMapAnnotation *ann = [[ClsMapAnnotation alloc] initWithDictionary:(NSDictionary *)dicPetSrv
                                                                   Image:imgPin
                                                               ImageLeft:imgInfo
                                                                   MyPos:myPos];
    [arr addObject:ann];
    self.arrMapAnnotations = arr;
}

- (MKAnnotationView *)showAnnotation:(MKMapView *)map
                   viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[ClsMapAnnotation class]]) {
        return [(ClsMapAnnotation *) annotation showAnnotation:map
                                             viewForAnnotation:annotation];
    }
    else
        return nil;
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    [self.delegate exitClsMapsWithLocation:nil];
//    [locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation* location = locations.lastObject;
    if (location.coordinate.latitude == prevLocation.coordinate.latitude &&
        location.coordinate.longitude == prevLocation.coordinate.longitude)
        return;
    prevLocation = location;
    NSLog(@"New Location: %@", location);
    [self.delegate exitClsMapsWithLocation:location];
}

#pragma mark - Current position

static NSString *mkPinId = @"pinMyPosition";

- (MKAnnotationView *)showMyPosition:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    map.userLocation.title = @"Kanito";
    map.userLocation.subtitle = @"";
    
    MKAnnotationView *annotationView = nil;
    annotationView = (MKAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:mkPinId];
    if (annotationView)
        return annotationView;
    
    annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:mkPinId];
    annotationView.canShowCallout = YES;
    annotationView.image = [ClsUtil imageResize:[UIImage imageNamed:@"icoKanito"] MaxSize:24];
    annotationView.layer.borderColor = [MyColor myGreyDark].CGColor;
    annotationView.layer.borderWidth = 1;
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[ClsUtil imageResize:[UIImage imageNamed:@"icoKanito"] MaxSize:40]];
    annotationView.leftCalloutAccessoryView = imgView;
    return annotationView;
}

#pragma mark -

- (void) getAddressFromLocation:(CLLocation *) location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                       if (error == nil && placemarks.count > 0) {
                           CLPlacemark *placemark = placemarks.lastObject;
                           NSLog(@"%@", [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                         placemark.subThoroughfare, placemark.thoroughfare,
                                         placemark.postalCode, placemark.locality,
                                         placemark.administrativeArea,
                                         placemark.country]);
                       } else {
                           NSLog(@"%@", error.debugDescription);
                       }
                   } ];
}



@end
