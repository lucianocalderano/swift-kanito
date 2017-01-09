//
//  ClsGalleria.h
//  Kanito
//
//  Created by Luciano Calderano on 17/06/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@protocol ClsGalleriaDelegate <NSObject>

- (void) exitClsGalleriaWithArr:(NSArray *) arr;

@end

@interface ClsGalleria : NSObject

@property (nonatomic, assign) id delegate;

- (void) start;
- (void) thumbnailToImageview:(UIImageView *)imageView asset:(PHAsset *)asset;
- (void) loadLastThumbnail;

@end
