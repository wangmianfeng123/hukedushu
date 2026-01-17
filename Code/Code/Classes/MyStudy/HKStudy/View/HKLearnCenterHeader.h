//
//  HKLearnCenterHeader.h
//  03-基本图形绘制
//
//  Created by hanchuangkeji on 2018/1/29.
//  Copyright © 2018年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HKMyLearningCenterModel.h"


@protocol HKLearnCenterHeaderDelegate <NSObject>

@optional

/** 成就  */
- (void)hkLearnCenterAchieveClick:(id)sender;

@end

@interface HKLearnCenterHeader : UIView

@property (nonatomic, strong)HKMyLearningCenterModel *model;
@property (nonatomic,  weak)id<HKLearnCenterHeaderDelegate> learnCenterHeaderDelegate;

@end
