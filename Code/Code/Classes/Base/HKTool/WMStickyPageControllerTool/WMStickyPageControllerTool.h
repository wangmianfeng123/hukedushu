//
//  WMStickyPageTool.h
//  Code
//
//  Created by Ivan li on 2018/12/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "WMStickyPageController.h"

typedef NS_ENUM(NSUInteger, WMStickyPageControllerType) {
    WMStickyPageControllerType_ordinary = 0,
    // 视频详情类型
    WMStickyPageControllerType_videoDetail
};

@interface WMStickyPageControllerTool : WMStickyPageController

/*** menu 类型 */
@property(nonatomic,assign)WMStickyPageControllerType controllerType;

- (void)prepareSetup;
#pragma mark - 建立登录视图
- (void)setLoginVC;
- (void)checkBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone;

@end
