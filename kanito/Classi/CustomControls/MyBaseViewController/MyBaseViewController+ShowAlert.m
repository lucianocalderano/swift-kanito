//
//  MyBaseViewController+ShowAlert.m
//  csen cinofilia
//
//  Created by Luciano Calderano on 11/07/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MyBaseViewController+ShowAlert.h"

@implementation MyBaseViewController (ShowAlert)

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)msg {
    [self showAlertWithTitle:title
                     message:msg
                 cancelBlock:nil
                     okBlock:nil
                  showCancel:NO];
}

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)msg
                    okBlock:(void (^) (void)) okBlock {
    [self showAlertWithTitle:title
                     message:msg
                 cancelBlock:nil
                     okBlock:okBlock
                  showCancel:NO];
}

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)msg
                cancelBlock:(void (^) (void)) cancelBlock
                    okBlock:(void (^) (void)) okBlock {
    [self showAlertWithTitle:title
                     message:msg
                 cancelBlock:cancelBlock
                     okBlock:okBlock
                  showCancel:YES];
}

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)msg
                cancelBlock:(void (^) (void)) cancelBlock
                    okBlock:(void (^) (void)) okBlock
                 showCancel:(BOOL) showCancel {
    
    if (title.length > 1 && [[title substringToIndex:1] isEqualToString:@"#"]) {
        title = keyLang([title substringFromIndex:1]);
    }
    if (msg.length > 1 && [[msg substringToIndex:1] isEqualToString:@"#"]) {
        msg = keyLang([msg substringFromIndex:1]);
    }

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (showCancel) {
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:keyLang(@"cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             if (cancelBlock) {
                                                                 cancelBlock();
                                                             }
                                                         }];
        [alert addAction:noAction];
    }
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:keyLang(@"OK")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         if (okBlock) {
                                                             okBlock();
                                                         }
                                                     }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
