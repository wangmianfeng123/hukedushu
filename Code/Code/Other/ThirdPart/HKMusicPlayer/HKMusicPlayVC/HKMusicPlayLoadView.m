
//
//  HKMusicPlayLoadView.m
//  Code
//
//  Created by Ivan li on 2018/4/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMusicPlayLoadView.h"

@implementation HKMusicPlayLoadView



- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgIV];
        [self addSubview:self.loadIV];
    }
    return self;
}


- (void)dealloc {
    
    [self releaseTimer];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.loadIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}



// 图片旋转
- (void)startLoading:(BOOL)animated {
    
//    if (animated) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.loadIV.transform = CGAffineTransformIdentity;
//        }];
//    }else {
//        self.loadIV.transform = CGAffineTransformIdentity;
//    }
    
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animation)];
        // 加入到主循环中
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }else{
        self.displayLink.paused = NO;
    }
}

// 图片停止旋转
- (void)pausedLoading:(BOOL)animated {
    
//    if (animated) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.loadIV.transform = CGAffineTransformMakeRotation(-M_PI_2 / 3);
//        }];
//    }else {
//        self.loadIV.transform = CGAffineTransformMakeRotation(-M_PI_2 / 3);
//    }
    //TTVIEW_RELEASE_SAFELY(self.loadIV);
    //TTVIEW_RELEASE_SAFELY(self.bgIV);
    //[self removeView];
    
    //[self releaseTimer];
    
    if (self.displayLink) {
        self.displayLink.paused = YES;
    }
}




// 图片旋转
- (void)animation {
    self.loadIV.transform = CGAffineTransformRotate(self.loadIV.transform, M_PI_4 / 10);
}


- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}


- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        _bgIV.image = [UIImage imageNamed:@"hkplayer_loading_bg"];
    }
    return _bgIV;
}


- (UIImageView *)loadIV {
    if (!_loadIV) {
        _loadIV = [UIImageView new];
        _loadIV.image = [UIImage imageNamed:@"hkplayer_loading"];
    }
    return _loadIV;
}


/** 销毁定时*/
- (void)releaseTimer {
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}



@end

