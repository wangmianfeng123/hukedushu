//
//  HKListeningBookVC+Category.m
//  Code
//
//  Created by Ivan li on 2019/7/19.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKListeningBookVC+Category.h"
#import "HKPlaytipByWWANTool.h"
#import "UMpopView.h"

@implementation HKListeningBookVC (Category)


+ (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    [HKPlaytipByWWANTool nomarlVideoPlaytipByWWAN:sureAction cancelAction:cancelAction];
}


#pragma mark  试听已结束 Alert
+ (void)tryAudioAlert:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel *label) {
        NSString *text = @"试听已结束，开通VIP可收听\n全部书籍哦~";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
        action.font = HK_FONT_SYSTEM(15);
        action.clickBlock = ^{
            
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"立即开通";
        action.titleColor = COLOR_0076FF;
        action.font = HK_FONT_SYSTEM(15);
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            sureAction();
            [HKALIYunLogManage sharedInstance].button_id = @"11";
            [MobClick event: hukedushu_trial_buy];
        };
    })
    .LeeMaxWidth(318)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



#pragma mark  vip 购买Alert
+ (void)buyVipAlert:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel *label) {
        NSString *text = @"当前为收费内容，开通VIP可收\n听全部书籍哦~";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
        action.font = HK_FONT_SYSTEM(15);
        action.clickBlock = ^{
            
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"立即开通";
        action.titleColor = COLOR_0076FF;
        action.font = HK_FONT_SYSTEM(15);
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            sureAction();
        };
    })
    .LeeMaxWidth(318)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}


- (void)uMShareImageSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

- (void)uMShareImageFail:(id)sender {
    
}


#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
