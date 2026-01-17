//
//  HKMyLearningCenterModel.m
//  03-基本图形绘制
//
//  Created by hanchuangkeji on 2018/1/30.
//  Copyright © 2018年 xiaomage. All rights reserved.
//

#import "HKMyLearningCenterModel.h"
#import "BannerModel.h"

@implementation HKMyLearningCenterModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HKMyLearningCenterDayModel class], @"achievement_info" : [HKMapModel class], @"recentStudiedList" : [VideoModel class]};
}

@end

@implementation HKStudyStatsModel


@end

@implementation HKMyLearningCenterDayModel


@end
