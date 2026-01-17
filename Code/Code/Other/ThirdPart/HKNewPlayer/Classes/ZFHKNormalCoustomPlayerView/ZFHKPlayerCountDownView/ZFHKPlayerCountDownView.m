//
//  ZFHKPlayerCountDownView.m
//  Code
//
//  Created by Ivan li on 2019/3/17.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKPlayerCountDownView.h"
#import <MZTimerLabel/MZTimerLabel.h>
#import "UIView+SNFoundation.h"

@interface ZFHKPlayerCountDownView()<MZTimerLabelDelegate>

@end



@implementation ZFHKPlayerCountDownView


- (instancetype)init {
    if (self = [super init]) {
        [self setNextUI];
    }
    return self;
}


- (void)setNextUI {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.countdownBgView];
    [self.countdownBgView addSubview:self.iconImageView];
    [self.countdownBgView addSubview:self.nextLabel];
    [self.countdownBgView addSubview:self.timeLabel];
    
    [self.countdownBgView addSubview:self.titleLabel];
    [self.countdownBgView addSubview:self.lookNowBtn];
    [self.countdownBgView addSubview:self.backBtn];
    [self.countdownBgView addSubview:self.repeatBtn];
    
    WeakSelf;
    [self.timeLabel setCountDownTime:3];
    self.timeLabel.endedBlock = ^(NSTimeInterval countTime) {
        [weakSelf killTimerAndNextVideo];
    };
    [self.timeLabel start];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [self nextUIConstraints];
}



- (void)nextUIConstraints {
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    BOOL isLandscape;
//    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//        isLandscape = YES;
//    }else {
//        isLandscape = NO;
//    }
    

    
    [self.countdownBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0, *)) {
            make.top.equalTo(self.countdownBgView.mas_safeAreaLayoutGuideTop).offset(15);
            make.left.equalTo(self.countdownBgView.mas_safeAreaLayoutGuideLeft).offset(15);
        }else{
            make.top.equalTo(self.countdownBgView.mas_top).offset(25);
            make.left.equalTo(self.countdownBgView).offset(15);
        }
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.countdownBgView);
    }];
    
    [self.nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        if(@available(iOS 11.0, *)) {
//            make.centerY.equalTo(self.mas_centerY).offset(-35);
//            make.left.equalTo(self.countdownBgView.mas_safeAreaLayoutGuideLeft).offset(PADDING_30);
//        }else{
//            make.centerY.equalTo(self.mas_centerY).offset(-35);
//            make.left.equalTo(self.countdownBgView).offset(PADDING_30);
//        }
        make.left.equalTo(self.iconImageView);
        make.bottom.equalTo(self.iconImageView.mas_top).offset(-PADDING_10);
    }];
    
    
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.left.equalTo(self.nextLabel);
//        //make.top.equalTo(self.nextLabel.mas_bottom).offset(PADDING_10);
//        if (self.isFullScreen) {
//                make.left.equalTo(self).offset(SCREEN_HEIGHT * 0.5 -150);
//                make.top.equalTo(self).offset(SCREEN_WIDTH * 0.5 - 40);
//            });
//
//        }else{
//            make.left.equalTo(self).offset(SCREEN_WIDTH * 0.5-150);
//            make.top.equalTo(self).offset(100);
//        }
//
//        if (IS_IPHONE5S) {
//            make.size.mas_equalTo(CGSizeMake(80, 80));
//        }else{
//            make.size.mas_equalTo(CGSizeMake(130, 80));
//        }
//    }];
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.nextLabel);
        //make.top.equalTo(self.nextLabel.mas_bottom).offset(PADDING_10);
        if (self.isFullScreen) {
                make.left.equalTo(self).offset(SCREEN_WIDTH * 0.5 -150);
                make.top.equalTo(self).offset(SCREEN_HEIGHT * 0.5 - 40);
        }else{
            make.left.equalTo(self).offset(SCREEN_WIDTH * 0.5-160);
            make.top.equalTo(self).offset(self.height * 0.5 - 40);
        }
        
        if (IS_IPHONE5S) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }else{
            make.size.mas_equalTo(CGSizeMake(130, 80));
        }
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(25/2);
        make.top.equalTo(self.iconImageView).offset(15);
        if (self.isFullScreen) {
            make.width.mas_lessThanOrEqualTo(250);
        }else{
            make.width.mas_lessThanOrEqualTo(200);
        }
        
        //make.right.lessThanOrEqualTo(@200);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lookNowBtn.mas_right).offset(PADDING_25);
        make.centerY.equalTo(self.lookNowBtn);
    }];
    
    [self.lookNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        make.left.equalTo(self.titleLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
}



- (UIView*)countdownBgView {
    if (!_countdownBgView) {
        _countdownBgView = [UIView new];
        _countdownBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }
    return _countdownBgView;
}


- (UIImageView*)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        if (IS_IPHONE5S) {
            _iconImageView.contentMode = UIViewContentModeScaleToFill;
        }else{
            _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_5;
        //_iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}



- (UILabel*)nextLabel {
    if (!_nextLabel) {
        _nextLabel = [UILabel labelWithTitle:CGRectZero title:@"下一节" titleColor:COLOR_ffffff titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _nextLabel .font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
    }
    return _nextLabel;
}


- (MZTimerLabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[MZTimerLabel alloc]initWithTimerType:MZTimerLabelTypeTimer];
        _timeLabel.timeFormat = @"s";
        _timeLabel.delegate = self;
        _timeLabel.hidden = YES;
    }
    return _timeLabel;
}

- (void)timerLabel:(MZTimerLabel *)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType {
    
    NSString *title = [NSString stringWithFormat:@"立即播放 (%.fs)",time];
    [self.lookNowBtn setTitle:title forState:UIControlStateNormal];
    [self.lookNowBtn setTitle:title forState:UIControlStateHighlighted];
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_ffffff titleFont:@"15" titleAligment:NSTextAlignmentLeft];
        _titleLabel .font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
    }
    return _titleLabel;
}


- (UIButton*)lookNowBtn {
    if(!_lookNowBtn){
        _lookNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookNowBtn.titleLabel.font = HK_FONT_SYSTEM_WEIGHT(14, UIFontWeightBold);
        [_lookNowBtn setBackgroundColor:[UIColor clearColor]];
        [_lookNowBtn setTitle:@"立即播放" forState:UIControlStateNormal];
        [_lookNowBtn setTitle:@"立即播放" forState:UIControlStateHighlighted];
        [_lookNowBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [_lookNowBtn setTitleColor:COLOR_ffffff forState:UIControlStateSelected];
        [_lookNowBtn addTarget:self action:@selector(lookNowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 120, 30) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(15, 0)];
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame       = CGRectMake(0, 0, 120, 30);
        borderLayer.path        = maskPath.CGPath;
        borderLayer.strokeColor  = COLOR_ffffff.CGColor;
        borderLayer.fillColor   = [UIColor clearColor].CGColor;
        borderLayer.lineWidth   = 1;
        [_lookNowBtn.layer addSublayer:borderLayer];
    }
    return _lookNowBtn;
}


- (void)lookNowBtnClick:(UIButton*)btn {
    [self killTimerAndNextVideo];
    if (self.isFullScreen) {
        [MobClick event:um_videodetailpage_fulllplayer_nextvideo];
    }else{
        [MobClick event:um_videodetailpage_smallplayer_nextvideo];
    }
}



- (UIButton*)repeatBtn {
    
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repeatBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_repeatBtn setBackgroundColor:[UIColor clearColor]];
        [_repeatBtn setTitle:@"重播" forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
        [_repeatBtn setImage:imageName(@"hkplayer_reset") forState:UIControlStateNormal];
        [_repeatBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_repeatBtn setHKEnlargeEdge:45];
    }
    return _repeatBtn;
}


- (void)repeatBtnClick:(UIButton*)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playNextVideo:repeatBtn:)]) {
        [self.delegate playNextVideo:self repeatBtn:btn];
    }
    
    if (self.isFullScreen) {
        [MobClick event:um_videodetailpage_fulllplayer_replay];
    }else{
        [MobClick event:um_videodetailpage_smallplayer_replay];
    }
}




- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setHKEnlargeEdge:50];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}


- (void)backBtnClickAction:(UIButton*)btn {
    if (self.backActionBlock) {
        self.backActionBlock();
    }
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
    TTVIEW_RELEASE_SAFELY(_nextLabel);
    TTVIEW_RELEASE_SAFELY(_backBtn);
    TTVIEW_RELEASE_SAFELY(_titleLabel);
    
    TTVIEW_RELEASE_SAFELY(_lookNowBtn);
    TTVIEW_RELEASE_SAFELY(_repeatBtn);
    TTVIEW_RELEASE_SAFELY(_iconImageView);
    TTVIEW_RELEASE_SAFELY(_countdownBgView);
}


- (void)setDetailModel:(DetailModel *)detailModel {
    
    self.titleLabel.text = detailModel.next_video_info.title;
    [self.iconImageView sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:detailModel.next_video_info.cover]) placeholderImage:HK_PlaceholderImage];
}


- (void)dealloc {
    if (_timeLabel.counting) {
        [_timeLabel pause];
    }
    [self releaseTimeTipView];
}


@end




@implementation ZFHKPlayerEndView



- (instancetype)init {
    if (self = [super init]) {
        [self setPlayEndUI];
    }
    return self;
}

- (void)setPlayEndUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.countdownBgView];
    [self.countdownBgView addSubview:self.backBtn];
    [self.countdownBgView addSubview:self.iconImageView];
    [self.countdownBgView addSubview:self.titleLabel];
    [self.countdownBgView addSubview:self.repeatBtn];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self playEndUIConstraints];
}


- (void)playEndUIConstraints {
    [self.countdownBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if(@available(iOS 11.0, *)) {
            make.top.equalTo(self.countdownBgView.mas_safeAreaLayoutGuideTop).offset(15);
            make.left.equalTo(self.countdownBgView.mas_safeAreaLayoutGuideLeft).offset(15);
        }else{
            make.top.equalTo(self.countdownBgView.mas_top).offset(25);
            make.left.equalTo(self.countdownBgView).offset(15);
        }
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.countdownBgView);
        //make.top.equalTo(self.backBtn.mas_bottom).offset(30);
        make.centerY.equalTo(self.countdownBgView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.countdownBgView);
        make.left.right.equalTo(self.countdownBgView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.countdownBgView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
    }];
}



- (UIView*)countdownBgView {
    if (!_countdownBgView) {
        _countdownBgView = [UIView new];
        _countdownBgView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
    }
    return _countdownBgView;
}


- (UIImageView*)iconImageView {
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = PADDING_5;
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.image = imageName(@"hkplayer_video_end_v2_17");
    }
    return _iconImageView;
}


- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTitle:CGRectZero title:@"恭喜完成该课程" titleColor:COLOR_ffffff titleFont:@"15" titleAligment:NSTextAlignmentCenter];
        _titleLabel .font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
    }
    return _titleLabel;
}



- (UIButton*)repeatBtn {
    
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repeatBtn.titleLabel.font = HK_FONT_SYSTEM(14);
        [_repeatBtn setBackgroundColor:[UIColor clearColor]];
        [_repeatBtn setTitle:@"重播" forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.7] forState:UIControlStateSelected];
        [_repeatBtn setImage:imageName(@"hkplayer_reset") forState:UIControlStateNormal];
        [_repeatBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_repeatBtn setHKEnlargeEdge:45];
    }
    return _repeatBtn;
}


- (void)repeatBtnClick:(UIButton*)btn {
    if (self.repeatActionBlock) {
        self.repeatActionBlock(self);
    }
}


- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setHKEnlargeEdge:45];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}


- (void)backBtnClickAction:(UIButton*)btn {
    if (self.backActionBlock) {
        self.backActionBlock();
    }
}


- (void)setDetailModel:(DetailModel *)detailModel {
    
//    self.titleLabel.text = detailModel.video_titel;
//    [self.iconImageView sd_setImageWithURL:HKURL(detailModel.img_cover_url) placeholderImage:HK_PlaceholderImage];
}



@end

