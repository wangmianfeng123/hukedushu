//
//  HKSoftwareRecommenCell.m
//  Code
//
//  Created by Ivan li on 2018/4/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareRecommenCell.h"
#import "UIView+SNFoundation.h"


@interface HKSoftwareRecommenCell()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *iconImageView;

@end


@implementation HKSoftwareRecommenCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(100);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(PADDING_5);
        make.left.bottom.right.equalTo(self);
    }];
}


- (UIImageView*)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        //_iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_5;
    }
    return _iconImageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff
                                     titleFont:@"14" titleAligment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}


- (void)setModel:(VideoModel *)model {
    
    _titleLabel.text = model.name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]  placeholderImage:imageName(HK_Placeholder)];
}



@end
