//
//  ExploreItemCls.m
//  kanito
//
//  Created by Luciano Calderano on 06/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import "ExploreItemCls.h"
#import "ClsCacheImg.h"

@interface ExploreItemCls ()

@end

@implementation ExploreItemCls

- (void)setItemDic:(NSDictionary *)itemDic {
    _itemDic = itemDic;
    self.nome = [_itemDic getString:@"dogName"];
    self.razz = [_itemDic getString:@"DogBreed"];
    self.prop = [_itemDic getString:@"owner_name"];
    self.like = [_itemDic getString:@"pats"];
    
    self.nome = (self.nome).uppercaseString;
    if (self.razz.length == 0)
        self.razz = keyLang(@"explList.NoBreed");
    
    NSInteger i = (self.like).integerValue;
    if (i > 0)
        self.like = [keyLang(@"explList.NumLike") stringByReplacingOccurrencesOfString:@"#"
                                                                            withString:(@(i)).stringValue];
    else
        self.like = @"";
    
    NSString *url = [_itemDic getString:@"image_url"];
    self.operation = [NSBlockOperation blockOperationWithBlock:^{
        self.image = [ClsCacheImg ImageWithUrl:url];
        if (self.image == nil) {
            self.image = defImageK;
        }
    }];

    
}
@end
