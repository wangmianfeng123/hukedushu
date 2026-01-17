//
//  HKJobPathHotHeaderView.m
//  Code
//
//  Created by Ivan li on 2019/6/4.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathHotHeaderView.h"

@implementation HKJobPathHotHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    [self addSubview:self.themeLB];
    [self.themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(PADDING_15);
        make.centerY.equalTo(self);
    }];
}



- (UILabel*)themeLB {
    if (!_themeLB) {
        _themeLB = [UILabel labelWithTitle:CGRectZero title:@"热门职业" titleColor:COLOR_27323F_EFEFF6 titleFont:nil titleAligment:NSTextAlignmentLeft];
        _themeLB.font = HK_FONT_SYSTEM_WEIGHT(17, UIFontWeightSemibold);
    }
    return _themeLB;
}



@end
