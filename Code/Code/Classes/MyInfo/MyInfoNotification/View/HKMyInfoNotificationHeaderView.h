//
//  HKMyInfoNotificationHeaderView.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *colseNotKey = @"HKMyInfoNotificationHeaderViewCloseBtnKey";

@interface HKMyInfoNotificationHeaderView : UIView

- (CGFloat)textHeight;

@property (nonatomic, copy)void(^openBtnClickBlock)();
@property (nonatomic, copy)void(^closeBtnClickBlock)();

@end
