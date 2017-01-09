#import <Foundation/Foundation.h>
#import "Define.h"

@interface ClsUtil : NSObject {

}
@property (nonatomic, assign) BOOL booInternetAttivo;

+ (NSString *)  dateToString:   (NSDate *)   dataInput withFormat: (NSString *) fmt;
+ (NSDate *)    dateFromString: (NSString *) dataInput withFormat: (NSString *) fmt;
+ (NSString *)  dateConvert:(NSString *) dataInput
                 fromFormat:(NSString *) fmtInp
                   toFormat:(NSString *) fmtOut;

+ (UIImage *) imageResize:(UIImage *)img MaxSize:(float) maxSize;
+ (UIImage *) imageRotate:(UIImage *)img ByDegrees:(CGFloat)degrees;

+ (NSAttributedString *) attributedStringWithLeftImageName:(NSString *)strImageName MaxSize:(CGFloat) maxSize RightText:(NSString *)strTxt;
+ (NSAttributedString *) attributedStringWithLeftImage:(UIImage *)img MaxSize:(CGFloat) maxSize RightText:(NSString *)strTxt;

+ (UIImage *) defaultBanner;

@end
