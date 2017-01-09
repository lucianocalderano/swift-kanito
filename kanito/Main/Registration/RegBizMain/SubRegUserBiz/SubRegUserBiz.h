//
//  RegisterViewController.h
//  Kanito
//
//  Created by Luciano on 1/11/2013.
//  Copyright (c) 2013 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClsRegUserBiz.h"
#import "ClsInputScrollView.h"

@protocol SubRegUserBizDelegate <NSObject>

- (void) exitSubRegUserBiz:(regUserBiz_Items) item;

@end

@interface SubRegUserBiz : UIView;

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) IBOutlet MyLabel *lblCity;
@property (nonatomic, strong) IBOutlet MyLabel *lblCountry;
@property (nonatomic, strong) IBOutlet MyLabel *lblActivities;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL checkUserData;

@end
