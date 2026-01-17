//
//  HKStoreOrderPayView.m
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStoreOrderPayBottomView.h"


@implementation HKStoreOrderPayBottomView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self addSubview:self.priceLB];
    [self addSubview:self.payBtn];
    
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.left.equalTo(self);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-60);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.right.equalTo(self);
    }];
}


- (UILabel*)priceLB {
    if (!_priceLB) {
        _priceLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"16" titleAligment:0];
    }
    return _priceLB;
}


- (UIButton*)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitleColor:COLOR_27323F forState:UIControlStateNormal];
        [_payBtn setTitleColor:COLOR_27323F forState:UIControlStateHighlighted];
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payBtn setTitle:@"立即支付" forState:UIControlStateHighlighted];
        _payBtn.titleLabel.font = HK_FONT_SYSTEM(16);
        [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}



- (void)payBtnClick:(UIButton*)btn {
    
}


@end
