//
//  ClsSettings.m
//  K Sport
//
//  Created by Luciano Calderano on 18/02/15.
//  Copyright (c) 2015 Kanito.it. All rights reserved.
//

#import "ClsSettings.h"

@implementation ClsSettings {
}

static NSUserDefaults *userDefault;

+ (void) open {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"userSettings"];
    });
}

+ (void) setVal:(NSString *)value ForKey:(userSettings) userSet {
    [ClsSettings open];
    [userDefault setObject:value forKey:[self key:userSet]];
    [userDefault synchronize];
}

+ (NSString *) getValForKey:(userSettings) userSet {
    [ClsSettings open];
    NSString *s = [self key:userSet];
    s = [userDefault objectForKey:s];
    if (s == nil)
        s = @"";
    return s;
}

+ (void) setObj:(NSObject *)obj ForKey:(userSettings) userSet {
    [ClsSettings open];
    [userDefault setObject:obj forKey:[self key:userSet]];
    [userDefault synchronize];
}

+ (NSObject *) getObjForKey:(userSettings) userSet {
    [ClsSettings open];
    NSString *s = [self key:userSet];
    NSObject *obj = [userDefault objectForKey:s];
    return obj;
}

+ (NSString *) key:(NSInteger) userKey {
    return [NSString stringWithFormat:@"%04ld", (long)userKey];
}

@end
