//
//  ViewUserDogs.h
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "PvtViewController.h"
#import "ClsRegUserBiz.h"

@protocol ViewRegBizOptDelegate <NSObject>

- (void) exitViewRegBizOptWithItem:(regUserBiz_Items)item;

@end

@interface ViewRegBizOpt : PvtViewController

- (void) clsRegUserBizId:(ClsRegUserBiz *)cls Delegate:(id)delegateMain Item:(regUserBiz_Items)item;

@end
