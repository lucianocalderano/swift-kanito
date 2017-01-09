//
//  MapAnnotation.m
//  Maps
//
//  Created by Luciano Calderano on 17/03/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ClsMapAnnotation.h"

@interface ClsMapAnnotation () {
}
@end

@implementation ClsMapAnnotation

- (instancetype)initWithDictionary:(NSDictionary *)dicPetSrv
                   Image:(UIImage *)image
               ImageLeft:(UIImage *)imageLeft
                   MyPos:(CLLocationCoordinate2D) myCoordinate {
    if ((self = [super init])) {
        NSDictionary *dic = dicPetSrv[@"Svcsection"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
        self.title = dic[@"business_name"];
        if (self.title.length == 0)
            self.title = dic[@"BizUsername"];
        self.title = (self.title).capitalizedString;
        
        CLLocation *myPos = [[CLLocation alloc] initWithLatitude:myCoordinate.latitude longitude:myCoordinate.longitude];
        CLLocation *other = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        float distance = [myPos distanceFromLocation:other] / 1000;
        self.title = [self.title stringByAppendingFormat:@" - %.2f km.", distance];
        self.subtitle = dic[@"address"];
        self.coordinate = coordinate;
        self.image = image;
        self.imageLeft = imageLeft;
        self.dicPetSrv = dicPetSrv;        
    }
    return self;
}

static NSString *mkPinId = @"pinPetService";

- (MKAnnotationView *)showAnnotation:(MKMapView *)map
                   viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [map dequeueReusableAnnotationViewWithIdentifier:mkPinId];
    if (annotationView) {
        annotationView.annotation = annotation;
        return annotationView;
    }

    annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:mkPinId];
    annotationView.canShowCallout = YES;
    annotationView.image = self.image;
    annotationView.backgroundColor = [UIColor whiteColor];
    
    annotationView.layer.borderColor = [MyColor myGreyDark].CGColor;
    annotationView.layer.borderWidth = 1;
    annotationView.layer.cornerRadius = 3;
    
//    MKAnnotationView *ann = (MKAnnotationView*)[map dequeueReusableAnnotationViewWithIdentifier:@"some id"];
    
//    UITapGestureRecognizer *pinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinTapped:)];
//    [annotationView addGestureRecognizer:pinTap];

    
    UIImageView *iconView = nil; //[[UIImageView alloc] initWithImage:self.imageLeft];
    annotationView.leftCalloutAccessoryView = iconView;
    
//    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = [self btnInfo];
    return annotationView;
}
/*
- (void) pinTapped:(UITapGestureRecognizer *)sender {
    MKAnnotationView *pin = (MKPinAnnotationView *)sender.view;
    NSLog(@"Pin with id %@ tapped", pin.reuseIdentifier);
}
*/
- (UIButton *) btnInfo {
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 40, 40);
    btn.backgroundColor = [MyColor myOrange];
    btn.layer.cornerRadius = 8;
    UIImage *img = [ClsUtil imageResize:[UIImage imageNamed:@"Next"] MaxSize:32];
    [btn setImage:img forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = YES;
    return btn;
}
@end
