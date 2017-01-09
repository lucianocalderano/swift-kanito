
#import <Foundation/Foundation.h>

@interface ClsFotoUpld : NSObject

- (void) uploadArrayOfPicsInBackground:(NSArray *) arrDat DicPost:(NSDictionary *) dic;
- (void) uploadFotoInBackground:(NSDictionary *)dicPost ImageData:(NSData *)datImage;

@end

