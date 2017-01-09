//
//  ClsUser.m
//  CyberGuide
//
//  Created by Sviluppo IOS on 25/02/14.
//  Copyright (c) 2014 Sviluppo IOS. All rights reserved.
//

#import "ClsUser.h"

@implementation ClsUser

static dispatch_once_t onceToken;
static ClsUser  *clsUser = nil;
static NSUserDefaults *userDefault;
static NSData *datPicture = nil;

#define defUserConfig @"UserConfig"

#pragma mark Singleton Methods

+ (void) open {
    if (clsUser == nil) {
        dispatch_once(&onceToken, ^{
            clsUser = [[super alloc] init];
            userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"userConfig"];
            
            NSDictionary *dic = [userDefault objectForKey:defUserConfig];
            [clsUser configUserWithDic:dic];
        });
    }
}

- (void) configUserWithDic:(NSDictionary *) dic {
    clsUser._uniqueId  =  dic[@"id"];
    clsUser._idBiz =      dic[@"biz_id"];
    clsUser._idPvt =      dic[@"pvt_id"];
    clsUser._tipologia =  dic[@"tipologia"];
    clsUser._myName    =  dic[@"username"];
    
    clsUser._isBiz = ([clsUser._tipologia isEqualToString:defUserBiz]);
    if (clsUser._isBiz) {
        clsUser._myId = clsUser._idBiz;
        clsUser._myType = defUserBiz;
    }
    else {
        clsUser._myId = clsUser._idPvt;
        clsUser._myType = defUserPvt;
    }
}

+ (void) saveUserData:(NSDictionary *) dic {
    [self open];
    NSMutableDictionary *dicTmp = [[NSMutableDictionary alloc] init];
    for (NSString *s in dic.allKeys) {
        NSString *value;
        @try {
            value = dic[s];
        }
        @catch (NSException *exception) {
        }
        @finally {
            if ([value isKindOfClass:[NSNull class]] == NO)
                dicTmp[s] = value;
        }
    }
    [clsUser configUserWithDic:dicTmp];
    [userDefault setObject:dicTmp forKey:defUserConfig];
    [userDefault synchronize];
}

+ (NSString *) uniqueId {
    return clsUser._uniqueId;
}

+ (NSString *) userId {
    return clsUser._myId;
}

+ (NSString *) userType {
    return clsUser._myType;
}

+ (NSString *) userName {
    return clsUser._myName;
}

+ (BOOL) isBiz {
    return clsUser._isBiz;
}

+ (void) userLogout {
    clsUser._uniqueId   = @"";
    clsUser._myId       = @"";
    clsUser._idBiz      = @"";
    clsUser._idPvt      = @"";
    clsUser._tipologia  = @"";
    clsUser._myType     = @"";
    clsUser._myName     = @"";
    [userDefault removeObjectForKey:defUserConfig];
    [userDefault synchronize];
}

@end
