//
//  ClsFB.h
//  Kanito
//
//  Created by Luciano Calderano on 15/05/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClsFB : NSObject

@property (nonatomic, strong) UIViewController *viewCtrl;

- (void) queryFacebookOnComplete:(void (^)(BOOL succeeded, NSDictionary *dicExit))completionBlock;
@end
