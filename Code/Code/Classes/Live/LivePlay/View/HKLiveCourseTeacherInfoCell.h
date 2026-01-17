//
//  HKLiveCourseTeacherInfoCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveDetailModel.h"
#import "HKLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveCourseTeacherInfoCell : UITableViewCell

@property (nonatomic, strong)HKLiveDetailModel *model;

@property (nonatomic, copy)void(^headerIVTapBlock)();
@property (nonatomic, copy)void(^followTeacherClickBlock)();


@end

NS_ASSUME_NONNULL_END
