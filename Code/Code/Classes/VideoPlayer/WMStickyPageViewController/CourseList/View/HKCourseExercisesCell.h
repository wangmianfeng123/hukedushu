//
//  HKCourseExercisesCell.h
//  Code
//
//  Created by hanchuangkeji on 2019/4/16.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKCourseExercisesCell : UITableViewCell

@property (nonatomic, strong)HKCourseModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic , assign) BOOL isLandScape ;
@end

NS_ASSUME_NONNULL_END
