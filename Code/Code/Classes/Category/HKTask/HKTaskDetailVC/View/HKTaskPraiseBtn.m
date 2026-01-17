//
//  HKTaskPraiseBtn.m
//  Code
//
//  Created by Ivan li on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskPraiseBtn.h"
#import "HKTaskModel.h"

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



- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(9);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.greaterThanOrEqualTo(self.titleLB.mas_top).offset(-3);
    }];
}

- (UIImageView*)iconIV {
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        _iconIV.image = imageName(@"praise_normal");
    }
    return _iconIV;
}



- (UILabel*)titleLB {
    
    if (!_titleLB) {
        _titleLB  = [UILabel labelWithTitle:CGRectZero title:nil
                                     titleColor:COLOR_7B8196
                                      titleFont:nil
                                  titleAligment:NSTextAlignmentCenter];
        _titleLB.font = HK_FONT_SYSTEM(12);
    }
    return _titleLB;
}


- (void)setModel:(HKTaskDetailModel *)model {
    _model = model;
    self.selected = model.is_like;
    if (model.thumbs) {
        self.titleLB.text = [NSString stringWithFormat:@"%ld",model.thumbs];
    }else{
        self.titleLB.text = nil;
    }
    self.titleLB.textColor = self.selected ?COLOR_27323F :COLOR_7B8196;
    
    self.backgroundColor = self.selected? COLOR_FFD305 : COLOR_EFEFF6;
    _iconIV.image = self.selected ?imageName(@"praise_selected") : imageName(@"praise_normal");
}


@end







