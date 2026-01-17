//
//  UIView+SNFoundation.m
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "UIView+SNFoundation.h"

@implementation UIView (SNFoundation)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)screenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)screenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)cornerRadius:(CGFloat)size
{
    if (size == 0) size = self.height * 0.5;
    
    self.layer.cornerRadius = size;
    self.layer.masksToBounds = YES;
    
}



- (void)removeAllSubviews
{
	while (self.subviews.count)
    {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}

- (UIViewController *)viewController
{
	id nextResponder = [self nextResponder];
	if ( [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}
	else
	{
		return nil;
	}
}


- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
	CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}




- (void)addShadowWithColor:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius offset:(CGSize)offset {
    
    self.layer.shadowOpacity = alpha;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
    
    if (color){
        self.layer.shadowColor = [color CGColor];
    }
    self.layer.masksToBounds = NO;
}




#pragma mark - FrontWindow
+ (UIWindow *)frontWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}




/**
 // 渐变背景

 @param colorArr  数组类型 CGColorRef
 */
- (void)gradientShadowWithColor:(NSArray*)colorArr {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colorArr;
    gradientLayer.locations = @[@0.3, @0.6, @1.0];
    
    //gradientLayer.startPoint = CGPointMake(0, 0);
    //gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    //颜色上下渐变
    [gradientLayer setStartPoint:CGPointMake(0, 0)];
    [gradientLayer setEndPoint:CGPointMake(0, 1)];
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
}



- (void)addShadowWithColor:(UIView*)view shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset {
    
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.shadowRadius = shadowRadius;
    
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    //设置缓存
    view.layer.shouldRasterize = YES;
    //设置抗锯齿边缘
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}



- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius rect:(CGRect)rect lineWidth:(CGFloat)lineWidth {

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineWidth = lineWidth;
    [self.layer addSublayer:maskLayer];
}


- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius rect:(CGRect)rect lineWidth:(CGFloat)lineWidth strokeColor:(UIColor*)strokeColor {

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = strokeColor.CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineWidth = lineWidth;
    [self.layer addSublayer:maskLayer];
}


- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius rect:(CGRect)rect lineWidth:(CGFloat)lineWidth strokeColor:(UIColor*)strokeColor  fillColor:(UIColor*)fillColor {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = strokeColor.CGColor;
    maskLayer.fillColor = fillColor.CGColor;
    maskLayer.lineWidth = lineWidth;
    //[self.layer addSublayer:maskLayer];
    [self.layer insertSublayer:maskLayer atIndex:0];
}



- (CAShapeLayer*)shapeLayerWithRect:(CGRect)rect lineWidth:(CGFloat)lineWidth strokeColor:(UIColor*)strokeColor  maskPath :(UIBezierPath *)maskPath {

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    if (maskPath) {
        maskLayer.path = maskPath.CGPath;
    }
    maskLayer.strokeColor = strokeColor.CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineWidth = lineWidth;
    return maskLayer;
}


@end
