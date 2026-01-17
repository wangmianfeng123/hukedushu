//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@implementation UINavigationBar (Awesome)
static char overlayKey;


- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)lt_setBackgroundColor:(UIColor *)backgroundColor {

    if (!self.overlay) {

        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [UIView new];
        //self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + (IS_IPHONE_X?44:20))];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight
        
        if (@available(iOS 13.0, *)) {
            self.overlay.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + (IS_IPHONE_X?48:20));
            [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
            
        }else if (@available(iOS 12.0, *)) {
            self.overlay.frame = CGRectMake(0, (IS_IPHONE_X? -44: -20), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + (IS_IPHONE_X?44:20));
            [self insertSubview:self.overlay atIndex:1];
        }else{
            self.overlay.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + (IS_IPHONE_X?44:20));
            [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
        }
    }
    self.overlay.backgroundColor = backgroundColor;
}



- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}


- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    
//    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
//        view.alpha = alpha;
//    }];
//
//    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
//        view.alpha = alpha;
//    }];
//
//    UIView *titleView = [self valueForKey:@"_titleView"];
    //titleView.alpha = alpha;
    
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
        }
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
            obj.alpha = alpha;
        }
        
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            obj.alpha = alpha;
        }
            
        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            obj.alpha = alpha;
        }
        
    }];
}


- (void)lt_reset
{
    //[self setShadowImage:nil];
    UIColor *color = [UIColor clearColor];
    //UIColor *color = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:[UIColor clearColor]];
    UIImage *image = [UIImage coustomSizeImageWithColor:color size:CGSizeMake(SCREEN_WIDTH, 0.5)];
    [self setShadowImage:image];
    
    //[self setShadowImage:[UIImage coustomSizeImageWithColor:COLOR_EFEFF6 size:CGSizeMake(SCREEN_WIDTH, 0.5)]];
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end




