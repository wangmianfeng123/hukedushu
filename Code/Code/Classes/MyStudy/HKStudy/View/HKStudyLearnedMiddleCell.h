//
//  HKHomeFollowCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyLearningCenterModel.h"

@interface HKStudyLearnedMiddleCell : UITableViewCell

@property (nonatomic, strong)HKMyLearningCenterModel *model;

@property (nonatomic, copy)void(^videoSelectedBlock)(NSIndexPath *indexPath, VideoModel *videoNodel);

@property (nonatomic, copy)void(^moreBtnClickBlock)();

@end
