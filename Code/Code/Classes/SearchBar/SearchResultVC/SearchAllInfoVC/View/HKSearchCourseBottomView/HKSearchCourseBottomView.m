//
//  HKSearchCourseBottomView.m
//  Code
//
//  Created by Ivan li on 2019/4/10.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKSearchCourseBottomView.h"
#import "UIImage+Helper.h"

@implementation HKSearchCourseBottomView

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
    [self addSubview:self.bgIV];
    [self addSubview:self.tipLB];
    [self addSubview:self.closeBtn];
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(PADDING_15);
        make.left.equalTo(self).offset(PADDING_25);
        make.right.equalTo(self).offset(-PADDING_25);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-PADDING_15);
        make.centerY.equalTo(self.tipLB);
    }];
}


- (UIImageView*)bgIV {
    if (!_bgIV) {
        
        UIColor *color = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA100"];
        UIColor *color2 = [UIColor colorWithHexString:@"#FF8E00"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH, 50) gradientColors:@[(id)color2,(id)color1,(id)color] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        
        _bgIV = [[UIImageView alloc]initWithImage:image];
    }
    return _bgIV;
}


- (UILabel*)tipLB {
    
    if (!_tipLB) {
        _tipLB = [UILabel labelWithTitle:CGRectZero title:@"搜不到结果？换个关键词试试？" titleColor:COLOR_ffffff
                                       titleFont:@"15" titleAligment:NSTextAlignmentCenter];
        
        _tipLB.font = HK_FONT_SYSTEM_WEIGHT(15, UIFontWeightSemibold);
    }
    return _tipLB;
}



- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:imageName(@"ic_close_white_v2_10") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setHKEnlargeEdge:PADDING_35];
    }
    return _closeBtn;
}



- (void)closeBtnClick:(UIButton *)sender {
    
    [self removeFromSuperview];
    if (self.closeClickCallback) self.closeClickCallback();
}


@end
