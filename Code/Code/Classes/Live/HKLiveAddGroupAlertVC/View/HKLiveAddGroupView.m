
//
//  HKLiveAddGroupView.m
//  Code
//
//  Created by Ivan li on 2018/12/10.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveAddGroupView.h"
#import "UIButton+ImageTitleSpace.h"


@interface HKLiveAddGroupView()

@end


@implementation HKLiveAddGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (instancetype)init {
    if (self =[super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = PADDING_5;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.closeViewBtn];
    [self addSubview:self.honorLB];
    [self addSubview:self.honorIV];
    [self addSubview:self.pushBtn];
    
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.closeViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(PADDING_15/2);
        make.right.equalTo(self).offset(-PADDING_15/2);
    }];
    
    [self.honorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(PADDING_20);
        make.centerX.equalTo(self);
        make.width.lessThanOrEqualTo(self);
    }];
    
    [self.honorLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.honorIV.mas_bottom).offset(PADDING_15);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    
    [self.pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(430/2, 75/2));
        make.centerX.equalTo(self);
    }];
}



- (UIButton*)closeViewBtn {
    
    if (!_closeViewBtn) {
        _closeViewBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15"  imageName:(@"ic_study_medall_close")];
        [_closeViewBtn setHKEnlargeEdge:PADDING_15];
        [_closeViewBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeViewBtn;
}


- (void)closeBtnClick:(UIButton*)btn {
    self.studyMedalCloseBlock ?self.studyMedalCloseBlock(btn) :nil;
}



- (UIButton*)pushBtn {
    
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_ffffff titleFont:@"17"  imageName:nil];
        [_pushBtn addTarget:self action:@selector(pushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pushBtn setBackgroundImage:imageName(@"ic_study_medall_bg") forState:UIControlStateNormal];
        [_pushBtn setTitle:@"立即加入" forState:UIControlStateNormal];
    }
    return _pushBtn;
}



- (void)pushBtnClick:(UIButton*)btn {
    self.studyMedalPushBlock ?self.studyMedalPushBlock(btn) :nil;
}


- (UILabel *)honorLB {
    if (!_honorLB) {
        NSString *title = @"本次直播已经结束啦，加入聊天群可以继续与老师同学聊天互动哦~";
        _honorLB = [UILabel labelWithTitle:CGRectZero title:title titleColor:COLOR_7B8196 titleFont:@"15" titleAligment:NSTextAlignmentCenter];
        _honorLB.numberOfLines = 0;
    }
    return _honorLB;
}


- (UIImageView*)honorIV {
    if (!_honorIV) {
        _honorIV = [UIImageView new];
        _honorIV.contentMode = UIViewContentModeScaleAspectFit;
        _honorIV.image = imageName(@"ic_live_chat_v2_7");
    }
    return _honorIV;
}


@end



