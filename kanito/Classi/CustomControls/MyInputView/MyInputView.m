//
//  MyInputView.m
//  kanito
//
//  Created by Luciano Calderano on 13/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MyInputView.h"

@interface MyInputView () <UITextFieldDelegate>

@property (nonatomic, strong) IBInspectable UIImage *image;
@property (nonatomic, strong) IBInspectable NSString *placeHolder;

@property (nonatomic, weak) IBOutlet MyInputView *nextInputView;

@end

@implementation MyInputView

#pragma mark - Protected methods

+ (instancetype)Instance {
    NSString *className = NSStringFromClass([self class]);
    return [[NSBundle mainBundle] loadNibNamed:className
                                         owner:self
                                       options:nil].firstObject;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    if (self.subviews.count > 0) {
        return;
    }

    MyInputView *input = [MyInputView Instance];
    input.frame = self.bounds;
    [self addSubview:input];
    
    self.text = input.text;
    self.imageView = input.imageView;
    self.imageView.image = self.image;
    self.text.placeholder = self.placeHolder;
    self.text.delegate = self;
    
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
}

- (void)textFieldDidBeginEditing:(MyTextField *)textField {
    [self.delegate textFieldDidBeginEditing:textField];
//    [self.nextInputView textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(MyTextField *)textField {
    [self.delegate textFieldDidBeginEditing:textField];
    if (self.nextInputView) {
        [self.nextInputView.text becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(MyTextField *)textField {
    [self.delegate textFieldDidBeginEditing:textField];
//    if (self.nextInputView) {
//        [self.nextInputView.text becomeFirstResponder];
//    }
    return YES;
}

@end
