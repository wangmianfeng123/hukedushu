//
//  HKH5PushToNativeVC.h
//  Code
//
//  Created by Ivan li on 2018/1/8.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AdvertParameterModel;

@interface HKH5PushToNative : NSObject

/**
 检测对象是否存在该属性 运行方法 跳转视图
 
 @param vcName 控制器名称
 @param arr <AdvertParameterModel> 属性
 @param currectVC 当前控制器 NavigationController
 */
//+ (void)runtimePush:(NSString *)vcName arr:(NSMutableArray <AdvertParameterModel*>*)arr nav:(UINavigationController *)nav;
+ (void)runtimePush:(NSString *)vcName arr:(NSMutableArray *)arr currectVC:(UIViewController *)currectVC;


+ (void)runtimePush:(NSString *)vcName arr:(NSMutableArray *)arr nav:(UINavigationController *)nav  methodName:(NSString*)methodName;


/** 当前控制器 */
+ (UIViewController *)topViewController;

+ (void)pushOrPresentController:(UIViewController *)targetVC  instance:(id)instance;

//通过类名字和参数生成一个控制器
+ (UIViewController *)runtimePush:(NSString *)vcName arr:(NSMutableArray *)arr ;

@end
