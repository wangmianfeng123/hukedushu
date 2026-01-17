//
//  AppDelegate.h
//  Code
//
//  Created by pg on 16/3/8.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKIMSdkConfig,TabBarTypeTwo,HKTabBarModel,HKSuspensionView,HKNewTaskModel,HKHNewbieFatherView,HKTaskSuspensionTipView;

typedef void(^BackgroundSessionCompletionHandler)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UIViewController *viewc;
@property (copy, nonatomic) BackgroundSessionCompletionHandler backgroundSessionCompletionHandler;

@property (nonatomic,strong,readonly)TabBarTypeTwo *tabBarControllerConfig;
/** 短视频 接口 */
@property(nonatomic,assign,getter=isShortVideoPostTimeOut)BOOL shortVideoPostTimeOut;

@property (nonatomic, strong) NSString * webUrl;//记录回调的URL，第一次初始化的时候使用

@property (nonatomic , strong) HKSuspensionView * suspensionView;
@property (nonatomic , strong) HKNewTaskModel * model;
@property (nonatomic , strong) HKHNewbieFatherView * taskView ;
@property (nonatomic , strong) HKTaskSuspensionTipView * tipView;

//登录页面是否折叠
@property (nonatomic , assign) BOOL isFold ; //1:折叠 0：不折叠
@property (nonatomic , assign) BOOL showLoadMessage ; //1:显示中 0：已经关闭
@property (nonatomic , assign) CGFloat cellHeight ;
+ (AppDelegate *)sharedAppDelegate;

- (void)setSuspensionViewHidden:(BOOL)hidden;
@end
