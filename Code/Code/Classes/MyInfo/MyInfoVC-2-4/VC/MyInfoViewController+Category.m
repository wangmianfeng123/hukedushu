//
//  MyInfoViewController+Category.m
//  Code
//
//  Created by Ivan li on 2018/5/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "MyInfoViewController+Category.h"
#import <UMShare/UMShare.h>

@implementation MyInfoViewController (Category)



- (NSString *)cachePath {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *userId = [HKAccountTool shareAccount].ID;
    if (!isEmpty(userId)) {
        return [NSString stringWithFormat:@"%@/%@-MyInfo.plist",path,userId];
    }else {
        return [NSString stringWithFormat:@"%@/MyInfo.plist",path];
    }
}


#pragma mark - 保存json
- (void)saveCacheData:(NSDictionary *)dict {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (dict) {
           BOOL temp = [dict.mj_JSONData writeToFile:[self cachePath] atomically:YES];
            if (NO == temp) {
                NSLog(@"保存json  ---  fail");
            }
        }
    });
}



- (void)contactService:(NSString*)phone qq:(NSString*)qq {

    WeakSelf;
    if (isEmpty(qq)) {
        [LEEAlert actionsheet].config
        .LeeAddAction(^(LEEAction *action) {
            __block NSString *phoneNum = phone;
            action.title = phoneNum;
            action.font = HK_FONT_SYSTEM(17);
            action.titleColor = COLOR_0076FF;
            action.clickBlock = ^{
                
                [CommonFunction callServiceWithPhone:phoneNum];
            };
        })
        .LeeAddAction(^(LEEAction *action) {

            action.title = @"取消";
            action.titleColor = COLOR_0076FF;
            action.font = HK_FONT_SYSTEM(17);
        }).LeeShow();
    }else{
        [LEEAlert actionsheet].config
        .LeeAddAction(^(LEEAction *action) {
            __block NSString *phoneNum = phone;
            action.title = phoneNum;
            action.font = HK_FONT_SYSTEM(17);
            action.titleColor = COLOR_0076FF;
            action.clickBlock = ^{
                
                [CommonFunction callServiceWithPhone:phoneNum];
            };
        })
        .LeeAddAction(^(LEEAction *action) {
    
            __block NSString *QQNumber = qq;
            action.title = [NSString stringWithFormat:@"QQ：%@",QQNumber];
            action.titleColor = COLOR_0076FF;
            action.font = HK_FONT_SYSTEM(17);
            action.clickBlock = ^{
                [weakSelf contactServiceWithQQ:QQNumber];
            };
        })
        .LeeAddAction(^(LEEAction *action) {

            action.title = @"取消";
            action.titleColor = COLOR_0076FF;
            action.font = HK_FONT_SYSTEM(17);
        }).LeeShow();
    }
}





/** 打开QQ 联系客服 */
- (void)contactServiceWithQQ:(NSString*)qq {
    
    if (isEmpty(qq)) {
        return;
    }
    
    if([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]) {
        //调用QQ客户端,发起QQ临时会话 --- 用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        //未安装QQ
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = qq;
        [MBProgressHUD showTipMessageInWindow:@"QQ号已复制，请安装QQ添加客服为好友~" timer:2];
    }
}







@end







