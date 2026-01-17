//
//  HKteacerSuggestCourse.m
//  Code
//
//  Created by Ivan li on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKteacerSuggestCourseView.h"

@implementation HKteacerSuggestCourseView


- (instancetype)initWithFrame:(CGRect)frame {
    
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.titleLabel];
    [self addSubview:self.tagLabel];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(13);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-PADDING_20);
        make.top.equalTo(self.mas_top).offset(PADDING_20);
        make.left.equalTo(self.tagLabel.mas_right).offset(PADDING_10);
    }];
    
}



- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"推荐教程" titleColor:COLOR_27323F_EFEFF6 titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONEMORE4_7INCH? 16 : 15 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}



- (UILabel*)tagLabel {
    if (!_tagLabel) {
        _tagLabel  = [UILabel new];
        _tagLabel.hidden = YES;
        _tagLabel.backgroundColor = COLOR_333333;
    }
    return _tagLabel;
}


@end
