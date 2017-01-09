//
//  MyFont
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyFontType) {
    MyFontTypeBold,
    MyFontTypeExtraBold,
    MyFontTypeExtraLight,
    MyFontTypeLight,
    MyFontTypeMedium,
    MyFontTypeRegular,
    MyFontTypeSemiBold,
};

@interface MyFont : UIFont

+ (UIFont *) fontSize:(CGFloat) fontSize;
+ (UIFont *) fontSize:(CGFloat) fontSize
                 Type:(MyFontType) fontType;


@end
