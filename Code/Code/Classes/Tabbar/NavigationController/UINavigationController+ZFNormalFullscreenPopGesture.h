


#import <UIKit/UIKit.h>

@interface UIViewController (ZFNormalFullscreenPopGesture)

// 隐藏NavigationBar（默认NO）
@property (nonatomic, assign) BOOL zf_prefersNavigationBarHidden;

@end

@interface UINavigationController (ZFNormalFullscreenPopGesture)<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL isPopGestureRecognizerEnable;

@end

