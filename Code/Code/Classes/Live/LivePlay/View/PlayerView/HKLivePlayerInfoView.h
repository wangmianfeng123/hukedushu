//
//  HKLivePlayerInfoView.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveDetailModel.h"
#import "HKLiveListModel.h"
#import "HKLiveCoursePlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKLivePlayerInfoView : UIView

@property (nonatomic, copy)void(^backBtnClickBlock)();

@property (nonatomic, copy)void(^shareBtnClickBlock)();

@property (nonatomic, copy)void(^middleBtnClickBlock)();

@property (nonatomic, copy)void(^livingBtnClickBlock)();

@property (nonatomic, copy)void(^countdownEndDataBlock)();

@property (nonatomic, strong)HKLiveDetailModel *model;

@end

NS_ASSUME_NONNULL_END
