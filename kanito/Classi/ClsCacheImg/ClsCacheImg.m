//
//  ClsPicCache.m
//  Kanito
//
//  Created by Luciano Lc on 26/05/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ClsCacheImg.h"

@implementation ClsCacheImg {
    NSString *pathCacheImg;
    NSString *fileName;
}

static ClsCacheImg *instance;

+ (UIImage *) ImageWithUrl:(NSString *) url {
    return [[ClsCacheImg SharedInstance] getImageFromUrl:url];
}

+ (instancetype) SharedInstance {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxCacheDays = 30;
        NSFileManager *fm = [NSFileManager defaultManager];
        pathCacheImg = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Thumbnail.cache"];
        if ([fm fileExistsAtPath:pathCacheImg] == NO)
            [fm createDirectoryAtPath:pathCacheImg withIntermediateDirectories:YES attributes:nil error:nil];
        else
            [self removeOldFiles];
    }
    return self;
}

- (void) removeOldFiles {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *dicAttrib = [fm attributesOfItemAtPath:pathCacheImg error:nil];
    if ([self dayDiff:dicAttrib.fileModificationDate] == 0) // last check = today
        return;
    
    dicAttrib = @{NSFileModificationDate: [NSDate date]};
    [fm setAttributes:dicAttrib ofItemAtPath:pathCacheImg error:nil]; // set date = today
    
    for (NSString *s in [fm contentsOfDirectoryAtPath:pathCacheImg error:nil]) {
        NSString *strFil = [pathCacheImg stringByAppendingPathComponent:s];
        dicAttrib = [fm attributesOfItemAtPath:strFil error:nil];
        if ([self dayDiff:dicAttrib.fileModificationDate] > self.maxCacheDays) // not used last 30 days
            [fm removeItemAtPath:strFil error:nil];
    }
}

- (NSInteger) dayDiff:(NSDate *) date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    return components.day;
}

- (UIImage *) getImageFromUrl:(NSString *)strUrl {
    fileName = [pathCacheImg stringByAppendingPathComponent:strUrl.lastPathComponent];
    
    UIImage *img = [self getImageFromCache];
    if (img == nil) {        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        if (data.length > 0) {
            img = [UIImage imageWithData:data];
            [self saveImageWithData:data];
        }
    }
    return img;
}

- (UIImage *) getImageFromCache {
    NSFileManager *fm = [NSFileManager defaultManager];
    UIImage *img = nil;
    if ([fm fileExistsAtPath:fileName]) {
        img = [UIImage imageWithContentsOfFile:fileName];
    }
    return img;
}

- (void) saveImageWithData:(NSData *)data {
    [data writeToFile:fileName atomically:YES];
}

@end
