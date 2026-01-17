//
//  HKHomeFollowCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyLearningCenterModel.h"
#import "HKDownloadModel.h"

@interface HKStudyDownloadCell : UITableViewCell

@property (nonatomic, strong)HKMyLearningCenterModel *model;

@property (nonatomic, copy)void(^modelSelectedBlock)(NSIndexPath *indexPath, HKDownloadModel *model);

@property (nonatomic, copy)void(^moreBtnClickBlock)();

- (void)setHistory:(NSMutableArray *)historyArray notFinish:(NSMutableArray *)notFinishArray diretory:(NSMutableArray *)directoryArray;

@end
