//
//  HK.m
//  Code
//
//  Created by Ivan li on 2018/8/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAnimation.h"


#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@implementation HKAnimation



+ (void )shakeAnimation:(UIView *)target {
    
    [HKAnimation shakeAnimation:target repeatCount:0];
}




+ (void )shakeAnimation:(UIView *)target repeatCount:(CGFloat)repeatCount {
    
    // 抖动
    CAKeyframeAnimation *anima_r = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    //anima_r.values = @[@(angle2Rad(-6)),@(angle2Rad(6)),@(angle2Rad(-6))];
    anima_r.values = @[@(angle2Rad(-8)),@(angle2Rad(8)),@(angle2Rad(-8)),@(angle2Rad(8)),@(angle2Rad(-8))];
    
    anima_r.repeatCount = (repeatCount >0.0) ?repeatCount :MAXFLOAT;
    anima_r.duration = .3;
    anima_r.repeatDuration = 10;
    //保持最后的状态
    anima_r.removedOnCompletion = YES;
    //动画的填充模式
    anima_r.fillMode =kCAFillModeForwards;
    
    // 缩放
    CAKeyframeAnimation *anima_s = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anima_s.values = @[@(1),@(1.1),@(1.2),@(1.3),@(1.2),@(1.1),@(1)];
    anima_s.repeatCount = (repeatCount >0.0) ?repeatCount :MAXFLOAT;
    anima_s.duration = .8;
    anima_s.repeatDuration = 10;
    anima_s.removedOnCompletion = YES;
    anima_s.fillMode =kCAFillModeForwards;
    
    if (target) {
        [target.layer addAnimation:anima_r forKey:@"HKShake"];
        [target.layer addAnimation:anima_s forKey:@"HKShakeBig"];
    }
}


/**
 *移除抖动动画
 */
+ (void )removeShakeAnimation:(UIView *)target {
    if (target) {
        [target.layer removeAnimationForKey:@"HKShake"];
        [target.layer removeAnimationForKey:@"HKShakeBig"];
    }
}


@end



