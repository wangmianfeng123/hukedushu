//
//  HKStudyCertificateCell.m
//  Code
//
//  Created by Ivan li on 2018/4/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyCertificateCell.h"
#import "UIView+SNFoundation.h"
#import "StudyCertificateModel.h"


@interface HKStudyCertificateCell()

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *cupImageView;

@property (nonatomic,strong) UIImageView *bgImageView;

@end

@implementation HKStudyCertificateCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
//    self.clipsToBounds = YES;
    self.layer.cornerRadius = PADDING_5;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.cupImageView];
    [self.contentView addSubview:self.bgImageView];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PADDING_30);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(90, 90));
        //make.left.equalTo(self.contentView).offset(87/2*Ratio);
    }];
    
//    [self.cupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bgImageView).offset(77/2);
//        make.left.equalTo(self.contentView).offset(74/2*Ratio);
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(2);
        make.left.right.equalTo(self.contentView);
    }];
    /** 阴影*/
    [self addShadowWithColor:COLOR_E1E7EB  alpha:0.8 radius:5 offset:CGSizeMake(0, 2)];
}




- (UIImageView*)cupImageView {
    if (!_cupImageView) {
        _cupImageView = [UIImageView new];
        _cupImageView.contentMode = UIViewContentModeScaleAspectFit;
        _cupImageView.image = imageName(@"huke");
    }
    return _cupImageView;
}


- (UIImageView*)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = imageName(HK_Placeholder);
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bgImageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
    
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_27323F
                                     titleFont:@"14" titleAligment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}



- (void)setModel:(StudyCertificateModel *)model {
    _model = model;
    _titleLabel.text = model.name;
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:model.cert_img_url]] placeholderImage:imageName(HK_Placeholder)];
}


@end






