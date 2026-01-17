//
//  HKNextVideoCountDownView.m
//  Code
//
//  Created by Ivan li on 2017/12/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKNextVideoCountDownView.h"
#import <MZTimerLabel/MZTimerLabel.h>

@implementation HKNextVideoCountDownView


- (instancetype)init {
    
    if (self = [super init]) {
        [self setTimeTip];
    }
    return self;
}

- (void)setTimeTip {
    WeakSelf;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.countdownBgView];
    [self.countdownBgView addSubview:self.tipLabel];
    [self.countdownBgView addSubview:self.timeLabel];
    [self.countdownBgView addSubview:self.quitBtn];

    [_countdownBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.countdownBgView);
    }];

    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.countdownBgView);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-PADDING_20);
    }];

    [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.countdownBgView);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(PADDING_20);
        make.size.mas_equalTo(CGSizeMake(PADDING_25*4, PADDING_30));
    }];

    [_timeLabel setCountDownTime:3];
    _timeLabel.endedBlock = ^(NSTimeInterval countTime) {
        [weakSelf killTimerAndNextVideo];
    };
    [_timeLabel start];
}

- (UIView*)countdownBgView {
    if (!_countdownBgView) {
        _countdownBgView = [UIView new];
        _countdownBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }
    return _countdownBgView;
}

- (UILabel*)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithTitle:CGRectZero title:@"即将跳转下一个视频" titleColor:COLOR_ffffff titleFont:@"15" titleAligment:NSTextAlignmentCenter];
    }
    return _tipLabel;
}


- (MZTimerLabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[MZTimerLabel alloc]initWithTimerType:MZTimerLabelTypeTimer];
        _timeLabel.timeFormat = @"s";
        _timeLabel.timeLabel.font = [UIFont systemFontOfSize:15.0f];
        _timeLabel.timeLabel.textColor = COLOR_ffffff;
    }
    return _timeLabel;
}


- (UIButton*)quitBtn {
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithTitle:@"取消" titleColor:COLOR_ffffff titleFont:@"15" imageName:nil];
        _quitBtn.clipsToBounds = YES;
        _quitBtn.layer.cornerRadius = PADDING_15;
        _quitBtn.layer.borderWidth = 1;
        _quitBtn.layer.borderColor = COLOR_ffffff.CGColor;
        [_quitBtn addTarget:self action:@selector(killTimer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}



- (void)killTimer:(UIButton*)btn {
    [MobClick event:UM_RECORD_DETAIL_PAGE_CACLE_NEXT];
    [self killTimer];
}


//关闭 定时器
- (void)killTimer {
    [self.timeLabel pause];
    [self releaseTimeTipView];
    if ([self.delegate respondsToSelector:@selector(playNextVideo:iskillTime:)]) {
        [self.delegate playNextVideo:nil iskillTime:YES];
    }
}


//关闭 定时器  并 播发下一视频
- (void)killTimerAndNextVideo {
    WeakSelf;
    if ([self.delegate respondsToSelector:@selector(playNextVideo:iskillTime:)]) {
        [weakSelf.timeLabel pause];
        [weakSelf releaseTimeTipView];
        [self.delegate playNextVideo:nil iskillTime:NO];
    }
}

- (void)releaseTimeTipView {
    TTVIEW_RELEASE_SAFELY(_timeLabel);
    TTVIEW_RELEASE_SAFELY(_tipLabel);
    TTVIEW_RELEASE_SAFELY(_quitBtn);
    TTVIEW_RELEASE_SAFELY(_countdownBgView);
}



@end
