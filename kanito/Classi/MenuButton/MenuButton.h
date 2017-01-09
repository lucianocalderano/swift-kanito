//
//  MenuButton.h
//  kanito
//
//  Created by Luciano Calderano on 25/09/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuButtonDelegate <NSObject>

- (void) menuButtonTapped:(id) sender;

@end

IB_DESIGNABLE

@interface MenuButton : UIView

+ (instancetype)newInstance:(MenuButton *) base;

@property (nonatomic, assign) IBOutlet id delegate;
@property (nonatomic, strong) NSObject *info;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet MyLabel *label;

@end
