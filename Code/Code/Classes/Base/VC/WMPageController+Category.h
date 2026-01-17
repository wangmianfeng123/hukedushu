//
//  WMPageController+Category.h
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "WMPageController.h"

@interface WMPageController (Category)

- (void)setLeftBarButtonItem;

- (void)backAction;

#pragma mark  导航栏上的标题 颜色
- (void)setTitle:(NSString *)title color:(UIColor*)color;

#pragma mark - 建立登录视图
- (void)setLoginVC;


/** 创建分享的 BarButtonItem */
- (void)setShareButtonItemWithImageName:(NSString*)imageName;

- (void)setShareButtonItem;

- (void)shareBtnItemAction;

/** 白色 左BarButton  */
- (void)setWhiteLeftBarButtonItem;

/** 占位 右BarButton  */
- (void)setBlankRightBarButtonItem;

- (void)rightBarButtonItemWithTitle:(NSString*)title color:(UIColor *)color  action:(SEL)action;
/**
 绑定手机号 检测

 @ commentBlock 已绑定之后的 操作
 */
- (void)checkBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone;

@end
