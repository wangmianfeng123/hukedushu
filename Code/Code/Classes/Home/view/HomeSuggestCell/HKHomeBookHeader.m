//
//  HomeRecomdCell.m
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.2
//

#import "HKHomeBookHeader.h"

@implementation HKHomeBookHeader


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
    [self addSubview:self.changeBtn];
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.grayLabel.backgroundColor = COLOR_F8F9FA_333D48;
    [self makeConstraints];
}


- (void)makeConstraints {
    [_grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayLabel.mas_bottom).offset(18);
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-18);
        make.width.mas_equalTo(2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(4);
        make.left.equalTo(self).offset(PADDING_15);
    }];
    
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
    }];
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:HKColorFromHex(0x27323F, 1.0)];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19: 18 weight:UIFontWeightBold];
        _titleLabel.text = @"虎课读书";
    }
    return _titleLabel;
}

- (UILabel*)grayLabel {
    if (!_grayLabel) {
        _grayLabel  = [UILabel new];
        _grayLabel.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
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



- (UIButton*)changeBtn {
    
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [_changeBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:HKColorFromHex(0xA8ABBE, 1.0) forState:UIControlStateNormal];
        [_changeBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13]];
        _changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_changeBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  
        _changeBtn.width = PADDING_20*6;
        [_changeBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        
//        [_changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_changeBtn.imageView.image.size.width, 0, _changeBtn.imageView.image.size.width)];
//        CGFloat imageOffset = IS_IPHONE6PLUS? 63 : 58;
//        [_changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, imageOffset, 0, -imageOffset)];
    }
    return _changeBtn;
}



- (void)rightBtnClick:(id)sender {
    !self.self.moreSeriesAndDesignBlock? : self.moreSeriesAndDesignBlock();
}










@end
