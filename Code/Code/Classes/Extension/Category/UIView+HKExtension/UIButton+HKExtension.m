//
//  UIButton+HKExtension.m
//  Code
//
//  Created by yxma on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "UIButton+HKExtension.h"

@implementation UIButton (HKExtension)

- (void)buttonCommitAnimationWithAnimateDuration:(CFTimeInterval)duration Completion:(nonnull void (^)())completion
{
    [self.imageView.layer removeAllAnimations];
    CAKeyframeAnimation *animationZoomIn = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationZoomIn.duration = duration;
    animationZoomIn.beginTime = CACurrentMediaTime();
    animationZoomIn.autoreverses = NO;
    animationZoomIn.repeatCount = 1;
    animationZoomIn.values = @[@1.0, @2.0, @1.0];
    animationZoomIn.removedOnCompletion = NO;
    animationZoomIn.fillMode = kCAFillModeForwards;
    animationZoomIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.imageView.layer addAnimation:animationZoomIn forKey:@"click-scale-anim"];
    completion();
}

@end
