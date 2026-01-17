//
//  GKCycleScrollViewCell.h
//  GKCycleScrollViewDemo
//
//  Created by QuintGao on 2019/9/15.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GKCycleScrollViewCell,HKBuyVipModel;

typedef void(^cellClickBlock)(NSInteger index);

@interface GKCycleScrollViewCell : UIView

/// 图片视图
@property (nonatomic, strong) UIImageView   *imageView;

///// 遮罩视图，用于处理透明度渐变
@property (nonatomic, strong) UIView        *coverView;

/// cell点击回调
@property (nonatomic, copy) cellClickBlock  didCellClick;

@property (nonatomic, assign ) NSInteger   currentIndex;

@property (nonatomic, assign ) BOOL   fromVip;


@property (nonatomic, strong)HKBuyVipModel * model;
- (void)setupCellFrame:(CGRect)frame;

@end
