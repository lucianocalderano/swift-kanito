//
//  ViewAdSelect.m
//  Kanito
//
//  Created by Luciano Lc on 12/09/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "ViewAdopPics.h"
#import "UIImageView+Download.h"

@interface ViewAdopPics () {
    IBOutlet UIScrollView *scrlAdImages;
}

@end

@implementation ViewAdopPics

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    scrlAdImages.contentSize = CGSizeZero;
    [self start];
}

- (void) start{
    NSMutableArray *array = [NSMutableArray array];
    CGFloat x = 0;
    for (NSInteger i = 0; i < self.arrImg.count; i++) {
        UIImageView *imv = [self createImageAtX:x];
        [scrlAdImages addSubview:imv];
        
        x += scrlAdImages.frame.size.width;
        
        NSDictionary *dic = self.arrImg[i];
        [array addObject:@[imv, dic[@"url"]]];
    }
    scrlAdImages.contentSize = CGSizeMake(x, scrlAdImages.frame.size.height);
    
    for (NSArray *arr in array ) {
        UIImageView *imv = arr[0];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:imv animated:YES];
        [imv downloadFromUrl:[self createUrlString:arr[1]]
                  completion:^(UIImage *image) {
                      if (image) {
                          imv.image = image;
                      }
                      else {
                          imv.backgroundColor = [UIColor lightGrayColor];
                      }
                      [hud hideAnimated:YES];
                  }];
    }
}

- (UIImageView *) createImageAtX:(CGFloat)x {
    UIImageView *imv = [[UIImageView alloc] init];
    imv.frame = CGRectMake(x, 0, scrlAdImages.frame.size.width, scrlAdImages.frame.size.height);
    imv.layer.borderColor = [MyColor myOrange].CGColor;
    imv.layer.borderWidth = 1.0f;
    imv.contentMode = UIViewContentModeScaleAspectFit;
    return imv;
}

- (NSString *) createUrlString:(NSString *) strUrl {
    NSArray *arr = [strUrl componentsSeparatedByString:@"&"];
    if (arr.count > 0) {
        strUrl = [NSString stringWithFormat:@"%@&zc=3&w=%.0f&h=%.0f", arr.firstObject,
                  self.view.frame.size.width * 2, self.view.frame.size.height * 2];
    }
    return strUrl;
}
@end
