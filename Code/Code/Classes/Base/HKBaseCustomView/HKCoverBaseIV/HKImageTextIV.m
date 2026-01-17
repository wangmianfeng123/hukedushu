
//
//  HKImageTextIV.m
//  Code
//
//  Created by Ivan li on 2018/10/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKImageTextIV.h"
#import "UIImage+Helper.h"
#import "UIView+SNFoundation.h"


@interface HKImageTextIV()

@property (nonatomic,strong) UILabel *textLB;

@property (nonatomic,strong) LOTAnimationView *animation;

@end


@implementation HKImageTextIV


- (instancetype)initWithImage:(nullable UIImage *)image {
    if (self = [super initWithImage:image]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    [self addSubview:self.textLB];
    [self addSubview:self.animation];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isCategoryLeftCell) {
        [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.centerY.equalTo(self);
        }];
        
        [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.animation.mas_right).offset(PADDING_5);
            make.right.equalTo(self).offset(-5);
            make.top.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
        }];
    }else{
        [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12);
            make.size.mas_equalTo(CGSizeMake(25/2, 22/2));
            make.centerY.equalTo(self);
        }];
        
        [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.animation.mas_right).offset(PADDING_5);
            make.right.equalTo(self).offset(-12);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
        }];
        if (NO == self.isRemoveRoundedCorner) {
            [self setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:5];
        }
    }
    
}



- (UIImage *)backGroundImage {
    if (!_backGroundImage) {
        UIColor *color = [UIColor colorWithHexString:@"#FF6363"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FF4C44"];
        UIColor *color2 = [UIColor colorWithHexString:@"#FF3525"];
        _backGroundImage = [[UIImage alloc]createImageWithSize:CGSizeMake(100, 30) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromTopToBottom];
    }
    return _backGroundImage;
}

- (UIImage *)otherGroundImage {
    if (!_otherGroundImage) {
        UIColor *color = [UIColor colorWithHexString:@"#FF6363"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FF3221"];
        _otherGroundImage = [[UIImage alloc]createImageWithSize:CGSizeMake(75, 20) gradientColors:@[(id)color,(id)color1] percentage:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromTopToBottom];
    }
    return _otherGroundImage;
}



- (LOTAnimationView*)animation {
    if (!_animation) {
        _animation = [LOTAnimationView new];
        _animation.loopAnimation = YES;
//        _animation.backgroundColor = [UIColor blackColor];
//        _animation.tintColor = [UIColor whiteColor];
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}



- (UILabel*)textLB {
    if (!_textLB) {
        _textLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:[UIColor whiteColor]
                                titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        
        _textLB.font = HK_FONT_SYSTEM_BOLD(15);
    }
    return _textLB;
}


- (void)setText:(NSString *)text {
    _text = text;
    self.textLB.text = text;
    // 显示
    self.hidden = isEmpty(text);
}

- (void)text:(NSString *)text hiddenIfTextEmpty:(BOOL)hidden {
    _text = text;
    self.textLB.text = text;
    self.hidden = isEmpty(text) && hidden;
}




- (void)setIsAnimation:(BOOL)isAnimation {
    _isAnimation = isAnimation;
    if (isAnimation) {
        [self.animation play];
        self.hidden = NO;
        
    }else{
        self.hidden = YES;
        [self.animation stop];
    }
}



- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    //_textLB.textColor = textColor;
    _textLB.textColor = [UIColor hkdm_colorWithColorLight:textColor dark:textColor];
}


- (void)setFont:(UIFont *)font {
    _font = font;
    _textLB.font = font;
}


- (void)setAnimationName:(NSString *)animationName {
    _animationName = animationName;
    [self.animation setAnimationNamed:animationName];
}


- (void)setLiveAnimationType:(HKLiveAnimationType)liveAnimationType {
    _liveAnimationType = liveAnimationType;
    
    switch (liveAnimationType) {
        case HKLiveAnimationType_liveList:
        {
            self.animationName = @"playing.json";
            self.text = @"直播中";
            self.image = [self backGroundImage];
        }
            break;
            
        case HKLiveAnimationType_videoDetail:
        {
            self.animationName = @"directory_palying.json";
            self.text = @"直播中";
            self.font = HK_FONT_SYSTEM(12);
            self.textColor = COLOR_FF3221;
        }
            break;
        case HKCategaryAnimationType_liveList:{
            self.animationName = @"playing.json";
            self.text = @"直播中";
            self.font = HK_FONT_SYSTEM(12);
            self.textColor = COLOR_FF3221;
            self.image = [self otherGroundImage];
        }
            break;
        default:
            break;
    }
}

- (void)hideText:(BOOL )hideText hideAnimation:(BOOL)hideAnimation {
    self.textLB.hidden = hideText;
    self.animation.hidden = hideAnimation;
}


@end


