//
//  HKStudyRecommendTopView.m
//  Code
//
//  Created by Ivan li on 2019/3/24.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKStudyRecommendTopView.h"

@interface HKStudyRecommendTopView ()

/** 第一行提示文案 */
@property (strong , nonatomic)UILabel *firstTipLB;
/** 第二行提示文案 */
@property (strong , nonatomic)UILabel *secondTipLB;

@end

@implementation HKStudyRecommendTopView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_FFFFFF_3D4752;
        [self addSubview:self.firstTipLB];
        [self addSubview:self.secondTipLB];
    }
    return self;
}


- (UILabel*)firstTipLB {
    if (!_firstTipLB) {
        _firstTipLB = [UILabel labelWithTitle:CGRectZero title:@"为你推荐入门课程" titleColor:COLOR_27323F_EFEFF6
                                    titleFont:nil titleAligment:NSTextAlignmentCenter];
        _firstTipLB.font = HK_FONT_SYSTEM_WEIGHT(24, UIFontWeightSemibold);
        _firstTipLB.numberOfLines = 2;
    }
    return _firstTipLB;
}


- (UILabel*)secondTipLB {
    if (!_secondTipLB) {
        _secondTipLB = [UILabel labelWithTitle:CGRectZero title:@"设计师必备基础课程，学了都说好" titleColor:COLOR_A8ABBE_7B8196
                                     titleFont:nil titleAligment:NSTextAlignmentCenter];
        _secondTipLB.font = HK_FONT_SYSTEM(13);
    }
    return _secondTipLB;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_secondTipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    
    [_firstTipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.secondTipLB.mas_top).offset(-4);
    }];
    
}

@end
