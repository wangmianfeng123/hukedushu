

#import "UINavigationController+ZFNormalFullscreenPopGesture.h"
#import <objc/runtime.h>


@implementation UIViewController (ZFNormalFullscreenPopGesture)

- (BOOL)zf_prefersNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZf_prefersNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(zf_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end




typedef void (^_ZFNormalViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (ZFNormalFullscreenPopGesturePrivate)

@property (nonatomic, copy) _ZFNormalViewControllerWillAppearInjectBlock zf_willAppearInjectBlock;

@end



@implementation UIViewController (ZFNormalFullscreenPopGesturePrivate)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL selectors[] = {
            @selector(viewWillAppear:),
            @selector(viewWillDisappear:)
        };

        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"zf_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }

    });
}


- (void)zf_viewWillAppear:(BOOL)animated {
    // Forward to primary implementation.

    [self zf_viewWillAppear:animated];
    [self.navigationController setIsPopGestureRecognizerEnable:YES];

    if (self.zf_willAppearInjectBlock) {
        self.zf_willAppearInjectBlock(self, animated);
    }
}


- (void)zf_viewWillDisappear:(BOOL)animated {
    [self.navigationController setIsPopGestureRecognizerEnable:YES];
    [self zf_viewWillDisappear:animated];
}


- (_ZFNormalViewControllerWillAppearInjectBlock)zf_willAppearInjectBlock {
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setZf_willAppearInjectBlock:(_ZFNormalViewControllerWillAppearInjectBlock)block {
    objc_setAssociatedObject(self, @selector(zf_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end



static const char * PopGestureRecognizerKey = "PopGestureRecognizerKey";

@implementation UINavigationController (ZFNormalFullscreenPopGesture)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(viewDidLoad),
            @selector(pushViewController:animated:)
        };

        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"zf_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}



- (void)zf_viewDidLoad {
    [self zf_viewDidLoad];
    self.zf_viewControllerBasedNavigationBarAppearanceEnabled = YES;
}



- (void)zf_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController {
    if (!self.zf_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    _ZFNormalViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.zf_prefersNavigationBarHidden animated:animated];
        }
    };
    appearingViewController.zf_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.zf_willAppearInjectBlock) {
        disappearingViewController.zf_willAppearInjectBlock = block;
    }
}



#pragma mark - 重写父类方法
- (void)zf_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {

    }
    [self zf_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    [self zf_pushViewController:viewController animated:animated];
}


- (void)setZf_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)zf_viewControllerBasedNavigationBarAppearanceEnabled {
    objc_setAssociatedObject(self, @selector(zf_viewControllerBasedNavigationBarAppearanceEnabled), @(zf_viewControllerBasedNavigationBarAppearanceEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)zf_viewControllerBasedNavigationBarAppearanceEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (BOOL)isPopGestureRecognizerEnable {
    return [objc_getAssociatedObject(self, PopGestureRecognizerKey) boolValue];
}


- (void)setIsPopGestureRecognizerEnable:(BOOL)isPopGestureRecognizerEnable {
    objc_setAssociatedObject(self, PopGestureRecognizerKey, [NSNumber numberWithBool:isPopGestureRecognizerEnable], OBJC_ASSOCIATION_ASSIGN);
}


@end



