//
//  VIewActivDet.m
//  Kanito
//
//  Created by Luciano Calderano on 13/04/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ViewPetSrvDett.h"
#import "SubPetSrvDetail.h"

#import "MyBaseViewController+ShowAlert.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface ViewPetSrvDett () < protocolSubPetServiceDett, MFMailComposeViewControllerDelegate > {
    IBOutlet UIScrollView *scrollView;
    SubPetSrvDetail *subPetSrvDetail;
    
    UIView *viewPop;
    UIView *viewSub;
    
    BOOL firstAppear;
}

@end

@implementation ViewPetSrvDett

- (void)viewDidLoad {
    [super viewDidLoad];
    subPetSrvDetail = [SubPetSrvDetail Instance];
    subPetSrvDetail.dicPetService = self.dicPetService;
    subPetSrvDetail.delegate = self;
    [scrollView addSubview:subPetSrvDetail];
    subPetSrvDetail.frame = scrollView.frame;

    self.view.backgroundColor = [UIColor whiteColor];
    firstAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *dic = self.dicPetService[@"Svcsection"];
    
    NSString *title = dic[@"business_name"];
    if (title.length == 0)
        title = dic[@"BizUsername"];

    self.myNavigationBar.titolo = title.uppercaseString;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (firstAppear == NO)
        return;
    scrollView.contentSize = subPetSrvDetail.subResize;
    firstAppear = NO;
}

- (void) delegateBtnClickedOnPetServiceDett:(enumPetSrvDetailAction)type {
    NSString *title = @"";
    NSString *msg = @"";
    switch (type) {
        case enumPetSrvDetailAction_Tel:
            title = @"Chiama";
            msg = [self.dicPetService getString:@"Svcsection.phone"];
            break;
        case enumPetSrvDetailAction_Eml:
            title = @"e-mail";
            msg = [self.dicPetService getString:@"Svcsection.BizAccountEmail"];
            break;
        case enumPetSrvDetailAction_Msg:
            title = @"Videochiamata";
            msg = [self.dicPetService getString:@"Svcsection.phone"];
            break;
    }
    [self showAlertWithTitle:title
                     message:msg
                 cancelBlock:nil
                     okBlock:^{
                         [self exec:type dest:msg];
                     }];
}

- (void)exec:(enumPetSrvDetailAction)type dest:(NSString *) dest{
    switch (type) {
        case enumPetSrvDetailAction_Tel: {
            NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:@"+1234567890"].invertedSet;
            NSString *s = [[dest componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            s = [NSString stringWithFormat:@"tel://%@", s];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
        }
            break;
        case enumPetSrvDetailAction_Eml:
            [self sendEmailTo:dest];
            break;
        default:
            break;
    }
}

#pragma mark - Email

- (void) sendEmailTo:(NSString *) strEml {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller == nil)
        return;
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[ strEml ]];
    [controller setSubject:@""];
    [controller setMessageBody:@"" isHTML:NO];
    
    [self presentViewController:controller animated:YES completion:nil];
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

    [self showAlertWithTitle:title message:message okBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
@end
