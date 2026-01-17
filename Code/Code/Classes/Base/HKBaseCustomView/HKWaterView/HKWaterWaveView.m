//
//  KYWaterWaveView.m
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define pathPadding 30

#import "HKWaterWaveView.h"


#define COLOR_FEFF3A  [UIColor colorWithHexString:@"#FEFF3A"]

#define COLOR_FFE70A  [UIColor colorWithHexString:@"#FFE70A"]



@interface HKWaterWaveView()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) CAShapeLayer *wave1Layer;

@property (nonatomic, strong) CAShapeLayer *wave2Layer;

@property (nonatomic, strong) CAShapeLayer *wave3Layer;


@property (nonatomic, strong) UIBezierPath *waveBoundaryPath1;

@property (nonatomic, strong) UIBezierPath *waveBoundaryPath2;

@property (nonatomic, strong) UIBezierPath *waveBoundaryPath3;


@end

@implementation HKWaterWaveView{
    
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
        self.backgroundColor = [UIColor whiteColor];
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
        self.backgroundColor = [UIColor clearColor];
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
    
    self.wave1Layer.fillColor = [[COLOR_FFE70A colorWithAlphaComponent:.5] CGColor];
    
    self.wave2Layer.fillColor = [[COLOR_FFE70A colorWithAlphaComponent:.5] CGColor];
    
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
    
    self.waveBoundaryPath1 = [self getCurrentWavePath:150 offX:0 waveH:0];
    self.wave1Layer.path = self.waveBoundaryPath1.CGPath;
    
    self.waveBoundaryPath2 = [self getCurrentWavePath_cosf:150];
    self.wave2Layer.path = self.waveBoundaryPath2.CGPath;
    
    self.waveBoundaryPath3 = [self getCurrentWavePath:80 offX:0 waveH:5];
    self.wave3Layer.path = self.waveBoundaryPath3.CGPath;
    
    //[coll addBoundaryWithIdentifier:@"waveBoundary" forPath:waveBoundaryPath];
}



- (UIBezierPath *)getCurrentWavePath:(CGFloat)height  offX:(CGFloat)offX  waveH:(CGFloat)waveH{

    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat H = height;
    CGPathMoveToPoint(path, nil, 0, self.frame.size.height);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        
        if (_type == waveTypeCosf) {
            y = (self.waveAmplitude + waveH) * cosf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + H;
            
        }else{
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





- (UIBezierPath *)getCurrentWavePath_fillBottom:(CGFloat)height {
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat Height = height ;//waterWaveHeight;
    
    CGPathMoveToPoint(path, nil, 0, Height);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        
        if (_type == waveTypeCosf) {
            y = self.waveAmplitude* cosf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + Height;
        }else{
            y = self.waveAmplitude* sinf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + Height;
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




