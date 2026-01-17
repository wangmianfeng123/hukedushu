//
//  HKStudyTagSelectGuideView.m
//  Code
//
//  Created by Ivan li on 2018/5/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyTagSelectGuideView.h"
#import "AppDelegate.h"


@interface HKStudyTagSelectGuideView()

@property(nonatomic,strong)UIButton  *closeBtn;

@property(nonatomic,strong)UIImageView  *ic2;

@property(nonatomic,strong)UIImageView  *ic3;

@property(nonatomic,strong)UILabel *titleLb;

@end


@implementation HKStudyTagSelectGuideView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBtnClick)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.ic3];
    [self addSubview:self.ic2];
    [self.ic2 addSubview:self.closeBtn];
    [self.ic2 addSubview:self.titleLb];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_ic3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(95/2);
    }];
    
    // 463 109 125
    [_ic2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.ic3.mas_top);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ic2.mas_top).offset(15/2);
        make.right.equalTo(self.ic2.mas_right).offset(-10);
    }];
    
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ic2.mas_left).offset(20);
        make.top.equalTo(self.ic2.mas_top).offset(6);
        make.bottom.equalTo(self.ic2.mas_bottom).offset(-6);
        make.right.equalTo(self.closeBtn.mas_left);
    }];
    
}




- (UIButton*)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:imageName(@"hkplayer_fork_white") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setHKEnlargeEdge:15];
    }
    return _closeBtn;
}


- (UIImageView*)ic2 {
    if (!_ic2) {
        _ic2 = [UIImageView new];
        _ic2.image = imageName(@"study_tag_learninginterest_bg");
        //_ic2.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _ic2;
}



- (UIImageView*)ic3 {
    if (!_ic3) {
        _ic3 = [UIImageView new];
        _ic3.image = imageName(@"study_tag_triangle");
        _ic3.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _ic3;
}


- (UILabel*)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel labelWithTitle:CGRectZero title:@"设置学习兴趣\n为您推荐想学的教程~" titleColor:COLOR_ffffff titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _titleLb.numberOfLines = 2;
    }
    return _titleLb;
}


- (void)closeBtnClick {
    
    [self delayRemoveView];
}


- (void)delayRemoveView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeGuidePage];
    }];
}


- (void)removeGuidePage {
    //移除手势
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        [self removeGestureRecognizer:ges];
    }
    [self removeFromSuperview];
}

@end
