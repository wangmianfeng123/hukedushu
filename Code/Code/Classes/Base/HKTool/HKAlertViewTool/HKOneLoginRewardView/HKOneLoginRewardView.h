//
//  HKOneLoginRewardView.h
//  Code
//
//  Created by Ivan li on 2019/8/22.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKInitConfigModel;

NS_ASSUME_NONNULL_BEGIN

@interface HKOneLoginRewardView : UIView

/** 关闭Block*/
@property (nonatomic , copy ) void (^closeBlock)(void);


/**
 显示 极验 注册成功 后奖励 AlertView
 
 @param frame
 */
+ (void)showOneLoginRewardAlertViewWithFrame:(CGRect)frame configModel:(HKInitConfigModel*)configModel;

@end

NS_ASSUME_NONNULL_END
