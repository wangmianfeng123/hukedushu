//
//  UIView+SNFoundation.h
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SNFoundation)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

- (void)cornerRadius:(CGFloat)size;

- (void)removeAllSubviews;

- (UIViewController *)viewController;

/**
 设四个圆角

 @param corners 那几个角
 @param radius 圆角度数
 */
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

/** 阴影设置 */
- (void)addShadowWithColor:(UIColor *)color alpha:(CGFloat)alpha radius:(CGFloat)radius offset:(CGSize)offset;


/**
 渐变背景
 
 数组类型 CGColorRef
 @param colorArr 数组类型 CGColorRef
 */
- (void)gradientShadowWithColor:(NSArray*)colorArr;

/**
 获取最顶层 Window

 @return
 */
+ (UIWindow *)frontWindow;

/** 阴影设置 */
- (void)addShadowWithColor:(UIView*)view shadowColor:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset;

/**
设四个圆角

@param corners 那几个角
@param radius 圆角度数
@param rect CGRect
@param lineWidth lineWidth
*/
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius rect:(CGRect)rect lineWidth:(CGFloat)lineWidth;



/**
设边框圆角

@param corners 那几个角
@param radius 圆角度数
@param rect CGRect
@param lineWidth lineWidth
  @param strokeColor
*/
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius rect:(CGRect)rect lineWidth:(CGFloat)lineWidth strokeColor:(UIColor*)strokeColor;


- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius rect:(CGRect)rect lineWidth:(CGFloat)lineWidth strokeColor:(UIColor*)strokeColor  fillColor:(UIColor*)fillColor;


- (CAShapeLayer*)shapeLayerWithRect:(CGRect)rect lineWidth:(CGFloat)lineWidth strokeColor:(UIColor*)strokeColor  maskPath :(UIBezierPath *)maskPath;

@end
