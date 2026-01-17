//
//  HKLoginTool.h
//  Code
//
//  Created by Ivan li on 2018/7/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKLoginTool : NSObject


/**
 * 重新登录 alert
 LIMIT_TOO_MANY_LOGIN
 */

+ (void)setResetLoginAlertWithContent:(NSString*)content;

/**
 *  登录次数过多 禁止登录
 */
+ (void)forbidLoginWithContent:(NSString*)content;


/** 保存 上一次 登录 平台类型 */
+ (void)saveLastLoginPattern:(NSString *)clientType;

/** 三级视图跳转 */
+ (void)pushToBeforeVC:(UIViewController*)VC;

/** 弹出登录VC */
+ (void)pushLoginVC;

/** 弹出新手礼包登录VC */
+ (void)pushGiftLoginVC;


/**
 VIP 受限 弹框
 */
+ (void)vipRestrictDialog;

@end
