//
//  HKWaterflowLayout.h
//  FOF
//
//  Created by hanchuangkeji on 2017/6/12.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKWaterflowLayout;

@protocol HKWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(HKWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(HKWaterflowLayout *)waterflowLayout;
@end

@interface HKWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<HKWaterflowLayoutDelegate> delegate;
@end
