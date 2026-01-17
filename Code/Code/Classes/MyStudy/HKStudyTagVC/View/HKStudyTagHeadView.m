//
//  HKStudyTagHeadView.m
//  Code
//
//  Created by Ivan li on 2018/5/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyTagHeadView.h"

@interface HKStudyTagHeadView ()

/** 第一行提示文案 */
@property (strong , nonatomic)UILabel *firstTipLB;
/** 第二行提示文案 */
@property (strong , nonatomic)UILabel *secondTipLB;

@end

@implementation HKStudyTagHeadView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.firstTipLB];
        [self addSubview:self.secondTipLB];
        self.firstTipLB.textColor = COLOR_27323F_EFEFF6;
        self.secondTipLB.textColor = COLOR_A8ABBE_7B8196;
        self.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return self;
}


- (UILabel*)firstTipLB {
    if (!_firstTipLB) {
        _firstTipLB = [UILabel labelWithTitle:CGRectZero title:@"选择你的兴趣" titleColor:COLOR_27323F
                                    titleFont:nil titleAligment:NSTextAlignmentCenter];
        _firstTipLB.font = HK_FONT_SYSTEM_WEIGHT(24, UIFontWeightSemibold);
        _firstTipLB.numberOfLines = 2;
    }
    return _firstTipLB;
}


- (UILabel*)secondTipLB {
    if (!_secondTipLB) {
        _secondTipLB = [UILabel labelWithTitle:CGRectZero title:@"至少选择一个，为你推荐更多的好课" titleColor:COLOR_A8ABBE
                                     titleFont:nil titleAligment:NSTextAlignmentCenter];
        _secondTipLB.font = HK_FONT_SYSTEM(13);
        //_secondTipLB.numberOfLines = 2;
    }
    return _secondTipLB;
}




- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_secondTipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-25);
    }];
    
    [_firstTipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.secondTipLB.mas_top).offset(-4);
    }];
    
}


@end

