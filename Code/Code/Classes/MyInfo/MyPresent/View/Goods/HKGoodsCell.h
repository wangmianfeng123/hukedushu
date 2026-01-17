//
//  HKGoodsCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKGoodsModel.h"


@protocol HKGoodsCellDelegate <NSObject>

// 期待滚动的UIScrollView
- (void)HKGoodsClick:(HKGoodsModel *)model;

@end

@interface HKGoodsCell : UICollectionViewCell

@property (nonatomic, strong)HKGoodsModel *model;

@property (nonatomic, weak)id<HKGoodsCellDelegate> delegate;

@end
