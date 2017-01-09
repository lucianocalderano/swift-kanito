//
//  GalleryItemCollectionViewCell.m
//  UICollectionView_p1_ObjC
//
//  Created by Olga Dalton on 19/11/14.
//  Copyright (c) 2014 Olga Dalton. All rights reserved.
//

#import "GalleryItemCollectionViewCell.h"
#import "ExploreItemCls.h"
#import "MyButton.h"

@implementation GalleryItemCollectionViewCell {
    IBOutlet MyLabel *lblNome;
    IBOutlet MyLabel *lblLike;
    IBOutlet MyLabel *lblRazz;
    IBOutlet UIImageView *itemImageView;
}

- (void)setItem:(ExploreItemCls *)item {
    _item = item;
    itemImageView.image = item.image;
    lblNome.text = item.nome;
    lblLike.text = item.like;
    lblRazz.text = item.razz;
}

@end
