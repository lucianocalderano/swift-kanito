//
//  MyButton.m
//  csen cinofilia
//
//  Created by Luciano Calderano on 05/07/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultMyButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultMyButton];
    }
    return self;
}

- (void) defaultMyButton {
    NSString *s = [self titleForState:UIControlStateNormal];
    if ([[s substringToIndex:1] isEqualToString:@"#"])
        [self setTitle:keyLang([s substringFromIndex:1]) forState:UIControlStateNormal];
    self.layer.masksToBounds = NO;
    self.showsTouchWhenHighlighted = YES;
    self.titleLabel.font = [MyFont fontSize:self.titleLabel.font.pointSize];
    if (self.backgroundColor == nil) {
        self.backgroundColor = [MyColor myOrange];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
