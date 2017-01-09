//
//  ViewUserDogs.h
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "PvtViewController.h"

@protocol ViewAdFltSelDelegate <NSObject>

@required
- (void) exitAdFltSelId:(NSString *)strId Descri:(NSString *) strDescri;
@end

@interface ViewAdFltSel : PvtViewController

@property (nonatomic, assign) id delegate;

- (void) configFilter:(NSString *)strTitle Feature:(NSString *) feature;

@end
