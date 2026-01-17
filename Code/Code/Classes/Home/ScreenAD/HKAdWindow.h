//
//  HKAdWindow.h
//  Code
//
//  Created by Ivan li on 2018/9/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKAdWindow : UIWindow

+ (HKAdWindow *)shareManager;

/** 关闭 广告 */
+ (void)closeADWindow;

/** 显示 广告 */
+ (void)showADWindow;

@end
