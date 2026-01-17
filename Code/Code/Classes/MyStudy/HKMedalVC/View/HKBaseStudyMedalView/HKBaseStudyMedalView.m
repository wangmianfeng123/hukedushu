//
//  HKBaseStudyMedalView.m
//  Code
//
//  Created by Ivan li on 2018/12/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseStudyMedalView.h"
#import "HKTextImageView.h"

@implementation HKBaseStudyMedalView


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
    [self addSubview:self.headLB];
    [self addSubview:self.honorIV];
    
    [self addSubview:self.pushBtn];
    [self addSubview:self.textImageView];
    [self addSubview:self.introductionLB];
}


- (UIButton*)closeViewBtn {
    
    if (!_closeViewBtn) {
        _closeViewBtn = [UIButton buttonWithTitle:nil titleColor:COLOR_333333 titleFont:@"15"  imageName:(@"ic_study_medall_close")];
        [_closeViewBtn setHKEnlargeEdge:PADDING_25];
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
        
        UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
        UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
        UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
        UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(430 * 0.5, 75 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        [_pushBtn setBackgroundImage:imageTemp forState:UIControlStateNormal];
        
        [_pushBtn setTitle:@"前往领取奖励" forState:UIControlStateNormal];
    }
    return _pushBtn;
}



- (void)pushBtnClick:(UIButton*)btn {
    self.studyMedalPushBlock ?self.studyMedalPushBlock(btn) :nil;
}



- (UILabel *)headLB {
    if (!_headLB) {
        _headLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"16" titleAligment:NSTextAlignmentCenter];
    }
    return _headLB;
}



- (UILabel *)introductionLB {
    if (!_introductionLB) {
        _introductionLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"13" titleAligment:NSTextAlignmentCenter];
    }
    return _introductionLB;
}


- (UIImageView*)honorIV {
    if (!_honorIV) {
        _honorIV = [UIImageView new];
        //_honorIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _honorIV;
}


- (HKTextImageView*)textImageView {
    if (!_textImageView) {
        _textImageView = [[HKTextImageView alloc]init];
    }
    return _textImageView;
}

@end




