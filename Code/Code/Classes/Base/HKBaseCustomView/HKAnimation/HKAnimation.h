//
//  HK.h
//  Code
//
//  Created by Ivan li on 2018/8/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKAnimation : NSObject


/**
 * 抖动动画
 *
 *target 目标控件
 */
+ (void )shakeAnimation:(UIView *)target;



/**
 *移除抖动动画
 */
+ (void )removeShakeAnimation:(UIView *)target;



/**
 * 抖动动画
 *
 *target 目标控件
 *
 *repeatCount  重复次数
 *
 */
+ (void )shakeAnimation:(UIView *)target repeatCount:(CGFloat)repeatCount;

@end




