//
//  HKAlarmClockView.h
//  Code
//
//  Created by yxma on 2020/10/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKAlarmClockView : UIView
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (nonatomic, copy) void(^timeBtnBlock)(void);

+ (HKAlarmClockView *)createViewFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
