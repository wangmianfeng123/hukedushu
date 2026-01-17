//
//  HKPhoneLoginVC+HK.m
//  Code
//
//  Created by ivan on 2020/6/19.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKPhoneLoginVC+HK.h"

@implementation HKPhoneLoginVC (HK)

//响应事件
-(void)changeSeverTapGestureAction: (UILongPressGestureRecognizer *) gesture {
        
    if (HKIsDebug) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"虎课服务器" message:@"志扬哥最帅" preferredStyle:UIAlertControllerStyleActionSheet];
        // 兼容iPad alert
        if (alert.popoverPresentationController) {
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat width = 300;
            CGFloat height = 300;
            alert.popoverPresentationController.sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
            alert.popoverPresentationController.sourceRect = CGRectMake((screenWidth - width ) * 0.5, (screenHeight - height ) * 0.5, 300, 300);
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger  action1Style = (0 == hk_testServer) ?UIAlertActionStyleDestructive  :UIAlertActionStyleDefault;
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"正式服务器" style:action1Style handler:^(UIAlertAction * _Nonnull action) {
            hk_testServer = 0;
            [defaults setObject:@"0" forKey:HK_TEST_SERVER];
            [defaults synchronize];
            showTipDialog(@"正式服务器");
        }];
        NSInteger  action2Style = (1 == hk_testServer) ?UIAlertActionStyleDestructive  :UIAlertActionStyleDefault;
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"测试服务器" style:action2Style handler:^(UIAlertAction * _Nonnull action) {
            hk_testServer = 1;
            [defaults setObject:@"1" forKey:HK_TEST_SERVER];
            [defaults synchronize];
            showTipDialog(@"测试服务器");
        }];
        NSInteger  action3Style = (2 == hk_testServer) ?UIAlertActionStyleDestructive  :UIAlertActionStyleDefault;
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"预发布" style:action3Style handler:^(UIAlertAction * _Nonnull action) {
            hk_testServer = 2;
            [defaults setObject:@"2" forKey:HK_TEST_SERVER];
            [defaults synchronize];
            showTipDialog(@"预发布");
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
