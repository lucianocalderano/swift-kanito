//
//  ClsFB.m
//  Kanito
//
//  Created by Luciano Calderano on 15/05/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ClsFB.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import "NSDictionary+Utility.h"

@implementation ClsFB

- (void) queryFacebookOnComplete:(void (^)(BOOL succeeded, NSDictionary *dicExit))completionBlock {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[
                                      @"public_profile",
                                      @"email",
                                      ]
                 fromViewController:self.viewCtrl
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    completionBlock (NO, @{ @"err": error.localizedDescription} );
                                    return;
                                } else if (result.isCancelled) {
                                    completionBlock (YES, nil);
                                    return;
                                } else {
                                    if ([result.grantedPermissions containsObject:@"email"]) {
                                        [self grantFacebookOnComplete:completionBlock];
                                    }
                                }
                            }];
}

- (void) grantFacebookOnComplete:(void (^)(BOOL succeeded, NSDictionary *dicExit))completionBlock {
    NSString *path = @"me?fields=first_name,last_name,email,gender,link,birthday";
    [[[FBSDKGraphRequest alloc] initWithGraphPath:path parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error) {
             completionBlock (NO, @{ @"err": error.localizedDescription} );
             return;
         }
         
         NSDictionary *dic = result;
         NSString *strGender = ([[dic getString:@"gender"] isEqualToString:@"male"]) ? @"0" : @"1";
         
         NSMutableDictionary *dicTmp = [[NSMutableDictionary alloc] init];
         dicTmp[@"email"] = [dic getString:@"email"];
         dicTmp[@"account_type"] = defUserPvt;
         dicTmp[@"business_name"] = @"";
         dicTmp[@"first_name"] = [dic getString:@"first_name"];
         dicTmp[@"last_name"] = [dic getString:@"last_name"];
         dicTmp[@"gender"] = strGender;
         dicTmp[@"facebook_url"] = [dic getString:@"link"];
         dicTmp[@"facebook"] = @"1";
         /*
          [dicTmp setObject:[ClsUtil dateConvert:dic[@"user_birthday"]
          fromFormat:@"MM/dd/yyyy"
          toFormat:@"dd-MM-yyyy"] forKey:@"birthday"];
          */
         completionBlock (YES, dicTmp.mutableCopy);
     }];
}
@end
