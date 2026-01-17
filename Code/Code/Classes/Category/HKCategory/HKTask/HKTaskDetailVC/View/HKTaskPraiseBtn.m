//
//  HKTaskPraiseBtn.m
//  Code
//
//  Created by Ivan li on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskPraiseBtn.h"

@implementation HKTaskPraiseBtn



- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = COLOR_EFEFF6;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 55/2;
        [self addSubview:self.titleLB];
        [self addSubview:self.iconIV];
    }
    return self;
}


- (void)praiseBtnClick:(UIButton*)sender {
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(9);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.greaterThanOrEqualTo(self.titleLB.mas_top).offset(-3);
    }];
}

- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        //._iconIV.userInteractionEnabled = YES;
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        _iconIV.image = imageName(@"praise_normal");
    }
    return _iconIV;
}



- (UILabel*)titleLB {
    
    if (!_titleLB) {
        _titleLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_27323F
                                      titleFont:nil
                                  titleAligment:NSTextAlignmentCenter];
        _titleLB.font = HK_FONT_SYSTEM(12);
        //_titleLB.userInteractionEnabled = YES;
    }
    return _titleLB;
}



- (void)setTitle:(NSString *)title {
    _title = title;
    self.selected = !self.selected;
    
    _iconIV.image = self.selected ?imageName(@"praise_selected") : imageName(@"praise_normal");
    
    if (self.selected) {
        self.titleLB.text = @"11";
    }else{
        self.titleLB.text = nil;
    }
}

@end







