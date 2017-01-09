//
//  MyColor.m
//  ENCI Sport
//
//  Created by Luciano Calderano on 20/07/16.
//  Copyright © 2016 Kanito.it. All rights reserved.
//

#import "MyColor.h"

@implementation MyColor

+ (UIColor *) myBlueLight { // 00aed9
    return  [self hexToUIColor:0x00aed9];
}
+ (UIColor *) myOrange { // ff9900
    return  [self hexToUIColor:0xff9900];
}
+ (UIColor *) myGreyLight { // 4c505c
    return  [self hexToUIColor:0x4c505c];
}
+ (UIColor *) myGreyDark { // d6dddf
    return  [self hexToUIColor:0xd6dddf];
}

+ (UIColor *) myMenuSel { // 646781
    return  [self hexToUIColor:0x646781];
}
+ (UIColor *) myMenuBkg { // 646781
    return  [self hexToUIColor:0x464960];
}

+ (UIColor *) hexToUIColor:(NSInteger) rgbValue {
    return  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                             blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                            alpha:1.0];
}
@end
