//
//  HKLivingDetailView.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKLivingDetailView : UIView

@property (nonatomic, copy)void(^headerIVClickBlock)();

@property (nonatomic, copy)void(^followBtnClickBlock)();

@property (nonatomic, copy)void(^backBtnClickBlock)();

@property (nonatomic, copy)void(^shareBtnClickBlock)();

@property (nonatomic, copy)void(^middleBtnClickBlock)();

@property (nonatomic, copy)void(^livingBtnClickBlock)();

@property (nonatomic, strong)HKLiveDetailModel *model;

@end

NS_ASSUME_NONNULL_END
