//
//  ZFHKNormalPlayerVipTipLB.m
//  Code
//
//  Created by Ivan li on 2019/3/12.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKNormalPlayerVipTipLB.h"
#import "HKPermissionVideoModel.h"
#import "UIView+SNFoundation.h"
#import "MZTimerLabel.h"

@interface ZFHKNormalPlayerVipTipLB () <MZTimerLabelDelegate>

@property (nonatomic,strong)MZTimerLabel *timerLabel;


@end

@implementation ZFHKNormalPlayerVipTipLB


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initilize];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initilize];
    }
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initilize];
    }
    return self;
}


- (void)initilize {
    self.textColor    = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font        = HK_FONT_SYSTEM_WEIGHT(12, UIFontWeightSemibold);
    self.textInsets = UIEdgeInsetsMake(0, 8, 0, 8);
}



- (void)setModel:(HKPermissionVideoModel *)model {
    _model = model;
     NSString *temp = [NSString stringWithFormat:@"您暂无%@VIP会员,每日免费学习一个教程",model.vip_name];
     //NSMutableAttributedString *attributed = [NSMutableAttributedString changeCorlorWithColor:COLOR_ff7c00 TotalString:temp SubStringArray:@[@"VIP会员"]];
     //[self setAttributedText: attributed];
    self.text = temp;
    self.textColor = COLOR_FFD305;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = COLOR_FFD305.CGColor;
    self.layer.borderWidth = 1;
    self.layer.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.5].CGColor;
    
    
    [self addSubview:self.timerLabel];
    [self.timerLabel start];
}

/// 倒计时
- (MZTimerLabel*)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[MZTimerLabel alloc] initWithFrame:CGRectZero];
        _timerLabel.timerType = MZTimerLabelTypeTimer;
        _timerLabel.backgroundColor = [UIColor clearColor];
        _timerLabel.hidden = YES;
        _timerLabel.delegate = self;
        [_timerLabel setCountDownTime:6];
        _timerLabel.tag = 200;
        _timerLabel.timeFormat = @"s";
    }
    return _timerLabel;
}


- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    if (timerLabel.tag == 200) {
        [timerLabel pause];
        [self removeView];
    }
}


- (void)removeView {
    [self removeFromSuperview];
}


- (void)dealloc {
    if (_timerLabel) {
        [self.timerLabel pause];
    }
}




@end
