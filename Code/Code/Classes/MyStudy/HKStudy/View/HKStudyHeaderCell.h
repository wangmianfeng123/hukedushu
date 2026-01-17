//
//  HKStudyHeaderCell.h
//  Code
//
//  Created by hanchuangkeji on 2019/6/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyLearningCenterModel.h"
#import "HKStudyHeaderCellModel.h"


@interface HKStudyHeaderCell : UITableViewCell

@property (nonatomic, strong)HKMyLearningCenterModel *model;

@property (nonatomic, copy)void(^medalBtnClickBlock)();

@property (nonatomic, copy)void(^todayLBClickBlock)();

@end




