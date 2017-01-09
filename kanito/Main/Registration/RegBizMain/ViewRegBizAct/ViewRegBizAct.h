//
//  ViewUserDogs.h
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "PvtViewController.h"
#import "ClsRegUserBiz.h"

@protocol ViewRegBizActDelegate <NSObject>

- (void) exitViewRegBizAct;

@end

@interface ViewRegBizAct : PvtViewController

- (void) clsRegUserBizId:(ClsRegUserBiz *)cls Delegate:(id)delegateMain;

@end
