//
//  HKHomeVipHeader.m
//  Code
//
//  Created by ivan on 2020/6/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeVipHeader.h"


@implementation HKHomeVipHeader


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    if (self) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.grayLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.moreBtn];
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self makeConstraints];
}


- (void)makeConstraints {
    [self.grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayLabel.mas_bottom).offset(18);
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-18);
        make.width.mas_equalTo(2);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(4);
        make.left.equalTo(self).offset(PADDING_15);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
    }];
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:COLOR_27323F_EFEFF6];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19: 18 weight:UIFontWeightBold];
        //_titleLabel.text = @"虎课读书";
    }
    return _titleLabel;
}

- (UILabel*)grayLabel {
    if (!_grayLabel) {
        _grayLabel  = [UILabel new];
        _grayLabel.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _grayLabel;
}


- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel  = [UILabel new];
        _tagLabel.backgroundColor = COLOR_333333;
        _tagLabel.hidden = YES;
    }
    return _tagLabel;
}



- (UIButton*)moreBtn {
    
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:HKColorFromHex(0xA8ABBE, 1.0) forState:UIControlStateNormal];
        [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13]];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
        _moreBtn.width = PADDING_20*6;
        [_moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    }
    return _moreBtn;
}



- (void)btnClick:(id)sender {
    if (self.moreBtnClickBlock) {
        self.moreBtnClickBlock();
    }
}



- (void)setMoreBtnTitle:(NSString*)title  headerTitle:(NSString*)headerTitle {
    self.titleLabel.text = headerTitle;
    [self.moreBtn setTitle:title forState:UIControlStateNormal];
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}








@end
