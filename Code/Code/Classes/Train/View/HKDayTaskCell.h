//
//  HKDayTaskCell.h
//  Code
//
//  Created by yxma on 2020/8/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKTrainTaskModel,HKDayTaskModel;

@interface HKDayTaskCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) HKTrainTaskModel * model;
@property (nonatomic, strong) HKDayTaskModel * taskDetailModel;
@property (nonatomic , strong) void(^didEnlargeBlock)(void);
@property (nonatomic , strong) void(^didDeleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
