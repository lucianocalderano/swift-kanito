//
//  ClsMenu.m
//  kanito
//
//  Created by Luciano Calderano on 04/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "ClsMenu.h"

@interface ClsMenu () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *screenShot;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIView *mainView;

@end

@implementation ClsMenu

- (instancetype) initInView:(UIView *)mainView withMenu:(UIView *) menuView {
    self = [super init];
    if (self) {
        self.mainView = mainView;
        self.menuView = menuView;
        
        [self configMe];
        [self configScreenShot];
        [self configMenu];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(hideMenu)];
        [self.screenShot addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *sx = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hideMenu)];
        sx.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:sx];
        
        self.hidden = YES;
        self.bounces = NO;
        self.delegate = self;
    }
    return self;
}

- (void) configMe {
    [self.mainView addSubview:self];
    self.frame = self.mainView.frame;
    
    CGSize size = CGSizeMake(self.menuView.frame.size.width + self.frame.size.width, self.frame.size.height);
    self.contentSize = size;
    self.contentOffset = CGPointMake(self.menuView.frame.size.width, 0);
}

- (void) configScreenShot {
    CGRect rect = self.mainView.frame;
    rect.origin.x = self.menuView.frame.size.width;
    self.screenShot = [[UIImageView alloc] initWithFrame:rect];
    self.screenShot.userInteractionEnabled = YES;
    [self addSubview:self.screenShot];
}

- (void) configMenu {
    [self addSubview:self.menuView];
}

- (UIImage*)captureView:(UIView *)myView {
    CGRect rect = [UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [myView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -

- (void) showMenu {
    self.hidden ? [self openMenu] : [self hideMenu];
}

- (void) openMenu {
    if (self.contentOffset.x == self.menuView.frame.size.width) {
        CGRect rect = self.menuView.frame;
        rect.size.height = self.mainView.frame.size.height;
        self.menuView.frame = rect;
        self.screenShot.image = [self captureView:self.mainView];
    }
    self.hidden = NO;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.contentOffset = CGPointMake(0, 0);
                     }
                     completion:^(BOOL fine) {
                     }];
}

- (void) hideMenu {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.contentOffset = CGPointMake(self.menuView.frame.size.width, 0);
                     }
                     completion:^(BOOL fine) {
                         self.hidden = YES;
                     }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x <= self.menuView.frame.size.width / 2) {
        [self openMenu];
    }
    else {
        [self hideMenu];
    }
}

@end

