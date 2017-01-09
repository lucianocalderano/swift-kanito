//
//  ViewAdSelect.m
//  Kanito
//
//  Created by Luciano Lc on 12/09/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewAdopDett.h"
#import "SubAdopDett.h"
#import "ViewAdopPics.h"
#import "MyBaseViewController+ShowAlert.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface ViewAdopDett () < SubAdopDettDelegate, MFMailComposeViewControllerDelegate >{
    IBOutlet UIScrollView *scrlAdSelSub;
    IBOutlet UIButton *btnContact;
    
    NSString *strEml;
    UIView *viewPic;
    NSArray *arrPhotos;
    SubAdopDett *subAdopDett;
}
@end

@implementation ViewAdopDett

- (void)viewDidLoad {
    [super viewDidLoad];

    [btnContact setTitle:keyLang(@"adoptions.ContactUs") forState:UIControlStateNormal];
    subAdopDett = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewAdSelSub"];
    subAdopDett.delegate = self;
    
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self.view;
    request.page = @"cldsection/retrive-ad-details";
    request.json = @{
                     @"lang_id"       : [ClsLang langId],
                     @"id"            : (self.dicAd)[@"id"],
                     @"img_width"     : @(self.view.frame.size.width * 2),
                     @"img_height"    : @(self.view.frame.size.height * 2),
                     @"img_crop"      : @"3",
                     @"img_bg"        : @"e7edef",
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if (succeeded) {
                     [self httpResponse:resultDict];
                 }
             }];
}

- (void) httpResponse:(NSDictionary *) dicExit {
    NSDictionary *dic = dicExit[@"classifieds"];
    arrPhotos = dic[@"Files"];
    dic = dic[@"Cldsection"];
    self.myNavigationBar.titolo = [dic[@"title"] uppercaseString];
    strEml = dic[@"user_email"];
    
    [scrlAdSelSub addSubview:subAdopDett.view];
    [subAdopDett fillWithDic:dic Images:arrPhotos];
    if (strEml.length == 0)
        btnContact.enabled = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    scrlAdSelSub.contentSize = subAdopDett.view.frame.size;
}

#define nextViewAdPhotos @"ViewAdopPics"

- (void) exitSubAdopDett {
    if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
        ViewAdopPics *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:nextViewAdPhotos];
        ctrl.arrImg = arrPhotos;
        ctrl.strTitle = self.myNavigationBar.titolo;
        [self.navigationController showViewController:ctrl sender:self];
    }
    else {
        [self performSegueWithIdentifier:nextViewAdPhotos sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:nextViewAdPhotos]) {
        ViewAdopPics *ctrl = segue.destinationViewController;
        ctrl.arrImg = arrPhotos;
        ctrl.strTitle = self.myNavigationBar.titolo ;
    }
}

#pragma mark -

- (void) closePic {
    [viewPic removeFromSuperview];
    viewPic = nil;
}

- (IBAction) btnContact {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller == nil)
        return;
    controller.mailComposeDelegate = self;
    
    [controller setToRecipients:@[ strEml ]];
    [controller setSubject:[NSString stringWithFormat:@"%@ - %@", keyLang(@"adoptions.EmailObj"), self.myNavigationBar.titolo]];
    [controller setMessageBody:keyLang(@"adoptions.EmailTxt") isHTML:NO];
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
