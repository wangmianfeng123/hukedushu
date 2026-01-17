//
//  HKAbountUsVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKAbountUsVC.h"
#import "HKAPPInfoVC.h"
#import "HtmlShowVC.h"
#import "HKUserOtherInfoModel.h"
#import <UMShare/UMShare.h>

@interface HKAbountUsVC ()

@property (weak, nonatomic) IBOutlet UILabel *versonLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *huLabel;
@property (nonatomic , strong)HKUserOtherInfoModel * serviceModel;
@end

@implementation HKAbountUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    // 初始化设置
    self.logoTopConstraint.constant = self.logoTopConstraint.constant + KNavBarHeight64;
    // 版本号
    self.versonLB.text = [NSString stringWithFormat:@"版本号：%@",[CommonFunction appCurVersion]];
    self.huLabel.textColor = [UIColor hkdm_colorWithColorLight:COLOR_999999 dark:COLOR_7B8196];

}


- (void)setupNav {
    self.title = @"关于虎课";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    
    self.titleLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_333333 dark:COLOR_EFEFF6];
    self.versonLB.textColor = [UIColor hkdm_colorWithColorLight:COLOR_999999 dark:COLOR_7B8196];
    [self.phoneLabel setTitleColor:[UIColor hkdm_colorWithColorLight:COLOR_999999 dark:COLOR_7B8196] forState:UIControlStateNormal];
    [self getPhoneNumber];
}



- (void)rightBarItemAction {
    [self pushToOtherController:[HKAPPInfoVC new]];
}


- (IBAction)agreementBtnClick {
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}

- (IBAction)privacyBtnClick {
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}

- (IBAction)contactPhoneClick {
    [MobClick event:UM_RECORD_PERSONAL_CENTER_CONTACTUS];
    [self contactService:self.serviceModel.phone qq:self.serviceModel.qq];
}


- (void)getPhoneNumber{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *dict = nil;
        NSData *data = [[NSData alloc] initWithContentsOfFile:[self cachePath]];
        if (data) {
            dict = data.mj_JSONObject;
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSString *serviceKey = @"service_info";
                if([[dict allKeys] containsObject:serviceKey]){
                    if ([[dict objectForKey:@"service_info"] isKindOfClass: [NSDictionary class]]) {
                        //客服
                        self.serviceModel = [HKUserOtherInfoModel mj_objectWithKeyValues:dict[serviceKey]];
                        [self.phoneLabel setTitle:[NSString stringWithFormat:@"客服电话：%@",self.serviceModel.phone] forState:UIControlStateNormal];
                    }
                }
            }
        }
    });

}

- (NSString *)cachePath {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *userId = [HKAccountTool shareAccount].ID;
    if (!isEmpty(userId)) {
        return [NSString stringWithFormat:@"%@/%@-MyInfo.plist",path,userId];
    }else {
        return [NSString stringWithFormat:@"%@/MyInfo.plist",path];
    }
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
                [self contactServiceWithQQ:QQNumber];
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


