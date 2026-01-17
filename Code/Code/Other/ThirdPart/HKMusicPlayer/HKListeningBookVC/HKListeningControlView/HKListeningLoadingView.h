//
//  HKListeningLoadingView.h
//  Code
//
//  Created by Ivan li on 2019/7/22.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKListeningLoadingView : UIView

@property (nonatomic, strong) UIImageView *bgIV;

@property (nonatomic, strong) UIImageView *loadIV;
///是否暂停
@property (nonatomic, assign) BOOL isPause;

- (void)startLoading:(BOOL)animated;

- (void)pausedLoading:(BOOL)animated;

- (void)invalidateTimer;

@end

NS_ASSUME_NONNULL_END



//
////
////  HKListeningLoadingView.m
////  Code
////
////  Created by Ivan li on 2019/7/22.
////  Copyright © 2019 pg. All rights reserved.
////
//
//#import "HKListeningLoadingView.h"
//#import "UIImageView+Rotate.h"
//
//@implementation HKListeningLoadingView
//
//
//
//- (instancetype)init {
//    
//    if (self = [super init]) {
//        self.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.bgIV];
//        [self addSubview:self.loadIV];
//        
//        [self makeConstraints];
//    }
//    return self;
//}
//
//
//- (void)dealloc {
//    [self invalidateTimer];
//}
//
//
//- (void)makeConstraints {
//    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(@0);
//    }];
//
//    [self.loadIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(@0);
//    }];
//}
//
//
//// 图片旋转
//- (void)startLoading:(BOOL)animated {
//    if (!self.displayLink) {
//        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animation)];
//        // 加入到主循环中
//        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    }else{
//        self.displayLink.paused = NO;
//    }
//    self.hidden = NO;
//    
//    [self rotateImageView];
//}
//
//// 图片停止旋转
//- (void)pausedLoading:(BOOL)animated {
//    
//    if (self.displayLink) {
//        self.displayLink.paused = YES;
//    }
//    self.hidden = YES;
//}
//
//
//// 图片旋转
//- (void)animation {
//    self.loadIV.transform = CGAffineTransformRotate(self.loadIV.transform, M_PI_4 / 10);
//    
//}
//
//- (void)rotateImageView {
//    // 一秒钟旋转几圈
//    CGFloat circleByOneSecond = 2;
//    // 执行动画
//    [UIView animateWithDuration:1.f / circleByOneSecond
//                          delay:0
//                        options:UIViewAnimationOptionRepeat| UIViewAnimationOptionCurveLinear
//                     animations:^{
//        self.loadIV.transform = CGAffineTransformRotate(self.loadIV.transform, M_PI_2);
//    }
//                     completion:^(BOOL finished){
//        [self rotateImageView];
//    }];
//}
//
//
//
//- (UIImageView *)bgIV {
//    if (!_bgIV) {
//        _bgIV = [UIImageView new];
//        _bgIV.userInteractionEnabled = YES;
//        //_bgIV.image = [UIImage imageNamed:@"hkplayer_loading_bg"];
//    }
//    return _bgIV;
//}
//
//
//- (UIImageView *)loadIV {
//    if (!_loadIV) {
//        _loadIV = [UIImageView new];
//        _loadIV.image = [UIImage imageNamed:@"ic_loading_v2_14"];
//        _loadIV.userInteractionEnabled = YES;
//    }
//    return _loadIV;
//}
//
//
///** 销毁定时*/
//- (void)invalidateTimer {
//    if (self.displayLink) {
//        [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//        [self.displayLink invalidate];
//        self.displayLink = nil;
//    }
//}
//
//
//
//@end
//
