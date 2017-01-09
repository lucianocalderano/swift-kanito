//
//  ClsCellUtil.m
//  Kanito
//
//  Created by Luciano Lc on 25/06/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ClsCellUtil.h"
#import "MyBaseViewController.h"
#import "MyBaseViewController+ShowAlert.h"

@implementation ClsCellUtil {
    NSString *strTel;
    NSString *strCel;
    NSString *strEml;
    MyBaseViewController *ctrlMain;
}

- (instancetype) initWithMainCtrl:(id)idMain
                 TelNum:(NSString *)tel
                  CelNm:(NSString *)cel
                  Email:(NSString *)eml {
    self = [super init];
    ctrlMain = idMain;
    strEml = eml;
    strCel = cel;
    strTel = tel;
    return self;
}

#pragma mark - Send SMS

- (void) sendSMS {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        controller.body = @"Message ...";
        controller.recipients = @[strCel];
        controller.messageComposeDelegate = self;
        [ctrlMain presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[ctrlMain dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

#pragma mark - Telefonata

- (void) openCall {
    NSString *s = (strCel.length > 0) ? strCel : strTel;
    s = [NSString stringWithFormat:@"telprompt://%@", s];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}

#pragma mark - Video Telefonata

- (void) openVideoCall {
    NSString *s = [NSString stringWithFormat:@"facetime://%@", strCel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}


#pragma mark - Email

- (void) sendEmail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller == nil)
        return;
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[ strEml ]];
    [controller setSubject:@""];
    [controller setMessageBody:@"" isHTML:NO];
    
    [ctrlMain presentViewController:controller animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    NSString *title = @"";
    NSString *message = @"";
    switch (result) {
        case MFMailComposeResultSent:
            title = @"Email sent";
            break;
        case MFMailComposeResultCancelled:
            title = @"Email canceled";
            break;
        default:
            title = @"Email error !";
            message = error.localizedDescription;
            break;
    }
    
    [ctrlMain showAlertWithTitle:title message:message okBlock:^{
        [ctrlMain dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
