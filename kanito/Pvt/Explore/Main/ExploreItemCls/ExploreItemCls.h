//
//  ExploreItemCls.h
//  kanito
//
//  Created by Luciano Calderano on 06/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExploreItemCls : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDictionary *itemDic;

@property (nonatomic, strong) NSString *nome;
@property (nonatomic, strong) NSString *razz;
@property (nonatomic, strong) NSString *prop;
@property (nonatomic, strong) NSString *like;

@property (nonatomic, strong) NSBlockOperation *operation;

@end
