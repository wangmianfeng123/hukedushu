
//  AppDelegate.m
//  Code
//
//  Created by pg on 16/3/8.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "AppDelegate.h"
#import <UMShare/UMShare.h>
#import "TabBarTypeTwo.h"
#import "DownloadCacher.h"
#import "DownloadManager.h"
#import "YHIAPpay.h"
#import "HomeServiceMediator.h"
#import "HomeVideoVC.h"
#import "VideoPlayVC.h"
#import "AppDelegate+Category.h"
#import "DownloadModel.h"
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"
#import <Bugly/Bugly.h>
#import "HKH5PushToNative.h"
#import "BannerModel.h"
#import "HKCategoryVC.h"
#import "HKStudyVC.h"
#import "MyInfoViewController.h"
#import "HKAdWindow.h"
//#import "HKGroupChatVC.h"
#import "HKShortVideoHomeVC.h"

#import <JPush/JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "HKShortVideoModel.h"
#import "HKEmptyRootVC.h"
#import "HKWechatLoginShareCallback.h"
#import "HKBookTabMainVC.h"
#import <LBLelinkKit/LBLelinkKit.h>
#import "LBUnlimitedBackgroundTaskTool.h"
#import <OneLoginSDK/OneLoginSDK.h>
#import "Code-Swift.h"
//#import "JMLinkService.h"
#import "HKTabBarModel.h"
#import "HKSuspensionView.h"
#import "HKNewTaskModel.h"
#import "HKHNewbieFatherView.h"
#import "DateChange.h"
#import "HNewbieTaskView.h"
#import "HKTaskSuspensionTipView.h"
#import "HKObtainCampVC.h"
#import "HKPresentVC.h"
#import "VideoPlayVC.h"
#import "HKGuideView.h"
#import "HKCommunityVC.h"
#import "AFNetworkActivityLogger.h"
#import "HKPushToSearch.h"
#import "HKStudyNewVC.h"
#import "HKTestVC.h"
#import <ZFPlayer/ZFLandscapeRotationManager.h>
#import "HKProtoclView.h"
#import "HtmlShowVC.h"


@interface AppDelegate ()<UITabBarControllerDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate,WXApiDelegate>{
    //-fno-objc-arc
}


@property (nonatomic,assign) NSInteger count;


@property (nonatomic,strong)TabBarTypeTwo *tabBarControllerConfig;

@property (nonatomic, strong) LBUnlimitedBackgroundTaskTool *unlimitedBgTask;

@property (nonatomic, strong)HKDarkView *darkView;
@property (nonatomic , strong) NSTimer * timer;
@property (nonatomic , strong)HKPushToSearch * manager;

@end


@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}


///防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        if([[CommonFunction topViewController] isKindOfClass:[HKLivingPlayVC2 class]]){
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }else{
            ZFInterfaceOrientationMask orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
            if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
                return (UIInterfaceOrientationMask)orientationMask;
            }
            /// 这里是非播放器VC支持的方向
            return UIInterfaceOrientationMaskPortrait;
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"123567");
    NSLog(@"123567");
    //bugly错误统计
    [self configUMRecordAndBugly];
    
    [HkNetworkManageCenter shareInstance];
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        //初始化本地数据库
    //        [HKDownloadManager shareInstance];
    //    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        //初始化本地数据库
        [HKDownloadManager shareInstance];
    });
    
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger ] startLogging ];
    [[AFNetworkActivityLogger sharedLogger ] setLogLevel:AFLoggerLevelDebug];
#else
#endif
    NSString *device_num = [CommonFunction getUUIDFromKeychain];
    NSLog(@"device_num ====== %@",device_num);
    [self setAPPUserTheme];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = COLOR_FFFFFF_333D48;
    [self.window makeKeyAndVisible];
    
    
    // 正式服务器和测试服务器的切换
    [self changeServerState];
    //键盘
    [self keyboardManager];
    
    
    
    [WXApi registerApp:HUKE_WXAPPID universalLink:hk_universalLink];
    
    //在register之前打开log, 后续可以根据log排查问题
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NSLog(@"WeChatSDK: %@", log);
    }];
    
    HKEmptyRootVC * vc = [HKEmptyRootVC new];
    vc.agreeBtnBlock = ^(BOOL isFinishAuthView) {
        [HkChannelData requestHkChannelData];
        //清空log 设置
        [[HKALIYunLogManage sharedInstance] removeBaseConfig];
        [[HKALIYunLogManage sharedInstance] setBaseConfig];
        
        //APP status 查询
        [CommonFunction checkAPPStatus];
        [self loadCheckinNotifyData];
        
        [self configUSharePlatforms];
        //极光设置
        [self configJPUSH:launchOptions];
        
        [self showShortVideoRequest:launchOptions];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadNewDeviceTask:3];
        });
        
        //更新提示
        [self upDateNewVersion];
        
        [self initLBLelinkKit];
        
        // 创建无限后台任务工具
        self.unlimitedBgTask = [[LBUnlimitedBackgroundTaskTool alloc] init];
        
        //数组越界
        //[AvoidCrash becomeEffective];
        [MobClick event:shouye_view];
    };
    
    UINavigationController *emptyNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = emptyNavigationController;
    // 成功登录
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, updateNewDeviceTask:);
    HK_NOTIFICATION_ADD(@"videoPlayed", videoPlayedNewDeviceTask);//播放结束
    HK_NOTIFICATION_ADD(@"PushSearch", pushToSearchVC:);
    
    return YES;
}

- (void)pushToSearchVC:(NSNotification *)noti{
    
    if ([[CommonFunction getRootViewController] isKindOfClass:[CYLTabBarController class]]) {
        CYLTabBarController * tab = (CYLTabBarController *)[CommonFunction getRootViewController];
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            NSDictionary * dic = noti.userInfo;
            HomeAdvertModel *adsModel = [HomeAdvertModel mj_objectWithKeyValues:dic];
            
            NSString * keyWord = nil;
            int index = 0;
            for (AdvertParameterModel * model in adsModel.list) {
                if ([model.parameter_name isEqualToString:@"keyWord"]) {
                    keyWord = model.value;
                }
                if ([model.parameter_name isEqualToString:@"selectIndex"]) {
                    index = [model.value intValue];
                }
            }
            UINavigationController * navi= (UINavigationController *)tab.selectedViewController;
            self.manager =[[HKPushToSearch alloc] init];
            self.manager.isPush = YES;
            [self.manager hkPushToSearchWithVC:navi withKeyWord:keyWord withIndex:index];
        }
    }
}


#pragma mark - 设置主题模式
- (void)setAPPUserTheme {
    if (@available(iOS 13.0, *)) {
        HKDarkView *darkView = [[HKDarkView alloc]initWithFrame:CGRectZero];
        self.darkView = darkView;
        [[HKDarkModelManger shareInstance]setAPPUserTheme];
    }
}



#pragma mark - 请求
- (void)showShortVideoRequest:(NSDictionary *)launchOptions {
    
    [self initRootVCWithDict:launchOptions];
}




- (void)initRootVCWithDict:(NSDictionary *)launchOptions {
    
    [self setRootViewController];
    //极光设置
    //[self configJPUSH:launchOptions];
    //启动页广告
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (YES == [CommonFunction isNeedShowADWindow] && self.webUrl.length == 0) {
            [HKAdWindow showADWindow];
        }
    });
    
    
    if (HKIsDebug) {
        [self loadingSimulator];
    }
    
    /// v2.17
    ///JPush不需要实现以下代码，否则会造成一条推送响两次的情况，注释掉就可解决
    //[self registerPushService];
    
    
    // 极验注册
    [OneLogin registerWithAppID:ONE_LOGIN_APPID];
    NSLog(@"版本号：%@",[OneLogin sdkVersion]);
}

/** 根控制器 */
- (void)setRootViewController {
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loadMiddleIconData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadMiddleIconData:^{
        self.tabBarControllerConfig.tabBarController.delegate = self;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loadMiddleIconData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"Linked in %f ms", linkTime *1000.0);
        
        self.window.rootViewController = self.tabBarControllerConfig.tabBarController;
        //添加小红点
        [self addTabarBadgeRedPoint:_tabBarControllerConfig.tabBarController];
    }];
    
    
    //极光
    //[self configJPUSH:launchOptions];
    // 1.6版本之前的视频缓存数据兼容转移
    [self processDownloadFileInCache];
    [self addSelectTabObserver];
    
    // 分类 new标签
    //[self showCategoryNewBadgeView];
}



- (TabBarTypeTwo*)tabBarControllerConfig {
    if (!_tabBarControllerConfig) {
        _tabBarControllerConfig = [[TabBarTypeTwo alloc] init];
    }
    return _tabBarControllerConfig;
}

- (void)loadMiddleIconData:(void(^)(void))block{
    NSLog(@"-----");
    [HKHttpTool POST:TabBar_Middle_icon parameters:@{HKneedNoLoginCallBack:@"1"} success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            HKTabBarModel * tabModel = [HKTabBarModel mj_objectWithKeyValues:responseObject[@"data"][@"bottomMiddleIcon"]];
            self.tabBarControllerConfig.tabModel = tabModel;
            self.isFold = responseObject[@"data"][@"isFold"];
            
            //            self.tabBarControllerConfig.tabBarController.selectedIndex = 1;
        }
        if (block) {
            block();
        }
    } failure:^(NSError *error) {
        if (block) {
            block();
        }
    }];
}




#pragma mark -  配置极光推送
- (void)configJPUSH:(NSDictionary *)launchOptions {
    //    if (@available(iOS 14,*)) {
    //        /// 因为 iOS 14 开始APP与外部通过剪切板传递数据会有系统弹框
    //        /// 如果不介意有系统弹框可以去掉这个判断
    //        /// 通过剪切板来传递数据会很大程度增加成功率
    //        /// 注：SDK 不会读其他数据，只是从 H5 传递魔链的数据到 SDK
    //        /// [JMLinkService pasteBoardEnable:NO];
    //    }
    //    [JMLinkService setDebug:YES];
    //    JMLinkConfig *config = [[JMLinkConfig alloc] init];
    //    config.appKey = JG_PUSH_APPKEY;
    //    [JMLinkService setupWithConfig:config];
    
    //Jpush
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction = NO;
#ifdef DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif
    // Required
    [JPUSHService setupWithOption:launchOptions
                           appKey:JG_PUSH_APPKEY
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    [self jPushCustomMessageConfig];
    
}


#pragma mark - 极光 自定义消息
- (void)jPushCustomMessageConfig {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(customMessageReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


- (void)customMessageReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    //自定义 推送 勋章
    [self pushCertificateDialogWithDict:userInfo];
}


// 1.6版本之前的视频缓存数据兼容转移
- (void)processDownloadFileInCache {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *step = [userDefaults valueForKey:@"HKVideoDownloadCache1_6"];
    
    // 尚未处理
    if (step == nil && [HKAccountTool shareAccount]) {
        
        NSArray<DownloadModel *> *finishAraay = [[DownloadCacher shareInstance] selectfinishedDownloadModels];
        
        // 先关闭数据库
        [[DownloadCacher shareInstance] tb_closeDB];
        
        // 遍历循环保存
        if (finishAraay.count > 0) {
            
            NSArray<HKDownloadModel *> *insertNewDataArray = [HKDownloadModel mj_objectArrayWithKeyValuesArray:finishAraay];
            
            for (int i = 0; i < finishAraay.count; i++) {
                HKDownloadModel *modelTemp = insertNewDataArray[i];
                modelTemp.saveInCache = YES;
                modelTemp.isFinish = YES;
                modelTemp.downloadPercent = 1.0;
                modelTemp.videoUrl = ((DownloadModel *)finishAraay[i]).url;
                [[HKDownloadManager shareInstance] saveModelBefore1_6:modelTemp];
            }
        }
        
        // 保存偏好属性
        [userDefaults setValue:@"setted" forKey:@"HKVideoDownloadCache1_6"];
        [userDefaults synchronize];
    }
    
    // 兼容1.8目录
    //    [HKDownloadManager adaptDirInfo1_8];
}




- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    
    //- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
    //{
    
    NSLog(@"handleEventsForBackgroundURLSession   ===   %ld",(long)self.count);
    self.backgroundSessionCompletionHandler = completionHandler;
}




#pragma tabbardelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    // 友盟统计
    UIViewController *tempVC = nil;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        tempVC = nav.topViewController;
    } else {
        tempVC = viewController;
    }
    
    if ([tempVC isKindOfClass:[HomeVideoVC class ]]) {
        [MobClick event:UM_RECORD_TAB_HOME];
    }else if ([tempVC isKindOfClass:[HKCategoryVC class ]]) {
        [MobClick event:UM_RECORD_TAB_CATEGORY_PAGE];
        // 移除读书引导通知
        HK_NOTIFICATION_POST(HKRemoveReadBookGuideViewNotification, nil);
    }else if ([tempVC isKindOfClass:[HKStudyNewVC class ]]) {
        [MobClick event:UM_RECORD_TAB_STUDY];
    }else if ([tempVC isKindOfClass:[MyInfoViewController class ]]) {
        [MobClick event:UM_RECORD_TAB_CATEGORY_PERSON_CENTER];
    }else if ([tempVC isKindOfClass:[HKShortVideoHomeVC class ]]) {
        //点击统计
        [[HKALIYunLogManage sharedInstance]shortVideoClickLogWithIdentify:@"1"];
        [MobClick event:SHORTVIDEO_TAB];
    }else if ([tempVC isKindOfClass:[HKCommunityVC class ]]) {
        [MobClick event:um_hukedushushouye_tab];
    }else if ([tempVC isKindOfClass:[HKCommunityVC class ]]){
        
    }
    
    if ([tempVC isKindOfClass:[HomeVideoVC class]] || [tempVC isKindOfClass:[MyInfoViewController class]]) {
        if (self.model.is_show) {
            self.suspensionView.hidden = NO;
        }else{
            self.suspensionView.hidden = YES;
        }
    }else{
        self.suspensionView.hidden = YES;
    }
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    return YES;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    
    if ([control cyl_isTabButton]) {
        UIView *animationView = [control cyl_tabImageView];
        [self addScaleAnimationOnView:animationView repeatCount:1];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"appdelegate========applicationDidEnterBackground");
    [self cleanIconBadge];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"appdelegate========applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([CommonFunction isOpenNotificationSetting]) {
        //开启通知
        HK_NOTIFICATION_POST(HKOpenNotification, nil);
    }else{
        //关闭通知
        HK_NOTIFICATION_POST(HKCloseNotification, nil);
    }
    //清空log 设置
    [[HKALIYunLogManage sharedInstance] removeBaseConfig];
    [[HKALIYunLogManage sharedInstance] setBaseConfig];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"appdelegate========applicationDidBecomeActive");
    [self cleanIconBadge];
    
    
    BOOL HaveAgreeAuthView = [[NSUserDefaults standardUserDefaults] boolForKey:@"HaveAgreeAuthView"];
    BOOL isFirstLoad = [CommonFunction isUpdateAppFirstLoad];
    if (HaveAgreeAuthView || isFirstLoad) {
        [CommonFunction recordUserLoginCount];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([AppDelegate sharedAppDelegate].showLoadMessage == YES){
            [HKProgressHUD hideHUD];
        }
        
    });
    
    //新手礼包
    //[HKNewUserGiftTool newUserGiftAction:NO];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


//Jpush
- (void)application:(UIApplication *)application  didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    // 极光 push
    [JPUSHService registerDeviceToken:deviceToken];
}




//应用在后台运行
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    // ios 10 之前系统 点击推送处理
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0) {
        [self handlePushApsDict:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}




/*********  极光推送   **********/
#pragma mark- JPUSHRegisterDelegate // 2.1.9版新增JPUSHRegisterDelegate,需实现以下两个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark- iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 本地通知
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


#pragma mark- iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 本地通知
    }
    [self handlePushApsDict:userInfo];
    //系统要求执行这个方法
    completionHandler();
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


/**
 *  处理推送
 *
 *  @param userInfo aps
 */
- (void)handlePushApsDict:(NSDictionary *)userInfo {
    
    //点击推送消息 进入相应页面
    [self cleanIconBadge];
    NSString *mapKey = @"JP_Data";
    if([[userInfo allKeys] containsObject:mapKey]){
        //极光推送
        [self getJPUSHInfoPushVC:userInfo];
    }
}


/** 清除通知数量 红色标签 */
- (void)cleanIconBadge {
    
    [JPUSHService resetBadge];
    [self setApplicationIconBadgeZero];
}


#pragma mark - 极光推送实现角标清0，通知栏未读消息不清空
- (void)setApplicationIconBadgeZero {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
        } else {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
            localNotification.applicationIconBadgeNumber = -1;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
}




#pragma mark -----友盟回调
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
//iOS9+，通过url scheme来唤起app
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSLog(@"appdelegate========openURL");
    //showTipDialog(@"iOS9+，通过url scheme来唤起app");
    //    [JMLinkService routeMLink:url];
    //点击web 跳转到APP 视频详情
    [self pushVideoPlayVCWithUrl:url];
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调x
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [self hkAlipayResultCallBack:url];
        }else{
            // 微信支付 登录
            result = [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

#endif
//iOS9以下，通过url scheme来唤起app
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"appdelegate========sourceApplication");
    //showTipDialog(@"iOS9以下，通过url scheme来唤起app");
    //    [JMLinkService routeMLink:url];
    
    //NSLog(@"__IPHONE_OS_VERSION_MAX_ALLOWED --%d",__IPHONE_OS_VERSION_MAX_ALLOWED);
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [self hkAlipayResultCallBack:url];
        }else{
            // 微信支付 登录
            result = [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}





- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"appdelegate========handleOpenURL");
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        result = [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

//通过universal link来唤起app
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    NSLog(@"appdelegate========continueUserActivity");
    //    [JMLinkService continueUserActivity:userActivity];
    
    //    if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
    //NSURL *url = userActivity.webpageURL;
    //    }
    NSString *webUrl = userActivity.webpageURL.absoluteString;
    
    
    // 包含 HUKE_WXAPPID 是从微信 返回来 （如支付 分享）
    if([webUrl containsString:@"https://js.huke88.com/qq_conn"]){//qq分享成功返回APP的回调
        
    }else if (([webUrl containsString:HUKE_JS_URL]
         && (NO == [webUrl containsString:HUKE_WXAPPID]))||([webUrl containsString:hk_universalLink]&&[webUrl containsString:@"?"])) {
        NSRange range = [webUrl rangeOfString:@"?"];
        NSString *url = [webUrl substringFromIndex:range.location];
        [self postPushTargetVCNotificationWithUrl:url];//跳转指定的页面
    }
    if(![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]){
        // 其他SDK的回调
    }
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    // 注 由于微信客户端的原因, 取消操作,返回的结果是依然是 WXSuccess
    switch (resp.errCode) {
        case WXSuccess:
        {
            if([resp isKindOfClass:[PayResp class]]){
                HKCashPay *cashPay = [HKCashPay sharedInstance];
                [[HKCashPay sharedInstance]queryOrderResultWithId:cashPay.payModel.out_trade_no];
            }
            
            if([resp isKindOfClass:[SendAuthResp class]]){
                // 登陆
                [self wechatAccessToken:(SendAuthResp*)resp];
            }
            
            if([resp isKindOfClass:[SendMessageToWXResp class]]) {
                // 分享
                if ([HKWechatLoginShareCallback sharedInstance].wechatShareCallback) {
                    [HKWechatLoginShareCallback sharedInstance].wechatShareCallback();
                }
            }
        }
            break;
        case WXErrCodeAuthDeny:
            break;
        case WXErrCodeUserCancel:
            break;
        case WXErrCodeSentFail:
            break;
        default:
            break;
    }
}




- (void)onReq:(BaseReq *)req {
    
    //获取开放标签传递的extinfo数据逻辑 GetMessageFromWXReq、ShowMessageFromWXReq等。
    WXMediaMessage *msg = nil;
    // 微信 跳转APP
    if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        msg = ((LaunchFromWXReq *)req).message;
        //NSString *openID = req.openID;
    }else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        msg = ((ShowMessageFromWXReq *)req).message;
    }
    
    if (msg) {
        NSString *extinfo = msg.messageExt;
        if (!isEmpty(extinfo)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *url = [NSString stringWithFormat:@"%@%@", @"?" ,extinfo];
                [self postPushTargetVCNotificationWithUrl:url];
                //[JMLinkService routeMLink:[NSURL URLWithString:url]];
            });
        }
    }
}

- (void)loadNewDeviceTask:(int)type{///0:未注册 1:完成 (领了vip和训练营或者没有配训练营) 2:已注册 3:已播放 4:已领vip,未领训练营 5:老用户
    
    //type   1 表示从悬浮按钮进入登录页，登录完要谈出tip    2.表示观看视频点击返回  3.表示启动进入时
    @weakify(self)
    [HKHttpTool POST:@"new-device-task/get-task" parameters:nil success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.model = [HKNewTaskModel mj_objectWithKeyValues:responseObject[@"data"]];
            //self.model.is_show = 1;
            if (self.model.is_show == 1 ) {
                [self createSuspensionView];//创建悬浮按钮
                if (type != 3) {
                    if (self.model.status == 2){//完成注册，tipview出现
                        self.tipView = [HKTaskSuspensionTipView viewFromXib];
                        self.tipView.frame = CGRectMake(0, SCREEN_HEIGHT - KTabBarHeight49 - 50, SCREEN_WIDTH, 50);
                        self.tipView.alpha = 1;
                        self.tipView.isFinishRegist = YES;
                        [self.window addSubview:self.tipView];
                        
                        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipViewClick)];
                        [self.tipView addGestureRecognizer:tap];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.tipView removeFromSuperview];
                            self.tipView = nil;
                        });
                    }
                }
                
                if (type == 2) {
                    [self suspensionViewDidClick];
                }
            }
            else
            {
                self.suspensionView.hidden = YES;
                if (self.model.status == 5){//老用户
                    if (type == 1) {
                        self.taskView = [[HKHNewbieFatherView alloc] initWithFrame:CGRectMake(0, 0, 290, 220)];
                        self.taskView.alertType = 4;
                        self.taskView.finishBtnBlock = ^{
                            [LEEAlert closeWithCompletionBlock:nil];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if ([[CommonFunction topViewController] isKindOfClass:[HKBaseVC class]]) {
                                    HKBaseVC * vc = (HKBaseVC *)[CommonFunction topViewController];
                                    HKPresentVC *VC = [[HKPresentVC alloc] init];
                                    [vc pushToOtherController:VC];
                                }
                            });
                            
                        };
                        [LEEAlert alert].config
                            .LeeCustomView(self.taskView)
                            .LeeQueue(YES)
                            .LeePriority(1)
                            .LeeCornerRadius(0)
                            .LeeHeaderColor([UIColor clearColor])
                            .LeeHeaderInsets(UIEdgeInsetsZero)
                            .LeeMaxWidth(320)
                            .LeeClickBackgroundClose(YES)
                            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
                            .LeeShow();
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"-----");
    }];
    
}

- (void)tipViewClick{
    NSLog(@"点击了tipView");
    [self.tipView removeFromSuperview];
    self.tipView = nil;
    [self suspensionViewDidClick];
    [MobClick event:newtask_signedtips];
}

- (void)createSuspensionView{//创建悬浮按钮
    HKBaseVC * vc = (HKBaseVC *)[CommonFunction topViewController];
    if ([vc isKindOfClass:[HomeVideoVC class]] || [vc isKindOfClass:[MyInfoViewController class]]) {//
        [self.suspensionView removeFromSuperview];
        self.suspensionView = nil;
        self.suspensionView = [HKSuspensionView viewFromXib];
        self.suspensionView.frame = CGRectMake(SCREEN_WIDTH - 90, SCREEN_HEIGHT - KTabBarHeight49 - 150, 80, 80);
        [self.window addSubview:self.suspensionView];
        
        for (UIView * view in self.window.subviews) {
            NSLog(@"--------------%@",[view class]);
            if ([view isKindOfClass:[HKGuideView class]]) {
                [self.window bringSubviewToFront:view];
            }
        }
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suspensionViewDidClick)];
        [self.suspensionView addGestureRecognizer:tap];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.timer invalidate];
            self.timer = nil;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
            //self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        });
        
        //        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    }
}

- (void)timerClick{
    int nowTime = [[DateChange getNowTimeTimestamp] intValue];
    int diff = self.model.end_time - nowTime;
    if (diff>0) {
        NSString * time = [self getMMSSFromSS:diff];
        self.suspensionView.timeLabel.text = time;
        self.taskView.taskView.countDownLabel.text = [NSString stringWithFormat:@"倒计时：%@",time];
    }else{
        [self.timer invalidate];
        self.timer = nil;
        [self.suspensionView removeFromSuperview];
        self.suspensionView = nil;
    }
}

-(NSString *)getMMSSFromSS:(int)seconds{
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        return format_time;
}

- (void)suspensionViewDidClick{////0:未注册 1:完成 (领了vip和训练营或者没有配训练营) 2:已注册 3:已播放 4:已领vip,未领训练营 5:老用户
    //alertType:1.新手任务 2.新手任务结束后台的领取训练营任务 3.领取成功立即体验 4.老用户查看福利
    //self.model.status = 5;
    
    if (self.model.status != 0) {
        if (!isLogin()) {
            UIViewController *topVC = [CommonFunction topViewController];
            if ([topVC isKindOfClass:[HKBaseVC class]]) {
                HKBaseVC * vc = (HKBaseVC *)topVC;
                [vc setLoginVC];
            }
            return;
        }
    }
    
    
    [MobClick event:newtask_icon];
    if (self.model.status == 0 ||self.model.status == 2 ||self.model.status == 3 ) {
        self.taskView = [[HKHNewbieFatherView alloc] initWithFrame:CGRectMake(0, 0, 290, 315)];
        if (self.model.status == 0) {//0:未注册
            self.taskView.alertType = 1;
        }else if (self.model.status == 2){//2:已注册
            self.taskView.alertType = 5;
        }else if (self.model.status == 3){//3:已播放
            self.taskView.alertType = 6;
        }
    }else if (self.model.status == 1){//1:完成  此时悬浮按钮已经隐藏
        
    }else if (self.model.status == 4){//4:已领vip,未领训练营
        self.taskView = [[HKHNewbieFatherView alloc] initWithFrame:CGRectMake(0, 0, 290, 255)];
        self.taskView.alertType = 2;
    }else if (self.model.status == 5){//5:老用户
        self.taskView = [[HKHNewbieFatherView alloc] initWithFrame:CGRectMake(0, 0, 290, 220)];
        self.taskView.alertType = 4;
    }
    
    self.taskView.model = self.model;
    @weakify(self)
    self.taskView.finishBtnBlock = ^{
        @strongify(self)
        [LEEAlert closeWithCompletionBlock:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[CommonFunction topViewController] isKindOfClass:[HKBaseVC class]]) {
                HKBaseVC * vc = (HKBaseVC *)[CommonFunction topViewController];
                if (self.model.status == 0 ) {//去登录注册
                    [MobClick event:newtask_signin];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!isLogin()) {
                            UIViewController *topVC = [CommonFunction topViewController];
                            if ([topVC isKindOfClass:[HKBaseVC class]]) {
                                HKBaseVC * vc = (HKBaseVC *)topVC;
                                vc.isFromSuspensionView = YES;
                                [vc setLoginVC];
                            }
                        }
                    });
                }else if (self.model.status == 2){//去学习
                    UIViewController *topVC = [CommonFunction topViewController];
                    if ([topVC isKindOfClass:[VideoPlayVC class]]) {
                        //不做操作
                    }else{
                        //定位到首页，展示引导层
                        if (self.tabBarControllerConfig.tabBarController.selectedIndex == 0) {
                            [topVC.navigationController popToRootViewControllerAnimated:YES];
                        }else{
                            self.tabBarControllerConfig.tabBarController.selectedIndex = 0;
                        }
                        
                        [MobClick event:newtask_tolearn];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showLearnGuidView"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        HK_NOTIFICATION_POST(@"showLearnGuidView", nil);
                    }
                    
                }else if (self.model.status == 3){//领取奖励
                    [MobClick event:newtask_getvip];
                    @weakify(self)
                    [HKHttpTool POST:@"new-device-task/add-vip" parameters:nil success:^(id responseObject) {
                        @strongify(self);
                        if (HKReponseOK) {
                            int status = [responseObject[@"data"][@"status"] intValue];
                            self.model.status =status;
                            self.taskView = nil;
                            if (status == 1 || status == 4) {
                                if (status == 1) {
                                    self.model.is_show = 0;
                                    self.taskView = [[HKHNewbieFatherView alloc] initWithFrame:CGRectMake(0, 0, 290, 170)];
                                    self.taskView.alertType = 3;
                                    self.taskView.finishBtnBlock = ^{
                                        [LEEAlert closeWithCompletionBlock:nil];
                                    };
                                }else if (status == 4){
                                    self.taskView = [[HKHNewbieFatherView alloc] initWithFrame:CGRectMake(0, 0, 290, 255)];
                                    self.taskView.alertType = 2;
                                    self.taskView.finishBtnBlock = ^{
                                        [LEEAlert closeWithCompletionBlock:nil];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            if ([[CommonFunction topViewController] isKindOfClass:[HKBaseVC class]]) {
                                                HKObtainCampVC * campVC = [[HKObtainCampVC alloc] init];
                                                [vc pushToViewController:campVC animated:YES];
                                            }
                                        });
                                        
                                    };
                                }
                                self.taskView.model = self.model;
                                [LEEAlert alert].config
                                    .LeeCustomView(self.taskView)
                                    .LeeQueue(YES)
                                    .LeePriority(1)
                                    .LeeCornerRadius(0)
                                    .LeeHeaderColor([UIColor clearColor])
                                    .LeeHeaderInsets(UIEdgeInsetsZero)
                                    .LeeMaxWidth(320)
                                    .LeeClickBackgroundClose(YES)
                                    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
                                    .LeeShow();
                            }
                        }
                    } failure:^(NSError *error) {
                        NSLog(@"-----");
                    }];
                    
                }else if (self.model.status == 4){//领训练营
                    [MobClick event:newtask_getcamp];
                    HKObtainCampVC * campVC = [[HKObtainCampVC alloc] init];
                    [vc pushToViewController:campVC animated:YES];
                }else if (self.model.status == 5){//老用户
                    [MobClick event:newtask_oldfriends];
                    HKPresentVC *VC = [[HKPresentVC alloc] init];
                    [vc pushToOtherController:VC];
                }
            }
        });
    };
    [LEEAlert alert].config
        .LeeCustomView(self.taskView)
        .LeeQueue(YES)
        .LeePriority(1)
        .LeeCornerRadius(0)
        .LeeHeaderColor([UIColor clearColor])
        .LeeHeaderInsets(UIEdgeInsetsZero)
        .LeeMaxWidth(320)
        .LeeClickBackgroundClose(YES)
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
}

- (void)updateNewDeviceTask:(NSNotification *)noti{
    int type = [noti.userInfo[@"type"] intValue]; //1 表示从悬浮按钮进入登录页，登录完要谈出tip
    [self loadNewDeviceTask:type];
    [self loadCheckinNotifyData];
    [self loadProtoclViewData];
}

- (void)videoPlayedNewDeviceTask{
    self.model.status = 3;
    [self suspensionViewDidClick];
}


-(void)setSuspensionViewHidden:(BOOL)hidden{
    self.suspensionView.hidden = hidden;
}

- (void)loadProtoclViewData{
    if (isLogin()) {
        NSString * IDStr = [CommonFunction getUserId];
        NSInteger show  = 0;
        if(IDStr.length){
            show = [[NSUserDefaults standardUserDefaults] integerForKey:IDStr];
        }
        
        if (show) {
            
        }else{
            [HKHttpTool POST:Protocol parameters:nil success:^(id responseObject) {
                if (HKReponseOK) {
                    int need_show = [responseObject[@"data"][@"need_show"] intValue];
                    if (need_show) {
                        [self showProtocolView];
                    }
                }
            } failure:^(NSError *error) { }];
        }
    }
}

- (void)showProtocolView{
    UIViewController * vc =[CommonFunction topViewController];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 330)];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor clearColor];
    
    HKProtoclView * authView = [HKProtoclView createView];
    authView.sureBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
        [self readProtocol];
    };
    
    authView.closeBlock = ^{
        exit(0);
    };
    
    authView.delegateClickBlock = ^(NSInteger tag) {
        [LEEAlert closeWithCompletionBlock:nil];
        NSString *webUrl = nil;
        if (tag == 0) {
            webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
        }else{
            webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
        }
        
        HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
        htmlShowVC.hidesBottomBarWhenPushed = YES;
        htmlShowVC.backActionCallBlock = ^(BOOL fullScreen) {
            [self showProtocolView];
        };
        [vc.navigationController pushViewController:htmlShowVC animated:YES];
    };
    [bgView addSubview:authView];
    
    LEEAlertConfig * alert = [LEEAlert alert];
    alert.config.showTopImage = YES;
    alert.config
        .LeeCustomView(bgView)
        .LeeMaxWidth(300)
        .LeeHeaderColor(COLOR_FFFFFF_3D4752)
        .LeeShouldAutorotate(NO)
        .LeeCloseAnimationDuration(0)
        .LeeOpenAnimationDuration(0)
        .LeeSupportedInterfaceOrientations( UIInterfaceOrientationMaskPortrait)
        .LeeShow();
}
    
- (void)readProtocol{
    [HKHttpTool POST:read_Protocol parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            int business_code = [responseObject[@"data"][@"business_code"] intValue];
            if (business_code == 200) {
                NSString * IDStr = [CommonFunction getUserId];
                if(IDStr.length){
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:IDStr];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    } failure:^(NSError *error) { }];
}



@end


