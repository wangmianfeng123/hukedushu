//
//  VideoPlayEmptyView.m
//  Code
//
//  Created by Ivan li on 2019/3/20.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "VideoPlayEmptyView.h"


#define titleForBtn @"重试"

#define btnTitleColor [UIColor whiteColor]

#define btnTitleFont [UIFont systemFontOfSize:16.0]

#define btnBackgroundImg [UIImage imageNamed:@"general_btn_bg"]


@interface VideoPlayEmptyView()

@property (nonatomic,strong) UIButton *button;

@end


@implementation VideoPlayEmptyView


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
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}


- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = btnTitleFont;
        _button.clipsToBounds = YES;
        [_button setTitle:titleForBtn forState:UIControlStateNormal];
        [_button setTitleColor:btnTitleColor forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置背景
        [_button setBackgroundImage:btnBackgroundImg forState:UIControlStateNormal];
        [_button sizeToFit];
    }
    return _button;
}



- (void)btnClick:(UIButton*)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoPlayEmptyView:)]) {
        [self.delegate videoPlayEmptyView:self];
    }
}

@end
