//
//  HKtestview.m
//  Code
//
//  Created by Ivan li on 2018/9/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayerAutoPlayBaseView.h"
#import "HKSwitchBtn.h"



@interface HKPlayerAutoPlayBaseView()<HKSwitchBtnDelegate>

/** Wi-Fi 自动播放 */
@property (nonatomic,strong) UILabel *autoPlayLB;
/** Wi-Fi 自动播放 */
@property (nonatomic,strong) UILabel *rateLB;

@property (nonatomic,strong) HKSwitchBtn *autoSwitch;

@property (nonatomic,strong) HKSwitchBtn *rateSwitch;

@property (nonatomic,strong) UIButton *feedbackBtn;

@end


@implementation HKPlayerAutoPlayBaseView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.autoPlayLB];
    [self addSubview:self.rateLB];
    [self addSubview:self.autoSwitch];
    [self addSubview:self.rateSwitch];
    [self addSubview:self.feedbackBtn];
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.autoPlayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-30);
        make.left.equalTo(self).offset(PADDING_20);
    }];

    [self.rateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.autoPlayLB.mas_bottom).offset(40);
        make.right.equalTo(self.autoPlayLB);
    }];

    [self.autoSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.autoPlayLB);
        make.left.equalTo(self.autoPlayLB.mas_right);
    }];

    [self.rateSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoSwitch);
        make.centerY.equalTo(self.rateLB);
    }];
    
    [self.feedbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);
        make.bottom.equalTo(self).offset(-PADDING_30);
    }];
}



- (UILabel*)autoPlayLB {
    if (!_autoPlayLB) {
        
        NSString *title = @"wifi下自动播放：\n(仅针对无限观看用户)";
        NSString *title1 = @"wifi下自动播放：";
        NSString *title2 = @"(仅针对无限观看用户)";
        NSInteger length = title1.length;
        
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:title];
        [attrS addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(14) range:NSMakeRange(0, length)];
        [attrS addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(10) range:NSMakeRange(length, title2.length)];
        
        _autoPlayLB = [UILabel labelWithTitle:CGRectZero title:title titleColor:COLOR_ffffff titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _autoPlayLB.numberOfLines = 0;
        _autoPlayLB.attributedText = attrS;
    }
    return _autoPlayLB;
}


- (UILabel*)rateLB {
    if (!_rateLB) {
        _rateLB = [UILabel labelWithTitle:CGRectZero title:@"记住倍速：" titleColor:COLOR_ffffff titleFont:@"14" titleAligment:NSTextAlignmentLeft];
    }
    return _rateLB;
}



- (HKSwitchBtn *)autoSwitch {
    if(_autoSwitch == nil) {
        _autoSwitch = [[HKSwitchBtn alloc]init];
        _autoSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        _autoSwitch.delegate = self;
        _autoSwitch.tag = 20;
        // 0 - 关闭 1 -开启
        NSInteger state = [HKNSUserDefaults integerForKey:HKAutoPlay];
        _autoSwitch.on = state ?YES :NO;
    }
    return _autoSwitch;
}


- (HKSwitchBtn *)rateSwitch {
    if(_rateSwitch == nil) {
        _rateSwitch = [[HKSwitchBtn alloc]init];
        _rateSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
        _rateSwitch.delegate = self;
        _rateSwitch.tag = 22;
        // 1 - 关闭 0 -开启
        NSInteger state = [HKNSUserDefaults integerForKey:HKRatePlay];
        _rateSwitch.on = state ?NO :YES;
    }
    return _rateSwitch;
}



- (UIButton*)feedbackBtn {
    if (!_feedbackBtn) {
        _feedbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *text = [NSMutableAttributedString bottomLineAttributedString:@"举报该视频"];
        [text addAttribute:NSForegroundColorAttributeName value:COLOR_EFEFF6 range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM(12) range:NSMakeRange(0, text.length)];
        
        [_feedbackBtn setAttributedTitle:text forState:UIControlStateNormal];
        [_feedbackBtn addTarget:self action:@selector(feedbackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _feedbackBtn;
}



- (void)feedbackBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkPlayerRateBaseView:feedBack:)]) {
        [self.delegate hkPlayerRateBaseView:self feedBack:nil];
    }
}




- (void)switchClick:(UISwitch*)sender {
    
    NSInteger tag = [sender tag];
    if(20 == tag) {
        //自动播放
        NSInteger state = sender.on ?1 :0;
        [HKNSUserDefaults setInteger:state forKey:HKAutoPlay];
        [HKNSUserDefaults synchronize];
    }else{
        //倍速
        NSInteger state = sender.on ?0 :1;
        [HKNSUserDefaults setInteger:state forKey:HKRatePlay];
        [HKNSUserDefaults synchronize];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(hkPlayerRateBaseView:)]) {
            [self.delegate hkPlayerRateBaseView:state];
        }
    }
}








@end






