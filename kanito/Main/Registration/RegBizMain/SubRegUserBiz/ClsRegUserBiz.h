//
//  RegisterViewController.h
//  Kanito
//
//  Created by Luciano on 1/11/2013.
//  Copyright (c) 2013 Kanito. All rights reserved.
//

typedef NS_ENUM(NSUInteger, regUserBiz_Items) {
    regUserBiz_None,
    regUserBiz_Region,
    regUserBiz_City,
    regUserBiz_Country,
    regUserBiz_Activities,
};


#import <Foundation/Foundation.h>

@interface ClsCity : NSObject
@property (nonatomic, strong) NSString *strId;
@property (nonatomic, strong) NSString *strName;
@end

@interface ClsCountry : NSObject
@property (nonatomic, strong) NSString *strId;
@property (nonatomic, strong) NSString *strIso;
@property (nonatomic, strong) NSString *strName;
@end

@interface ClsActivity : NSObject
@property (nonatomic, strong) NSArray *arrId;
@end

@interface ClsRegUserBiz : NSObject

@property (nonatomic, strong) ClsCity *city;
@property (nonatomic, strong) ClsCountry *country;
@property (nonatomic, strong) ClsActivity *activity;

@property (nonatomic, strong) NSString *strNome;
@property (nonatomic, strong) NSString *strMail;
@property (nonatomic, strong) NSString *strUser;
@property (nonatomic, strong) NSString *strPass;
@property (nonatomic, strong) NSString *strAddr;
@property (nonatomic, strong) NSString *strCap;
@property (nonatomic, strong) NSString *strForeignCity;

@end
