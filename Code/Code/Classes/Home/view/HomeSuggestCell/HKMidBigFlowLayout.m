//
//  HKMidBigFlowLayout.m
//  Code
//
//  Created by hanchuangkeji on 2018/5/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMidBigFlowLayout.h"



@implementation HKMidBigFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attrs = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    int i = 0;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat scale = 1 - fabs(attr.center.x - contentOffsetX - collectionViewCenterX) / self.collectionView.bounds.size.width;
        
        
        CGFloat detal = fabs(attr.center.x - contentOffsetX - collectionViewCenterX);
        
        
        if (i == 2) {
            NSLog(@"\n");
        }
        if (detal > 300.0) {
            scale = 0.95;
        } else {
            scale =  1 - (detal / 300.0) * 0.05;
        }
        
//        NSLog(@"contentOffsetX %f  %d ---> %.2f  scale %f", contentOffsetX, i, detal, scale);
        
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        i++;
    }
    return attrs;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (ABS(minDelta) > ABS(attributes.center.x - centerX)) {
            minDelta = attributes.center.x - centerX;
        }
    }
    
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

//  UICollectionViewFlowLayout has cached frame mismatch for index path这个警告来源主要是在使用layoutAttributesForElementsInRect：方法返回的数组时，没有使用该数组的拷贝对象，而是直接使用了该数组。解决办法对该数组进行拷贝，并且是深拷贝。

- (NSArray *)deepCopyWithArray:(NSArray *)arr {
    NSMutableArray *arrM = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in arr) {
        [arrM addObject:[attr copy]];
    }
    return arrM;
}

@end
