//
//  ViewUserDogs.h
//  Kanito
//
//  Created by Luciano Lc on 21/07/14.
//  Copyright (c) 2014 Kanito. All rights reserved.
//

#import "PvtViewController.h"

typedef NS_ENUM(NSUInteger, enumMyNewDog) {
    optNewDogBrd,
    optNewDogSiz,
    optNewDogAge,
};

@protocol ViewOptPhotoDelegate <NSObject>
@required
- (void) exitOptPhotoId:(NSString *)strId Descri:(NSString *) strDescri;
@end

@interface ViewMyDogOpt : PvtViewController

@property (nonatomic, assign) id delegate;

- (void) configNewDog:(enum enumMyNewDog)opzSelected;
@end
