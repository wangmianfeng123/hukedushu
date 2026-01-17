//
//  VerificationCodeButton.m
//  Grape-ToC-Iphone
//
//  Created by Xuehan Gong on 14-5-13.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import "VerificationCodeButton.h"


//#define COUNT_DOWN_TIME  (HKIsDebug ?5 :60)

#define COUNT_DOWN_TIME 60



@interface VerificationCodeButton ()
{
    NSTimer         *_timer;
    NSTimeInterval  _second;
}

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation VerificationCodeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isFirst = YES;
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _isFirst = YES;
    [self initUI];
}

- (void)initUI {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = (self.cornerRadius !=0.0) ?self.cornerRadius :7.5f;
    
    self.normalTitle = @"发送验证码";

    self.selected = NO;
    self.titleLabel.font = HK_FONT_SYSTEM(14);
    [self setTitleColor:COLOR_A8ABBE_27323F forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    UIColor *color = [UIColor colorWithHexString:@"#ff8c00"];
    UIColor *color1 = [UIColor colorWithHexString:@"#ffa000"];
    UIColor *color2 = [UIColor colorWithHexString:@"#ffb200"];
    UIImage *imageTemp = [[UIImage alloc]createImageWithSize:CGSizeMake(430 * 0.5, 75 * 0.5) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
    [self setBackgroundImage:imageTemp forState:UIControlStateSelected];
    
    UIImage *backgroundImage = [UIImage hkdm_imageWithNameLight:@"login_code_bg_enable" darkImageName:@"login_code_bg_enable_dark"];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [self setTitle:@"发送验证码" forState:UIControlStateNormal];
}


- (void)setNormalTitle:(NSString *)normalTitle {
    _normalTitle = normalTitle;
    [self setTitle:normalTitle forState:UIControlStateNormal];
}


- (void)startCountDown {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self setEnabled:NO];
    
    _second = COUNT_DOWN_TIME;
    
    [self countDown];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(countDown)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)countDown {
    _second --;
    
    self.isTiming = YES;
    
    [self setTitle:[NSString stringWithFormat:@"重新发送(%.0fs)", _second] forState:UIControlStateNormal];
    if (_second < 1) {
        [self stopCountDown];
    }
}


- (void)stopCountDown {
    if (_isFirst) {
        _isFirst = NO;
    }
    
    //[self setTitle:@"发送验证码" forState:UIControlStateSelected];
    [self setTitle:self.normalTitle forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(timerEnd:) ]) {
        [self.delegate timerEnd:nil];
    }
    
    if (_timer) {
        TT_INVALIDATE_TIMER(_timer)
    }
    self.isTiming = NO;
    [self setEnabled:YES];
}



- (void)dealloc {
    TT_INVALIDATE_TIMER(_timer);
}



@end



