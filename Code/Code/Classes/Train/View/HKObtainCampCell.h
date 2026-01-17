//
//  HKObtainCampCell.h
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKNewDeviceTrainModel;

@interface HKObtainCampCell : UITableViewCell

@property (nonatomic , strong) HKNewDeviceTrainModel * model;

@property (nonatomic,copy) void(^obtainClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
