//
//  ClsUser.h
//  CyberGuide
//
//  Created by Sviluppo IOS on 25/02/14.
//  Copyright (c) 2014 Sviluppo IOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsUser : NSObject

@property (nonatomic, assign) 	BOOL _isBiz;
@property (nonatomic, strong) 	NSString *_tipologia;
@property (nonatomic, strong) 	NSString *_uniqueId;
@property (nonatomic, strong) 	NSString *_idBiz;
@property (nonatomic, strong) 	NSString *_idPvt;
@property (nonatomic, strong) 	NSString *_myId;
@property (nonatomic, strong) 	NSString *_myType;
@property (nonatomic, strong) 	NSString *_myName;

+ (void) open;
+ (void) saveUserData:(NSDictionary *) dic;
+ (NSString *) uniqueId;
+ (NSString *) userId;
+ (NSString *) userType;
+ (NSString *) userName;

+ (BOOL) isBiz;
+ (void) userLogout;

@end
