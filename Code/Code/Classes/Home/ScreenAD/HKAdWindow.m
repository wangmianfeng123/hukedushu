


//
//  HKAdWindow.m
//  Code
//
//  Created by Ivan li on 2018/9/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAdWindow.h"
#import "HKFullScreenADVC.h"


#define Status_Bar_H ([UIApplication sharedApplication].statusBarFrame.size.height)

#define IS_IPHONE_X_12  ((Status_Bar_H == 44.0) ? YES : NO)



@implementation HKAdWindow

+ (HKAdWindow *)shareManager {
    
    static HKAdWindow *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HKAdWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        manager.backgroundColor = [UIColor whiteColor];
        // +1 为了将 该窗口显示在 Alert 之上
        manager.windowLevel = UIWindowLevelAlert+1;
        [manager makeKeyAndVisible];
        manager.hidden = NO;
        
    });
    return manager;
}



+ (void)showADWindow {
    
    // 首次安装 或者更新 后首次启动 不显示
    BOOL show = [HKNSUserDefaults boolForKey:@"FullScreenAd"];
    if (show) {
        [HKAdWindow shareManager].rootViewController = [HKFullScreenADVC new];
    }else{
        [HKNSUserDefaults setBool:YES forKey:@"FullScreenAd"];
        [HKNSUserDefaults synchronize];
    }
}


+ (void)closeADWindow {
    [HKAdWindow shareManager].hidden = YES;
    [[HKAdWindow shareManager] resignKeyWindow];
    [HKAdWindow shareManager].rootViewController = nil;
}

@end



