//
//  HKVideoNewGuideView.m
//  Code
//
//  Created by Ivan li on 2018/1/28.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKVideoNewGuideView.h"

@interface HKVideoNewGuideView()

/** 知道 按钮 */
@property(nonatomic,strong)UIButton  *btn;
/** 侧滑返回 icon */
@property(nonatomic,strong)UIImageView  *leftBackIc;
/** 侧滑返回文字提示 icon */
@property(nonatomic,strong)UIImageView  *leftTipIc;
/** 顶部 返回文字提示 icon*/
@property(nonatomic,strong)UIImageView  *upTipIc;
/** 顶部 向上箭头 icon */
@property(nonatomic,strong)UIImageView  *upBackIc;
/** 顶部 圆圈 icon */
@property(nonatomic,strong)UIImageView  *circleIc;

@end


@implementation HKVideoNewGuideView

- (instancetype)init {
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (isEmpty([defaults valueForKey:@"HKVideoNewGuide"])) {
//        if (self = [super init]) {
//            [self createUI];
//        }
//        [defaults setValue:@"2" forKey:@"HKVideoNewGuide"];
//        [defaults synchronize];
//        return self;
//    }
//    return nil;
    
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if (isEmpty([defaults valueForKey:@"HKVideoNewGuide"])) {
//        if (self = [super initWithFrame:frame]) {
//            [self createUI];
//        }
//        [defaults setValue:@"2" forKey:@"HKVideoNewGuide"];
//        [defaults synchronize];
//        return self;
//    }
//    return nil;
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBtnClick)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.btn];
    [self addSubview:self.leftBackIc];
    [self addSubview:self.leftTipIc];
    
    [self addSubview:self.upTipIc];
    [self addSubview:self.upBackIc];
    [self addSubview:self.circleIc];
    
    
    [_circleIc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(22);
        make.left.equalTo(self).offset(PADDING_5);
    }];
    
    [_upBackIc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_circleIc.mas_bottom).offset(PADDING_15);
        make.left.equalTo(_circleIc.mas_right).offset(-PADDING_5);
    }];
    
    [_upTipIc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_upBackIc.mas_top).offset(8);
        make.left.equalTo(_upBackIc.mas_right).offset(PADDING_15);
    }];
    
    [_leftTipIc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(570/2*Ratio);
        make.left.equalTo(_leftBackIc.mas_right).offset(PADDING_20);
    }];
    
    [_leftBackIc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftTipIc);
        make.left.equalTo(self).offset(PADDING_13);
    }];
    
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_leftTipIc.mas_bottom).offset(100);
    }];
}


- (UIButton*)btn {
    if (!_btn) {
        _btn = [UIButton new];
        [_btn setImage:imageName(@"home_word_know") forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}


- (UIImageView*)leftBackIc {
    if (!_leftBackIc) {
        _leftBackIc = [UIImageView new];
        _leftBackIc.image = imageName(@"video_arrow_left");
        _leftBackIc.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftBackIc;
}



- (UIImageView*)leftTipIc {
    if (!_leftTipIc) {
        _leftTipIc = [UIImageView new];
        _leftTipIc.image = imageName(@"video_word_back_1");
        _leftTipIc.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftTipIc;
}


- (UIImageView*)upTipIc {
    if (!_upTipIc) {
        _upTipIc = [UIImageView new];
        _upTipIc.image = imageName(@"video_word_back");
        _upTipIc.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _upTipIc;
}


- (UIImageView*)upBackIc {
    if (!_upBackIc) {
        _upBackIc = [UIImageView new];
        _upBackIc.image = imageName(@"video_arrow_up");
        _upBackIc.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _upBackIc;
}

- (UIImageView*)circleIc {
    if (!_circleIc) {
        _circleIc = [UIImageView new];
        _circleIc.image = imageName(@"home_circle_white");
        _circleIc.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _circleIc;
}



- (void)closeBtnClick {
    
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:0.5];
        });
    }];
}


- (void)removeGuidePage {
    //移除手势
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        [self removeGestureRecognizer:ges];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}




@end
