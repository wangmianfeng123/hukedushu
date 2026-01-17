//
//  HKTrainHeaderView.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKTrainDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKTrainHeaderView : UIView

@property (nonatomic, copy)void(^seeCerBtnClickBlock)();


@property (nonatomic, strong)HKTrainDetailModel *detailModel;


@end

NS_ASSUME_NONNULL_END
