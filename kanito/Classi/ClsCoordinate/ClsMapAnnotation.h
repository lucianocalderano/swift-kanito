//
//  MapAnnotation.h
//  Maps
//
//  Created by Luciano Calderano on 17/03/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ClsMapAnnotation : NSObject <MKAnnotation> {
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *imageLeft;
@property (nonatomic, strong) NSDictionary *dicPetSrv;

- (instancetype)initWithDictionary:(NSDictionary *)dicPetSrv
                   Image:(UIImage *)image
               ImageLeft:(UIImage *)imageLeft
                   MyPos:(CLLocationCoordinate2D) myPos;

- (MKAnnotationView *)showAnnotation:(MKMapView *)map
                   viewForAnnotation:(id <MKAnnotation>)annotation;

@end
