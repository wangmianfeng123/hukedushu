//
//  ViewController+HKHideNavShadowImage.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/30.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "UIViewController+HKHideNavShadowImage.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

static const char HKDideNavBarShadowImageKey = '\0'; // 是否隐藏
static const char HKNavBarShadowImageKey = '\0'; // 阴影image

@implementation UIViewController (HKHideNavShadowImage)


+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}


+ (void)load
{
    [self exchangeInstanceMethod1:@selector(viewWillAppear:) method2:@selector(hk_viewWillAppear:)];
    [self exchangeInstanceMethod1:@selector(viewWillDisappear:) method2:@selector(hk_viewWillDisappear:)];
}

- (void)hk_viewWillAppear:(BOOL)animated {
    
    [self hk_viewWillAppear:animated];
    
    if (self.hk_hideNavBarShadowImage) {
        
        // 存储原本的image
        UIImage *shadowImage = self.navigationController.navigationBar.shadowImage;
        objc_setAssociatedObject(self, &HKNavBarShadowImageKey,
                                 shadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        
        // 清除导航栏
        UIColor *color = [UIColor clearColor];
        //UIColor *color = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:[UIColor clearColor]];
        UIImage *image = [UIImage coustomSizeImageWithColor:color size:CGSizeMake(SCREEN_WIDTH, 0.5)];
        [self.navigationController.navigationBar setShadowImage:image];
    }

}

- (void)hk_viewWillDisappear:(BOOL)animated {
    
    [self hk_viewWillDisappear:animated];
    
    if (self.hk_hideNavBarShadowImage) {
        
        // 还原导航栏阴影，注意此次和 HKNavigationController 设置一致
        UIImage *shadowImage = objc_getAssociatedObject(self, &HKNavBarShadowImageKey);
        [self.navigationController.navigationBar setShadowImage:shadowImage];
        objc_setAssociatedObject(self, &HKNavBarShadowImageKey,
                                 nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

}

// 代理
- (void)setHk_hideNavBarShadowImage:(BOOL)hk_hideNavBarShadowImage {
    // 存储
    NSString *string = hk_hideNavBarShadowImage? @"1" : @"0";
    objc_setAssociatedObject(self, &HKDideNavBarShadowImageKey,
                             string, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)hk_hideNavBarShadowImage {
    
    // 获取
    NSString *string = objc_getAssociatedObject(self, &HKDideNavBarShadowImageKey);
    if (string && [string isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
}





@end
