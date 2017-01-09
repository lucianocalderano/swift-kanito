//
//  MyFont.m
//

#import "MyFont.h"

@implementation MyFont

+ (UIFont *) fontSize:(CGFloat) fontSize {
    return [self fontSize:fontSize
                     Type:MyFontTypeSemiBold];
}

+ (UIFont *) fontSize:(CGFloat)fontSize
                 Type:(MyFontType) fontType {
    NSString *strFontType = [self fontNameForType:fontType];
    return [UIFont fontWithName:strFontType size:fontSize];
}

+ (NSString *) fontNameForType:(MyFontType) fontType {
    NSString *strFontType;
    switch (fontType) {
        case MyFontTypeBold:
            strFontType = @"Bold";
            break;
        case MyFontTypeExtraBold:
            strFontType = @"Bold";
            break;
        case MyFontTypeExtraLight:
            strFontType = @"Light";
            break;
        case MyFontTypeLight:
            strFontType = @"Light";
            break;
        case MyFontTypeMedium:
            strFontType = @"Regular";
            break;
        case MyFontTypeRegular:
            strFontType = @"Regular";
            break;
        default:
            strFontType = @"Bold";
            break;
    }
    NSString *s = [NSString stringWithFormat:@"DINAlternate-%@", strFontType];
    return s;
}

@end
