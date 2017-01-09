//
//  MyHttp.m
//  kanito
//
//  Created by Luciano Calderano on 30/08/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MyHttp.h"

@interface MyHttpRequest ()

@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, strong) NSDictionary *authDict;
@property (nonatomic, assign) BOOL isBiz;

@end

@implementation MyHttpRequest

+ (id) pvtRequest {
    MyHttpRequest *http = [[MyHttpRequest alloc] init];
    if (http) {
        http.isBiz = NO;
        http.basePath = defServerPvt;
        http.authDict = @{
                          @"auth_code" : defKeyPvt,
                          };
    }
    return http;
}

+ (id) bizRequest {
    MyHttpRequest *http = [[MyHttpRequest alloc] init];
    if (http) {
        http.isBiz = YES;
        http.basePath = defServerBiz;
        http.authDict = @{
                          @"auth_code" : defKeyBiz,
                          };
    }
    return http;
}

- (void) setPage:(NSString *)page {
    _page = [self.basePath stringByAppendingPathComponent:page];
}

- (void) setJson:(NSDictionary *)json {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:json];
    [dic addEntriesFromDictionary:self.authDict];
    _json = dic.copy;
}

@end

@implementation MyHttp

+ (void)httpRequest:(MyHttpRequest *) request completion:(httpResponse) completionBlock {
//    MYObjC_HttpRequest *req = [[MYObjC_HttpRequest alloc] init];
//    if (request.isBiz) {
//        [req startBizWithPage:request.page
//                        param:request.json
//                   completion:^(BOOL sucess, NSDictionary* resultDict) {
//                       completionBlock (sucess, resultDict);
//                   }];
//    }
//    else {
//        [req startPvtWithPage:request.page
//                        param:request.json
//                   completion:^(BOOL sucess, NSDictionary* resultDict) {
//                       completionBlock (sucess, resultDict);
//                   }];
//        
//    }
    
    MBProgressHUD *hud = nil;
    if (request.view) {
        hud = [MBProgressHUD showHUDAddedTo:request.view animated:YES];
    }
    
    [super loadHttpWithUrl:request.page
                      json:request.json
           completionBlock:^(BOOL succeeded, NSDictionary *resultDict) {
               if (request.view) {
                   [hud hideAnimated:YES];
               }
               completionBlock (succeeded, resultDict);
           }];
}


@end
