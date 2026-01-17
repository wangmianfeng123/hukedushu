//
//  HKSoftwareHopeCell.m
//  Code
//
//  Created by Ivan li on 2018/1/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKSoftwareHopeCell.h"

@implementation HKSoftwareHopeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    self.backgroundColor = COLOR_eeeeee;
    [self addSubview:self.textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}



- (UILabel*)textLabel {
    if (!_textLabel) {
        _textLabel  = [UILabel labelWithTitle:CGRectZero title:@"更多软件\n不断更新" titleColor:COLOR_999999
                                    titleFont:IS_IPHONE6PLUS ?@"15" :@"14" titleAligment:NSTextAlignmentCenter];
        _textLabel.numberOfLines = 0;
        [UILabel changeLineSpaceForLabel:_textLabel WithSpace:7];
    }
    return _textLabel;
}

@end
