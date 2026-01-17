//
//  HKStudyTagCell.m
//  Code
//
//  Created by Ivan li on 2018/5/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyTagCell.h"
#import "HKStudyTagModel.h"
#import "UIImage+Helper.h"
#import "UIImage+SNFoundation.h"

@implementation HKStudyTagCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.typeLabel];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}


- (UILabel*)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentCenter];
        _typeLabel.backgroundColor = [UIColor clearColor];
    }
    return _typeLabel;
}


- (UIImageView*)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        //_bgImageView.contentMode =UIViewContentModeScaleAspectFit;
        //_bgImageView.image = imageName(@"study_tag_gray_bg_v211");
        _bgImageView.clipsToBounds = YES;
        _bgImageView.layer.cornerRadius = self.height/2.0;
        _bgImageView.image = self.normalImage;
    }
    return _bgImageView;
}




- (void)setModel:(HKStudyTagModel *)model {
    _model = model;
    _typeLabel.text = model.name;
    //_bgImageView.image = imageName( model.is_select ?@"study_tag_orange_bg_v211" : @"study_tag_gray_bg_v211");
    _bgImageView.image = model.is_select? self.selectedImage :self.normalImage;
    UIColor *color = [UIColor hkdm_colorWithColorLight:COLOR_7B8196 dark:COLOR_27323F];
    _typeLabel.textColor = model.is_select ?COLOR_ffffff :color;
}


- (UIImage*)selectedImage {
    
    if (!_selectedImage) {
        UIColor *color = [UIColor colorWithHexString:@"#FF9200"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA200"];
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(self.width, self.height) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        //_selectedImage = [image roundCornerImageWithRadius:self.height/2.0];
        _selectedImage = image;
    }
    return _selectedImage;
}



- (UIImage*)normalImage {
    
    if (!_normalImage) {
        UIColor *color = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_A8ABBE];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(self.width, self.height) gradientColors:@[(id)color,(id)color,(id)color] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
       _normalImage  = image;
    }
    return _normalImage;
}


@end




