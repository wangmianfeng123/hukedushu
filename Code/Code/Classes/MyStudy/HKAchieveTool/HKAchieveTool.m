
//
//  HKAchieveTool.m
//  Code
//
//  Created by Ivan li on 2018/12/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAchieveTool.h"
#import "HKStudyCertificateDialogVC.h"
#import "HKStudyCertificateView.h"
#import "HKCertificateModel.h"
#import "HKStudyMedalView.h"
#import "HKH5PushToNative.h"
#import "AppDelegate.h"

@implementation HKAchieveTool


+ (void)setDialogWithModel:(HKCertificateModel*)model {
    
    //枚举备注: 1 等级勋章 2 特殊勋章 3 学习证书
    NSInteger type = [model.achieve_info.type integerValue];
    switch (type) {
        case 1:
        {
            [self setCertificateViewWithModel:model];
        }
            break;
            
        case 2:
        {
            [self setCertificateViewWithModel:model];
        }
            break;
            
        case 3:
        {
            // 学习证书
            [self setMedalViewWithModel:model];
        }
            break;
        default:
            break;
    }

}





/** 学习勋章 */
+ (void)setCertificateViewWithModel:(HKCertificateModel*)model {
    
        HKStudyCertificateView *view = [[HKStudyCertificateView alloc]init];
        view.frame = CGRectMake(0, 0, 580/2, 780/2);
        view.model = model;
    
        view.studyMedalCloseBlock = ^(UIButton *sender) {
            [LEEAlert closeWithCompletionBlock:nil];
        };
        view.studyMedalPushBlock = ^(UIButton *sender) {

            [LEEAlert closeWithCompletionBlock:^{
                [HKH5PushToNative runtimePush:model.button_info.redirect_package.className arr:model.button_info.redirect_package.list currectVC:[AppDelegate sharedAppDelegate].window.rootViewController];
            }];
        };
    
        [self setCertificateDialogWithView:view];
}



/** 学习证书 */
+ (void)setMedalViewWithModel:(HKCertificateModel*)model {
    
    HKStudyMedalView *view = [[HKStudyMedalView alloc]init];
    view.frame = CGRectMake(0, 0, 580/2, 780/2);
    view.model = model;
    
    view.studyMedalCloseBlock = ^(UIButton *sender) {
        [LEEAlert closeWithCompletionBlock:nil];
    };
    view.studyMedalPushBlock = ^(UIButton *sender) {
        
        [LEEAlert closeWithCompletionBlock:^{
            [HKH5PushToNative runtimePush:model.button_info.redirect_package.className arr:model.button_info.redirect_package.list currectVC:[AppDelegate sharedAppDelegate].window.rootViewController];
        }];
        
    };
    
    
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ((orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)&&IS_IPHONE) return;
    [self setCertificateDialogWithView:view];
}


/** 弹窗 */
+ (void)setCertificateDialogWithView:(id)view {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ((orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)&&IS_IPHONE) return;
    
    [LEEAlert alert].config
    .LeeMaxWidth(580/2)
    .LeeCornerRadius(5)
    .LeeCustomView(view)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


@end


