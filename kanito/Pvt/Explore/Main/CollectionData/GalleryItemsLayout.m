//
//  GalleryItemsLayout.m
//

#import "GalleryItemsLayout.h"

@interface GalleryItemsLayout()

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic, strong) NSMutableArray *pointArray;

@end

@implementation GalleryItemsLayout

- (NSInteger) getColumn {
    NSInteger column = 0;
    CGFloat pointY = CGFLOAT_MAX;
    
    for (NSInteger i = 0; i < self.pointArray.count; i++) {
        CGPoint temp = [self getPointAtIndex:i];
        if (temp.y < pointY) {
            pointY = temp.y;
            column = i;
        }
    }
    return column;
}

- (CGPoint) getPointAtIndex:(NSInteger) column {
    CGPoint pt;
    NSValue *value = self.pointArray[column];
    [value getValue:&pt];
    return pt;
}

#pragma mark - Layout

- (void)invalidateLayout {
    [super invalidateLayout];
    
    self.attributesArray = [NSMutableArray array];
    self.pointArray = [NSMutableArray arrayWithCapacity:self.maxColumns];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width / self.maxColumns;
    for (NSInteger i = 0; i < self.maxColumns; i++) {
        CGFloat x = w * i + self.horizontalInset / self.maxColumns;
        [self.pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, 0.0)]];
    }
}

- (void)prepareLayout {
    [super prepareLayout];

    NSInteger sectionNumber = 0;
    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:sectionNumber];
    for (NSInteger item = self.attributesArray.count; item < numberOfItems; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:sectionNumber];
        
        NSInteger column = [self getColumn];
        CGPoint point = [self getPointAtIndex:column];

        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGSize itemSize = [self.dataSource getImageSizeAtIndexPath:indexPath];
        attributes.frame = CGRectIntegral(CGRectMake(point.x, point.y, itemSize.width, itemSize.height));
        [self.attributesArray addObject:attributes];

        point.y += itemSize.height;
        [self.pointArray setObject:[NSValue valueWithCGPoint:point] atIndexedSubscript:column];
    }
    
    CGFloat contentHeight = 0;
    for (NSInteger i = 0; i < self.pointArray.count; i++) {
        CGPoint temp;
        NSValue *value = self.pointArray[i];
        [value getValue:&temp];
        if (temp.y > contentHeight) {
            contentHeight = temp.y;
        }
    }
    self.contentSize = CGSizeMake(self.collectionView.frame.size.width, contentHeight);
}

#pragma mark - Invalidate

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

#pragma mark - Required methods

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributesArray[indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arr = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.attributesArray) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [arr addObject:attribute];
        }
    }
    return arr;
}

@end
