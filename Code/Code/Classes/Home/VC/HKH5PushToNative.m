//
//  HKH5PushToNativeVC.m
//  Code
//
//  Created by Ivan li on 2018/1/8.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKH5PushToNative.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "BannerModel.h"
#import <stdio.h>
#import "LoginVC.h"
#import "AppDelegate.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "VideoPlayVC.h"
#import "HKAdWindow.h"
#import "NSString+MD5.h"
#import "HKNavigationController.h"
#import <OneLoginSDK/OneLoginSDK.h>

@implementation HKH5PushToNative


/**
 检测对象是否存在该方法 运行方法 跳转视图
 
 @param vcName
 @param arr
 @param nav
 @param methodName
 */
+ (void)runtimePush:(NSString *)vcName arr:(NSMutableArray *)arr nav:(UINavigationController *)nav  methodName:(NSString*)methodName{
    
    NSString *class = vcName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    id instance = [[newClass alloc] init];
    [self impleWithName:methodName instance:instance argumentsArr:arr];
    [nav pushViewController:instance animated:YES];
}



/**
 检测对象是否存在该属性 运行方法 跳转视图

 @param vcName 控制器名称
 @param arr <AdvertParameterModel> 属性
 @param currectVC 当前控制器 NavigationController
 */
//+ (void)runtimePush:(NSString *)vcName arr:(NSMutableArray <AdvertParameterModel*>*)arr nav:(UINavigationController *)nav {
+ (void)runtimePush:(NSString *)vcName arr:(NSMutableArray *)arr currectVC:(UIViewController *)currectVC {
    NSString *class = vcName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    
    if ([class isEqualToString:@"HKSystemBrowserVC"]) {
        //跳转浏览器或APP商店
        if (arr.count) {
            AdvertParameterModel *model = arr[0];
            if ([NSString isUrl:model.value]) {
                [[UIApplication sharedApplication] openURL:HKURL(model.value)];
            }
        }
        return;
    }
    
    if (className == NULL) {
        return;// 不存在此类
    }
    
    if (!newClass && className != NULL) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    
    id instance = [[newClass alloc] init];
    //属性传值
    for (AdvertParameterModel *model in arr) {
        
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:model.parameter_name]) {
            //kvc给属性赋值
            [instance setValue:model.value forKey:model.parameter_name];
        }else {
            NSLog(@"不包含key=%@的属性",model.parameter_name);
        }
    }
    if ([class isEqualToString:@"LoginVC"]) {
//        if (!isLogin()) {
            UINavigationController *loginVC = [[UINavigationController alloc]initWithRootViewController:[LoginVC new]];
            loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [currectVC presentViewController:loginVC animated:YES completion:nil];
//        }
        
    }else if ([class isEqualToString:@"HomeVideoVC"]) {
        if (arr.count) {
            for (AdvertParameterModel *model in arr) {
                if ([model.parameter_name isEqualToString:@"select_tab_index"]) {
                    [CommonFunction pushTabVCWithCurrectVC:currectVC index:[model.value intValue]];
                    return;
                }
            }
        }else{//签到
            [CommonFunction pushTabVCWithCurrectVC:currectVC index:0];
        }
    }else{
        __block UIViewController *resultVC = [self topViewController];
//        if ([resultVC isKindOfClass:[LEEAlertViewController class]] || [resultVC isKindOfClass:[LEEActionSheetViewController class]]) {
//            [LEEAlert closeWithCompletionBlock:^{
//                  resultVC = [self topViewController];
//                [self pushOrPresentController:resultVC instance:instance];
//            }];
//        }else{
//            if ([resultVC isKindOfClass: [VideoPlayVC class]]) {
//                //如果VideoPlayVC 全屏 强制竖屏
//                [((VideoPlayVC *)resultVC)forcePlayerPortrait];
//            }
//            [self pushOrPresentController:resultVC instance:instance];
//        }
        
        if ([resultVC isKindOfClass:[LEEAlertViewController class]] || [resultVC isKindOfClass:[LEEActionSheetViewController class]]) {
            [LEEAlert closeWithCompletionBlock:^{
                  resultVC = [self topViewController];
                [self pushOrPresentController:resultVC instance:instance];
            }];
        }else if ([NSStringFromClass([resultVC class]) isEqualToString:@"OLAuthViewController"]) {
            @weakify(self);
            [OneLogin dismissAuthViewController:^{
                @strongify(self);
                resultVC = [self topViewController];
                if ([resultVC isKindOfClass: [LoginVC class]]) {
                    [((LoginVC *)resultVC)closeBtnClick:^{
                        resultVC = [self topViewController];
                        [self pushOrPresentController:resultVC instance:instance];
                    }];
                }
            }];
        }else{//
            if ([NSStringFromClass([resultVC class]) isEqualToString:@"ZFLandscapeViewController_iOS15"] ||
                [NSStringFromClass([resultVC class]) isEqualToString:@"ZFPortraitViewController"]){//ZFLandscapeViewController_iOS15
                [self pushOrPresentController:currectVC instance:instance];
            }else if ([resultVC isKindOfClass: [VideoPlayVC class]]) {
                //如果VideoPlayVC 全屏 强制竖屏
                [((VideoPlayVC *)resultVC)forcePlayerPortrait];
                [self pushOrPresentController:resultVC instance:instance];
            }else{
                [self pushOrPresentController:resultVC instance:instance];
            }
        }
    }
}


+ (void)pushOrPresentController:(UIViewController *)targetVC  instance:(id)instance {
    if (targetVC) {
        if ([instance isKindOfClass:[UIViewController class]]) {
            ((UIViewController*)instance).hidesBottomBarWhenPushed = YES;
            if (targetVC.navigationController) {
                [targetVC.navigationController pushViewController:instance animated:YES];
            }else{
                HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:instance];
                if ([instance isKindOfClass:[VideoPlayVC class]]) {
                    loginVC.navigationBarHidden = YES;
                }
                if (@available(iOS 13.0, *)) {
                    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
                }
                [targetVC presentViewController:loginVC animated:YES completion:nil];
            }
        }
    }
}





+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}



/** 当前控制器 */
+ (UIViewController *)topViewController {
    UIWindow *win = nil;
    if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[HKAdWindow class]]) {
        // 广告 窗口 正在显示
        win = [AppDelegate sharedAppDelegate].window;
    }else{
        win = [UIApplication sharedApplication].keyWindow;
    }
    UIViewController *resultVC;
    resultVC = [self _topViewController:[win rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}




/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    unsigned int outCount, i;
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
}



/**
 *  检测对象是否存在该方法
 */
+ (void)impleWithName:(NSString*)methodName instance:(id)instance  argumentsArr:(NSArray *)argumentsArr {

    unsigned int outCountMethod = 0;
    Method * methods = class_copyMethodList([instance class], &outCountMethod);
    for (int j = 0; j < outCountMethod; j++) {
        
        Method method = methods[j];
        SEL methodSEL = method_getName(method);
        const char *selName = sel_getName(methodSEL);
        NSString *propertyName = [[NSString alloc] initWithCString:selName encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:methodName]) {
            [self tb_performSelector:methodSEL withObjects:argumentsArr];
            free(methods);
            break;
        }
    }
    free(methods);
}


+ (UIViewController *)runtimePush:(NSString *)vcName arr:(NSMutableArray *)arr {
    NSString *class = vcName;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    
    if ([class isEqualToString:@"HKSystemBrowserVC"]) {
        //跳转浏览器或APP商店
        if (arr.count) {
            AdvertParameterModel *model = arr[0];
            if ([NSString isUrl:model.value]) {
                [[UIApplication sharedApplication] openURL:HKURL(model.value)];
            }
        }
        return nil;
    }
    
    if (className == NULL) {
        return nil;// 不存在此类
    }
    
    if (!newClass && className != NULL) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    
    id instance = [[newClass alloc] init];
    //属性传值
    for (AdvertParameterModel *model in arr) {
        
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:model.parameter_name]) {
            //kvc给属性赋值
            [instance setValue:model.value forKey:model.parameter_name];
        }else {
            NSLog(@"不包含key=%@的属性",model.parameter_name);
        }
    }
    return instance;
}



@end

