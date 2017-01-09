//
//  ClsCellUtil.h
//  Kanito
//
//  Created by Luciano Lc on 25/06/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ClsCellUtil : NSObject <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

- (instancetype) initWithMainCtrl:(id)idMain
                 TelNum:(NSString *)tel
                  CelNm:(NSString *)cel
                  Email:(NSString *)eml;

- (void) sendSMS;
- (void) openCall;
- (void) openVideoCall;
- (void) sendEmail;

@end
