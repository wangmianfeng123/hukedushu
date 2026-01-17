//
//  HKDayTaskHeaderView.h
//  Code
//
//  Created by yxma on 2020/8/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKDayTaskModel;

@interface HKDayTaskHeaderView : UIView
@property (nonatomic, strong) HKDayTaskModel * taskDetailModel;
@property (nonatomic, copy) void(^backBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
