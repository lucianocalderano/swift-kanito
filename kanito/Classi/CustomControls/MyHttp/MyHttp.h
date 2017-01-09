//
//  MyHttp.h
//  kanito
//
//  Created by Luciano Calderano on 30/08/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "ClsHttp.h"

typedef void (^httpResponse)(BOOL succeeded, NSDictionary *resultDict);

#define defKeyPvt       @"A221F6>S)>Z#1i`Md6D6Efl?:$9J)9CKy[ol396+U10MBTrj2;0juwCR~6b-igi"
#define defKeyBiz       @"B221F6>S)>Z#1i`Md6D6Efl?:$(iUsad73%90Aa£$)+U10MBTrj2;0juwCR~6b-igi"

#define defServerPvt    @"http://www.kanito.it/mobile/"
#define defServerBiz    @"http://software.kanito.it/mobile/api/"


@interface MyHttpRequest : NSObject

@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) UIView *view;

+ (id) pvtRequest;
+ (id) bizRequest;

@end

@interface MyHttp : ClsHttp

+ (void)httpRequest:(MyHttpRequest *) request completion:(httpResponse) completionBlock;


@end
