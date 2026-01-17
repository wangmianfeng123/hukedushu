//
//  HKLiveCourseVC.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKLiveListModel.h"
#import "HKLiveDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKLiveDetailVC : HKBaseVC

@property (nonatomic, copy)NSString *course_id;

@property (nonatomic, copy) void(^didSelectedRecBlock)(VideoModel *model);

@property (nonatomic, copy)void(^refreshBlock)(HKLiveListModel *model);

@property (nonatomic, strong)HKLiveDetailModel *model;

@end

NS_ASSUME_NONNULL_END
