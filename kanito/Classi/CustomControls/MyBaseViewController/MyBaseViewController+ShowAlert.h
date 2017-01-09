//
//  MyBaseViewController+ShowAlert.h
//  csen cinofilia
//
//  Created by Luciano Calderano on 11/07/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MyBaseViewController.h"

@interface MyBaseViewController (ShowAlert)

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)msg;
- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)msg
                    okBlock:(void (^) (void)) okBlock;
- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)msg
                cancelBlock:(void (^) (void)) cancelBlock
                    okBlock:(void (^) (void)) okBlock;

@end
