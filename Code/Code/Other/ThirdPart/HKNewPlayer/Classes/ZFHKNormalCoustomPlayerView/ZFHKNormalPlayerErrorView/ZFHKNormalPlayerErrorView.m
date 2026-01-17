//
//  ZFHKNormalPlayerErrorView.m
//  Code
//
//  Created by Ivan li on 2019/12/24.
//  Copyright © 2019 pg. All rights reserved.
//

#import "ZFHKNormalPlayerErrorView.h"
#import "UIView+SNFoundation.h"

@interface ZFHKNormalPlayerErrorView()

/// 
@property (nonatomic, strong) UILabel *tipLB;
/// 重试
@property (nonatomic, strong) UIButton *retryBtn;
/// 切换线路
@property (nonatomic, strong) UIButton *switchLineBtn;

@end


@implementation ZFHKNormalPlayerErrorView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self addSubview:self.tipLB];
    [self addSubview:self.retryBtn];
    [self addSubview:self.switchLineBtn];
    self.backgroundColor = COLOR_000000;
    self.alpha = 0.8;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-40);
    }];
    
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(60);
        make.top.equalTo(self.tipLB.mas_bottom).offset(34);
    }];
    
    [self.switchLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-60);
        make.top.equalTo(self.retryBtn);
    }];
}


- (UILabel*)tipLB {
    if (!_tipLB) {
        _tipLB = [UILabel labelWithTitle:CGRectZero title:@"非常抱歉，播放失败了" titleColor:[UIColor whiteColor] titleFont:@"14" titleAligment:NSTextAlignmentCenter];
    }
    return _tipLB;
}


- (UIButton*)retryBtn {
    if (!_retryBtn) {
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [_retryBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
        [_retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_retryBtn setHKEnlargeEdge:10];
        [_retryBtn setTitle:@"点击重试" forState:UIControlStateNormal];
        [_retryBtn setTitle:@"点击重试" forState:UIControlStateSelected];
        _retryBtn.titleLabel.font = HK_FONT_SYSTEM(13);
        _retryBtn.size = CGSizeMake(86, 27);
        
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(86, 27) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        
        [_retryBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_retryBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [_retryBtn setRoundedCorners:UIRectCornerAllCorners radius:13.5];
    }
    return _retryBtn;
}


- (void)retryBtnClick:(UIButton*)btn {
    
    self.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zFHKNormalPlayerErrorView:retryBtn:)]) {
        [self.delegate zFHKNormalPlayerErrorView:self retryBtn:btn];
    }
}



- (UIButton*)switchLineBtn {
    if (!_switchLineBtn) {
        _switchLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchLineBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [_switchLineBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
        [_switchLineBtn addTarget:self action:@selector(switchLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_switchLineBtn setHKEnlargeEdge:10];
        [_switchLineBtn setTitle:@"切换线路" forState:UIControlStateNormal];
        [_switchLineBtn setTitle:@"切换线路" forState:UIControlStateSelected];
        _switchLineBtn.titleLabel.font = HK_FONT_SYSTEM(13);
        _switchLineBtn.size = CGSizeMake(86, 27);
        
        UIColor *color = [UIColor colorWithHexString:@"#32333D"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(86, 27) gradientColors:@[(id)color,(id)color,(id)color] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        
        [_switchLineBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_switchLineBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [_switchLineBtn setRoundedCorners:UIRectCornerAllCorners radius:13.5];
        //_switchLineBtn.layer.cornerRadius = 13.5;
        //_switchLineBtn.clipsToBounds = YES;
    }
    return _switchLineBtn;
}



- (void)switchLineBtnClick:(UIButton*)btn {
    self.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zFHKNormalPlayerErrorView:switchLineBtn:)]) {
        [self.delegate zFHKNormalPlayerErrorView:self switchLineBtn:btn];
    }
}


- (void)setHidden:(BOOL)hidden {
    if (hidden == NO) {
        self.alpha = 0.8;
    }else{
        self.alpha = 0;
    }
}


@end
