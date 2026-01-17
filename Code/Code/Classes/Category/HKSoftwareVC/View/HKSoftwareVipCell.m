//
//  HKSoftwareVipCell.m
//  Code
//
//  Created by Ivan li on 2018/3/31.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareVipCell.h"


@interface HKSoftwareVipCell ()

/** 背景图片 */
@property (strong, nonatomic)  UIImageView *bgIV;
/** VIP 标签 图片 */
@property (strong, nonatomic)  UIImageView *avator;
/** VIP 标题 */
@property (strong, nonatomic)  UILabel *nameLB;
/** VIP 介绍 */
@property (strong, nonatomic)  UILabel *detailLB;
/** 开通 vip Btn */
@property (strong, nonatomic)  UIButton *openVipBtn;


@end

@implementation HKSoftwareVipCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.bgIV];
    [self.bgIV addSubview:self.avator];
    
    [self.bgIV addSubview:self.detailLB];
    [self.bgIV addSubview:self.nameLB];
    [self.bgIV addSubview:self.openVipBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeLayout];
}

- (void)makeLayout {
    [_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.right.equalTo(self.contentView).offset(-PADDING_15);
        make.top.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
    
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIV).offset(PADDING_20);
        make.top.equalTo(self.bgIV).offset(18);
    }];
    
    [_avator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB.mas_right).offset(2);
        make.top.equalTo(self.nameLB.mas_top).offset(2);
    }];
    
    [_detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.right.equalTo(self.bgIV);
        make.top.equalTo(self.nameLB.mas_bottom).offset(PADDING_5);
    }];
    
    [_openVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgIV).offset(-PADDING_20);
        make.centerY.equalTo(self.nameLB);
        //make.size.mas_equalTo(CGSizeMake(75, 25));
    }];
    
}


- (UIImageView*)bgIV {
    if (!_bgIV) {
        _bgIV = [UIImageView new];
        _bgIV.image = imageName(@"orange_mask");
        _bgIV.userInteractionEnabled = YES;
    }
    return _bgIV;
}

- (UIImageView*)avator {
    if (!_avator) {
        _avator = [UIImageView new];
        _avator.image = imageName(@"medals_white");
        _avator.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avator;
}



- (UILabel*)detailLB {
    if (!_detailLB) {
        _detailLB = [UILabel new];
        _detailLB.font = HK_FONT_SYSTEM(12);
        _detailLB.textColor = COLOR_ffffff;
        _detailLB.text = @"零基础学习100+软件工具，不断更新中";
    }
    return _detailLB;
}

- (UILabel*)nameLB {
    if (!_nameLB) {
        _nameLB = [UILabel new];
        _nameLB.font = HK_FONT_SYSTEM(17);
        _nameLB.textColor = COLOR_ffffff;
        _nameLB.text = @"软件入门SVIP";
    }
    return _nameLB;
}


- (UIButton*)openVipBtn {
    if (!_openVipBtn) {
        _openVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_openVipBtn.titleLabel.font = HK_FONT_SYSTEM(12);
        //_openVipBtn.layer.cornerRadius = 25/2;
        //_openVipBtn.clipsToBounds = YES;
        //[_openVipBtn setTitleColor:COLOR_FF7820 forState:UIControlStateNormal];
        //[_openVipBtn setTitle:@"去开通>" forState:UIControlStateNormal];
        [_openVipBtn setImage:imageName(@"open_vip_bg") forState:UIControlStateNormal];
        [_openVipBtn setImage:imageName(@"open_vip_bg") forState:UIControlStateHighlighted];
        _openVipBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_openVipBtn addTarget:self action:@selector(openVipClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openVipBtn;
}



- (void)openVipClicked:(UIButton*)btn {
    self.openVipBlock ?self.openVipBlock(@"dd") : nil;
}




- (void)setVipDesc:(NSString *)vipDesc {
    _vipDesc = vipDesc;
    self.detailLB.text = vipDesc;
}




@end



