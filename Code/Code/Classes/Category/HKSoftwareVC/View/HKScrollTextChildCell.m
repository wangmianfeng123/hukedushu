//
//  HKScrollTextChildCell.m
//  Code
//
//  Created by ivan on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKScrollTextChildCell.h"
#import "HKCustomMarginLabel.h"

@implementation HKScrollTextChildCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FFFFFF_3D4752;
        [self.contentView addSubview:self.textLB];
        [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}



- (HKCustomMarginLabel*)textLB {
    if (!_textLB) {
        _textLB = [HKCustomMarginLabel new];
        _textLB.backgroundColor = COLOR_FFF0E6;
        _textLB.textColor = COLOR_FF7820;
        _textLB.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        _textLB.font = HK_FONT_SYSTEM(12);
        _textLB.textAlignment = NSTextAlignmentLeft;
    }
    return _textLB;
}

@end
