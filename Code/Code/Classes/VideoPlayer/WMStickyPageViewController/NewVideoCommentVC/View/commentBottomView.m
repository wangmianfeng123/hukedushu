//
//  commentBottomView.m
//  Code
//
//  Created by Ivan li on 2017/10/10.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "commentBottomView.h"
#import "UIView+SNFoundation.h"

@implementation commentBottomView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    [self addSubview:self.lineLabel];
    [self addSubview:self.circleLine];
    [self.circleLine addSubview:self.titleLabel];
    
    //[self addShadowWithColor:[COLOR_E1E7EB colorWithAlphaComponent:0.5] alpha:1 radius:1 offset:CGSizeMake(0, -2)];
    [self addShadowWithColor];
}


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    
    if (@available(iOS 13.0, *)) {
        // 主题模式 发生改变
        [self addShadowWithColor];
    }
}



- (void)addShadowWithColor {
    UIColor *shadowColor = [UIColor hkdm_colorWithColorLight:[COLOR_E1E7EB colorWithAlphaComponent:0.5] dark:COLOR_333D48];
    [self addShadowWithColor:shadowColor alpha:1 radius:1 offset:CGSizeMake(0, -2)];
}




- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}


- (UILabel*)lineLabel {
    
    if (!_lineLabel) {
        _lineLabel  = [UILabel new];
        _lineLabel.backgroundColor = COLOR_FFFFFF_333D48;
    }
    return _lineLabel;
}


- (UILabel*)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel  = [UILabel labelWithTitle:CGRectZero title:@"我要评价~每日首评得30虎课币"
                                    titleColor:COLOR_7B8196_A8ABBE
                                     titleFont:nil
                                 titleAligment:NSTextAlignmentLeft];
        _titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}


- (UIView*)circleLine {
    
    if (!_circleLine) {
        _circleLine = [[UIView alloc] init];
        _circleLine.layer.cornerRadius = 15.0f;
        _circleLine.backgroundColor = COLOR_F8F9FA_333D48;
    }
    return _circleLine;
}


- (void)makeConstraints {
    WeakSelf;
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(0.3);
    }];
    
    [_circleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(PADDING_10);
        make.left.equalTo(weakSelf.mas_left).offset(PADDING_25);
        make.right.equalTo(weakSelf.mas_right).offset(-PADDING_25);
        make.height.mas_equalTo(PADDING_15*2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.circleLine.mas_centerY);
        make.left.equalTo(weakSelf.circleLine.mas_left).offset(PADDING_20);
        make.right.equalTo(weakSelf.circleLine.mas_right).offset(-PADDING_5);
        make.height.mas_equalTo(PADDING_25);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [MobClick event: UM_RECORD_VIDEO_DETAIL_COMMENT];
    
    if ([self.delegate respondsToSelector:@selector(commentBottomView:comment:)]) {
        [self.delegate commentBottomView:self comment:nil];
    }
}


@end


