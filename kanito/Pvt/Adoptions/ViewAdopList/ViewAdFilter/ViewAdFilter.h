//
//  ViewUserDogs.h
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "PvtViewController.h"

@protocol ViewAdFilterDelegate <NSObject>
@required
- (void) exitViewAdFilterSetGender:(NSString *)strGen
                               Age:(NSString *)strAge
                              Size:(NSString *)strSiz
                             Breed:(NSString *)strBrd
                             Price:(NSString *)strPri
                          Pedigree:(NSString *)strPed;
@end

@interface ViewAdFilter : PvtViewController

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSArray *arrAd;
@end
