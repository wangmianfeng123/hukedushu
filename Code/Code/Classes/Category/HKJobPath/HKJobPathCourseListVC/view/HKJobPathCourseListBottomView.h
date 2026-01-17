//
//  HKJobPathCourseListBottomView.h
//  Code
//
//  Created by Ivan li on 2019/6/11.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKJobPathStudyedModel;

typedef NS_ENUM(NSUInteger, HKJobPathCourseListBottomViewType) {
    HKJobPathCourseListBottomViewType_None = 0,// 开始学习
    HKJobPathCourseListBottomViewType_Study,// 开始学习
    HKJobPathCourseListBottomViewType_Record
};


@interface HKJobPathCourseListBottomView : UIView

@property(nonatomic,assign)HKJobPathCourseListBottomViewType viewType;

@property(nonatomic,copy)void (^studyBtnClickBlock)(HKJobPathStudyedModel *model);

@property(nonatomic,copy)void (^goOnBtnClickBlock)(HKJobPathStudyedModel *model);

@property (nonatomic,strong) HKJobPathStudyedModel *model;

- (void)createUI;

- (void)removeJobPathCourseListBottomView;

@end

NS_ASSUME_NONNULL_END
