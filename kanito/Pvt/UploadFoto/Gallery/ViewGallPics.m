//
//  ViewGallPics.m
//  Kanito
//
//  Created by Luciano Calderano on 17/06/15.
//  Copyright (c) 2015 Kanito. All rights reserved.
//

#import "ViewGallPics.h"
#import "ClsGalleria.h"
#import "ClsSettings.h"

//#import <ImageIO/ImageIO.h>

@class PHAsset;

@interface ViewGallPics () < ClsGalleriaDelegate > {
    IBOutlet UICollectionView *collView;
    IBOutlet UIButton *btnUpload;
    ClsGalleria *clsGalleria;
    NSArray *arrGallPics;
    NSMutableArray *arrData;
    NSMutableSet *setSelected;
    NSInteger imagesReceived;
    
    MBProgressHUD *hud;
}

@end

@implementation ViewGallPics

- (void)viewDidLoad {
    [super viewDidLoad];

    clsGalleria = [[ClsGalleria alloc] init];
    clsGalleria.delegate = self;
    [clsGalleria start];
    setSelected = [[NSMutableSet alloc] init];
    collView.backgroundColor = [UIColor clearColor];
    [self updateBtnTitle];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger i = rect.size.width / 100;
    CGFloat f = rect.size.width - ((i + 1) * 2);
    f /= i;

    UICollectionViewFlowLayout *layout = (id) collView.collectionViewLayout;
    layout.itemSize = CGSizeMake(f, f);
}

- (void) exitClsGalleriaWithArr:(NSArray *)arr {
    arrGallPics = arr;
    [collView reloadData];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return arrGallPics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell"
                                                                           forIndexPath:indexPath];
    
    PHAsset *asset = arrGallPics[(arrGallPics.count - 1) - indexPath.row];
    UIImageView *imvPhoto = (UIImageView *)[cell viewWithTag:99];
    [clsGalleria thumbnailToImageview:imvPhoto asset:asset];
    
    UIImageView *imvCheck = (UIImageView *)[cell viewWithTag:90];
    if ([setSelected containsObject:indexPath]) {
        imvCheck.hidden = NO;
        imvPhoto.alpha = 0.66;
    }
    else {
        imvCheck.hidden = YES;
        imvPhoto.alpha = 1;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([setSelected containsObject:indexPath]) {
        [setSelected removeObject:indexPath];
    }
    else {
        if (setSelected.count >= 3)
            return;
        [setSelected addObject:indexPath];
    }
    [self updateBtnTitle];

    [collView reloadItemsAtIndexPaths:@[ indexPath ]];
}

#pragma mark - Upload selected

- (IBAction)uploadSelected {
    if (setSelected.count == 0)
        return;
    imagesReceived = 0;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (NSIndexPath *idx in setSelected) {
        PHAsset *asset = arrGallPics[(arrGallPics.count - 1) - idx.row];
        [self imageForAsset:asset maxPixelSize:1600];
    }
}

- (void)imageForAsset:(PHAsset *)asset maxPixelSize:(CGFloat)size {
    PHImageManager *ph = [[PHImageManager alloc] init];
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
    opt.synchronous = YES;
    [ph requestImageForAsset:asset
                  targetSize:CGSizeMake(size, size)
                 contentMode:PHImageContentModeAspectFit
                     options:opt
               resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                   [self addImage:result];
               }];
}

- (void) addImage:(UIImage *)image {
    if (arrData == nil) {
        arrData = [[NSMutableArray alloc] init];
    }
    NSData *dat = UIImageJPEGRepresentation(image, 0.8);
    if (dat) {
        [arrData addObject:dat];
    }
    imagesReceived++;
    if (imagesReceived == setSelected.count) {
        [ClsSettings setObj:arrData ForKey:userArrayDataForPicsToUpload];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PvtUpload" bundle:nil];
        UIViewController *ctrl = [sb instantiateViewControllerWithIdentifier:@"ViewFotoInfo"];
        [self.navigationController showViewController:ctrl sender:self];
        [hud hideAnimated:YES];
    }
}

- (void) updateBtnTitle {
    if (setSelected.count == 0)
        [btnUpload setTitle:keyLang(@"galleria.BtnUploadNone") forState:UIControlStateNormal];
    else
        [btnUpload setTitle:[keyLang(@"galleria.BtnUploadPics") stringByReplacingOccurrencesOfString:@"$" withString:(@(setSelected.count)).stringValue] forState:UIControlStateNormal];

}
@end
