//
//  ViewTypeList.h
//  Kanito
//
//  Created by Luciano Calderano on 10/04/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PvtViewController.h"

@protocol PetServiceTypeCtrlDelegate <NSObject>

- (void) exitPetServiceType;

@end

@interface PetServiceTypeCtrl : PvtViewController

@property (nonatomic, assign) id delegate;

@end
