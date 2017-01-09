//
//  ClsFollowin.h
//  Kanito
//
//  Created by Luciano Lc on 21/08/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>
enum enumFollowType {
    FollowTypeBiz,
    FollowTypePvt,
    FollowTypeDog,
};

@interface ClsFollowin : NSObject

+ (void) loadFollowed;
+ (BOOL) isIdFollowed:(NSString *)strId Type:(enum enumFollowType)type;
+ (void) followedIdUpdate:(NSString *)strId Add:(BOOL)addId Type:(enum enumFollowType)type;

@end
