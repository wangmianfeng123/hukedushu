//
//  AppDelegate+HK.m
//  Code
//
//  Created by Ivan li on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "HKVersionModel.h"
#import "AFNetworkTool.h"
#import "HKH5PushToNative.h"
#import "BannerModel.h"
#import "HKCategoryVC.h"
#import "UIImage+Helper.h"
#import "UMpopScreenshotView.h"
#import "UIView+SNFoundation.h"
#import "IQKeyboardManager.h"
#import <Bugly/Bugly.h>
#import "VideoPlayVC.h"
#import "HKFullScreenAdView.h"
#import "HKFullScreenADVC.h"
#import "HKAdWindow.h"
//#import "NTESCellLayoutConfig.h"
#import "UIBarButtonItem+Badge.h"
#import "UITabBarItem+PPBadgeView.h"
#import "HKCertificateModel.h"
#import "HKAchieveTool.h"
#import "HkNetworkManageCenter.h"


#import "UITabBarItem+PPBadgeView.h"
#import "TabBarTypeTwo.h"
#import "HKShortVideoHomeVC.h"
#import "HKStudyVC.h"
#import "HKUpdateAppView.h"
#import "HKOneLoginRewardView.h"
#import "HKWechatLoginShareCallback.h"
#import <LBLelinkKit/LBLelinkKit.h>
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "HKPushNoticeModel.h"

#define CFBundleIdentifier [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

//乐播官网注册账号，并添加APP，获取APPid和密钥
NSString * const LBAPPID = @"11635";

NSString * const LBSECRETKEY =  @"aca7a371f604b144f2f32e4a3941687f";//@"a20b4b19e6da15f95464af0e4aa59564";//



@implementation AppDelegate (Category)


- (void)changeServerState {
    if (!HKIsDebug) {
        hk_testServer = 0;
    } else {
        NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:HK_TEST_SERVER];
        if ([temp isKindOfClass:[NSString class]]) {
            switch ([temp intValue]) {
                case 0:
                {// 正式
                    hk_testServer = 0;
                }
                    break;
                case 1:
                {// 测试
                    hk_testServer = 1;
                }
                    break;
                case 2:
                {//预发
                    hk_testServer = 2;
                }
                    break;
            }
        }
    }
}





- (void)addTabarBadgeRedPoint:(CYLTabBarController *)tabBarController {
    // 截屏通知
    [self addScreenshotNotification];
}




#pragma mark - 提示更新
- (void)upDateNewVersion {
    
    NSString *ver = [CommonFunction appCurVersion];
    NSString *temp = BaseUrl;
    if ([temp hasSuffix:@"/v5"]) {
        temp = [temp substringWithRange:NSMakeRange(0, temp.length - 3)];
    }
    NSString *URL  = [NSString stringWithFormat:@"%@%@",temp,SITE_VERSION];
    
    WeakSelf;
    [AFNetworkTool postWithHeader:nil url:URL parameters:nil success:^(id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        
        if ([code isEqualToString:@"1"]) {
            HKVersionModel *model =[HKVersionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            // 保存服务器APP版本号
            [CommonFunction saveServerVersion:model.version_code];
            if (![self isLatestVersion]) {
                
                //HKVersionModel *model = [HKVersionModel new];
                //model.force_update = @"1";
                
                HKUpdateAppView *view = [[HKUpdateAppView alloc] initWithFrame:CGRectMake(0, 0, 290, 320+45)];
                view.model = model;
                view.closeBlock = ^{
                    [LEEAlert closeWithCompletionBlock:nil];
                };
                view.updateBlock = ^{
                    //[LEEAlert closeWithCompletionBlock:nil];
                };
                [LEEAlert alert].config
                    .LeeCustomView(view)
                    .LeeQueue(YES)
                    .LeePriority(1)
                    .LeeCornerRadius(0)
                    .LeeHeaderColor([UIColor clearColor])
                    .LeeHeaderInsets(UIEdgeInsetsZero)
                    .LeeMaxWidth(320)
                    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
                    .LeeShow();
                
                /***
                 NSString * otherBtnTitle = nil;
                 if ([model.force_update isEqualToString:@"2"]) {
                 otherBtnTitle = nil; //强制更新
                 }else {
                 otherBtnTitle = @"取消";
                 }
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:(isEmpty(model.update_info) ?@"有新的版本,请立即升级" :model.update_info)
                 delegate:weakSelf cancelButtonTitle:@"确定"  otherButtonTitles:otherBtnTitle, nil];
                 alert.tag = 20;
                 [alert show];
                 ***/
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




- (BOOL)isLatestVersion {
    NSString *currentVerString = [CommonFunction appCurVersion];
    NSString *serverVerString = [CommonFunction getServerVersion];
    BOOL isNew = NO;
    
    NSComparisonResult result3 = [currentVerString compare:serverVerString options:NSNumericSearch];
    if (result3 == NSOrderedDescending || result3 == NSOrderedSame) {
        isNew = YES;
    }
    return isNew;
}




#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 20) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
        }else{
            
        }
    }
}



/**
 点击推送消息 进入相应页面
 dict: 极光推送数据
 */

static bool isFirstJpush = NO; // 首次 点击通知 回调延迟一秒
- (void)getJPUSHInfoPushVC:(NSDictionary*)dict {
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"app_1" ofType:@"json"];
    //    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    if (isFirstJpush) {
        [self _getJPUSHInfoPushVC:dict];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[HKAdWindow class]]) {
                // 广告 窗口 正在显示
                [self _getJPUSHInfoPushVC:dict];
            }else{
                [self _getJPUSHInfoPushVC:dict];
            }
            isFirstJpush = YES;
        });
    }
}


- (void)_getJPUSHInfoPushVC:(NSDictionary*)dict {
    
    HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:[dict objectForKey:@"JP_Data"]];
    // 下次需要修改 推送 优惠券 类名
    if (!isEmpty(adsModel.class_name)) {
        if ([adsModel.class_name isEqualToString:@"SearchResultVC"]) {
            [MyNotification postNotificationName:@"PushSearch" object:nil userInfo:[dict objectForKey:@"JP_Data"]];
        }else{
            [HKH5PushToNative runtimePush:adsModel.class_name arr:adsModel.list currectVC:self.window.rootViewController];
        }
        
        [MobClick event:UM_RECORD_HOME_PAGE_AD];
        
        [[HKALIYunLogManage sharedInstance]hkNotificationWithBtnId:@"13" showType:@"3" pushType:adsModel.push_type];
    }
    if (!isEmpty(adsModel.record_id)) {
        [self recordJpushCilck:adsModel.record_id];
    }
}


//- (void)getJPUSHInfoPushVC:(NSDictionary*)dict {
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"app_1" ofType:@"json"];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:[jsonDict objectForKey:@"JP_Data"]];
//
//    //HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:[dict objectForKey:@"JP_Data"]];
//    // 下次需要修改 推送 优惠券 类名
//    if (!isEmpty(adsModel.class_name)) {
//
//        showTipDialog(@"11122");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (isEmpty(adsModel.class_name)) {
//
//                showTipDialog(@"1234");
//            }
//            showTipDialog(@"HKH5PushToNative");
//            [HKH5PushToNative runtimePush:adsModel.class_name arr:adsModel.list currectVC:self.window.rootViewController];
//        });
//        [MobClick event:UM_RECORD_HOME_PAGE_AD];
//    }
//    if (!isEmpty(adsModel.record_id)) {
//        [self recordJpushCilck:adsModel.record_id];
//    }
//
//    if (DEBUG) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (isEmpty(adsModel.class_name)) {
//                showTipDialog(@"dddd is");
//            }else{
//                showTipDialog(@"isEmpty");
//            }
//        });
//    }
//}



/** 统计 点击 极光推送 数 */
- (void)recordJpushCilck:(NSString*)recordId {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:recordId,@"record_id",nil];
    [HKHttpTool POST:JPUSH_CLICK_STATS parameters:parameters success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}



/** 截图监听通知 */
- (void)addScreenshotNotification {
    HK_NOTIFICATION_ADD_OBJ(UIApplicationUserDidTakeScreenshotNotification, (userScreenshotAction:), nil);
}


- (void)userScreenshotAction:(NSNotification *)notification {
    //截图
    UIImage *shootImage = [UIImage imageWithUIScreenShootImage];
    //图片拼接
    UIImage *image = [UIImage combineWithtopImage:shootImage bottomImage:imageName(@"hk_screenshot") withMargin:0];
    [self setShareUI:image];
}



/** 建立 分享 UI */
- (void)setShareUI:(UIImage*)image {
    
    if (![UMpopScreenshotView isHaveSharePlatform] || ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)) {
        return;
    }
    for (id view in [[UIView frontWindow] subviews]) {
        
        Class temp = [UMpopScreenshotView class];
        if ([view isKindOfClass:temp]) {
            [(UMpopScreenshotView*)view immediateRemoveView];
        }
    }
    UMpopScreenshotView *popView = [UMpopScreenshotView sharedInstance];
    popView.shotScreenImage = image;
    [popView createUI];
    popView.second = 5;
    
    __weak typeof (popView) weakSelf = popView;
    popView.selectBlock = ^(NSString *selectStr, UMSocialPlatformType platform) {
        [weakSelf shareImageToPlatformType:platform image:image];
    };
}



- (void)keyboardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = NO;//自带键盘工具条开关
    manager.shouldResignOnTouchOutside = YES;//点击空白区域键盘收缩的开关
}




#pragma mark 配置第三方平台 key
- (void)configUSharePlatforms {
    [UMConfigure setLogEnabled:YES];//设置打开日志
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    // 获取友盟social版本号
    [UMConfigure initWithAppkey:UM_HUKE_APPKEY channel:@"App Store"];
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    NSString *device_num = [CommonFunction getUUIDFromKeychain];
    NSLog(@"device_num ====== %@",device_num);
    if (device_num.length) {
        [MobClick profileSignInWithPUID:device_num provider:@"HK"];
    }
    
    
    
    
    
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
    //                                          appKey:HUKE_WXAPPID
    //                                       appSecret:HUKE_WXAPPSecret
    //                                     redirectURL:@"http://mobile.umeng.com/social"];
    
    //主线程刷新ui
    dispatch_async(dispatch_get_main_queue(), ^(){
        [UMSocialGlobal shareInstance].universalLinkDic =@{
            @(UMSocialPlatformType_QQ):@"https://js.huke88.com/",
            @(UMSocialPlatformType_Sina):@"https://js.huke88.com/"
        };
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                              appKey:HUKE_QQAPPID
                                           appSecret:HUKE_QQAPPKEY
                                         redirectURL:@"http://mobile.umeng.com/social"];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                              appKey:HUKE_SINAAPPID
                                           appSecret:HUKE_SINAAPPSecret
                                         redirectURL:@"http://api.huke88.com/site/weibo-callback"];
        
        //可允许http图片分享
        [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    });
    
    
    //    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
}




#pragma mark - 友盟统计 bugly错误统计
- (void)configUMRecordAndBugly {
    //bugly 错误统计
    //    [Bugly startWithAppId:BUGLY_APP_ID];
    //    NSString * version = [Bugly sdkVersion];
    //    NSString * appver = [Bugly appVersion];
    
    //#warning TODO 上线前打开
    //
    //
    //#ifdef DEBUG
    //    NSLog(@"----");
    //#else
    [Bugly startWithAppId:BUGLY_APP_ID];
    NSString *device_num = [CommonFunction getUUIDFromKeychain];
    NSLog(@"device_num ====== %@",device_num);
    if (device_num.length) {
        [Bugly setUserIdentifier:device_num];
    }
    
}



#pragma mark - 点击web 跳转到APP 视频详情
- (void)pushVideoPlayVCWithUrl:(NSURL*)url {
    //huke://www.huke88.com?video_id=&classKey=videoDetail&videoId=53994&videoType=0
    NSString *tempStr = [url absoluteString];
    if ([tempStr containsString:@"hukemain:"]) {
        NSString * resultUrl = [tempStr stringByReplacingOccurrencesOfString:@"hukemain://www.huke88.com" withString:@""];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self postPushTargetVCNotificationWithUrl:resultUrl];
            //[JMLinkService routeMLink:[NSURL URLWithString:url]];
        });
        
        //        NSRange range = [tempStr rangeOfString:@"video_id="];
        //        NSString *videoId = [tempStr substringFromIndex:range.location + range.length];
        //        //__block NSDictionary *dict =  @{@"video_id": videoId};
        //        if (!isEmpty(videoId)) {
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
        //                                                           lookStatus:LookStatusInternetVideo videoId:videoId model:nil];
        //
        //                UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
        //                UINavigationController *nc = tbc.selectedViewController;
        //                UIViewController *vc = nc.visibleViewController;
        //                [vc.navigationController pushViewController:VC animated:YES];
        //            });
        //        }
    }
}




- (void)addSelectTabObserver {
    HK_NOTIFICATION_ADD(HKSelectTabItemIndexNotification, selectTabItem:);
}


- (void)selectTabItem:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    if (dict) {
        NSUInteger index = [dict[@"ItemIndex"] integerValue];;
        [CommonFunction pushTabVCWithCurrectVC:nil index:index];
    }
}


#pragma mark - 注册 IM 推送
- (void)registerPushService {
    if (@available(iOS 11.0, *)){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted){
                NSLog(@"请开启推送功能否则无法收到推送通知");
            }
        }];
        
    }else {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types   categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}



- (void)selectThirdTab {
    [CommonFunction pushTabVCWithCurrectVC:nil index:3];
}




/*** 缩放动画 */
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.2,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.8;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}


#pragma mark  模拟器热加载
- (void)loadingSimulator {
    
#if DEBUG
    //    for iOS
    //        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle"] load];
    //        //    for tvOS
    //        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/tvOSInjection10.bundle"] load];
    //        //    for masOS
    //        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/macOSInjection10.bundle"] load];
    
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    //    for tvOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/tvOSInjection.bundle"] load];
    //    for masOS
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle"] load];
#endif
    
}



#pragma mark - 证书和勋章 弹框
- (void)pushCertificateDialogWithDict:(NSDictionary *)userInfo {
    HomeAdvertModel *model = [HomeAdvertModel mj_objectWithKeyValues:[userInfo[@"extras"] objectForKey:@"JP_data"]];
    if ([model.className isEqualToString:@"HKStudyCertificateView"] || [model.className isEqualToString:@"HKStudyMedalView"]) {
        if (model.list.count) {
            
            NSString *achieveId = model.list[0].value;
            NSDictionary *dict = @{@"achieve_id" :achieveId};
            [HKHttpTool POST:ACHIEVEMENT_GET_COMPLETED_ACHIEVE parameters:dict success:^(id responseObject) {
                
                /**
                 if (DEBUG) {
                 HKCertificateModel *model = [[HKCertificateModel alloc]init];
                 HKCertificateAchieveInfoModel *avModel = [HKCertificateAchieveInfoModel new];
                 avModel.type = @"3";
                 avModel.name = @"学习之星";
                 avModel.condition_description = @"APP端视频播放时长2小时";
                 avModel.completed_icon = @"https://pic.huke88.com/app/achievement/icon/m1-1.png";
                 avModel.level_icon = @"http://localhost.api.js.huke88.com/api/images/achievement/lv1.png";
                 model.achieve_info = avModel;
                 [HKAchieveTool setDialogWithModel:model];
                 }
                 **/
                
                if (HKReponseOK) {
                    HKCertificateModel *model = [HKCertificateModel mj_objectWithKeyValues:responseObject[@"data"]];
                    [HKAchieveTool setDialogWithModel:model];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
}





- (void)batteryLevel {
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    // 电量 百分比
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    // 时 分
    NSString *date = [DateChange getCurrentTime_Min];
    NSLog(@"%@",date);
}



#pragma mark - 短视频 限免标签
- (void)showShortVideoBadgeView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (isShowShortVideoFreeTag) {
            if (self.tabBarControllerConfig.tabBarController.viewControllers.count) {
                
                UIViewController *viewController = self.tabBarControllerConfig.tabBarController.viewControllers[2];
                UIViewController *temp = viewController;
                
                if ([viewController isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nav = (UINavigationController *)viewController;
                    temp = nav.topViewController;
                }
                
                if ([temp isKindOfClass:[HKShortVideoHomeVC class]]) {
                    UIImageView *imageIv = [[UIImageView alloc]initWithImage:imageName(@"ic_free_v210")];
                    imageIv.x = 15;
                    imageIv.y = -2;
                    [[viewController.tabBarItem bottomView]addSubview:imageIv];
                }
            }
        }
    });
}

#pragma mark - 设置分类 new标签
- (void)showCategoryNewBadgeView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.tabBarControllerConfig.tabBarController.viewControllers.count) {
            
            UIViewController *viewController = self.tabBarControllerConfig.tabBarController.viewControllers[1];
            UIViewController *temp = viewController;
            
            if ([viewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)viewController;
                temp = nav.topViewController;
            }
            
            if ([temp isKindOfClass:[HKCategoryVC class]]) {
                UIImageView *imageIv = [[UIImageView alloc]initWithImage:imageName(@"ic_free_v210")];
                imageIv.x = 15;
                imageIv.y = -2;
                [[viewController.tabBarItem bottomView]addSubview:imageIv];
            }
        }
    });
}



#pragma mark - 删除 短视频 限免标签
- (void)removeShortVideoBadgeView {
    
    if (self.tabBarControllerConfig.tabBarController.viewControllers.count) {
        UIViewController *viewController = self.tabBarControllerConfig.tabBarController.viewControllers[2];
        
        UIViewController *temp = viewController;
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)viewController;
            temp = nav.topViewController;
        }
        
        if ([temp isKindOfClass:[HKShortVideoHomeVC class]]) {
            for (UIView *subView in [viewController.tabBarItem bottomView].subviews) {
                if (subView) {
                    [subView removeFromSuperview];
                }
            }
        }
    }
}





/// 支付宝 支付回调
- (void)hkAlipayResultCallBack:(NSURL *)url {
    
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        if([[resultDic allKeys] containsObject:@"result"]){
            
            NSString *resultStr = resultDic[@"result"];
            NSDictionary *dict = resultStr.mj_JSONObject;
            
            HKBuyVipModel *vipModel = [HKBuyVipModel mj_objectWithKeyValues:dict[@"alipay_trade_app_pay_response"]];
            NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if (9000 == [resultStatus intValue]) {
                // 支付成功
                [[HKCashPay sharedInstance]queryOrderResultWithId:vipModel.out_trade_no];
            }
        }
    }];
    
    // 授权跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
}





#pragma mark - 获取微信的 token
- (void)wechatAccessToken:(SendAuthResp*)resp {
    // 拼接微信 access_token 接口
    if (!isEmpty(resp.code)) {
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                         HUKE_WXAPPID ,HUKE_WXAPPSecret,resp.code];
        
        [HKHttpTool hk_taskPost:nil allUrl:url isGet:YES parameters:nil success:^(id responseObject) {
            
            NSString *access_token = responseObject[@"access_token"];
            NSString *openid = responseObject[@"openid"];
            // 拼接微信 用户个人信息 接口
            NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
            [self wechatUserInfoWithUrl:url];
            
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark - 获取微信用户的信息
- (void)wechatUserInfoWithUrl:(NSString*)url {
    
    [HKHttpTool hk_taskPost:nil allUrl:url isGet:YES parameters:nil success:^(id responseObject) {
        NSDictionary *userDict = responseObject;
        if ([HKWechatLoginShareCallback sharedInstance].wechatLoginCallback && userDict) {
            [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback(userDict);
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 初始化乐播投屏
- (void)initLBLelinkKit {
    /**是否打开log，默认是关闭的*/
    [LBLelinkKit enableLog:YES];
    /** 使用APP id 和密钥授权授权SDK （1）需要在Info.plist中设置ATS；（2）可以异步执行，不影响APP的启动 */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError * error = nil;
        BOOL result = [LBLelinkKit authWithAppid:LBAPPID secretKey:LBSECRETKEY error:&error];
        if (result) {
            NSLog(@"乐播投屏 授权成功");
        }else{
            NSLog(@"乐播投屏 授权失败：error = %@",error);
        }
    });
}

- (void)postPushTargetVCNotificationWithUrl:(NSString*)url  {
    NSDictionary *dict = @{@"webUrl":url};
    HK_NOTIFICATION_POST_DICT(HKWebPushTargetVCNotification, nil, dict);
}

- (void)loadCheckinNotifyData{
    @weakify(self);
    [HKHttpTool POST:@"/setting/setting-options" parameters:nil success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSMutableArray * arry = [HKPushNoticeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (arry.count) {
                [NSKeyedArchiver archiveRootObject:arry toFile:PushNoticeModelFile];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}


@end

