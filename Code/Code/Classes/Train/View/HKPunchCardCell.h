//
//  HKPunchCardCell.h
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKTrainDetailModel,HKAllTrainTaskModel,HKTrainTaskModel;


@interface HKPunchCardCell : UITableViewCell

@property (nonatomic, strong) HKTrainDetailModel * detailModel;
@property (nonatomic, copy) void(^punchViewClickBlock)(HKAllTrainTaskModel * allModel , HKTrainTaskModel * taskModel);

- (CGFloat)cellHight;

@end
    
NS_ASSUME_NONNULL_END
