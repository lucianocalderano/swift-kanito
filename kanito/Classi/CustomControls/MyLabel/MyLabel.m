
//  MyLabel.m
//  csen cinofilia
//
//  Created by Luciano Calderano on 25/03/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (instancetype)init {
    self = [super init];
    if (self)
        [self defaultMyLabel];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
        [self defaultMyLabel];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        [self defaultMyLabel];
    return self;
}

- (void) defaultMyLabel {
    self.minimumScaleFactor = 0.75;
    self.adjustsFontSizeToFitWidth = YES;
    self.font = [MyFont fontSize:self.font.pointSize Type:MyFontTypeSemiBold];
    self.title = self.text;
//    if ([[self.text substringToIndex:1] isEqualToString:@"#"])
//        self.text = keyLang([self.text substringFromIndex:1]);
    //    self.textColor = defCol_Blu;
}

- (void) setTitle:(NSString *)title {
    if (title.length > 0 && [[title substringToIndex:1] isEqualToString:@"#"]) {
        self.text = keyLang([title substringFromIndex:1]);
    }
    else {
        self.text = title;
    }
}
@end
