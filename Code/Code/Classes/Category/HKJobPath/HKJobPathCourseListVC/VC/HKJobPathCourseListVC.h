//
//  HKJobPathCourseListVC.h
//  Code
//
//  Created by Ivan li on 2019/6/10.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "YUFoldingTableView.h"
NS_ASSUME_NONNULL_BEGIN


@class HKJobPathCourseListVC, HKJobPathModel,HKJobPathStudyedModel,HKJobPathHeadGuideModel;


@protocol HKJobPathCourseListVCDelegate <NSObject>

- (void)hkJobPathCourseListVC:(HKJobPathCourseListVC*)VC showBottomView:(BOOL)showBottomView;

/** 分享信息 */
- (void)hkJobPathCourseListVC:(HKJobPathCourseListVC*)VC shareModel:(ShareModel*)shareModel;

/** 职业路径 i信息 */
- (void)hkJobPathCourseListVC:(HKJobPathCourseListVC*)VC jobModel:(HKJobPathModel*)jobModel;

//头部配置是否跳转VIP购买页
- (void)hkJobPathCourseListVC:(HKJobPathCourseListVC*)VC headGuideModel:(HKJobPathHeadGuideModel*)guideModel;


@end

@interface HKJobPathCourseListVC : HKBaseVC

@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic,weak)id <HKJobPathCourseListVCDelegate> delegate;

@property (nonatomic , strong) HKJobPathHeadGuideModel * headGuideModel;

- (void)setJobCourseId:(NSString *)jobCourseId;

- (void)setSourceId:(NSString *)sourceId;

@end


NS_ASSUME_NONNULL_END
