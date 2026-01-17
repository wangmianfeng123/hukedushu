//
//  HKGoodsContainerCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKGoodsModel.h"

@protocol HKGoodsContainerCellDelegate <NSObject>

// 期待滚动的UIScrollView
- (void)HKOtherVIPClick:(HKGoodsModel *)model;
- (void)HKOtherVIPSelected:(HKGoodsModel *)model;

@end


@interface HKGoodsContainerCell : UITableViewCell

@property (nonatomic, strong)NSMutableArray<HKGoodsModel *> *dataSource;

@property (nonatomic, weak)id<HKGoodsContainerCellDelegate> delegate;

@end
