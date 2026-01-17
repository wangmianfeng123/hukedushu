//
//  HKListeningLoadingView.m
//  Code
//
//  Created by Ivan li on 2019/7/22.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKListeningLoadingView.h"

@implementation HKListeningLoadingView



- (instancetype)init {

    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgIV];
        [self addSubview:self.loadIV];

        [self makeConstraints];
    }
    return self;
}


- (void)dealloc {
    [self pausedLoading:YES];
    NSLog(@"-- HKListeningLoadingView");
}


- (void)makeConstraints {
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    [self.loadIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}


// 图片旋转
- (void)startLoading:(BOOL)animated {
    // 取消动画
    [self.loadIV.layer removeAllAnimations];
    self.hidden = NO;
    self.isPause = NO;
    [self rotateImageView];
}


// 图片停止旋转
- (void)pausedLoading:(BOOL)animated {

    self.hidden = YES;
    self.isPause = YES;
}



// 图片旋转
- (void)rotateImageView {
    // 一秒钟旋转几圈
    CGFloat circleByOneSecond = 2;
    // 执行动画
    [UIView animateWithDuration:1.f / circleByOneSecond
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
            if(!_isPause) {
                self.loadIV.transform = CGAffineTransformRotate(self.loadIV.transform, M_PI_2);
            }
    }completion:^(BOOL finished){
        if(finished){
            if(!_isPause) {
                self.hidden = NO;
                [self rotateImageView];
            }
        }else{
            self.hidden = YES;
        }
    }];
}



- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        _bgIV.userInteractionEnabled = YES;
    }
    return _bgIV;
}


- (UIImageView *)loadIV {
    if (!_loadIV) {
        _loadIV = [UIImageView new];
        _loadIV.image = [UIImage imageNamed:@"ic_loading_v2_14"];
        _loadIV.userInteractionEnabled = YES;
    }
    return _loadIV;
}


/** 销毁定时*/
- (void)invalidateTimer {

    [self pausedLoading:YES];
}



@end
