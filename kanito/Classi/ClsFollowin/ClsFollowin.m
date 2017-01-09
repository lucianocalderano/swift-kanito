//
//  ClsFollowin.m
//  Kanito
//
//  Created by Luciano Lc on 21/08/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ClsFollowin.h"

@implementation ClsFollowin

static ClsFollowin *cls = nil;
static NSMutableDictionary *dicFollowing;
static NSDictionary *dicFollowingTypes;

+ (id) open {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cls = [[self alloc] init];
        dicFollowing = [[NSMutableDictionary alloc] init];
        dicFollowingTypes = @{
                              @(FollowTypeBiz) : (defUserBiz).uppercaseString,
                              @(FollowTypePvt) : (defUserPvt).uppercaseString,
                              @(FollowTypeDog) : (defTypeDog).uppercaseString,
                              };
    });
    return cls;
}

+ (void) loadFollowed {
    [ClsFollowin open];
    if ([ClsUser userId].length == 0)
        return;
    if ([ClsUser userType].length == 0)
        return;
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = nil;
    request.page = @"user-followed-list";
    request.json = @{
                     @"follower_id"   : [ClsUser userId],
                     @"follower_type" : [ClsUser userType]
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 NSArray *arr = [resultDict getArray:@"followed_list"];
                 for (NSDictionary *dicTmp in arr) {
                     NSDictionary *dic = dicTmp[@"FollowingRelation"];
                     NSString *strType = dic[@"followed_type"];
                     NSString *strId = dic[@"followed_id"];
                     
                     NSMutableSet *setFollowing = dicFollowing[strType];
                     if (setFollowing == nil) {
                         setFollowing = [[NSMutableSet alloc] init];
                     }
                     [setFollowing addObject:strId];
                     dicFollowing[strType] = setFollowing;
                 }
             }];
}

+ (BOOL) isIdFollowed:(NSString *)strId Type:(enum enumFollowType)type {
    NSString *strType = dicFollowingTypes[@(type)];
    NSSet *set = dicFollowing[strType];
    BOOL found = ([set containsObject:strId]);
    return found;
}

+ (void) followedIdUpdate:(NSString *)strId Add:(BOOL)addId Type:(enum enumFollowType)type {
    NSString *strType = dicFollowingTypes[@(type)];
    NSMutableSet *set = dicFollowing[strType];

    if (addId)
        [set addObject:strId];
    else
        [set removeObject:strId];
}
@end
