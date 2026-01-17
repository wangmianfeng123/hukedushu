//
//  HKNewUserThirdView.m
//  Code
//
//  Created by Ivan li on 2018/8/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKNewUserThirdView.h"
#import "HKNewUserCouponView.h"
#import "HKTagBtnTool.h"
#import "HKHomeGiftModel.h"


@implementation HKNewUserThirdView


- (void)createUI {
    [super createUI];
    
    [self.waterBgView addSubview:self.couponBgView];
    //[self.couponBgView addSubview:self.couponView];
    
    [self.couponBgView addSubview:self.giftTagIV];
    [self.couponBgView addSubview:self.giftTagLB];
    [self.couponBgView addSubview:self.tagLB];
    
    [self.couponBgView addSubview:self.moneyIV];
    [self.couponBgView addSubview:self.moneyLB];
    
    [self addSubview:self.headIV];
    
    [self.tagBtnTool setTagTitle:@"「签到」也可领取虎课币哟~" fontSize:12];
    //self.tagBtnTool.tagTitle = @"「签到」也可领取虎课币哟~";
    self.giftTagTitle = @"第三天恭喜获得";
    self.bottomTagTitle = @"可在虎课币商城使用";
}


- (void)setModel:(HKHomeGiftModel *)model {
    _model = model;
    if (!isEmpty(model.gold)) {
        self.moneyLB.text = [NSString stringWithFormat:@"%@虎课币",model.gold];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    [super makeConstraints];
    
    [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.couponBgView.mas_top).offset(-PADDING_15);
        make.centerX.equalTo(self.couponBgView);
    }];
    
    [self.couponBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.waterBgView).offset(-PADDING_30);
        make.left.equalTo(self.waterBgView).offset(PADDING_30);
        make.height.mas_equalTo(396/2);
    }];
    
    
    [self.giftTagIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponBgView).offset(22);
        make.centerX.equalTo(self.couponBgView);
    }];
    
    [self.giftTagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftTagIV.mas_bottom).offset(3);
        make.right.left.equalTo(self.couponBgView);
    }];
    
    [self.moneyIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftTagLB.mas_bottom).offset(17);
        make.centerX.equalTo(self.couponBgView);
    }];
    
    [self.moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyIV.mas_bottom).offset(PADDING_5);
        make.centerX.equalTo(self.couponBgView);
    }];
    
    [self.tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLB.mas_bottom).offset(3);
        make.right.left.equalTo(self.couponBgView);
    }];
}



- (UIImageView*)moneyIV {
    if (!_moneyIV) {
        _moneyIV = [UIImageView new];
        _moneyIV.contentMode = UIViewContentModeScaleAspectFit;
        _moneyIV.image = imageName(@"ic_money_v2_3");
    }
    return _moneyIV;
}


- (UILabel*)moneyLB {
    if (!_moneyLB) {
        _moneyLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor colorWithHexString:@"#FF9200"] titleFont:nil titleAligment:NSTextAlignmentCenter];
        _moneyLB.font = HK_FONT_SYSTEM_WEIGHT(19, UIFontWeightSemibold);
    }
    return _moneyLB;
}


- (UIImageView*)headIV {
    
    if (!_headIV) {
        _headIV = [UIImageView new];
        _headIV.image = imageName( @"hk_gift_third");
        _headIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headIV;
}

@end





