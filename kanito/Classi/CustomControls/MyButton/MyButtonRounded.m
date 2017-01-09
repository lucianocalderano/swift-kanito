//
//  MyButton.m
//  csen cinofilia
//
//  Created by Luciano Calderano on 05/07/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MyButtonRounded.h"

@interface MyButtonRounded ()

@end
@implementation MyButtonRounded

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultMyButtonRounded];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultMyButtonRounded];
    }
    return self;
}

- (void) defaultMyButtonRounded {
    self.layer.cornerRadius = 5;
}

@end
