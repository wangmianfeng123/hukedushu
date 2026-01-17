

//
//  ZFHKNormalPortraitControlView.m
//  ZFHKNormalPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFHKNormalPortraitControlView.h"
#import "UIView+ZFHKNormalFrame.h"
#import "ZFHKNormalUtilities.h"
#import "ZFHKNormalPlayer.h"
#import "NSString+Size.h"
#import "ZFHNomalCustom.h"
#import "UIImage+Helper.h"
#import "UIView+SNFoundation.h"
#import "ZFHKNormalPlayerResolutionView.h"
#import "UIButton+Style.h"
#import "LBLelinkKitManager.h"

@interface ZFHKNormalPortraitControlView () <ZFHKNormalSliderViewDelegate,ZFHKNormalPlayerResolutionViewDelegate,CAAnimationDelegate>
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFHKNormalSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

@property (nonatomic, assign) BOOL isShow;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 切换倍速开关
@property (nonatomic, strong) UIButton *resolutionBtn;

/** 图文按钮 */
@property (nonatomic, strong) UIButton *centerGraphicBtn;
/** 顶部 图文按钮 */
@property (nonatomic, strong) UIButton *topGraphicBtn;
/** 跳转VIP按钮 */
@property (nonatomic, strong) UIButton *bottomVipBtn;
/** 投屏按钮 */
@property (nonatomic, strong) UIButton *airPlayBtn;
/** 音频按钮 */
@property (nonatomic, strong) UIButton *audioBtn;
/// 阴影蒙层
@property (nonatomic,strong) UIView *shadowCoverView;

@property (nonatomic,strong)ZFHKNormalPlayerResolutionView *playerResolutionView;

@property (nonatomic,assign) BOOL isHiddenPlayerResolutionView;

/** 快进按钮 */
@property (nonatomic, strong) UIButton *fastPlayBtn;
/** 快进按钮 */
@property (nonatomic, strong) UIButton *backPlayBtn;

@property (nonatomic, strong) UILabel *forwardLB;

@property (nonatomic,assign) BOOL isNeedLayout;

@end


@implementation ZFHKNormalPortraitControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.shadowCoverView];
        [self addSubview:self.topToolView];
        [self addSubview:self.bottomToolView];
        //[self addSubview:self.playOrPauseBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        
        [self.topToolView addSubview:self.resolutionBtn];
        [self.topToolView addSubview:self.topGraphicBtn];
        
        [self addSubview:self.centerGraphicBtn];
        [self.topToolView addSubview:self.backBtn];
        [self addSubview:self.bottomVipBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        self.clipsToBounds = YES;
        
        [self.topToolView addSubview:self.airPlayBtn];
        [self.topToolView addSubview:self.audioBtn];
        
        [self addSubview:self.fastPlayBtn];
        [self addSubview:self.backPlayBtn];
        
        [self resetControlView];
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ZFHKNormalSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
            }
            self.slider.isdragging = NO;
        }];
        if (self.seekToPlay) {
            [self.player.currentPlayerManager play];
        }
    } else {
        self.slider.isdragging = NO;
    }
    if (self.sliderValueChanged) self.sliderValueChanged(value);
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFHKNormalUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            //            if (finished) {
            //                [self.player.currentPlayerManager play];
            //            }
            if (self.seekToPlay) {
                [self.player.currentPlayerManager play];
            }
            self.slider.isdragging = NO;
        }];
        // v2.18
        if (self.sliderValueChanged) self.sliderValueChanged(value);
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

#pragma mark - action

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

- (void)fullScreenButtonClickAction:(UIButton *)sender {
    if(IS_IPAD){
        [self.player enterPortraitFullScreen:YES animated:YES];
    }else{
        [self.player enterFullScreen:YES animated:YES];
    }
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
    [self lbPlayOrPause];
}



- (void)lbPlayOrPause {
    if ([LBLelinkKitManager sharedManager].isLBlink) {
        if ([[LBLelinkKitManager sharedManager].videoUrl isEqualToString:self.permissionModel.video_url]) {
            if (LBLelinkPlayStatusPlaying == [LBLelinkKitManager sharedManager].currentPlayStatus) {
                if (NO ==  self.playOrPauseBtn.isSelected) {
                    [[LBLelinkKitManager sharedManager].lelinkPlayer pause];
                }else{
                    //[[LBLelinkKitManager sharedManager].lelinkPlayer resumePlay];
                }
            } else {
                if (YES ==  self.playOrPauseBtn.isSelected) {
                    [[LBLelinkKitManager sharedManager].lelinkPlayer resumePlay];
                }
            }
        }
    }
}


- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

#pragma mark - 添加子控件约束

- (void)makeSubviews {
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 70;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_h = 65;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_y = (iPhoneX) ? 15: 35;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topToolView.mas_top).offset(min_y);
        make.left.equalTo(self.topToolView).offset(30);
    }];
    
    [self.centerGraphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.size.mas_equalTo(CGSizeMake(106, 34));
    }];
    
    // topToolView
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topToolView.mas_left).offset(50);
        make.centerY.equalTo(self.resolutionBtn);
        make.width.mas_lessThanOrEqualTo(280);
    }];
    
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topToolView.mas_right).offset(-15);
        make.centerY.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(36, 17));
    }];
    
    [self.topGraphicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resolutionBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.backBtn);
    }];
    
    
    // bottomToolView
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomToolView);
        make.left.equalTo(self.bottomToolView).offset(15);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playOrPauseBtn.mas_right).offset(10);
        make.centerY.equalTo(self.playOrPauseBtn);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomToolView.mas_right).offset(-15);
        make.centerY.equalTo(self.playOrPauseBtn);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.playOrPauseBtn);
    }];
    
    [self.bottomVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(81, 25));
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playOrPauseBtn.mas_centerY);
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(10);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    self.shadowCoverView.frame = self.bounds;
    
    self.fastPlayBtn.centerY = self.centerY;
    self.fastPlayBtn.x = self.width - 46 -46;
    
    self.backPlayBtn.centerY = self.centerY;
    self.backPlayBtn.x = 46;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeSubviews];
    
    if (!self.isShow) {
        self.topToolView.y = -self.topToolView.height;
        self.bottomToolView.y = self.height;
    } else {
        self.topToolView.y = 0;
        self.bottomToolView.y = self.height - self.bottomToolView.height;
    }
    
    [self.airPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.resolutionBtn);
        make.right.equalTo(self.audioBtn.mas_left).offset(-15);
    }];
    
    [self.audioBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.resolutionBtn);
        if (isEmpty(self.videoDetailModel.pictext_url)) {
            make.right.equalTo(self.resolutionBtn.mas_left).offset(-15);
        }else{
            make.right.equalTo(self.topGraphicBtn.mas_left).offset(-15);
        }
    }];
}

#pragma mark -

/** 重置ControlView */
- (void)resetControlView {
    self.bottomToolView.alpha        = 1;
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    
    self.centerGraphicBtn.hidden = YES;
    self.topGraphicBtn.hidden = YES;
    self.bottomVipBtn.hidden = YES;
    
    self.permissionModel = nil;
    self.videoDetailModel = nil;
    
    self.shadowCoverView.hidden = NO;
    self.fastPlayBtn.hidden = YES;
    self.backPlayBtn.hidden = YES;
    self.isNeedLayout = NO;
    
    if (_playerResolutionView) {
        _playerResolutionView.hidden = YES;
    }
}

- (void)showControlView {
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = YES;
    self.topToolView.zf_y            = 0;
    self.bottomToolView.zf_y         = self.zf_height - self.bottomToolView.zf_height;
    self.playOrPauseBtn.alpha        = 1;
    self.player.statusBarHidden      = NO;
    
    self.centerGraphicBtn.hidden = YES;
    if (!isEmpty(self.videoDetailModel.pictext_url)) {
        self.topGraphicBtn.hidden = NO;
    }
    self.shadowCoverView.hidden = NO;
    self.fastPlayBtn.hidden = NO;
    self.backPlayBtn.hidden = NO;
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = NO;
    self.playOrPauseBtn.alpha        = 0;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    
    self.shadowCoverView.hidden = YES;
    self.fastPlayBtn.hidden = YES;
    self.backPlayBtn.hidden = YES;
    [self hiddenForwardLB];
}


- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFHKNormalPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    
    if (_playerResolutionView) {
        CGRect sliderRect = [self convertRect:_playerResolutionView.frame toView:self];
        if (CGRectContainsPoint(sliderRect, point)) {
            return NO;
        }else{
            if (!self.isHiddenPlayerResolutionView) {
                [self hiddenPlayerResolutionView];
                self.isHiddenPlayerResolutionView = YES;
            }
        }
    }
    
    if (type == ZFHKNormalPlayerGestureTypePan) {
        return NO;
    }
    
    if(NO == _fastPlayBtn.hidden) {
        if (touch.view == _fastPlayBtn || touch.view == _backPlayBtn) {
            return NO;
        }
    }
    return YES;
}


- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    //    if (!self.slider.isdragging) {
    NSString *currentTimeString = [ZFHKNormalUtilities convertTimeSecond:currentTime];
    self.currentTimeLabel.text = currentTimeString;
    NSString *totalTimeString = [ZFHKNormalUtilities convertTimeSecond:totalTime];
    self.totalTimeLabel.text = totalTimeString;
    self.slider.value = videoPlayer.progress;
    //    }
    
    [self hiddenPortraitCenterGraphicBtn];
}

- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFHKNormalFullScreenMode)fullScreenMode {
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        //UIImage *image = ZFHKNormalPlayer_Image(@"ZFPlayer_top_shadow");
        //_topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        //UIImage *image = ZFHKNormalPlayer_Image(@"ZFPlayer_bottom_shadow");
        //_bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:imageName(@"ic_start_v2_19") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:imageName(@"hkplayer_stop_v2_19") forState:UIControlStateSelected];
        [_playOrPauseBtn setHKEnlargeEdge:30];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        //_currentTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _currentTimeLabel.font = HK_TIME_FONT(10);
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_currentTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _currentTimeLabel;
}

- (ZFHKNormalSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFHKNormalSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _slider.bufferTrackTintColor  = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
        _slider.minimumTrackTintColor = HKColorFromHex(0xFFD305, 1.0);
        [_slider setThumbImage:imageName(@"hkplayer_slider_v2_19") forState:UIControlStateNormal];
        _slider.sliderHeight = 3;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = HK_TIME_FONT(10);
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_totalTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:imageName(@"hkplayer_fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setHKEnlargeEdge:30];
    }
    return _fullScreenBtn;
}


- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setHKEnlargeEdge:30];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}


- (void)backButtonClickAction:(UIButton*)sender {
    //    if (self.portraitBackBtnClickCallback) {
    //        self.portraitBackBtnClickCallback();
    //    }
}


- (UIButton*)centerGraphicBtn {
    if (!_centerGraphicBtn) {
        _centerGraphicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerGraphicBtn addTarget:self action:@selector(centerGraphicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _centerGraphicBtn.hidden = YES;
        _centerGraphicBtn.size = CGSizeMake(106, 34);
        //[_centerGraphicBtn sizeToFit];
        
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
        UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(106, 34) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromTopToBottom];
        
        _centerGraphicBtn.titleLabel.font = HK_FONT_SYSTEM_WEIGHT(16, UIFontWeightSemibold);
        [_centerGraphicBtn setTitle:@"图文教程" forState:UIControlStateNormal];
        [_centerGraphicBtn setTitle:@"图文教程" forState:UIControlStateHighlighted];
        [_centerGraphicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_centerGraphicBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
        
        [_centerGraphicBtn setImage:imageName(@"arrow_right_white") forState:UIControlStateNormal];
        [_centerGraphicBtn setImage:imageName(@"arrow_right_white") forState:UIControlStateHighlighted];
        
        [_centerGraphicBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_centerGraphicBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        [_centerGraphicBtn setBackgroundImage:image forState:UIControlStateSelected];
        
        [_centerGraphicBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [_centerGraphicBtn setRoundedCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft radius:17];
    }
    return _centerGraphicBtn;
}


- (void)centerGraphicBtnClick:(UIButton*)sender {
    if (self.portraitGraphicBtnClickCallback) {
        self.portraitGraphicBtnClickCallback(sender, YES,self.videoDetailModel.pictext_url);
    }
}


- (UIButton*)topGraphicBtn {
    if (!_topGraphicBtn) {
        _topGraphicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topGraphicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topGraphicBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11];
        
        [_topGraphicBtn setImage:imageName(@"hkplayer_pic_v2_15") forState:UIControlStateNormal];
        [_topGraphicBtn setImage:imageName(@"hkplayer_pic_v2_15") forState:UIControlStateHighlighted];
        
        [_topGraphicBtn addTarget:self action:@selector(topGraphicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topGraphicBtn setEnlargeEdgeWithTop:25 right:10 bottom:5 left:25];
        [_topGraphicBtn sizeToFit];
        _topGraphicBtn.hidden = YES;
    }
    return _topGraphicBtn;
}


- (void)topGraphicBtnClick:(UIButton*)sender {
    if (self.portraitGraphicBtnClickCallback) {
        self.portraitGraphicBtnClickCallback(sender, NO,self.videoDetailModel.pictext_url);
        [MobClick event:um_videodetailpage_smallplayer_graphic];
    }
}


/** 显示顶部图文按钮 */
- (void)portraitShowTopGraphicBtn {
    self.centerGraphicBtn.hidden = YES;
    self.topGraphicBtn.hidden = NO;
}


- (void)portraitShowCenterGraphicBtn {
    //    self.centerGraphicBtn.hidden = NO;
}

- (UIButton*)bottomVipBtn {
    
    if (!_bottomVipBtn) {
        _bottomVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomVipBtn setTitle:@"超值充值VIP" forState:UIControlStateNormal];
        [_bottomVipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomVipBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
        _bottomVipBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [_bottomVipBtn addTarget:self action:@selector(bottomVipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomVipBtn sizeToFit];
        [_bottomVipBtn setHKEnlargeEdge:30];
        _bottomVipBtn.hidden = YES;
        
        [_bottomVipBtn setImage:imageName(@"arrow_right_white") forState:UIControlStateNormal];
        [_bottomVipBtn setImage:imageName(@"arrow_right_white") forState:UIControlStateHighlighted];
        [_bottomVipBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        
        UIImage *image = [UIImage createImageWithColor:[COLOR_000000 colorWithAlphaComponent:0.4] size:CGSizeMake(81, 25)];
        [_bottomVipBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_bottomVipBtn setBackgroundImage:image forState:UIControlStateHighlighted];
        _bottomVipBtn.layer.cornerRadius = 5;
        _bottomVipBtn.clipsToBounds = YES;
    }
    return _bottomVipBtn;
}

- (void)bottomVipBtnClick:(UIButton*)btn {
    if (self.portraitVipBtnClickCallback) {
        self.portraitVipBtnClickCallback(btn);
    }
}


- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:isHiddenView:) forControlEvents:UIControlEventTouchUpInside];
        
        [_resolutionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resolutionBtn setTitleColor:COLOR_27323F forState:UIControlStateSelected];
        [_resolutionBtn setEnlargeEdgeWithTop:PADDING_25 right:PADDING_15 bottom:0 left:PADDING_10];
        
        NSString *title = [ZFHKNormalPlayerPlayRate normalPlayerPlayRate];
        [_resolutionBtn setTitle:title forState:UIControlStateNormal];
        CGRect rect = CGRectMake(0, 0, 36, 17);
        [_resolutionBtn setRoundedCorners:UIRectCornerAllCorners radius:0 rect:rect lineWidth:1.5];
    }
    return _resolutionBtn;
}




- (UIButton *)airPlayBtn {
    if (!_airPlayBtn) {
        _airPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_airPlayBtn setBackgroundImage:imageName(@"hkplay_airplay_tv") forState:UIControlStateNormal];
        [_airPlayBtn setBackgroundImage:imageName(@"hkplay_airplay_tv") forState:UIControlStateSelected];
        [_airPlayBtn addTarget:self action:@selector(airPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_airPlayBtn setHKEnlargeEdge:30];
    }
    return _airPlayBtn;
}


- (void)airPlayBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPortraitControlView:airPlayBtn:)]) {
        [self.delegate zfHKNormalPortraitControlView:self airPlayBtn:btn];
        [MobClick event:um_videodetailpage_smallplayer_caststreen];
    }
}


- (UIButton *)audioBtn {
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioBtn setBackgroundImage:imageName(@"hkplayer_audio_v2.15") forState:UIControlStateNormal];
        [_audioBtn setBackgroundImage:imageName(@"hkplayer_audio_v2.15") forState:UIControlStateSelected];
        [_audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_audioBtn setHKEnlargeEdge:10];
    }
    return _audioBtn;
}


- (void)audioBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPortraitControlView:audioBtn:)]) {
        [self.delegate zfHKNormalPortraitControlView:self audioBtn:btn];
        [MobClick event:um_videodetailpage_smallplayer_audio];
    }
}

/** isHiddenView yes - 点击播放界面 隐藏分辨率View  */
- (void)resolutionBtnClick:(UIButton *)sender isHiddenView:(BOOL)isHiddenView {
    //sender.selected = !sender.selected;
    [self showPlayerResolutionView];
    //友盟倍速统计事件
    [MobClick event:um_videodetailpage_smallplayer_speed];
}

/**
 *  同步全屏点击切换分别率按钮
 */
- (void)changeResolutionCurrent:(NSInteger)index {
    
    NSString *title = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateWithIndex:index];
    [self.resolutionBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - -- 虎课自定义部分
- (void)setPermissionModel:(HKPermissionVideoModel *)permissionModel {
    _permissionModel = permissionModel;
    if ([permissionModel.is_vip isEqualToString:@"0"] ) {
        //self.bottomVipBtn.hidden = NO;
    }
}

- (void)setVideoDetailModel:(DetailModel *)videoDetailModel {
    _videoDetailModel = videoDetailModel;
    if (!isEmpty(videoDetailModel.pictext_url)) {
        //        self.centerGraphicBtn.hidden = NO;
    }
    
    if (videoDetailModel) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}


- (void)hiddenPortraitCenterGraphicBtn {
    self.centerGraphicBtn.hidden = YES;
}



- (void)showPortraitControlViewAirPlayBtn:(BOOL)hidden {
    self.airPlayBtn.hidden = hidden;
    self.audioBtn.hidden = hidden;
}



- (UIView*)shadowCoverView {
    if (!_shadowCoverView) {
        _shadowCoverView = [UIView new];
        _shadowCoverView.backgroundColor = [UIColor blackColor];
        _shadowCoverView.alpha = 0.3;
    }
    return _shadowCoverView;
}


- (void)showPortraitShadowCoverView {
    if (_shadowCoverView) {
        _shadowCoverView.hidden = NO;
    }
}


- (ZFHKNormalPlayerResolutionView*)playerResolutionView {
    if (!_playerResolutionView) {
        _playerResolutionView = [[ZFHKNormalPlayerResolutionView alloc]initWithIsportrait:YES];
        _playerResolutionView.hidden = YES;
        _playerResolutionView.delegate = self;
        _playerResolutionView.tag = 200;
    }
    return _playerResolutionView;
}


- (void)showPlayerResolutionView {
    
    NSString *text = self.resolutionBtn.titleLabel.text;
    NSInteger index = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateIndexWithRateStr:text];
    
    [self removePlayerResolutionView];
    self.playerResolutionView.hidden = NO;
    [self.playerResolutionView selectResolutionWithRateIndex:index];
    
    CGFloat min_view_h = self.height;
    CGFloat min_view_w = self.width;
    CGFloat min_w = 100;
    self.playerResolutionView.frame = CGRectMake(min_view_w, 0, min_w, min_view_h);
    [self addSubview:self.playerResolutionView];
    [UIView animateWithDuration:0.2 animations:^{
        self.playerResolutionView.zf_x = min_view_w - min_w;
    }];
}

- (void)hiddenPlayerResolutionView {
    if (_playerResolutionView) {
        [UIView animateWithDuration:0.3 animations:^{
            _playerResolutionView.zf_x = self.zf_width;
        } completion:^(BOOL finished) {
            [self removePlayerResolutionView];
        }];
    }
}


- (void)removePlayerResolutionView {
    self.isHiddenPlayerResolutionView = NO;
    TTVIEW_RELEASE_SAFELY(_playerResolutionView);
}


////ZFHKNormalPlayerResolutionViewDelegate
- (void)zFHKNormalPlayerResolutionView:(nullable UIView*)view resolutionBtn:(UIButton*)resolutionBtn {
    [self.resolutionBtn setTitle:resolutionBtn.titleLabel.text forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(zfHKNormalPortraitControlView: resolutionBtn: rate: index:)]) {
        [ZFHKNormalPlayerPlayRate saveNormalPlayerPlayRate:(resolutionBtn.tag - 200)+1];
        // 这里开启倍速功能
        CGFloat rate = ((resolutionBtn.tag - 200) * 0.25) + 0.75;
        if (rate > 2.0) rate = 3.0;
        //CGFloat rate = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateFloat];
        [self.delegate zfHKNormalPortraitControlView:self resolutionBtn:resolutionBtn rate:rate index:(resolutionBtn.tag - 200)];
        [self umRateEvent:resolutionBtn.tag - 200];
    }
}


/// 友盟统计
- (void)umRateEvent:(NSInteger)index {
    switch (index) {
        case 0:
            [MobClick event:um_videodetailpage_smalllplayer_speed0_75];
            break;
        case 1:
            [MobClick event:um_videodetailpage_smalllplayer_speed1_0X];
            break;
        case 2:
            [MobClick event:um_videodetailpage_smalllplayer_speed1_25X];
            break;
        case 3:
            [MobClick event:um_videodetailpage_smalllplayer_speed1_5X];
            break;
        case 4:
            [MobClick event:um_videodetailpage_smalllplayer_speed2_0X];
            break;
        default:
            break;
    }
}

- (UILabel*)forwardLB {
    if (!_forwardLB) {
        _forwardLB = [UILabel labelWithTitle:CGRectZero title:@"+5s" titleColor:[UIColor whiteColor] titleFont:nil titleAligment:NSTextAlignmentCenter];
        _forwardLB.font = HK_FONT_SYSTEM_WEIGHT(25, UIFontWeightSemibold);
        _forwardLB.backgroundColor = [UIColor clearColor];
        _forwardLB.hidden = YES;
    }
    return _forwardLB;
}

- (UIButton *)fastPlayBtn {
    if (!_fastPlayBtn) {
        _fastPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fastPlayBtn setImage:imageName(@"hkplayer_goon_v2_19") forState:UIControlStateNormal];
        [_fastPlayBtn setImage:imageName(@"hkplayer_goon_v2_19") forState:UIControlStateHighlighted];
        [_fastPlayBtn addTarget:self action:@selector(fastPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fastPlayBtn.hidden = YES;
        [_fastPlayBtn sizeToFit];
        [_fastPlayBtn setHKEnlargeEdge:20];
    }
    return _fastPlayBtn;
}

- (UIButton *)backPlayBtn {
    if (!_backPlayBtn) {
        _backPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backPlayBtn setImage:imageName(@"hkplayer_goback_v2_19") forState:UIControlStateNormal];
        [_backPlayBtn setImage:imageName(@"hkplayer_goback_v2_19") forState:UIControlStateHighlighted];
        [_backPlayBtn addTarget:self action:@selector(backPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _backPlayBtn.hidden = YES;
        [_backPlayBtn sizeToFit];
        [_backPlayBtn setHKEnlargeEdge:20];
    }
    return _backPlayBtn;
}

- (void)fastPlayBtnClick:(UIButton*)btn {
    if (self.portraitFastForwardBtnClickCallback) {
        [self showForwardLB:NO];
        self.portraitFastForwardBtnClickCallback(btn);
        [MobClick event:um_videodetailpage_smallplayer_fast5];
    }
}

- (void)backPlayBtnClick:(UIButton*)btn {
    if (self.portraitBackForwardBtnClickCallback) {
        [self showForwardLB:YES];
        self.portraitBackForwardBtnClickCallback(btn);
        [MobClick event:um_videodetailpage_smallplayer_return5];
    }
}

- (void)showForwardLB:(BOOL)isBack {
    
    [self immediateHiddenForwardLB];
    if (nil == _forwardLB) {
        [self addSubview:self.forwardLB];
    }
    
    self.forwardLB.text = isBack ?@"-5s" :@"+5s";
    self.forwardLB.size = CGSizeMake(70, 40);
    self.forwardLB.center = self.center;
    [self.forwardLB setNeedsLayout];
    [self.forwardLB layoutIfNeeded];
    
    [self forwardLBOpacityAnimation];
}

- (void)immediateHiddenForwardLB {
    if (_forwardLB) {
        [_forwardLB.layer removeAllAnimations];
    }
}

- (void)hiddenForwardLB {
    if (_forwardLB) {
        _forwardLB.hidden = YES;
        TTVIEW_RELEASE_SAFELY(_forwardLB);
    }
}

- (void)forwardLBOpacityAnimation  {
    // 透明动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.f];
    animation.removedOnCompletion = YES;
    animation.duration = 1.5;
    animation.delegate = self;
    if (_forwardLB) {
        [_forwardLB.layer addAnimation:animation forKey:@"opacity"];
        _forwardLB.layer.opacity = 0.0;
        _forwardLB.hidden = NO;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self hiddenForwardLB];
}

- (void)showOrhiddenTopToolView:(BOOL)isShow {
    self.topToolView.hidden = !isShow;
}

- (void)dealloc {
    [self immediateHiddenForwardLB];
    TTVIEW_RELEASE_SAFELY(_forwardLB);
}

@end


