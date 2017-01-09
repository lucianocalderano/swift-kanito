//
//  MyColor.h
//
//  Created by Luciano Calderano on 20/07/16.
//  Copyright © 2016 Kanito.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyColor : UIColor

+ (UIColor *) myBlueLight;
+ (UIColor *) myOrange;
+ (UIColor *) myGreyLight;
+ (UIColor *) myGreyDark;

+ (UIColor *) myMenuSel;
+ (UIColor *) myMenuBkg;

+ (UIColor *) hexToUIColor:(NSInteger) rgbValue;
@end
