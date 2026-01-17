//
//  HKTrainHomeTopView.h
//  Code
//
//  Created by Ivan li on 2021/4/2.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKTrainDetailTaskCalendarModel,HKTrainDetailModel;

@interface HKTrainHomeTopView : UIView
@property (nonatomic , strong) void(^previousBlock)(void);
@property (nonatomic , strong) void(^nextBlock)(void);
@property (nonatomic , strong) void(^timeClickBlock)(void);
@property (nonatomic , strong) void(^signInClickBlock)(HKTrainDetailModel * detailModel);

@property (nonatomic , strong) HKTrainDetailTaskCalendarModel *taskCalendarModel;
@property (nonatomic , strong) HKTrainDetailModel *detailModel;;
@end

NS_ASSUME_NONNULL_END
