//
//  GKCycleScrollViewItemCell.h
//  Code
//
//  Created by eon Z on 2022/3/4.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^cellClickBlock)(NSInteger index);



@interface GKCycleScrollViewItemCell : UIView


/// 图片视图
@property (nonatomic, strong) UIImageView   *imageView;

///// 遮罩视图，用于处理透明度渐变
@property (nonatomic, strong) UIView        *coverView;

/// cell点击回调
@property (nonatomic, copy) cellClickBlock  didCellClick;

@property (nonatomic, assign ) NSInteger   currentIndex;

- (void)setupCellFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
