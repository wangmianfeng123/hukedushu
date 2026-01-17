//
//  TabBarControllerConfig.h
//  gcnsxp
//
//  Created by happying on 16/11/8.
//  Copyright © 2016年 gcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"

@class HKTabBarModel;

@interface TabBarControllerConfig : NSObject

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;

@property (nonatomic, strong) HKTabBarModel * tabModel;

/**
 tab 文字 颜色

 @param normalColor 普通状态颜色
 @param selectColor 选中颜色
 */
+ (void)tabBarItemTextColor:(UIColor*)normalColor selectColor:(UIColor*)selectColor;

@end
