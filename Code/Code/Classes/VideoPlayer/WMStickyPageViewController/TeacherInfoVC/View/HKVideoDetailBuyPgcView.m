//
//  HKVideoDetailBuyPgcView.m
//  Code
//
//  Created by Ivan li on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKVideoDetailBuyPgcView.h"
#import "HKCustomMarginLabel.h"
#import "DetailModel.h"

@implementation HKVideoDetailBuyPgcView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.immediateOpenBtn];
        [self.bgView addSubview:self.priceLabel];
        [self.bgView addSubview:self.timeLabel];
        
        [self.bgView addSubview:self.oldPriceLabel];
        [self.bgView addSubview:self.discountLabel];
        [self.bgView addSubview:self.vipDiscountLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    WeakSelf;
    __block HKCourseModel *courseModel = self.model.course_data;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(18);
        isEmpty(courseModel.price) ?make.centerY.equalTo(weakSelf.bgView) :make.top.equalTo(weakSelf.bgView.mas_top).offset(PADDING_10);
    }];
    
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(8);
        make.left.equalTo(weakSelf.priceLabel);
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.priceLabel.mas_right).offset(PADDING_10);
        make.top.equalTo(weakSelf.priceLabel);
    }];
    
    [_vipDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        // _discountLabel 有可能为空
        make.left.equalTo(isEmpty(courseModel.tag_1) ?(weakSelf.priceLabel.mas_right):(weakSelf.discountLabel.mas_right)).offset(PADDING_10);
        make.top.equalTo(weakSelf.priceLabel);
        make.right.lessThanOrEqualTo(weakSelf.immediateOpenBtn.mas_left).offset(-1);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.priceLabel.mas_right).offset(PADDING_10);
        make.centerY.equalTo(weakSelf.priceLabel);
        make.right.mas_greaterThanOrEqualTo((Ratio*140));
    }];
    
    [_immediateOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.right.equalTo(weakSelf.bgView);
        make.width.mas_equalTo(Ratio*140);
    }];
}



- (UIButton*)immediateOpenBtn {
    if (!_immediateOpenBtn) {
        _immediateOpenBtn = [UIButton buttonWithTitle:@"立即开通" titleColor:COLOR_333333 titleFont:nil imageName:nil];
        _immediateOpenBtn.backgroundColor = COLOR_e3b967;
        [_immediateOpenBtn.titleLabel setFont:HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ?18 :17)];
        [_immediateOpenBtn addTarget:self action:@selector(buyClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _immediateOpenBtn;
}

- (void)buyClickAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(buyPgcCourse:)]) {
        [self.delegate buyPgcCourse:sender];
    }
}


- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_999999 titleFont:@"14" titleAligment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (HKCustomMarginLabel*)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[HKCustomMarginLabel alloc]init];
        _priceLabel.backgroundColor = COLOR_333333;
        _priceLabel.textColor = COLOR_e3b967;
        [_priceLabel setFont:HK_FONT_SYSTEM_BOLD(IS_IPHONE6PLUS ?16 :15)];
    }
    return _priceLabel;
}


- (HKCustomMarginLabel*)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [self customMarginLabel];
    }
    return _discountLabel;
}

- (HKCustomMarginLabel*)vipDiscountLabel {
    if (!_vipDiscountLabel) {   
        _vipDiscountLabel = [self customMarginLabel];
    }
    return _vipDiscountLabel;
}

- (HKCustomMarginLabel*)customMarginLabel {
    
    HKCustomMarginLabel *label =  [[HKCustomMarginLabel alloc]init];
    label.backgroundColor = COLOR_333333;
    label.textColor = COLOR_e3b967;
    [label setFont:HK_FONT_SYSTEM(IS_IPHONE6PLUS ?15 :14)];
    label.textInsets = UIEdgeInsetsMake(0, PADDING_5, 0, PADDING_5);
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 2;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = COLOR_e3b967.CGColor;
    //label.adjustsFontSizeToFitWidth = YES;
    return label;
}



- (HKLineLabel*)oldPriceLabel {
    if (!_oldPriceLabel) {
        _oldPriceLabel = [HKLineLabel new];
        _oldPriceLabel.textColor = COLOR_999999;
        [_oldPriceLabel setFont:HK_FONT_SYSTEM(IS_IPHONE6PLUS ?13 :12)];
        _oldPriceLabel.strikeThroughEnabled = YES;
        _oldPriceLabel.strikeThroughColor = COLOR_999999;
    }
    return _oldPriceLabel;
}

- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_333333;
    }
    return _bgView;
}


- (void)setModel:(DetailModel *)model {
    _model = model;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.course_data.now_price];
    _oldPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.course_data.price];
    
    _discountLabel.text = model.course_data.tag_1;
    _vipDiscountLabel.text = model.course_data.tag_2;
    _timeLabel.text = [model.course_data.now_price isEqualToString:model.course_data.price] ?@"(永久有限)":nil;
}





@end
