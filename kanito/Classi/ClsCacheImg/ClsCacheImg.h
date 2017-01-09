//
//  ClsPicCache.h
//  Kanito
//
//  Created by Luciano Lc on 26/05/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCacheImg : NSObject

@property (nonatomic, assign) CGFloat maxCacheDays;

+ (UIImage *) ImageWithUrl:(NSString *) url;

@end
