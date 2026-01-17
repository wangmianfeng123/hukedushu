//
//  HKTaskTopView.h
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKTrainDetailModel,HKAllTrainTaskModel,HKTrainTaskModel;

@interface HKTaskTopView : UIView
@property (nonatomic, strong) HKTrainDetailModel * detailModel;
@property (nonatomic, copy) void(^punchViewClickBlock)(HKAllTrainTaskModel * allModel , HKTrainTaskModel * taskModel);

- (CGFloat)cellHight;

@end

NS_ASSUME_NONNULL_END
