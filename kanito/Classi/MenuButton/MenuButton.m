//
//  MenuButton.m
//  kanito
//
//  Created by Luciano Calderano on 25/09/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MenuButton.h"

@interface MenuButton ()
@property (nonatomic, strong) IBInspectable UIImage *menuImage;
@property (nonatomic, strong) IBInspectable NSString *menuTitle;
@end

@implementation MenuButton

+ (instancetype)Instance {
    NSString *className = NSStringFromClass([self class]);
    return [[NSBundle mainBundle] loadNibNamed:className
                                          owner:self
                                        options:nil].firstObject;
}

+ (instancetype)newInstance:(MenuButton *)base {
    MenuButton *menuButton = [MenuButton Instance];
    [base addSubview:menuButton];
    menuButton.menuImage = base.menuImage;
    menuButton.menuTitle = base.menuTitle;
    return menuButton;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.image.image = self.menuImage;
    self.label.title = self.menuTitle;
    self.label.textColor = [UIColor whiteColor];
}

- (IBAction)tapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(menuButtonTapped:)])
        [self.delegate menuButtonTapped:self];
}

- (void) setMenuImage:(UIImage *)menuImage {
    _menuImage = menuImage;
    _image.image = menuImage;
}

- (void) setMenuTitle:(NSString *)menuTitle {
    _menuTitle = menuTitle;
    _label.title = menuTitle;
}
@end
