//
//  ViewAdSelect.m
//  Kanito
//
//  Created by Luciano Lc on 12/09/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "SubAdopDett.h"
#import "UIImageView+Download.h"

@interface SubAdopDett () {
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblPubl;
    IBOutlet UILabel *lblData;
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblDesc;
    IBOutlet UILabel *lblDescData;
    IBOutlet UILabel *lblWarnHead;
    IBOutlet UILabel *lblWarnBody;
    
    IBOutlet UIImageView *imvFoto;
    
    BOOL firstAppear;
}

@end

@implementation SubAdopDett

- (void)viewDidLoad {
    [super viewDidLoad];
    firstAppear = YES;
    CGRect rect = self.view.frame;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    self.view.frame = rect;
}

- (void) fillWithDic:(NSDictionary *)dic Images:(NSArray *) arrImg {
    NSString *s;
    NSMutableString *str = [[NSMutableString alloc] init];
    s = dic[@"ads_breed"];
    if (s.length > 0)
        [str appendFormat:@"%@, ", s];
    s = dic[@"ads_size"];
    if (s.length > 0)
        [str appendFormat:@"%@, ", s];
    s = dic[@"ads_age"];
    if (s.length > 0)
        [str appendFormat:@"%@, ", s];

    s = dic[@"gender"];
    if (s.integerValue == 0)
        [str appendString:keyLang(@"genderM")];
    else
        [str appendString:keyLang(@"genderF")];
    
    lblName.text = dic[@"name"];
    lblPubl.text = [NSString stringWithFormat:@"%@ %@, %@ %@",  keyLang(@"adoptions.PublDate"), [dic[@"creation_data"] substringToIndex:10], keyLang(@"by"), dic[@"username"]];
    lblData.text = str;
    
    [str setString:@""];
    s = dic[@"city"];
    if ([s isKindOfClass:[NSNull class]] == NO && s.length > 0)
        [str appendString:s];
    s = dic[@"country"];
    if ([s isKindOfClass:[NSNull class]] == NO && s.length > 0) {
        if (str.length > 0)
            [str appendString:@" "];
        [str appendFormat:@"(%@)", s];
    }
    lblCity.text = str;
    lblDesc.text = keyLang(@"description");
    lblDescData.text = dic[@"description"];
    lblWarnHead.text = keyLang(@"adoptions.WarnHead");
    lblWarnBody.numberOfLines = 0;
    lblWarnBody.text = [keyLang(@"adoptions.WarnBody") stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];

    imvFoto.alpha = 0.7;
    if (arrImg.count > 0) {
        NSDictionary *dic = arrImg[0];
        NSString *strUrl = dic[@"url"];
        [imvFoto downloadFromUrl:strUrl
                      completion:^(UIImage *image) {
                          if (image) {
                              imvFoto.image = image;
                              imvFoto.contentMode  = UIViewContentModeScaleAspectFit;
                              imvFoto.userInteractionEnabled = YES;
                              imvFoto.alpha = 1.0;
                              UITapGestureRecognizer *tap;
                              tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subViewPicTapped:)];
                              [imvFoto addGestureRecognizer:tap];
                          }
                      }];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (firstAppear == NO)
        return;
    
    firstAppear = NO;
    if (lblDescData.text.length == 0) {
        lblDescData.hidden = lblDesc.hidden = YES;
        return;
    }
    
    [lblDescData sizeToFit];
    CGRect rect = self.view.frame;
    rect.size.height = lblDescData.frame.origin.y + lblDescData.frame.size.height + lblWarnBody.frame.size.height + 10;
    self.view.frame = rect;
}

- (void) subViewPicTapped:(UITapGestureRecognizer *) sender {
    [self.delegate exitSubAdopDett];
}


@end
