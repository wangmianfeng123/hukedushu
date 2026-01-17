//
//  UMShareCell.m
//  Code
//
//  Created by Ivan li on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "UMShareCell.h"

@implementation UMShareCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    WeakSelf;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.centerX.equalTo(weakSelf.contentView);
        if (IS_IPAD) {
            make.size.mas_equalTo(CGSizeMake(85, 85));
        }else{
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).offset(8);
        make.centerX.equalTo(weakSelf.iconImageView);
        make.width.equalTo(weakSelf.contentView.mas_width);
    }];
    
    _titleLabel.textColor = COLOR_27323F_EFEFF6;
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}


- (UIButton*)iconBtn {
    if (!_iconBtn) {
        _iconBtn = [UIButton new];
    }
    return _iconBtn;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F titleFont:@"14" titleAligment:NSTextAlignmentCenter];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}


- (void)setImageName:(NSString *)imageName {
    _iconImageView.image = imageName(imageName);
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
