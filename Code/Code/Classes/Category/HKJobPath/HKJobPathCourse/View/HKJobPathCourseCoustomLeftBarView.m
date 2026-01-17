
//
//  HKJobPathCourseCoustomLeftBar.m
//  Code
//
//  Created by Ivan li on 2019/6/10.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathCourseCoustomLeftBarView.h"

@implementation HKJobPathCourseCoustomLeftBarView


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



- (void)createUI {
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLB];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.backBtn.mas_right).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH -80);
    }];
}



- (UIButton*)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateHighlighted];
        
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn sizeToFit];
        [_backBtn setHKEnlargeEdge:20];
    }
    return _backBtn;
}



- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:@"17" titleAligment:0];
        //[_titleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _titleLB.font = HK_FONT_SYSTEM_WEIGHT(18, UIFontWeightSemibold);
    }
    return _titleLB;
}



- (void)backBtnClick:(UIButton*)btn {
    
    if (self.backBtnClickCallBack) {
        self.backBtnClickCallBack();
    }
}


- (void)setTitleColor:(UIColor*)color {
    [self.titleLB setTextColor:color];
}


#pragma mark ( ios 11 无法响应点击 )
- (CGSize)intrinsicContentSize {
    return CGSizeMake(200, 50);
}



@end
