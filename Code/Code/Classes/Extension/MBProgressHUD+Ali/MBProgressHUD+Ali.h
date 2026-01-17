//
//  MBProgressHUD+Ali.h
//  AliHUD
//
//  Created by mac on 17/8/7.
//  Copyright © 2017年 mac. All rights reserved.
//


#import "MBProgressHUD.h"

//[MBProgressHUD showActivityMessageInWindow:nil];
//
//[MBProgressHUD showActivityMessageInView:nil];
//
//[MBProgressHUD showTipMessageInWindow:@"在window"];
//
//[MBProgressHUD showTipMessageInView:@"在View"];
//
//[MBProgressHUD showSuccessMessage:@"加载成功"];
//
//[MBProgressHUD showWarnMessage:@"显示警告"];
//
//[MBProgressHUD showErrorMessage:@"显示错误"];
//
//[MBProgressHUD showInfoMessage:@"显示信息"];

@interface MBProgressHUD (Ali)

+ (void)showTipMessageInWindow:(NSString*)message;
+ (void)showTipMessageInView:(NSString*)message;
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer;


+ (void)showActivityMessageInWindow:(NSString*)message;
+ (void)showActivityMessageInView:(NSString*)message;
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer;
+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer;


+ (void)showSuccessMessage:(NSString *)Message imageName:(NSString*)imageName;
//+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;


+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;


+ (void)showTipMessageInWindow:(NSString*)message
                         timer:(int)aTimer
                       bgColor:(UIColor *)bgColor
                         alpha:(CGFloat)alpha
                          font:(UIFont*)font;

+ (void)hideHUD;

@end
