//
//  ViewAdSelect.h
//  Kanito
//
//  Created by Luciano Lc on 12/09/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubAdopDettDelegate <NSObject>

- (void) exitSubAdopDett;

@end


@interface SubAdopDett : UIViewController
@property (nonatomic, assign) id delegate;

- (void) fillWithDic:(NSDictionary *)dic Images:(NSArray *) arrImg;

@end
