//
//  MJChiBaoZiHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/12.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "HKMiaoMiaoHeader.h"

@implementation HKMiaoMiaoHeader
#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
//    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=35; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mao_%zd", i]];
//        [idleImages addObject:image];
//    }
//     [self setImages:idleImages forState:MJRefreshStateIdle];
//
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 35; i<= 61; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mao_%zd", i]];
//        [refreshingImages addObject:image];
//    }
//
//    for (NSUInteger i = 1; i<= 35; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"mao_%zd", i]];
//        [refreshingImages addObject:image];
//    }
//
////    [self setImages:refreshingImages forState:MJRefreshStatePulling];
//
//    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages duration:2.0 forState:MJRefreshStateRefreshing];
    
    [self addSubview:self.loadAnimationView];
    [self.loadAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    // 设置 动画模式为底部
    self.gifView.contentMode = UIViewContentModeBottom;
}


- (void)setState:(MJRefreshState)state {
    [super setState:state];
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        [self.loadAnimationView play];
    } else if (state == MJRefreshStateIdle) {
        [self.loadAnimationView stop];
    }
}



- (LOTAnimationView*)loadAnimationView {
    if (!_loadAnimationView) {
        _loadAnimationView = [LOTAnimationView animationNamed:@"refreshGif.json"];
        _loadAnimationView.loopAnimation = YES;
    }
    return _loadAnimationView;
}

@end
