//
//  HKHomeLiveCellHeader.m
//  Code
//
//  Created by ivan on 2020/5/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKHomeLiveCellHeader.h"

@implementation HKHomeLiveCellHeader


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (self) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.grayLabel];
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.grayLabel.backgroundColor = COLOR_F8F9FA_333D48;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(5);
        make.left.equalTo(self).offset(PADDING_15);
    }];
    
    [self.grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(8);
    }];
}



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19: 18 weight:UIFontWeightBold];
        _titleLabel.text = @"今日直播";
    }
    return _titleLabel;
}


- (UILabel*)grayLabel {
    if (!_grayLabel) {
        _grayLabel  = [UILabel new];
        _grayLabel.backgroundColor = COLOR_F8F9FA;
    }
    return _grayLabel;
}




@end
