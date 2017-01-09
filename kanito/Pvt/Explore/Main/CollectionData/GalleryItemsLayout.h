//
//  GalleryItemsLayout.h
//  UICollectionView_p1_ObjC
//
//  Created by Olga Dalton on 27/02/15.
//  Copyright (c) 2015 Olga Dalton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GalleryItemsLayoutDataSource <NSObject>

- (CGSize)getImageSizeAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface GalleryItemsLayout : UICollectionViewLayout

@property (nonatomic, assign) id dataSource;
@property (nonatomic, assign) NSInteger maxColumns;

@property (nonatomic, assign) CGFloat horizontalInset;
@property (nonatomic, assign) CGFloat verticalInset;

@end
