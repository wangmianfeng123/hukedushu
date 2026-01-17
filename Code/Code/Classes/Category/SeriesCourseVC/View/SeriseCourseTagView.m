
//
//  SeriseCourseTagView.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SeriseCourseTagView.h"

@interface SeriseCourseTagView()

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)UILabel *tagLabel;

@property(nonatomic,strong)UILabel *lineLabel;

@end



@implementation SeriseCourseTagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (void)createUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.tagLabel];
    [self addSubview:self.lineLabel];
}

- (void)makeConstraints {
    WeakSelf;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(weakSelf);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(PADDING_5);
        make.top.height.equalTo(weakSelf.iconImageView);
        make.right.lessThanOrEqualTo(weakSelf.mas_right).offset(-7);
    }];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImageView);
        make.height.mas_equalTo(13);
        make.left.equalTo(weakSelf.tagLabel.mas_right).offset(7);
        make.width.mas_equalTo(0.5);
    }];
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}


- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel  = [UILabel new];
        [_tagLabel setTextColor:HKColorFromHex(0xA8ABBE, 1.0)];
        _tagLabel.textAlignment = NSTextAlignmentLeft;
        _tagLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 13:12];
    }
    return _tagLabel;
}


- (UILabel*)lineLabel {
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        _lineLabel.backgroundColor = COLOR_999999;
    }
    return _lineLabel;
}


- (void)setImageWithName:(NSString*)imageName  text:(NSString*)text  isHidden:(BOOL)isHidden{
    _iconImageView.image = imageName(imageName);
    _tagLabel.text = text;//@"100";
    _lineLabel.hidden = isHidden;
}



@end
