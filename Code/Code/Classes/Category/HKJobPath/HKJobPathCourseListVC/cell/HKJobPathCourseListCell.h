//
//  HKJobPathCourseListCell.h
//  Code
//
//  Created by Ivan li on 2019/6/11.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKJobPathCourseListCell : UITableViewCell

@property (nonatomic, copy)void(^expandExerciseBlock)(HKCourseModel *model);

@property (nonatomic, strong)HKCourseModel *model;

@end

NS_ASSUME_NONNULL_END

