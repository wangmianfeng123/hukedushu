
//
//  HKPlayerAutoPlayConfigView.m
//  Code
//
//  Created by Ivan li on 2018/9/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayerAutoPlayConfigView.h"
#import "HKPlayerAutoPlayBaseView.h"


@interface HKPlayerAutoPlayConfigView()<UIGestureRecognizerDelegate,HKPlayerAutoPlayBaseViewDelegate>

@property (nonatomic,strong) HKPlayerAutoPlayBaseView *configBgView;

@end


@implementation HKPlayerAutoPlayConfigView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {

    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.configBgView];
    [self makeConstraints];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    //NSString *str = NSStringFromClass([touch.view class]);
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UISwitch class]]) {
        return NO;
    }
    
    if ([touch.view isKindOfClass:[HKPlayerAutoPlayBaseView class]]) {
        return NO;
    }
    return YES;
}



- (void)tapAction:(UIGestureRecognizer *)ges {
    [self removeView];
}


- (void)makeConstraints {
    
    [self.configBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(@200);
    }];
}


- (HKPlayerAutoPlayBaseView*)configBgView {
    
    if (!_configBgView) {
        _configBgView = [HKPlayerAutoPlayBaseView new];
        _configBgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        _configBgView.delegate = self;
    }
    return _configBgView;
}



#pragma mark --- HKPlayerAutoPlayBaseView delegate
- (void)hkPlayerRateBaseView:(NSInteger)state {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerRateConfigView:state:)]) {
        // 1 - 关闭 0 -开启
        [self.delegate playerRateConfigView:self state:state];
    }
}


- (void)hkPlayerRateBaseView:(UIView *)view feedBack:(NSString *)feedBack {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerRateConfigView:feedBack:)]) {
        [self.delegate playerRateConfigView:self feedBack:feedBack];
    }
}



/** 销毁 */
- (void)removeView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(removePlayerAutoPlayConfigView:)]) {
            [self.delegate removePlayerAutoPlayConfigView:self];
        }
    }];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//}



@end







