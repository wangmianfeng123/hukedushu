//
//  HKLoginVC.h
//  Code
//
//  Created by Ivan li on 2018/7/21.
//  Copyright © 2018年 pg. All rights reserved.
//


/**

1-登录页面 LoginVC 背景透明,调用手机登录按钮点击方法 去 OneLogin 预取号

2-根据OneLogin 预取号的回调 跳转或者 弹出相应的页面(OneLogin弹窗页面 或 手机登录VC)

3-进行登录  登录接口返回数据（out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录 5 -强制绑定手机号）
 
根据 out_line 的对应值 做不同操作

*/

#import "HKBaseVC.h"

@interface LoginVC : HKBaseVC

@property(nonatomic,assign)HKLoginViewType loginViewType;

@property(nonatomic,assign)HKLoginViewThemeType  loginViewThemeType;

@property (nonatomic, copy) NSString * loginTxt;
@property (nonatomic , assign) BOOL isFromSuspensionView; //比较一下来自悬浮窗点击登录
@property (nonatomic , strong) NSDictionary * sender;

/// 弹窗关闭按钮
- (void)closeBtnClick:(void (^ __nullable)(void))completion;

@end
