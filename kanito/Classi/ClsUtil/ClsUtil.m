#import "ClsUtil.h"

@implementation ClsUtil

+ (NSString *) dateToString:(NSDate *) dataInput withFormat: (NSString *) fmt {
    if (dataInput == nil)
        return @"";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *ret;
    df.dateFormat = fmt;
    ret = [NSString stringWithString:[df stringFromDate: dataInput]];
    return ret;
}

+ (NSDate *) dateFromString: (NSString *) dataInput withFormat:(NSString *) fmt {
    if (dataInput.length != fmt.length)
        return nil;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = fmt;
    NSDate *ret = [df dateFromString: dataInput];
    return ret;
}

+ (NSString *) dateConvert:(NSString *) dataInput
                fromFormat:(NSString *) fmtInp
                  toFormat:(NSString *) fmtOut  {
    NSDate *d = [ClsUtil dateFromString:dataInput withFormat:fmtInp];
    NSString *s = [ClsUtil dateToString:d withFormat:fmtOut];
    return s;
}

+ (UIImage *) imageResize:(UIImage *)img MaxSize:(float)maxSize {
    CGSize originalSize = img.size;
    float xScale = maxSize / originalSize.width;
    float yScale = maxSize / originalSize.height;
    float scale = MIN(xScale, yScale);
    scale = MIN(scale, 1);
    
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];

    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

+ (UIImage *) imageRotate:(UIImage *)img ByDegrees:(CGFloat)degrees {
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,img.size.width, img.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-img.size.width / 2, -img.size.height / 2, img.size.width, img.size.height), img.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

static UIImage *imgBanner = nil;
+ (UIImage *) defaultBanner {
    if (imgBanner == nil)
        imgBanner = [UIImage imageNamed:@"logoKanito"];

    return imgBanner;
}

+ (NSAttributedString *) attributedStringWithLeftImageName:(NSString *)strImageName MaxSize:(CGFloat) maxSize RightText:(NSString *)strTxt {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [ClsUtil imageResize:[UIImage imageNamed:strImageName] MaxSize:maxSize];
    NSAttributedString *attImg = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    NSAttributedString *attTxt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", strTxt]];
    [attributedString appendAttributedString:attImg];
    [attributedString appendAttributedString:attTxt];
    return attributedString;
}

+ (NSAttributedString *) attributedStringWithLeftImage:(UIImage *)img MaxSize:(CGFloat) maxSize RightText:(NSString *)strTxt {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [ClsUtil imageResize:img MaxSize:maxSize];
    NSAttributedString *attImg = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    NSAttributedString *attTxt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", strTxt]];
    [attributedString appendAttributedString:attImg];
    [attributedString appendAttributedString:attTxt];
    return attributedString;
}

@end
