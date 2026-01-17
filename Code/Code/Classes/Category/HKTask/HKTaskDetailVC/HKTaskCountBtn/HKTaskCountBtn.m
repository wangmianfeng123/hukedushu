//
//  HKTaskCountBtn.m
//  Code
//
//  Created by Ivan li on 2018/7/19.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskCountBtn.h"

@implementation HKTaskCountBtn

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.countLB];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-PADDING_5);
        make.bottom.equalTo(self.mas_top).offset(PADDING_10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}



- (UILabel*)countLB {
    if (!_countLB) {
        _countLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor] titleFont:@"10" titleAligment:NSTextAlignmentCenter];
        _countLB.backgroundColor = COLOR_3D8BFF;
        _countLB.clipsToBounds = YES;
        _countLB.layer.cornerRadius = 8;
        _countLB.hidden = YES;
    }
    return _countLB;
}

- (void)setCount:(NSString *)count {
    _count = count;
    BOOL empty = isEmpty(count);
    if (!empty) {
        self.countLB.text = count;
    }
    self.countLB.hidden = empty;
}

@end
