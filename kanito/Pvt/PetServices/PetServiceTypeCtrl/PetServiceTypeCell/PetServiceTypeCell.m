//
//  PetServiceTypeCell
//  kanito
//
//  Created by Luciano Calderano on 19/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "PetServiceTypeCell.h"
#import "ClsPetSrv.h"

@implementation PetServiceTypeCell {
    IBOutlet MyLabel *title;
    IBOutlet UIImageView *imageView;
    UIImage *img_On;
    UIImage *img_Off;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.idService = [dict getString:@"id"];
    img_On = [ClsPetSrv getImagePetActivityWithId:self.idService];
    img_Off= [ClsPetSrv toGrayscale:img_On];
    title.text = [dict getString:@"name"];
}

- (void)setSelected:(BOOL)selected {
    imageView.image = (selected) ? img_On : img_Off;
}
@end
