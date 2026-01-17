//
//  HomeRecomdCell.m
//  Code
//
//  Created by Ivan li on 2017/10/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeRecommendeCell.h"

@implementation HomeRecommendeCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.freeLabel];
    [self addSubview:self.rightTitleLabel];
    [self addSubview:self.grayLabel];
    [self addSubview:self.tagLabel];
    [self addSubview:self.changeBtn];
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.titleLabel.textColor = COLOR_27323F_EFEFF6;
    self.freeLabel.textColor = COLOR_A8ABBE_7B8196;

    self.grayLabel.backgroundColor = COLOR_F8F9FA_333D48;
    [self makeConstraints];
}



- (void)makeConstraints {
    
    [_grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(5);
        make.left.equalTo(self).offset(PADDING_15);
    }];
    
    [_freeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(PADDING_5);
    }];
    
    [self.rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(5);
        make.right.equalTo(self).offset(-PADDING_15);
    }];
    
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-PADDING_15);
        make.width.mas_equalTo(PADDING_20*4);
    }];
    [_changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];//图片位置偏移
}



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        [_titleLabel setTextColor:HKColorFromHex(0x27323F, 1.0)];
        
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 19: 18 weight:UIFontWeightBold];
        _titleLabel.text = @"官方推荐";
    }
    return _titleLabel;
}

- (UILabel*)freeLabel {
    
    if (!_freeLabel) {
        _freeLabel  = [[UILabel alloc] init];
        [_freeLabel setTextColor:HKColorFromHex(0x27323F, 1.0)];
        
        _freeLabel.textAlignment = NSTextAlignmentLeft;
        _freeLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14: 13];
        _freeLabel.text = @"（推荐视频新用户免费看）";
    }
    return _freeLabel;
}

- (void)setUpdate_video_total:(NSString *)video_total{
    if (isLogin()) {
        HKUserModel *updateModel = [HKAccountTool shareAccount];
        if ([updateModel.vip_class isEqualToString:@"0"]) {
            self.rightTitleLabel.text = @"每天免费学一课";
        }else{
            self.rightTitleLabel.text = [NSString stringWithFormat:@"今日更新%@节课",video_total];
        }        
    }else{
        self.rightTitleLabel.text = @"每天免费学一课";
    }
}


- (UILabel*)rightTitleLabel {
    
    if (!_rightTitleLabel) {
        _rightTitleLabel  = [[UILabel alloc] init];
        [_rightTitleLabel setTextColor:COLOR_A8ABBE_7B8196];
        _rightTitleLabel.textAlignment = NSTextAlignmentLeft;
        _rightTitleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14: 13];//[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14: 13 weight:UIFontWeightMedium];
        _rightTitleLabel.text = @"每天免费学一课";
    }
    return _rightTitleLabel;
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
        _tagLabel.hidden = YES;
        _tagLabel.backgroundColor = COLOR_333333;
    }
    return _tagLabel;
}



- (UIButton*)changeBtn {
    
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setImage:imageName(@"change_yellow") forState:UIControlStateSelected];
        [_changeBtn setImage:imageName(@"change_yellow") forState:UIControlStateNormal];
        [_changeBtn setImage:imageName(@"change_yellow") forState:UIControlStateHighlighted];
        [_changeBtn setTitle:@"换一批" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:HKColorFromHex(0xA8ABBE, 1.0) forState:UIControlStateNormal];
        [_changeBtn.titleLabel setFont:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13]];
        _changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_changeBtn addTarget:self action:@selector(changeVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.hidden = YES;
    }
    return _changeBtn;
}



- (void)changeVideoAction:(id)sender {
    
    if (self.changeVideoBlock) {
        self.changeVideoBlock();
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
        anima.toValue = [NSNumber numberWithFloat:M_PI * 4];
        anima.duration = 2.0f;
        [_changeBtn.imageView.layer addAnimation:anima forKey:@"rotateAnimation"];
        [MobClick event:UM_RECORD_HOME_BATCH];
    }
}

- (void)changeMas_makeConstraints:(CGFloat)margin{
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(margin);
    }];
    
    [_freeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
    }];
}







@end
