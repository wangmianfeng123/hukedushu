


//
//  HKGiftWaterWaveView.m
//  Code
//
//  Created by Ivan li on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKGiftWaterWaveView.h"

#define COLOR_FEFF3A  [UIColor colorWithHexString:@"#FEFF3A"]

#define COLOR_FFE805  [[UIColor colorWithHexString:@"#FFE805"]colorWithAlphaComponent:.9]

#define COLOR_FFD406  [UIColor colorWithHexString:@"#FFD406"]

#define COLOR_D1B115  [UIColor colorWithHexString:@"#D1B115"]





@interface HKGiftWaterWaveView()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) CAShapeLayer *wave1Layer;

@property (nonatomic, strong) CAShapeLayer *wave2Layer;

@property (nonatomic, strong) CAShapeLayer *wave3Layer;


@property (nonatomic, strong) UIBezierPath *waveBoundaryPath1;

@property (nonatomic, strong) UIBezierPath *waveBoundaryPath2;

@property (nonatomic, strong) UIBezierPath *waveBoundaryPath3;


@end

@implementation HKGiftWaterWaveView{
    
    BOOL fishFirstColl;
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;
    
    CADisplayLink *waveDisplaylink;
    
    UIDynamicAnimator *animator;
    UIPushBehavior *push;
    UIGravityBehavior * grav;
    UICollisionBehavior *coll;
    waveType _type;
}

- (void)dealloc {
    
}


- (id)initWithFrame:(CGRect)frame type:(waveType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_FFD406;
        self.layer.masksToBounds  = YES;
        waterWaveHeight = frame.size.height /5;
        waterWaveWidth  = frame.size.width;
        _type = type;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.masksToBounds  = YES;
        waterWaveHeight = self.frame.size.height;
        waterWaveWidth  = self.frame.size.width;
    }
    return self;
}




- (CAShapeLayer *)wave1Layer{
    
    if (!_wave1Layer) {
        _wave1Layer = [CAShapeLayer layer];
        [self.layer addSublayer:_wave1Layer];
    }
    return _wave1Layer;
}


- (CAShapeLayer *)wave2Layer{
    
    if (!_wave2Layer) {
        _wave2Layer = [CAShapeLayer layer];
        [self.layer addSublayer:_wave2Layer];
    }
    return _wave2Layer;
}


- (CAShapeLayer *)wave3Layer{
    if (!_wave3Layer) {
        _wave3Layer = [CAShapeLayer layer];
        [self.layer addSublayer:_wave3Layer];
    }
    return _wave3Layer;
}



- (UIBezierPath*)waveBoundaryPath1 {
    if (!_waveBoundaryPath1) {
        _waveBoundaryPath1 = [UIBezierPath bezierPath];
    }
    return _waveBoundaryPath1;
}


- (UIBezierPath*)waveBoundaryPath2 {
    if (!_waveBoundaryPath2) {
        _waveBoundaryPath2 = [UIBezierPath bezierPath];
    }
    return _waveBoundaryPath2;
}


- (UIBezierPath*)waveBoundaryPath3 {
    if (!_waveBoundaryPath3) {
        _waveBoundaryPath3 = [UIBezierPath bezierPath];
    }
    return _waveBoundaryPath3;
}


#pragma mark - public
- (void)waveWithColor:(UIColor *)waveColor {
    
    self.wave1Layer.fillColor = [[COLOR_D1B115 colorWithAlphaComponent:0.5] CGColor];
    
    self.wave2Layer.fillColor = [COLOR_FFE805 CGColor];
    
    self.wave3Layer.fillColor = [COLOR_FEFF3A CGColor];
    
    waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}


- (void)stop {
    
    if (waveDisplaylink) {
        [waveDisplaylink invalidate];
        waveDisplaylink = nil;
        [self removeFromSuperview];
    }
}


#pragma mark - helper
- (void)getCurrentWave:(CADisplayLink *)displayLink {
    //[coll removeAllBoundaries];
    offsetX += self.waveSpeed;
    
    self.waveBoundaryPath3 = [self getCurrentWavePath:80 offX:0 waveH:5];
    self.wave3Layer.path = self.waveBoundaryPath3.CGPath;
    
    self.waveBoundaryPath2 = [self getCurrentWavePath_cosf:150];
    self.wave2Layer.path = self.waveBoundaryPath2.CGPath;
    
    self.waveBoundaryPath1 = [self getCurrentWavePath_fillBottom:230 waveH:10]; //[self getCurrentWavePath:280 offX:0 waveH:10];
    self.wave1Layer.path = self.waveBoundaryPath1.CGPath;
    
    //[coll addBoundaryWithIdentifier:@"waveBoundary" forPath:waveBoundaryPath];
}





/**
 
 @param height 浪高
 @param offX  x 偏移
 @param waveH  增加 额外 浪高
 @return
 */
- (UIBezierPath *)getCurrentWavePath:(CGFloat)height  offX:(CGFloat)offX  waveH:(CGFloat)waveH{
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat H = height;
    CGPathMoveToPoint(path, nil, 0, self.frame.size.height);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        
        if (_type == waveTypeCosf) {
            //余弦
            y = (self.waveAmplitude + waveH) * cosf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + H;
            
        }else{
            //正弦
            y = (self.waveAmplitude + waveH) * sinf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + H;
        }
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, 0);
    CGPathAddLineToPoint(path, nil, 0, 0);
    
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    CGPathRelease(path);
    return p;
}




/**
 * 余弦
 */
- (UIBezierPath *)getCurrentWavePath_cosf:(CGFloat)height {
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat H = height;
    CGPathMoveToPoint(path, nil, 0, self.frame.size.height);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        
        y = self.waveAmplitude* cosf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + H;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, 0);
    CGPathAddLineToPoint(path, nil, 0, 0);
    
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    CGPathRelease(path);
    return p;
}





- (UIBezierPath *)getCurrentWavePath_fillBottom:(CGFloat)height  waveH:(CGFloat)waveH {
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat Height = height ;
    
    CGPathMoveToPoint(path, nil, 0, Height);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        
        if (_type == waveTypeCosf) {
            y = (self.waveAmplitude + waveH)* cosf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + Height;
        }else{
            y = (self.waveAmplitude + waveH)* sinf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + Height;
        }
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    CGPathRelease(path);
    return p;
}





@end




