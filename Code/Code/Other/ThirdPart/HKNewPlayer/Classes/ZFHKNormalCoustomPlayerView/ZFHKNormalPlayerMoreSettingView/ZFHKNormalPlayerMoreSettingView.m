//
//  ZFHKNormalPlayerMoreSettingView.m
//  Code
//
//  Created by Ivan li on 2019/3/13.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKNormalPlayerMoreSettingView.h"
#import "HKSwitchBtn.h"



@interface ZFHKNormalPlayerMoreSettingView()<HKSwitchBtnDelegate>

/** Wi-Fi 自动播放 */
@property (nonatomic,strong) UILabel *autoPlayLB;
/** Wi-Fi 自动播放 */
@property (nonatomic,strong) UILabel *rateLB;

@property (nonatomic,strong) HKSwitchBtn *autoSwitch;

@property (nonatomic,strong) HKSwitchBtn *rateSwitch;

@property (nonatomic,strong) UIButton *feedbackBtn;
/** 切换线路 */
@property (nonatomic,strong) UILabel *changeLineLB;
/** 七牛线路 */
@property (nonatomic,strong) UIButton *qiniuLineBtn;
/** 腾讯线路 */
@property (nonatomic,strong) UIButton *txLineBtn;
/** 播放线路 */
@property (nonatomic,assign)NSInteger playLine;

@end


@implementation ZFHKNormalPlayerMoreSettingView


- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    [self addSubview:self.autoPlayLB];
    [self addSubview:self.rateLB];
    [self addSubview:self.autoSwitch];
    [self addSubview:self.rateSwitch];
    [self addSubview:self.feedbackBtn];
    
    [self addSubview:self.changeLineLB];
    [self addSubview:self.qiniuLineBtn];
    [self addSubview:self.txLineBtn];
    
    [self makeConstraints];
    self.playLine = [HKNSUserDefaults integerForKey:HKVideoPlayerPlayLine];
    [self setLineBtnTextColor:self.playLine];
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
    
    [self.changeLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(34);
        make.left.equalTo(self.autoPlayLB);
    }];
    
    [self.qiniuLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeLineLB.mas_bottom).offset(12);
        make.left.equalTo(self.changeLineLB);
        make.size.mas_equalTo(CGSizeMake(60, 22));
    }];
    
    [self.txLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.equalTo(self.qiniuLineBtn);
        make.left.equalTo(self.qiniuLineBtn.mas_right).offset(PADDING_15);
    }];
}



- (UILabel*)autoPlayLB {
    if (!_autoPlayLB) {
        
        NSString *title = @"wifi下自动播放：\n(仅针对无限观看用户)";
        NSString *title1 = @"wifi下自动播放：";
        NSString *title2 = @"(仅针对无限观看用户)";
        NSInteger length = title1.length;
        
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] initWithString:title];
        [attrS addAttribute:NSFontAttributeName value:HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold) range:NSMakeRange(0, length)];
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
        _rateLB.font = HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold);
    }
    return _rateLB;
}



- (UILabel*)changeLineLB {
    if (!_changeLineLB) {
        _changeLineLB = [UILabel labelWithTitle:CGRectZero title:@"切换线路：" titleColor:COLOR_ffffff titleFont:@"14" titleAligment:NSTextAlignmentLeft];
        _changeLineLB.font = HK_FONT_SYSTEM_WEIGHT(13, UIFontWeightSemibold);
    }
    return _changeLineLB;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerMoreSettingView:feedBack:)]) {
        [self.delegate zfHKNormalPlayerMoreSettingView:self feedBack:nil];
        [MobClick event:um_videodetailpage_fulllplayer_settingpage_report];
    }
}



- (UIButton*)qiniuLineBtn {
    if (!_qiniuLineBtn) {
        _qiniuLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qiniuLineBtn setTitle:@"线路一" forState:UIControlStateNormal];
        [_qiniuLineBtn setTitle:@"线路一" forState:UIControlStateHighlighted];
        [_qiniuLineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_qiniuLineBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_qiniuLineBtn setTitleColor:COLOR_FFD305 forState:UIControlStateSelected];
        [_qiniuLineBtn addTarget:self action:@selector(qiniuLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _qiniuLineBtn.size = CGSizeMake(60, 22);
        _qiniuLineBtn.titleLabel.font = HK_FONT_SYSTEM(13);
    }
    return _qiniuLineBtn;
}


- (void)qiniuLineBtnClick:(UIButton*)btn {
    
    [MobClick event:um_videodetailpage_fulllplayer_settingpage_line1];
    if (0 == self.playLine || 1 == self.playLine ) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerMoreSettingView:qiniuLineBtn:)]) {
        [self savePlayLine:1 btn:btn];
        [self.delegate zfHKNormalPlayerMoreSettingView:self qiniuLineBtn:btn];
    }
}


- (UIButton*)txLineBtn {
    if (!_txLineBtn) {
        _txLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_txLineBtn setTitle:@"线路二" forState:UIControlStateNormal];
        [_txLineBtn setTitle:@"线路二" forState:UIControlStateHighlighted];
        [_txLineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_txLineBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_txLineBtn setTitleColor:COLOR_FFD305 forState:UIControlStateSelected];
        [_txLineBtn addTarget:self action:@selector(txLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _txLineBtn.size = CGSizeMake(60, 22);
        _txLineBtn.titleLabel.font = HK_FONT_SYSTEM(13);
    }
    return _txLineBtn;
}



- (void)txLineBtnClick:(UIButton*)btn {
    [MobClick event:um_videodetailpage_fulllplayer_settingpage_line2];
    if (2 == self.playLine) {
        return ;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerMoreSettingView:txLineBtn:)]) {
        [self savePlayLine:2 btn:btn];
        [self.delegate zfHKNormalPlayerMoreSettingView:self txLineBtn:btn];
    }
}


#pragma mark - 记录播放线路
- (void)savePlayLine:(NSInteger)line btn:(UIButton*)btn {
    [HKNSUserDefaults setInteger:line forKey:HKVideoPlayerPlayLine];
    [HKNSUserDefaults synchronize];
    [self setLineBtnTextColor:line];
}



- (void)setLineBtnTextColor:(NSInteger)line {
    self.playLine = line;
    if (0 == self.playLine || 1 == self.playLine ) {
        self.qiniuLineBtn.selected = YES;
        self.txLineBtn.selected = !self.qiniuLineBtn.selected;
        
        [self setShapeLayer:self.qiniuLineBtn strokeColor:COLOR_FFD305];
        [self setShapeLayer:self.txLineBtn strokeColor:[UIColor whiteColor]];
    }else{
        self.txLineBtn.selected = YES;
        self.qiniuLineBtn.selected = !self.txLineBtn.selected;
        
        [self setShapeLayer:self.txLineBtn strokeColor:COLOR_FFD305];
        [self setShapeLayer:self.qiniuLineBtn strokeColor:[UIColor whiteColor]];
    }
}



- (void)setShapeLayer:(UIButton*)btn  strokeColor:(UIColor*)strokeColor {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 60, 22) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(11, 0)];
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame       = CGRectMake(0, 0, 60, 22);
    borderLayer.path        = maskPath.CGPath;
    borderLayer.strokeColor = strokeColor.CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    borderLayer.lineWidth   = 1;
    [btn.layer addSublayer:borderLayer];
}



- (void)switchClick:(UISwitch*)sender {
    
    NSInteger tag = [sender tag];
    if(20 == tag) {
        //自动播放
        NSInteger state = sender.on ?1 :0;
        [HKNSUserDefaults setInteger:state forKey:HKAutoPlay];
        [HKNSUserDefaults synchronize];
        if (state) {
            [MobClick event:um_videodetailpage_fulllplayer_settingpage_wifiopen];
        }else{
            [MobClick event:um_videodetailpage_fulllplayer_settingpage_wificlose];
        }
        
    }else{
        //倍速
        NSInteger state = sender.on ?0 :1;
        [HKNSUserDefaults setInteger:state forKey:HKRatePlay];
        [HKNSUserDefaults synchronize];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPlayerMoreSettingView:state:)]) {
            [self.delegate zfHKNormalPlayerMoreSettingView:self state:state];
        }
        if (state) {
            [MobClick event:um_videodetailpage_fulllplayer_settingpage_speedopen];
        }else{
            [MobClick event:um_videodetailpage_fulllplayer_settingpage_speedclose];
        }
    }
}




/** 销毁 */
- (void)removeSubviews {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(removePlayerAutoPlayConfigView:)]) {
//            [self.delegate removePlayerAutoPlayConfigView:self];
//        }
//    }];
}


/// 隐藏线路
- (void)hiddenChangeLine {
    self.changeLineLB.hidden = YES;
    self.qiniuLineBtn.hidden = YES;
    self.txLineBtn.hidden = YES;
}



@end


