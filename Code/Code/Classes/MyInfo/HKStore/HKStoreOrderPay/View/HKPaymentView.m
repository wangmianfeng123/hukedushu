//
//  HKPaymentView.m
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKPaymentView.h"


@interface HKPaymentView ()

/// 支付宝支付
@property (nonatomic,strong) UIImageView *aliPayIV;

@property (nonatomic,strong) UILabel *aliPayTitleLB;

@property (nonatomic,strong) UIButton *aliPayBtn;
/// 微信支付
@property (nonatomic,strong) UIImageView *weChatPayIV;

@property (nonatomic,strong) UILabel *weChatPayTitleLB;

@property (nonatomic,strong) UIButton *weChatBtn;

@end


@implementation HKPaymentView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self addSubview:self.aliPayIV];
    [self addSubview:self.aliPayTitleLB];
    [self addSubview:self.aliPayBtn];
    
    [self addSubview:self.weChatPayIV];
    [self addSubview:self.weChatPayTitleLB];
    [self addSubview:self.weChatBtn];
    
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [self.aliPayIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.aliPayTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliPayIV.mas_right).offset(15);
        make.centerY.equalTo(self.aliPayIV);
    }];
    
    [self.aliPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self.aliPayIV);
    }];
    
    [self.weChatPayIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aliPayIV);
        make.top.equalTo(self.aliPayIV.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.weChatPayTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weChatPayIV);
        make.left.equalTo(self.weChatPayIV.mas_right).offset(15);
    }];
    
    [self.weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weChatPayIV);
        make.right.equalTo(self).offset(-10);
    }];
}



- (UILabel*)aliPayTitleLB {
    if (!_aliPayTitleLB) {
        _aliPayTitleLB = [UILabel labelWithTitle:CGRectZero title:@"支付宝" titleColor:COLOR_27323F titleFont:@"14" titleAligment:0];
    }
    return _aliPayTitleLB;
}


- (UIImageView*)aliPayIV {
    if (!_aliPayIV) {
        _aliPayIV = [UIImageView new];
        _aliPayIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _aliPayIV;
}


- (UIButton*)aliPayBtn {
    if (!_aliPayBtn) {
        _aliPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_aliPayBtn addTarget:self action:@selector(aliPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_aliPayBtn setImage:imageName(@"cirlce_gray") forState:UIControlStateNormal];
        [_aliPayBtn setImage:imageName(@"right_green") forState:UIControlStateSelected];
        [_aliPayBtn setEnlargeEdgeWithTop:5 right:25 bottom:5 left:25];
    }
    return _aliPayBtn;
}


- (void)aliPayBtnClick:(UIButton*)btn {
    
    btn.selected = !btn.selected;
    self.payType = btn.selected ? HKPaymentViewPayType_AliPay : HKPaymentViewPayType_None;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hKPaymentView:payType:)]) {
        [self.delegate hKPaymentView:self payType:self.payType];
    }
}




- (UILabel*)weChatPayTitleLB {
    if (!_weChatPayTitleLB) {
        _weChatPayTitleLB = [UILabel labelWithTitle:CGRectZero title:@"微信" titleColor:COLOR_27323F titleFont:@"14" titleAligment:0];
    }
    return _weChatPayTitleLB;
}


- (UIImageView*)weChatPayIV {
    if (!_weChatPayIV) {
        _weChatPayIV = [UIImageView new];
        _weChatPayIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _weChatPayIV;
}


- (UIButton*)weChatBtn {
    if (!_weChatBtn) {
        _weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weChatBtn addTarget:self action:@selector(weChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_weChatBtn setImage:imageName(@"cirlce_gray") forState:UIControlStateNormal];
        [_weChatBtn setImage:imageName(@"right_green") forState:UIControlStateSelected];
        [_weChatBtn setEnlargeEdgeWithTop:5 right:25 bottom:5 left:25];
    }
    return _weChatBtn;
}



- (void)weChatBtnClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    
    self.payType = btn.selected ? HKPaymentViewPayType_WeChat : HKPaymentViewPayType_None;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hKPaymentView:payType:)]) {
        [self.delegate hKPaymentView:self payType:self.payType];
    }
}



- (void)setPayType:(HKPaymentViewPayType)payType {
    
    _payType = payType;
    self.aliPayBtn.selected = (payType == HKPaymentViewPayType_AliPay) ?YES : NO;
    self.weChatBtn.selected = (payType == HKPaymentViewPayType_WeChat) ?YES : NO;
}


@end
