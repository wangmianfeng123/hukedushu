//
//  HKLoginTool.m
//  Code
//
//  Created by Ivan li on 2018/7/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLoginTool.h"
#import "LoginVC.h"
#import "HKAdWindow.h"
#import "HKNavigationController.h"
#import <OneLoginSDK/OneLoginSDK.h>



@implementation HKLoginTool


//LIMIT_TOO_MANY_LOGIN
+ (void)setResetLoginAlertWithContent:(NSString*)content {
    [self resetLoginWithContent:content];
}


#pragma mark - 登录次数过多 禁止登录
+ (void)forbidLoginWithContent:(NSString*)content {
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"小虎提醒";
        label.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
        label.textColor = COLOR_030303;
    })
    .LeeAddContent(^(UILabel *label) {
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineSpaceWithTotalString:content LineSpace:PADDING_5];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"确定";
        action.font = HK_FONT_SYSTEM(15);
        action.titleColor = COLOR_0076FF;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


#pragma mark - 登录过期,强制重新登录
+ (void)resetLoginWithContent:(NSString*)content {
    WeakSelf;
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"小虎提醒";
        label.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
        label.textColor = COLOR_030303;
    })
    .LeeAddContent(^(UILabel *label) {
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineSpaceWithTotalString:content LineSpace:PADDING_5];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"确定";
        action.font = HK_FONT_SYSTEM(15);
        action.titleColor = COLOR_0076FF;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            //销毁广告
            if(NO == [HKAdWindow shareManager].hidden) {
                [HKAdWindow closeADWindow];
            }
            signOut();
            [weakSelf pushLoginVC];
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



+ (void)pushLoginVC {
    
    LoginVC *VC = [LoginVC new];
    
    if ([OneLogin isPreGettedTokenValidate]) {
        HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:VC];
        //loginVC.navigationBarHidden = YES;
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *topVC = [CommonFunction topViewController];
        if (nil != topVC && ![topVC isKindOfClass:[LoginVC class]]) {
            [topVC presentViewController:loginVC animated:YES completion:nil];
        }
    } else {
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            VC.sender = sender;
            HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:VC];
            //loginVC.navigationBarHidden = YES;
            loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *topVC = [CommonFunction topViewController];
            if (nil != topVC && ![topVC isKindOfClass:[LoginVC class]]) {
                [topVC presentViewController:loginVC animated:YES completion:nil];
            }
        }];
    }
}


+ (void)pushGiftLoginVC {
    
    LoginVC *VC = [LoginVC new];
    VC.loginViewType = HKLoginViewType_Firstload;
    HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:VC];
    //loginVC.navigationBarHidden = YES;
    loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *topVC = [CommonFunction topViewController];
    if (nil != topVC && ![topVC isKindOfClass:[LoginVC class]]) {
        [topVC presentViewController:loginVC animated:YES completion:nil];
    }
}




/** 保存 上一次 登录 平台类型 */
+ (void)saveLastLoginPattern:(NSString *)clientType {
    //登录方式 [1:QQ,2:微信,3:微博 4:手机]
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[clientType integerValue] forKey:HK_LOGIN_TYPE];
    [defaults synchronize];
}



#pragma mark - 三级视图跳转
+ (void)pushToBeforeVC:(UIViewController*)VC  {

    [VC dismissViewControllerAnimated:NO completion:^{
        //登录成功通知
        HK_NOTIFICATION_POST(HKLoginSuccessNotification, nil);
        [VC.navigationController popToRootViewControllerAnimated:NO];
    }];
}




/**
 VIP 受限 弹框
 */
+ (void)vipRestrictDialog {
    
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"提示";
        label.textColor = COLOR_27323F;
        label.font = HK_FONT_SYSTEM(15);
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"您暂无播放权限，请升级新版APP哦";
        label.textColor = COLOR_27323F;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"确定";
        action.titleColor = COLOR_27323F;
        action.font = HK_FONT_SYSTEM(15);
        action.clickBlock = ^{
            
        };
    })
    .LeeCornerRadius(12)
    .LeeShouldAutorotate(YES)
    .LeeCloseAnimationDuration(0.0)
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



@end


