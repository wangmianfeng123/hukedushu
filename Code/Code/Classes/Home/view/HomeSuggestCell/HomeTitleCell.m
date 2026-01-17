

//
//  HomeTitleCell.m
//  Code
//
//  Created by Ivan li on 2017/9/26.
//  Copyright © 2017年 pg. All rights reserved.
//



#import "HomeTitleCell.h"

@implementation HomeTitleCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.grayLabel];
    
    WeakSelf;
    [_grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(8);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(0);
        make.top.equalTo(weakSelf.grayLabel.mas_bottom).offset(18);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-PADDING_15);
        make.width.mas_equalTo(2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf).mas_offset(5);
        make.left.equalTo(weakSelf).offset(PADDING_15);
    }];
}

- (UILabel*)grayLabel {
    if (!_grayLabel) {
        _grayLabel  = [UILabel new];
        _grayLabel.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
    }
    return _grayLabel;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:HKColorFromHex(0x27323F, 1.0)];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19: 18 weight:UIFontWeightBold];
        _titleLabel.text = @"猜你喜欢";
    }
    return _titleLabel;
}



- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel  = [UILabel new];
        _tagLabel.hidden = YES;
        _tagLabel.backgroundColor = COLOR_333333;
    }
    return _tagLabel;
}

@end
