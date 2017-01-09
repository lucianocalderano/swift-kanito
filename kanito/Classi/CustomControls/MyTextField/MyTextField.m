//
//  MyTextField
//  NextGen
//
//  Created by Lc
//  Copyright (c) 2016 Lc. All rights reserved.
//

#import "MyTextField.h"

@interface MyTextField ()
@property (nonatomic, assign) CGFloat oldYposition;
@end

@implementation MyTextField

#pragma mark - Initialization / dealloc

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        [self initialization];
    }
    
    return self;
}

#pragma mark - Protected methods

- (void)initialization {
}

@end
