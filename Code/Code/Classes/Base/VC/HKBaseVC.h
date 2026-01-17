//
//  HKBaseVC.h
//  Code
//
//  Created by pg on 2017/3/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    //记录 是否是 第一次 初始化
    SetupCountOnce,
    SetupCountSecond,
} SetupCount;



typedef void(^NetWorkStatusBlock)(NSInteger status);

@interface HKBaseVC : UIViewController <TBSrollViewEmptyDelegate>


@property(nonatomic,copy)NSString *emptyText;  //列表为空时 显示文字
/** 空视图 图片竖直 偏移距离 */
@property(nonatomic,assign)float verticalOffset;
/**管理 baritem */
@property (nonatomic,strong) UIButton *rightBarEditBtn;

@property (nonatomic , assign) BOOL isFromSuspensionView; //比较一下来自悬浮窗点击登录

#pragma mark  导航栏上的标题 颜色
- (void)setTitle:(NSString *)title color:(UIColor*)color;


#pragma mark  返回上一页面
- (void)backAction;

/**
 设置导航栏标题 颜色

 @param color
 */
- (void)setNavigationBarTitleColor:(UIColor*)color;


- (void)createLeftBarButton;

/// 返回 baritem 图标
//+ (NSString*)barButtonItemBackgroudImageName;

- (void)createLeftBarItemWithImageName:(NSString*)imageName;


/**
  创建rightBarButtonItem

 @param title 标题
 @param action
 */
//- (void)rightBarButtonItemWithTitle:(NSString*)title  action:(SEL)action;
- (void)rightBarButtonItemWithTitle:(NSString*)title color:(UIColor *)color  action:(SEL)action;

/**
 *
 *根据图片大小 创建右BarButtonItem
 *
 */
- (void)createRightBarButtonWithImage:(NSString*)image;

- (void)rightBarBtnAction;


/** 创建分享的 BarButtonItem */
- (void)createShareButtonItem;

- (void)shareBtnItemAction;

/**
 *
 *push 另一视图
 *
 */
- (void)pushToOtherController:(UIViewController*)VC;



/**
 push 另一视图

 @param VC <#VC description#>
 @param animated 是否动画跳转
 */
- (void)pushToViewController:(UIViewController*)VC  animated:(BOOL)animated;

/**
 *
 *创建指定大小的 右BarButtonItem
 *
 */
- (void)createRightBarButtonWithImage:(NSString*)image size:(CGSize)size;



/**
 *
 *判断是否是模拟器
 *
 */
- (void)isSimulator;


/**
 手机流量提醒
 */

- (void)mobileTrafficNotice;


/**
 手机空间不足提醒

 @return
 */

- (void)mobileMemoryNotice;


/**
 登入过期 强制重新登入

 @return void
 */
//- (void)resetLogin;

/**
 #pragma mark - 登录过期,重新登录
 
 @return void
 */

- (void)resetUserLogin;


#pragma mark - 退出登录
- (void)userSignOut;

#pragma mark - 建立登录视图
- (void)setLoginVC;

- (void)setStudyLoginVC;

#pragma mark - 建立新手礼包登录视图
- (void)setGiftLoginVC;

#pragma mark - 当前窗口控制器
- (UIViewController *)topViewController;

/** 设置 登录-退出 观察 */
- (void)userLoginAndLogotObserver;

/** 接受 登录通知后 操作 */
- (void)userloginSuccessNotification;

/** 接受 退出通知后 操作 */
- (void)userlogoutSuccessNotification;

///** 登录 IM */
//- (void)loginIM;

/** 绑定手机 alert */
- (void)setBindPhoneAlert:(NSString *)text;

/**
 绑定手机号 检测

 @ commentBlock 已绑定之后的 操作
 */
- (void)checkBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone;
- (void)checkloadImgBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone;

/// 购买VIP完成 时检测 绑定手机号 检测
/// @param bindSucessBlock 绑定成功
/// @param bindPhoneBlock 绑定手机号
- (void)buyVipCheckBindPhone:(void (^)())bindSucessBlock  bindPhoneBlock:(void (^)())bindPhoneBlock;


#pragma mark - 跳转vip 购买协议html
- (void)pushToVipProtocolHtmlVC;


/// 禁止侧滑返回
- (void)forbidBackGestureRecognizer;

- (CGFloat)tabitemPointXForIndex:(NSInteger)index;
@end
