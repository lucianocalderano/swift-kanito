//
//  CellCani.m
//  Kanito
//
//  Created by Sviluppo IOS on 26/03/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "CellAdopList.h"
#import "UIImageView+Download.h"

@implementation CellAdopList {
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblPubbDate;
    IBOutlet UILabel *lblGndr;
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblAged;
    IBOutlet UILabel *lblBrnd;
    IBOutlet UILabel *lblSize;
    IBOutlet UIImageView *imvPic;
}

- (void) loadWithDic:(NSDictionary *) dicCell {
//    self.backgroundColor = [UIColor colorWithRed:0xf0/255.0f green:0xf0/255.0f blue:0xf0/255.0f alpha:1];
    NSDictionary *dicCld = dicCell[@"Cldsection"];
    lblName.text = [NSString stringWithFormat:@" %@", dicCld[@"title"]].uppercaseString;
    lblPubbDate.text = [NSString stringWithFormat:@"%@: %@", keyLang(@"adoptions.PublDate"), [dicCld[@"creation_data"] substringToIndex:10]];
    lblSize.text = dicCld[@"ads_size"];
    lblBrnd.text = dicCld[@"ads_breed"];
    lblAged.text = dicCld[@"ads_age"];
    NSString *s = dicCld[@"gender"];
    if (s.integerValue == 0)
        s = keyLang(@"genderM");
    else
        s = keyLang(@"genderF");
    lblGndr.text = s;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    s = dicCld[@"city"];
    if ([s isKindOfClass:[NSNull class]] == NO && s.length > 0)
        [str appendString:s];
    s = dicCld[@"country"];
    if ([s isKindOfClass:[NSNull class]] == NO && s.length > 0) {
        if (str.length > 0)
            [str appendString:@" "];
        [str appendFormat:@"(%@)", s];
    }
    lblCity.text = str;
    imvPic.alpha = 0.7;
    [imvPic downloadFromUrl:[dicCld getString:@"image_url"]
                 completion:^(UIImage *image) {
                     if (image) {
                         imvPic.image = image;
                         imvPic.alpha = 1;
                     }
                 }];
}
@end
