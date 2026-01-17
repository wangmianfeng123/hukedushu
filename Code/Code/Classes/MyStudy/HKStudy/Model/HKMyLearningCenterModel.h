//
//  HKMyLearningCenterModel.h
//  03-基本图形绘制
//
//  Created by hanchuangkeji on 2018/1/30.
//  Copyright © 2018年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKMyLearningCenterDayModel,HKMapModel, HKStudyStatsModel, HKStudyHeaderCellModel;

@interface HKMyLearningCenterModel : NSObject
/** 证书数量 */
@property (nonatomic, copy)NSString *diploma_total;
/** 学习课程 数量 */
@property (nonatomic, copy)NSString *study_total;
/** 学习兴趣 cell 右侧显示文案 */
@property (nonatomic, copy)NSString *interest_str;

@property (nonatomic, strong)NSMutableArray<HKMyLearningCenterDayModel *> *list;

@property (nonatomic, assign)BOOL hasMore; //   最近学习更多

@property (nonatomic, strong)HKMapModel *achievement_info;

@property (nonatomic, strong)HKStudyHeaderCellModel *studyStats;

@property (nonatomic, strong)NSMutableArray<VideoModel *> *recentStudiedList;

@end


@interface HKStudyStatsModel : NSObject

@property (nonatomic, copy)NSString *today_count;
@property (nonatomic, copy)NSString *full_count;

@end

@interface HKMyLearningCenterDayModel : NSObject

@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *count;


@end
