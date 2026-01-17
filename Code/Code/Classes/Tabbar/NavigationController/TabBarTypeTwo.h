//
//  TabBarTypeTwo.h
//  gcnsxp
//
//  Created by happying on 17/3/17.
//  Copyright © 2017年 gcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabBarControllerConfig.h"

@interface TabBarTypeTwo :TabBarControllerConfig


/**
 替换 tabitem icon

 @param tabBarController
 @param viewController 
 */
+ (void)changeTabItemImage:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end


