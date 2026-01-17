//
//  HKCourseListCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCourseModel.h"

@interface HKCourseListCell : UITableViewCell


@property (nonatomic, copy)void(^expandExerciseBlock)(HKCourseModel *model);

@property (nonatomic, strong)HKCourseModel *model;
@property (nonatomic , assign) BOOL isFromLandScape;
//- (void)setModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden isSeriesCourse:(BOOL)isSeriesCourse;

- (void)setModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden videoType:(HKVideoType)videoType;

@end
