//
//  AppDelegate+HK.h
//  Code
//
//  Created by Ivan li on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "AppDelegate.h"
#import "CYLTabBarController.h"

#import <JPush/JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate (Category) <UIAlertViewDelegate>

/** 切换服务器 */
- (void)changeServerState;


/** 提示更新 */
- (void)upDateNewVersion;


/**
 点击推送消息 进入相应页面
 dict: 极光推送数据
 */
- (void)getJPUSHInfoPushVC:(NSDictionary*)dict;


/** 添加 我的 消息未读红点*/
- (void)addTabarBadgeRedPoint:(CYLTabBarController *)tabBarController;


/** 键盘管理*/
- (void)keyboardManager;


/** 配置第三方平台 key */
- (void)configUSharePlatforms;


/**  友盟统计 bugly错误统计 */
- (void)configUMRecordAndBugly;


/**
 点击web 跳转到APP 视频详情
 
 @param url web url
 */
- (void)pushVideoPlayVCWithUrl:(NSURL*)url;


/**
 创建 选择 tab item 通知接收者
 */
- (void)addSelectTabObserver;

/**
 *
 *  缩放动画
 */
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount;


/**
 *
 * 注册 IM 推送
 */
- (void)registerPushService;


///**
// *  IM 未读消息
// */
//- (void)setIMIconBadge;

/**
 *
 *  模拟器热加载
 */
- (void)loadingSimulator;


/**
 *
 *  选择 聊天 tab
 */
- (void)selectThirdTab;


/**
 *
 *  证书和勋章 弹框
 * userInfo （推送 Json）
 */
- (void)pushCertificateDialogWithDict:(NSDictionary *)userInfo;

/**
 短视频 限免标签
 */
- (void)showShortVideoBadgeView;


/**
 删除 短视频 限免标签
 */
- (void)removeShortVideoBadgeView;

/**
 短视频 限免标签
 */
- (void)showCategoryNewBadgeView;

/** 支付宝 支付回调 */
- (void)hkAlipayResultCallBack:(NSURL *)url;


/**获取微信的 token */
- (void)wechatAccessToken:(SendAuthResp*)resp;


/** 初始化乐播投屏 */
- (void)initLBLelinkKit;

/// 发送 web或者微信 打开APP页面通知
- (void)postPushTargetVCNotificationWithUrl:(NSString*)url;

//push通知列表
- (void)loadCheckinNotifyData;

@end





