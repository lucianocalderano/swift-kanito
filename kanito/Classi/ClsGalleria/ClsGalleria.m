//
//  ClsGalleria.m
//  Kanito
//
//  Created by Luciano Calderano on 17/06/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ClsGalleria.h"
#import <ImageIO/ImageIO.h>

@import Photos;

@interface ClsGalleria () {
    NSMutableArray *arrAssets;
}
@end

@implementation ClsGalleria

- (void) avvia {
    
}


- (void) start {
    [self grabAllMediaCompletion:^(NSArray *arr) {
        [self.delegate exitClsGalleriaWithArr:arr];
    }];
}

- (void) thumbnailToImageview:(UIImageView *)imageView asset:(PHAsset *)asset {
    NSInteger retinaMultiplier = [UIScreen mainScreen].scale;
    CGSize retinaSquare = CGSizeMake(imageView.bounds.size.width * retinaMultiplier, imageView.bounds.size.height * retinaMultiplier);
    
    [[PHImageManager defaultManager]  requestImageForAsset:(PHAsset *)asset
                                                targetSize:retinaSquare
                                               contentMode:PHImageContentModeAspectFill
                                                   options:nil
                                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                                 imageView.image = result;
                                             }];
}

- (void) loadLastThumbnail {
    [self grabAllMediaCompletion:^(NSArray *arr) {
        [self.delegate exitClsGalleriaWithArr:arr];
    }];
}

#pragma mark - Image for asset

#pragma mark - ios 8

- (UIImage*)grabImageFromAsset:(PHAsset *)asset {
    __block UIImage *returnImage;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(200, 200)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:
     ^(UIImage *result, NSDictionary *info) {
         returnImage = result;
     }];
    return returnImage;
}

- (NSDictionary *)grabImageDataFromAsset:(PHAsset *)asset {
    __block NSMutableDictionary *imageAssetInfo = [NSMutableDictionary new];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                                    if ([info[@"PHImageResultIsInCloudKey"] isEqual:@YES]) {
                                                        // in the cloud
                                                        NSLog(@"in the cloud (sync grabImageDataFromAsset)");
                                                    }
                                                    imageAssetInfo = [info mutableCopy];
                                                    if (imageData) {
                                                        imageAssetInfo[@"IMAGE_NSDATA"] = imageData;
                                                    }
                                                }];
    return imageAssetInfo;
}

- (void) grabAllMediaCompletion:(void (^)(NSArray *))completion {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    NSMutableArray *allMediaAssetsArray = [NSMutableArray new];
    
    PHFetchResult *fr = [PHAsset fetchAssetsWithOptions:options];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        if (fr.count > 0) {
            for (int idx=0; idx < fr.count; idx++) {
                PHAsset *asset = fr[idx];
                if (asset) {
                    UIImage *assetImage = [self grabImageFromAsset:asset];
                    if (assetImage != nil) {
                        [allMediaAssetsArray addObject:asset];
                    }
                }
            }
            if (completion) completion(allMediaAssetsArray);
        } else {
            if (completion) completion(nil);
        }
    });
}


@end
