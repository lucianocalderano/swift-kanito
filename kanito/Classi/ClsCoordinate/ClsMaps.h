//
//  ClsCoordinate.h
//  Kanito
//
//  Created by Luciano Calderano on 26/05/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClsMapAnnotation.h"

@protocol ClsMapsDelegate <NSObject>

- (void) exitClsMapsWithLocation:(CLLocation *)currentLocation;

@end

@interface ClsMaps : NSObject

@property (nonatomic, strong) NSArray *arrMapAnnotations;
@property (nonatomic, strong) ClsMapAnnotation *mapAnnotation;
@property (nonatomic, assign) id delegate;

- (instancetype) initWithCurrentLocation;

- (void) addNewAnnotationWithDictionary:(NSDictionary *)dicPetSrv
                               ImagePin:(UIImage *)imgPin
                              ImageInfo:(UIImage *)imgInfo
                             myPosition:(CLLocationCoordinate2D) myPos;

- (MKAnnotationView *)showMyPosition:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation;
- (MKAnnotationView *)showAnnotation:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation;

@end
