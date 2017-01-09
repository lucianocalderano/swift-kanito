//
//  ClsUser.h
//  CyberGuide
//
//  Created by Sviluppo IOS on 25/02/14.
//  Copyright (c) 2014 Sviluppo IOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(unsigned int, enumPetActivityImageType) {
    enumPetActivityImageTypeOn,
    enumPetActivityImageTypeOff,
    enumPetActivityImageTypeIco,
};



@interface ClsPetSrv : NSObject
@property (nonatomic, strong) NSArray *arrPetServices;

@property (nonatomic, strong) NSDictionary *dicSelectedCity;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateStart;
@property (nonatomic, assign) CGFloat fltMaxDistance;

+ (id) getClassId;

+ (NSDictionary *) getSavedPetServicesList;
+ (void) setPetSrvListAndSaveImages:(NSDictionary *) dicPet;

+ (void) setPetSrvSelected:(NSArray *) arrSel;
+ (NSArray *) getPetServicesIdSelected;

+ (UIImage *) getImagePetActivityWithId:(NSString *)strId;
+ (UIImage *) toGrayscale:(UIImage *) img;
+ (UIImage *) getIconPetActivityWithId:(NSString *)strId MaxSize:(CGFloat) maxSize;

+ (void)loadPetSrvListPagNum:(NSInteger) pagNum
                    mainView:(UIView *) mainView
                   MaxRecord:(NSInteger) maxRec
                    Complete:(void (^)(NSString *strNumRec))completionBlock;
/*
+ (void)loadPetSrvListPagNum:(NSInteger) pagNum
                   MaxRecord:(NSInteger) maxRec
                    Complete:(void (^)(NSArray *arrList, NSString *strNumRec))completionBlock;
*/
@end
