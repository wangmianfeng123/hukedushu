//
//  HKPicSwitchView.m
//  Code
//
//  Created by Ivan li on 2018/7/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPicSwitchView.h"
#import "HKSwitchBtn.h"
#import "UISwitch+EnlargeEdge.h"


@interface HKPicSwitchView()<HKSwitchBtnDelegate>

@property (nonatomic,strong) HKSwitchBtn *switchBtn;

@property (nonatomic,strong) UILabel *titleLB;

@end



@implementation HKPicSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creteUI];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self creteUI];
    }
    return self;
}


- (void)creteUI {
    
    [self addSubview:self.switchBtn];
    [self addSubview:self.titleLB];
    [self addSubview:self.coverView];
    
    UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewClick)];
    [self.coverView addGestureRecognizer:coverTap];
    self.coverView.userInteractionEnabled = YES;
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(0);
        make.centerY.equalTo(self);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_switchBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:50];
}


- (HKSwitchBtn *)switchBtn {
    if(_switchBtn == nil) {
        _switchBtn = [[HKSwitchBtn alloc]init];
        CGAffineTransform scale= CGAffineTransformMakeScale(0.5, 0.5);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(-9, 0);
        _switchBtn.transform = CGAffineTransformConcat(scale, translate);
        _switchBtn.delegate = self;
    }
    return _switchBtn;
}


- (void)coverViewClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkPicSwitchClick:)]) {
        self.switchBtn.on = !self.switchBtn.on;
        [self.delegate hkPicSwitchClick:self.switchBtn];
    }
    self.hKPicSwitchBlock ? self.hKPicSwitchBlock() :nil;
}


- (UILabel*)titleLB {
    if (!_titleLB) {
        _titleLB = [UILabel labelWithTitle:CGRectZero title:@"图文" titleColor:COLOR_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentRight];
    }
    return _titleLB;
}



- (UIView*)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}


@end
