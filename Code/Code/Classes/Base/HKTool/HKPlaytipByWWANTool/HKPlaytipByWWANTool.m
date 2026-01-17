
//
//  HKPlaytipByWWANTool.m
//  Code
//
//  Created by Ivan li on 2019/6/19.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKPlaytipByWWANTool.h"
#import "HKGPRSSwitchView.h"

@implementation HKPlaytipByWWANTool



+ (void)shortVideoPlaytipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKGPRSSwitch];
    if (on) {
        // 开启流量观看
        sureAction();
        return;
    }
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"流量提醒";
        label.font = HK_FONT_SYSTEM_BOLD(15);
        label.textColor = COLOR_030303;
    })
    .LeeHeaderInsets(UIEdgeInsetsMake(15, 30, 10, 30))
    .LeeAddContent(^(UILabel *label) {
        NSString *text = @"当前为流量状态，继续播放会消耗你的流量哦~";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
        label.textAlignment = NSTextAlignmentLeft;
    })
    .LeeItemInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        HKGPRSSwitchView *view = [[HKGPRSSwitchView alloc] init];
        view.size = CGSizeMake(SCREEN_WIDTH-60, 40);
        custom.view = view;
        custom.isAutoWidth = YES;
        custom.positionType = LEECustomViewPositionTypeLeft;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
        action.font = HK_FONT_SYSTEM(15);
        action.clickBlock = ^{
            
            [MobClick event:UM_RECORD_GPRS_ALERT_CANCLE];
            cancelAction();
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"继续观看";
        action.titleColor = COLOR_0076FF;
        action.font = HK_FONT_SYSTEM(15);
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            isViaWWANPlayVideo = YES;// 允许流量观看
            sureAction();
            
            [MobClick event:UM_RECORD_GPRS_ALERT_CONTINUEPLAY];
        };
    })
    .LeeMaxWidth(318)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeCloseAnimationDuration(0)
    .LeeShow();
}





+ (void)nomarlVideoPlaytipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKGPRSSwitch];
    if (on) {
        // 开启流量观看
        sureAction();
        return;
    }
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"流量提醒";
        label.font = HK_FONT_SYSTEM_BOLD(15);
        label.textColor = COLOR_030303;
    })
    .LeeHeaderInsets(UIEdgeInsetsMake(15, 30, 10, 30))
    .LeeAddContent(^(UILabel *label) {
        NSString *text = @"当前为流量状态，继续播放会消耗你的流量哦~";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
        label.textAlignment = NSTextAlignmentLeft;
    })
    .LeeItemInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        HKGPRSSwitchView *view = [[HKGPRSSwitchView alloc] init];
        view.size = CGSizeMake(SCREEN_WIDTH-60, 40);
        custom.view = view;
        custom.isAutoWidth = YES;
        custom.positionType = LEECustomViewPositionTypeLeft;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
        action.font = HK_FONT_SYSTEM(15);
        action.clickBlock = ^{
            [MobClick event:UM_RECORD_GPRS_ALERT_CANCLE];
            cancelAction();
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"继续播放";
        action.titleColor = COLOR_0076FF;
        action.font = HK_FONT_SYSTEM(15);
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            [MobClick event:UM_RECORD_GPRS_ALERT_CONTINUEPLAY];
            sureAction();
        };
    })
    .LeeMaxWidth(318)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShouldAutorotate(YES)
    .LeeCloseAnimationDuration(0)
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}




+ (void)nomarlVideoDownloadtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"流量提醒";
        label.font = HK_FONT_SYSTEM_BOLD(15);
        label.textColor = COLOR_030303;
    })
    //.LeeHeaderInsets(UIEdgeInsetsMake(15, 30, 10, 30))
    .LeeAddContent(^(UILabel *label) {
        NSString *text = @"当前为流量状态，继续播放会消耗你的流量哦~";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
        label.textAlignment = NSTextAlignmentLeft;
    })
    .LeeItemInsets(UIEdgeInsetsMake(10, 0, 0, 0))
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"稍后下载";
        action.titleColor = COLOR_3D8BFF;
        action.font = HK_FONT_SYSTEM(15);
        action.backgroundColor = [UIColor whiteColor];
        cancelAction();
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"继续下载";
        action.titleColor = COLOR_27323F;
        action.font = HK_FONT_SYSTEM(15);
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            sureAction();
        };
    })
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}





@end


