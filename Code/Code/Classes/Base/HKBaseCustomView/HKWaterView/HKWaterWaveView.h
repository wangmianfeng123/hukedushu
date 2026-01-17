//
//  KYWaterWaveView.h
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKEnumerate.h"

//typedef NS_ENUM(NSInteger, waveType) {
//    waveTypeCosf = 0,
//    waveTypeSinf = 1,
//};



@interface HKWaterWaveView : UIView


- (id)initWithFrame:(CGRect)frame type:(waveType)type;
/**
 *  The speed of wave 波浪的快慢
 */
@property (nonatomic,assign)CGFloat waveSpeed;

/**
 *  The amplitude of wave 波浪的震荡幅度
 */
@property (nonatomic,assign)CGFloat waveAmplitude; // 波浪的震荡幅度

/**
 *  Start waving
 */
- (void)waveWithColor:(UIColor *)waveColor;

/**
 *  Stop waving
 */
- (void)stop;

@end












////
////  KYWaterWaveView.m
////  KYWaterWaveAnimation
////
////  Created by Kitten Yang on 3/16/15.
////  Copyright (c) 2015 Kitten Yang. All rights reserved.
////
//
//#define pathPadding 30
//
//#import "KYWaterWaveView.h"
//
//
//
//@interface KYWaterWaveView()<UICollisionBehaviorDelegate>
//
//
//@end
//
//@implementation KYWaterWaveView{
//    CALayer *l;
//
//    BOOL fishFirstColl;
//    CGFloat waterWaveHeight;
//    CGFloat waterWaveWidth;
//    CGFloat offsetX;
//
//    CADisplayLink *waveDisplaylink;
//    CAShapeLayer  *waveLayer;
//    UIBezierPath *waveBoundaryPath;
//    UIDynamicAnimator *animator;
//    UIPushBehavior *push;
//    UIGravityBehavior * grav;
//    UICollisionBehavior *coll;
//    waveType _type;
//}
//
//- (id)initWithFrame:(CGRect)frame type:(waveType)type{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.layer.masksToBounds  = YES;
//        waterWaveHeight = frame.size.height / 6;
//        waterWaveWidth  = frame.size.width;
//        _type = type;
//    }
//
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.layer.masksToBounds  = YES;
//        waterWaveHeight = self.frame.size.height;
//        waterWaveWidth  = self.frame.size.width;
//
//    }
//    return self;
//}
//
//#pragma mark - public
//- (void)waveWithColor:(UIColor *)waveColor {
//    waveBoundaryPath = [UIBezierPath bezierPath];
//
//    waveLayer = [CAShapeLayer layer];
//    waveLayer.fillColor = waveColor.CGColor;//[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
//    [self.layer addSublayer:waveLayer];
//    waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
//    [waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//
//
//}
//
//- (void)stop {
//    [waveDisplaylink invalidate];
//
//    waveDisplaylink = nil;
//
//    [self removeFromSuperview];
//}
//
//#pragma mark - helper
//- (void)getCurrentWave:(CADisplayLink *)displayLink {
//    [coll removeAllBoundaries];
//    offsetX += self.waveSpeed;
//    waveBoundaryPath = [self getgetCurrentWavePath];
//    waveLayer.path = waveBoundaryPath.CGPath;
//
//    [coll addBoundaryWithIdentifier:@"waveBoundary" forPath:waveBoundaryPath];
//}
//
//- (UIBezierPath *)getgetCurrentWavePath {
//    UIBezierPath *p = [UIBezierPath bezierPath];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, nil, 0, waterWaveHeight);
//    CGFloat y = 0.0f;
//    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
//
//        if (_type == waveTypeCosf) {
//            y = self.waveAmplitude* cosf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + waterWaveHeight;
//
//        }else{
//            y = self.waveAmplitude* sinf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + waterWaveHeight;
//
//        }
//        CGPathAddLineToPoint(path, nil, x, y);
//    }
//
//    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
//    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
//    CGPathCloseSubpath(path);
//
//    p.CGPath = path;
//    CGPathRelease(path);
//    return p;
//}
//
//
//@end

