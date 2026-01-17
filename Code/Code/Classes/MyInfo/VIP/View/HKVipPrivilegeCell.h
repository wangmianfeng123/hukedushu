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
#import "HKVipPrivilegeModel.h"


//@protocol HKOtherVipMidCellDelegate <NSObject>
//
//// 期待滚动的UIScrollView
//- (void)HKOtherVIPSelected:(HKBuyVipModel *)model;
//
//@end



@interface HKVipPrivilegeCell : UITableViewCell

- (void)setDataSource:(NSMutableArray<HKVipPrivilegeModel *> *)dataSource vipInfoExModel:(HKVipInfoExModel *)model;

//- (void)titleForFirstItem:(NSString *)title;

//@property (nonatomic, weak)id<HKOtherVipMidCellDelegate> delegate;
/** 隐藏 职业路径 tag view */
- (void)hiddenPrivilegeTagView;

@end



@interface HKVipPrivilegeTagView : UIImageView


@end
