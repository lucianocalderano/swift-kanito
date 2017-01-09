//
//  MyInputView.h
//  kanito
//
//  Created by Luciano Calderano on 13/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"

@interface MyInputView : UIView

@property (nonatomic, assign) IBOutlet id delegate;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet MyTextField *text;

@end
