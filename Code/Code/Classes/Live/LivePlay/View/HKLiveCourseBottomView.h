//
//  HKLiveCourseBottomView.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveListModel.h"
#import "HKLiveDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HKLiveCourseBottomView : UIView

@property (nonatomic, copy)void(^buyNowBtnBlock)();
@property (nonatomic, copy)void(^contectTeacherBlock)(void);

@property (nonatomic, strong)HKLiveDetailModel *model;

@end

NS_ASSUME_NONNULL_END
