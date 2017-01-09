//
//  ClsMenu.h
//  kanito
//
//  Created by Luciano Calderano on 04/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumMenuItem.h"

@interface ClsMenu : UIScrollView

- (instancetype) initInView:(UIView *)mainView withMenu:(UIView *) menuView;

- (void) showMenu;
- (void) hideMenu;

@end
