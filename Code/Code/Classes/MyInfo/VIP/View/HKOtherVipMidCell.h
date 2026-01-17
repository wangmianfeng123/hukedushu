//
//  HKOtherVipMidCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBuyVipModel.h"
#import "HKVipInfoExModel.h"


@protocol HKOtherVipMidCellDelegate <NSObject>

// 期待滚动的UIScrollView
- (void)HKOtherVIPSelected:(HKBuyVipModel *)model;

@end



@interface HKOtherVipMidCell : UITableViewCell

//@property (nonatomic, strong)NSMutableArray<HKBuyVipModel *> *dataSource;
- (void)setDataSource:(NSMutableArray<HKBuyVipModel *> *)dataSource vipInfoExModel:(HKVipInfoExModel *)model;

@property (nonatomic, weak)id<HKOtherVipMidCellDelegate> delegate;

@end
