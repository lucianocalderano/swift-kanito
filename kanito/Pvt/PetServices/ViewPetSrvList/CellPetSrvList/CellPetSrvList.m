//
//  CellPetSrvList.m
//  kanito
//
//  Created by Luciano Calderano on 21/09/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "CellPetSrvList.h"
#import "UIImageView+Download.h"

@implementation CellPetSrvList {
    IBOutlet MyLabel *lblFollowerPvt;
    IBOutlet MyLabel *lblFollowerBiz;
    IBOutlet MyLabel *lblBusinessName;
    IBOutlet MyLabel *lbl_address;
    IBOutlet MyLabel *lbl_distance;
    IBOutlet MyLabel *lblActivity;

    IBOutlet UIImageView *logo;
}

+ (NSString *) cellId {
    return NSStringFromClass([self class]);
}

- (void)setDicPetSrv:(NSDictionary *)dicPetSrv {
    _dicPetSrv = dicPetSrv;
    NSDictionary *dic = dicPetSrv[@"Svcsection"];
    
    lblFollowerPvt.text = [NSString stringWithFormat:@"%ld", [dic[@"pvt_followers"] longValue]];
    lblFollowerBiz.text = [NSString stringWithFormat:@"%ld", [dic[@"biz_followers"] longValue]];
    lblBusinessName.text = [dic[@"business_name"] capitalizedString];
    if (lblBusinessName.text.length == 0)
        lblBusinessName.text = [dic[@"BizUsername"] capitalizedString];

    lbl_address.text = dic[@"address"];
    lbl_distance.text = dic[@"distance"];
    if (lbl_distance.text.length > 0) {
        lbl_distance.attributedText = [ClsUtil attributedStringWithLeftImageName:@"Distance" MaxSize:16 RightText:[NSString stringWithFormat:@"%@ %@ km.", keyLang(@"at"), lbl_distance.text]];
    }
    
    lblActivity.text = @"";
    NSArray *arrAct = dicPetSrv[@"Activity_habtm"];
    for (NSDictionary *dicAct in arrAct) {
        if (lblActivity.text.length > 0)
            lblActivity.text = [lblActivity.text stringByAppendingString:@", "];
        lblActivity.text = [lblActivity.text stringByAppendingString:dicAct[@"name"]];
    }
    
    NSString *strMyId = [ClsUser userId];
    if (strMyId.length == 0) {
        self.btnFollow.alpha = 0.5f;
        self.btnFollow.enabled = NO;
    }
    self.followStatus = [dic[@"following_status"] integerValue];
    
    [logo downloadFromUrl:dic[@"image_url"]
               completion:^(UIImage *image) {
                   if (image) {
                       logo.image = image;
                       logo.alpha = 1;
                   }
               }];
}

- (void)setFollowStatus:(BOOL)followStatus {
    _followStatus = followStatus;
    self.btnFollow.hidden = followStatus;
    [self.btnFollow setTitle: keyLang(@"follow") forState:UIControlStateNormal];
}

- (IBAction) followTapped {
    if ([self.delegate respondsToSelector:@selector(followTapped:)])
        [self.delegate followTapped:self];
}

@end
