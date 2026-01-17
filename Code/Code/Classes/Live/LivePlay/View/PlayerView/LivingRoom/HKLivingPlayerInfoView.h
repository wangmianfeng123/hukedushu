//
//  HKLivingPlayerInfoView.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLiveDetailModel.h"
#import "HKLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKLivingPlayerInfoView : UIView

@property (nonatomic, strong)HKLiveDetailModel *model;

@property (nonatomic, copy)void(^backBtnClickBlock)();

@property (nonatomic, copy)void(^fullOrSmallBtnClickBlock)();

@property (nonatomic, copy)void(^refreshBtnClickBlock)();

@property (nonatomic, copy)void(^courseDetailBtnClickBlock)();


@end

NS_ASSUME_NONNULL_END
