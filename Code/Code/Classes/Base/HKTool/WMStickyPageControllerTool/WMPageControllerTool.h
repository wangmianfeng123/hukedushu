//
//  WMPageControllerTool.h
//  Code
//
//  Created by Ivan li on 2018/12/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <WMPageController/WMPageController.h>

@interface WMPageControllerTool : WMPageController


- (void)prepareSetup;

#pragma mark - 建立登录视图
- (void)setLoginVC;

//- (void)checkBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone;
@end
