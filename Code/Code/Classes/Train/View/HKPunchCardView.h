//
//  HKPunchCardView.h
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKAllTrainTaskModel,HKTrainTaskModel,HKTrainDetailModel;

@protocol HKPunchCardViewDelegate <NSObject>

- (void)punchCardViewDidTaskView:(HKAllTrainTaskModel *)allModel withTaskModel:(HKTrainTaskModel *)taskModel;

@end


@interface HKPunchCardView : UIView
+ (HKPunchCardView *)createViewByFrame:(CGRect)frame;
@property (nonatomic, strong) HKAllTrainTaskModel * task_list;
@property (nonatomic, strong) HKTrainTaskModel * taskModel;
@property (nonatomic, weak) id<HKPunchCardViewDelegate>delegate;
@property (nonatomic , strong) HKTrainDetailModel * detailModel;
@end

NS_ASSUME_NONNULL_END
