//
//    HKNavigationController.m
//
//
//  Created by Coneboy_K on 13-12-2.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.  MIT
//

#import "HKNavigationController.h"
#import "UINavigationController+ZFNormalFullscreenPopGesture.h"
#import "HKListeningBookVC.h"
#import "HKVIPCategoryVC.h"


@interface HKNavigationController ()
{
    BOOL _isEnable;
}


@end

@implementation   HKNavigationController



+ (void)initialize {

    //导航状态栏背景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if (@available(iOS 13.0, *)) {
        
    }else if (@available(iOS 12.0, *)) {

    }else{
        [[UINavigationBar appearance] lt_setBackgroundColor:NAVBAR_Color];
    }
    //设置字体颜色
    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : COLOR_27323F}];
    //导航栏分割线COLOR_EFEFF6
    //[[UINavigationBar appearance] setShadowImage:[UIImage coustomSizeImageWithColor:COLOR_EFEFF6 size:CGSizeMake(SCREEN_WIDTH, 0.5)]];
    
    UIColor *color = [UIColor clearColor];
    //UIColor *color = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:[UIColor clearColor]];
    UIImage *image = [UIImage coustomSizeImageWithColor:color size:CGSizeMake(SCREEN_WIDTH, 0.5)];
    [[UINavigationBar appearance] setShadowImage:image];
    
    
    
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//设置导航栏标题颜色
//
//    self.navigationBar.backgroundColor = [UIColor blackColor];//导航栏背景颜色

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}


#pragma mark ---- 屏幕切换
- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([self.topViewController isKindOfClass:[HKVIPCategoryVC class]]) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)setIsPopGestureRecognizerEnable:(BOOL)isPopGestureRecognizerEnable{
    _isEnable = isPopGestureRecognizerEnable;
}


#pragma mark -

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}



- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {

    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&& animated == YES ){

        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}



- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ){

        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        if (navigationController.childViewControllers.count <= 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }else{
            self.interactivePopGestureRecognizer.enabled = _isEnable;
        }
    }
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *VC = [super popViewControllerAnimated:animated];
    if ([VC isKindOfClass:[HKListeningBookVC class]]) {
        //HKBookPlayer.isBackFrontVC = YES;
    }
    return VC;
}


@end







