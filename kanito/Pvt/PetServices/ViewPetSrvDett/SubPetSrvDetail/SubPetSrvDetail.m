//
//  SubPetSrvDetail.m
//  kanito
//
//  Created by Luciano Calderano on 18/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "SubPetSrvDetail.h"
#import "UIImageView+Download.h"
#import "MyButton.h"

@interface SubPetSrvDetail () {
    IBOutlet UIButton *btnTel;
    IBOutlet UIButton *btnEml;
    IBOutlet UIButton *btnMsg;
    
    IBOutlet UIView  *viewContactUs;
    
    IBOutlet UIImageView *logo;

    IBOutlet MyButton *follow;
    IBOutlet MyLabel *followedPvt;
    IBOutlet MyLabel *followedBiz;

    IBOutlet MyLabel *activityName;
    IBOutlet MyLabel *activities;

    IBOutlet MyLabel *address;
    IBOutlet MyLabel *city;

    IBOutlet MyLabel *descriptionLabel;
    IBOutlet UITextView *descriptionText;
}
@end

@implementation SubPetSrvDetail

+ (instancetype)Instance {
    NSString *className = NSStringFromClass([self class]);
    return [[NSBundle mainBundle] loadNibNamed:className
                                         owner:self
                                       options:nil].firstObject;
}

- (void)setDicPetService:(NSDictionary *)dicPetService {
    _dicPetService = dicPetService;
    
    NSDictionary *dic = dicPetService[@"Svcsection"];
    
    followedPvt.text = [NSString stringWithFormat:@"%ld", (long)[dic[@"pvt_followers"] integerValue]];
    followedBiz.text = [NSString stringWithFormat:@"%ld", (long)[dic[@"biz_followers"] integerValue]];
    
    activityName.text = dic[@"business_name"];
    if (activityName.text.length == 0)
        activityName.text = dic[@"BizUsername"];
    activityName.text = activityName.text.capitalizedString;
    
    activities.text = @"";
    NSArray *arrAct = [self.dicPetService getArray:@"Activity_habtm"];
    for (NSDictionary *dicAct in arrAct) {
        if (activities.text.length > 0)
            activities.text = [activities.text stringByAppendingString:@", "];
        activities.text = [activities.text stringByAppendingString:dicAct[@"name"]];
    }
    
    address.text = dic[@"address"];
    NSString *s = dic[@"BizProvinceName"];

    city.text = dic[@"BizCityName"];
    if (s.length > 0) {
        if (city.text.length > 0)
            city.text = [city.text stringByAppendingString:@", "];
        city.text = [city.text stringByAppendingString:s];
    }
    
    [follow setTitle:keyLang(@"follow") forState:UIControlStateNormal];
    NSString *strMyId = [ClsUser userId];
    if (strMyId.length > 0) {
        [follow addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [follow setTitle:dic[@"id"] forState:UIControlStateApplication];
        if ([dic[@"following_status"] integerValue] > 0)
            [follow setTitle:keyLang(@"unfollow") forState:UIControlStateNormal];
    }
    else {
        follow.enabled = NO;
        follow.alpha = 0.3;
    }

    NSString *sTel = dic[@"phone"];
    NSString *sEml = dic[@"BizAccountEmail"];
    if (sTel.length + sEml.length > 0) {
        if (sTel.length == 0)
            btnTel.enabled = NO;
        if (sEml.length == 0)
            btnEml.enabled = NO;
    }
    else {
        viewContactUs.hidden = YES;
    }
    descriptionText.hidden = descriptionLabel.hidden = YES;
    descriptionText.text = [dic getString:@"description"];

    [logo downloadFromUrl:dic[@"image_url"]
               completion:^(UIImage *image) {
                   if (image) {
                       logo.image = image;
                       logo.alpha = 1.0f;
                   }
               }];
}

- (CGSize) subResize {
    if (descriptionText.text.length > 0) {
        descriptionText.hidden = descriptionLabel.hidden = NO;
        descriptionText.backgroundColor = descriptionLabel.backgroundColor;
        descriptionText.font = [MyFont fontSize:14];
        descriptionText.scrollEnabled = NO;
        descriptionText.editable = NO;

        CGRect rect = self.frame;
        [descriptionText sizeToFit];
        rect.size.height += descriptionText.frame.size.height;
        self.frame = rect;
    }
    return self.frame.size;
}

- (void)btnClick:(id) sender {
    UIButton *btn = sender;
    NSString *strId = [btn titleForState:UIControlStateApplication];
    NSString *strFoll = ([[btn titleForState:UIControlStateNormal] isEqualToString:keyLang(@"follow")]) ? @"unfollow" : @"follow";
    
    MyHttpRequest *request = [MyHttpRequest pvtRequest];
    request.view = self;
    request.page = @"follow-function";
    request.json = @{
                     @"action"         : strFoll,
                     @"followed_id"    : strId,
                     @"followed_type"  : defUserBiz,
                     @"follower_id"    : [ClsUser userId],
                     @"follower_type"  : [ClsUser userType],
                     };
    
    [MyHttp httpRequest:request
             completion:^(BOOL succeeded, NSDictionary *resultDict) {
                 if ([[btn titleForState:UIControlStateNormal] isEqualToString:keyLang(@"follow")])
                     [btn setTitle:keyLang(@"unfollow") forState:UIControlStateNormal];
                 else
                     [btn setTitle:keyLang(@"follow") forState:UIControlStateNormal];
             }];
}

- (IBAction)btnClicked:(id)sender {
    if (sender == btnTel) {
        [self.delegate delegateBtnClickedOnPetServiceDett:enumPetSrvDetailAction_Tel];
    }
    else if (sender == btnEml) {
        [self.delegate delegateBtnClickedOnPetServiceDett:enumPetSrvDetailAction_Eml];
    }
    else if (sender == btnMsg) {
        [self.delegate delegateBtnClickedOnPetServiceDett:enumPetSrvDetailAction_Msg];
    }
}

@end
