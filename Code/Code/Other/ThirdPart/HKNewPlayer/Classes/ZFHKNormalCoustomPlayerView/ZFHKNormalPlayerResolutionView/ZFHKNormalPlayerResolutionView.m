//
//  ZFHKNormalPlayerResolutionView.m
//  Code
//
//  Created by Ivan li on 2019/12/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "ZFHKNormalPlayerResolutionView.h"

@interface ZFHKNormalPlayerResolutionView()

@property (nonatomic,strong) UIButton *resolutionBtn0_75;

@property (nonatomic,strong) UIButton *resolutionBtn1_0;

@property (nonatomic,strong) UIButton *resolutionBtn1_25;

@property (nonatomic,strong) UIButton *resolutionBtn1_5;

@property (nonatomic,strong) UIButton *resolutionBtn2_0;
@property (nonatomic,strong) UIButton *resolutionBtn3_0;

@property(nonatomic,assign)BOOL isportrait;

@end



@implementation ZFHKNormalPlayerResolutionView

- (instancetype)initWithIsportrait:(BOOL)isportrait {
    if (self = [super init]) {
        [self createUI];
        self.isportrait = isportrait;
//        if (isportrait) {
//            [self portraitMakeConstraints];
//        }else{
//            [self landScapemakeConstraints];
//        }
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    [self addSubview:self.resolutionBtn0_75];
    [self addSubview:self.resolutionBtn1_0];
    [self addSubview:self.resolutionBtn1_25];
    [self addSubview:self.resolutionBtn1_5];
    [self addSubview:self.resolutionBtn2_0];
    [self addSubview:self.resolutionBtn3_0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isportrait) {
        CGFloat margin = (self.height-2 * PADDING_10)/6;
        [self landScapemakeConstraints:margin andTopMargin:PADDING_10 andLeftMargin:33];
    }else{
        CGFloat margin = (self.height-2 * PADDING_20)/6;
        [self landScapemakeConstraints:margin andTopMargin:20 andLeftMargin:PADDING_25];
    }
}

- (void)landScapemakeConstraints:(CGFloat)margin andTopMargin:(CGFloat)topMargin andLeftMargin:(CGFloat)leftMargin{
    
    [self.resolutionBtn0_75 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topMargin);
        make.left.equalTo(self).offset(leftMargin);
        make.height.mas_equalTo(margin);
    }];
    
    [self.resolutionBtn1_0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resolutionBtn0_75.mas_bottom).offset(0);
        make.left.equalTo(self).offset(leftMargin);
        make.height.mas_equalTo(margin);
    }];
    
    [self.resolutionBtn1_25 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resolutionBtn1_0.mas_bottom).offset(0);
        make.left.equalTo(self).offset(leftMargin);
        make.height.mas_equalTo(margin);
    }];
    
    [self.resolutionBtn1_5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resolutionBtn1_25.mas_bottom).offset(0);
        make.left.equalTo(self).offset(leftMargin);
        make.height.mas_equalTo(margin);
    }];
    
    [self.resolutionBtn2_0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resolutionBtn1_5.mas_bottom).offset(0);
        make.left.equalTo(self).offset(leftMargin);
        make.height.mas_equalTo(margin);
    }];
    [self.resolutionBtn3_0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resolutionBtn2_0.mas_bottom).offset(0);
        make.left.equalTo(self).offset(leftMargin);
        make.height.mas_equalTo(margin);
    }];
    
    
//    [self.resolutionBtn0_75 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(40);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn1_0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn0_75.mas_bottom).offset(PADDING_20);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn1_25 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn1_0.mas_bottom).offset(PADDING_20);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn1_5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn1_25.mas_bottom).offset(PADDING_20);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn2_0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn1_5.mas_bottom).offset(PADDING_20);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
}



//- (void)portraitMakeConstraints {
//
//    [self.resolutionBtn0_75 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(PADDING_20);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn1_0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn0_75.mas_bottom).offset(PADDING_10);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn1_25 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn1_0.mas_bottom).offset(PADDING_10);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn1_5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn1_25.mas_bottom).offset(PADDING_10);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//
//    [self.resolutionBtn2_0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn1_5.mas_bottom).offset(PADDING_10);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//    [self.resolutionBtn3_0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resolutionBtn2_0.mas_bottom).offset(PADDING_10);
//        make.left.equalTo(self).offset(PADDING_25);
//    }];
//}




- (void)selectResolutionWithRateIndex:(NSInteger)index {
    
    switch (index) {
            case 1:
                self.resolutionBtn0_75.selected = YES;
                break;
            
            case 2:
                self.resolutionBtn1_0.selected = YES;
                break;
            
            case 3:
                self.resolutionBtn1_25.selected = YES;
                break;
            
            case 4:
                self.resolutionBtn1_5.selected = YES;
                break;
            
            case 5:
                self.resolutionBtn2_0.selected = YES;
                break;
            case 6:
                self.resolutionBtn3_0.selected = YES;
            break;
            
        default:
            break;
    }
}




- (UIButton*)resolutionBtn:(NSString*)title tag:(NSInteger)tag {
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:COLOR_FFD305 forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setEnlargeEdgeWithTop:0 right:60 bottom:0 left:20];
    btn.titleLabel.font = HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold);
    btn.tag = tag;
    //btn.height = 20;
    return btn;
}



- (UIButton*)resolutionBtn0_75 {
    if (!_resolutionBtn0_75) {
        _resolutionBtn0_75 = [self resolutionBtn:@"0.75x" tag:200];
    }
    return _resolutionBtn0_75;
}


- (UIButton*)resolutionBtn1_0 {
    if (!_resolutionBtn1_0) {
        _resolutionBtn1_0 = [self resolutionBtn:@"1.0x" tag:201];
    }
    return _resolutionBtn1_0;
}


- (UIButton*)resolutionBtn1_25 {
    if (!_resolutionBtn1_25) {
        _resolutionBtn1_25 = [self resolutionBtn:@"1.25x" tag:202];
    }
    return _resolutionBtn1_25;
}



- (UIButton*)resolutionBtn1_5 {
    if (!_resolutionBtn1_5) {
        _resolutionBtn1_5 = [self resolutionBtn:@"1.5x" tag:203];
    }
    return _resolutionBtn1_5;
}


- (UIButton*)resolutionBtn2_0 {
    if (!_resolutionBtn2_0) {
        _resolutionBtn2_0 = [self resolutionBtn:@"2.0x" tag:204];
    }
    return _resolutionBtn2_0;
}


- (UIButton*)resolutionBtn3_0 {
    if (!_resolutionBtn3_0) {
        _resolutionBtn3_0 = [self resolutionBtn:@"3.0x" tag:205];
    }
    return _resolutionBtn3_0;
}



- (void)resolutionBtnClick:(UIButton*)btn {
    self.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(zFHKNormalPlayerResolutionView:resolutionBtn:)]) {
        [self.delegate zFHKNormalPlayerResolutionView:self resolutionBtn:btn];
    }
}


/** 销毁 */
- (void)removeSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


@end

