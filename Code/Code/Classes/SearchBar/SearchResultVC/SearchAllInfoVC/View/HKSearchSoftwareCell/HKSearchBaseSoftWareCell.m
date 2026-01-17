//
//  HKSearchBaseSoftWareCell.m
//  Code
//
//  Created by Ivan li on 2019/4/9.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKSearchBaseSoftWareCell.h"
#import "HKCustomMarginLabel.h"

@implementation HKSearchBaseSoftWareCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame ];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.studyCountLabel];
    [self.contentView addSubview:self.courseLabel];
    [self.contentView addSubview:self.lineLabel];
    
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.exerciseLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(PADDING_15);
        make.top.equalTo(self.contentView).offset(PADDING_20);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(3);
        make.left.equalTo(self.iconImageView.mas_right).offset(PADDING_10);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(PADDING_15/2);
        make.right.lessThanOrEqualTo(self.contentView);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.studyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.iconImageView).offset(-3);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.studyCountLabel.mas_right).offset(PADDING_15/2);
        make.width.mas_equalTo(0.5);
        make.top.equalTo(self.studyCountLabel).offset(2);
        make.bottom.equalTo(self.studyCountLabel).offset(-2);
    }];
    
    [self.courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.studyCountLabel);
        make.left.equalTo(self.lineLabel.mas_right).offset(PADDING_15/2);
    }];
    
    [self.exerciseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.studyCountLabel);
        make.left.equalTo(self.courseLabel.mas_right).offset(45/2);
        make.right.lessThanOrEqualTo(self.contentView).offset(-PADDING_5);
    }];
}



- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 3;
    }
    return _iconImageView;
}



- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightMedium);
    }
    return _titleLabel;
}



- (UILabel*)studyCountLabel {
    
    if (!_studyCountLabel) {
        _studyCountLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196 titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _studyCountLabel;
}


- (UILabel*)courseLabel {
    
    if (!_courseLabel) {
        _courseLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196 titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _courseLabel;
}



- (UILabel*)exerciseLabel {
    
    if (!_exerciseLabel) {
        _exerciseLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE_7B8196 titleFont:@"11" titleAligment:NSTextAlignmentLeft];
    }
    return _exerciseLabel;
}


- (UILabel*)lineLabel {
    
    if (!_lineLabel) {
        _lineLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_A8ABBE titleFont:@"11" titleAligment:NSTextAlignmentLeft];
        _lineLabel.backgroundColor = COLOR_A8ABBE_7B8196;
    }
    return _lineLabel;
}


- (HKCustomMarginLabel*)stateLabel {
    if (!_stateLabel) {
        _stateLabel  = [[HKCustomMarginLabel alloc] init];
        _stateLabel.textInsets = UIEdgeInsetsMake(2, 10, 2, 10);
        [_stateLabel setTextColor:COLOR_A8ABBE_27323F];
        _stateLabel.font = HK_FONT_SYSTEM(11);
        _stateLabel.clipsToBounds = YES;
        _stateLabel.layer.cornerRadius = 7.5;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = COLOR_F3F3F6;
    }
    return _stateLabel;
}


- (void)setModel:(VideoModel *)model {
    _model = model;
    
    _titleLabel.text = model.title;
    
    _studyCountLabel.text = [NSString stringWithFormat:@"%@人已学", model.study_num];
    _courseLabel.text = [NSString stringWithFormat:@"%ld课", (long)model.master_curriculum];
    _exerciseLabel.text = [NSString stringWithFormat:@"%ld练习", (long)model.slave_curriculum];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.app_small_img_url]] placeholderImage:imageName(HK_Placeholder)];
    
    ///** is_end：1-已完结 0-更新中*/3
    if ([model.is_end isEqualToString:@"1"]) {
        _stateLabel.text = @"已完结";
        _stateLabel.textColor = COLOR_A8ABBE_27323F;
        UIColor *bgColor = [UIColor hkdm_colorWithColorLight:COLOR_F3F3F6 dark:COLOR_7B8196];
        _stateLabel.backgroundColor = bgColor;
    }else{
        _stateLabel.text = @"更新中";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.backgroundColor = COLOR_FFD710;
    }
}



@end
