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





@interface HKComingCategoryCell : UITableViewCell

- (void)setDataSource:(NSMutableArray<HKVipPrivilegeModel *> *)dataSource vipInfoExModel:(HKVipInfoExModel *)model;


@end
