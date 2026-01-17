//
//  HKPlayBackLandScapeControlView.m
//  ZFPlayer
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

#import "HKPlayBackLandScapeControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import <ZFPlayer/ZFPlayer.h>
#import "UIView+SNFoundation.h"

@interface HKPlayBackLandScapeControlView () <ZFSliderViewDelegate>

/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;

@property (nonatomic, assign) BOOL isShow;

/// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

/** 投屏按钮 */
@property (nonatomic, strong) UIButton *airPlayBtn;

//自定义
/** 倍速 ***********/
@property (nonatomic, strong) NSArray *resolutionArray;
/** 倍速的View */
@property (nonatomic, strong) UIView *resolutionView;
/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton *resoultionCurrentBtn;

@property (atomic, assign)BOOL isFirst;

@property (nonatomic, strong)CAShapeLayer *borderLayer;

/// 切换倍速开关
@property (nonatomic, strong) UIButton *resolutionBtn;
/** 倍速 ***********/

@end

@implementation HKPlayBackLandScapeControlView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    HK_NOTIFICATION_REMOVE();
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.resolutionBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self.topToolView addSubview:self.airPlayBtn];
        
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.fullScreenBtn];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self addSubview:self.lockBtn];
        
        // 倍速
        NSArray *resolutionArray = @[@"0.75x", @"1.0x", @"1.25x", @"1.5x", @"2.0x",@"3.0x"];
        [self hk_playerResolutionArray:resolutionArray];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];
        
        // 添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenSetSameIJKPlayerRateNotification:) name:@"SetSameIJKPlayerRate0" object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = iPhoneX ? 110 : 80;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: 15;
    min_y = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 15: (iPhoneX ? 40 : 20);
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    // 倍速按钮
    self.resolutionBtn.size = IS_IPHONE6PLUS ?CGSizeMake(40, 20): CGSizeMake(37, 18);
    self.resolutionBtn.x = min_view_w - self.resolutionBtn.width - (iPhoneX ? 40 : 15);
    self.resolutionBtn.centerY = self.backBtn.centerY;
    
    self.airPlayBtn.centerY = self.resolutionBtn.centerY;
    self.airPlayBtn.right = self.resolutionBtn.left -20;
    
    min_x = self.backBtn.right + 5;
    min_y = 0;
    min_w = min_view_w - min_x - 15 ;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.centerY = self.backBtn.centerY;
    
    //min_h = 45;
    min_h = iPhoneX ? 70 : 65;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: 15;
    min_y = 32;
    min_w = 45;
    min_h = 45;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.y = (self.bottomToolView.frame.size.height - min_h) -25;
    self.currentTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    //    min_x = self.playOrPauseBtn.right;
    //    min_y = 0;
    //    min_w = 48;
    //    min_h = 30;
    //    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    //    self.currentTimeLabel.centerY = self.playOrPauseBtn.centerY;
    
    min_w = 45;
    min_h = min_w;
    min_x = iPhoneX? self.bottomToolView.width - min_w - 35 : self.bottomToolView.width - min_w;
    min_y = (self.bottomToolView.height - min_h) * 0.5;
    self.fullScreenBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fullScreenBtn.centerY = self.playOrPauseBtn.centerY;
    
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playOrPauseBtn);
        make.left.equalTo(self.playOrPauseBtn.mas_right).offset(10);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playOrPauseBtn);
        make.right.equalTo(self.fullScreenBtn.mas_left).offset(-10);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playOrPauseBtn);
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(10);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 50: 18;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.centerY = self.centerY;
    
    if (!self.isShow) {
        self.topToolView.y = -self.topToolView.height;
        self.resolutionView.hidden = YES;
        self.bottomToolView.y = self.height;
    } else {
        if (self.player.isLockedScreen) {
            self.topToolView.y = -self.topToolView.height;
            self.resolutionView.hidden = YES;
            self.bottomToolView.y = self.height;
        } else {
            self.topToolView.y = 0;
            self.resolutionView.hidden = !self.resolutionBtn.selected;
            self.bottomToolView.y = self.height - self.bottomToolView.height;
        }
    }
    
    // resolutionView 绘制 底部圆角
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.resolutionView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.resolutionView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.resolutionView.layer.mask = maskLayer;
    });
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action

- (void)layOutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}


#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        @weakify(self)
        self.slider.isdragging = YES;
        if (self.sliderValueChanging) self.sliderValueChanging(value, self.slider.isForward);
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            self.slider.isdragging = NO;
            if (finished) {
                if (self.sliderValueChanged) self.sliderValueChanged(value);
            }
            if (self.seekToPlay) {
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            self.slider.isdragging = NO;
            if (finished) {
                if (self.sliderValueChanged) self.sliderValueChanged(value);
            }
            if (self.seekToPlay) {
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

#pragma mark -

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = NO;
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.isShow                      = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.y           = -self.topToolView.height;
        self.resolutionView.hidden   = YES;
        self.bottomToolView.y        = self.height;
    } else {
        self.topToolView.y           = 0;
        self.resolutionView.hidden   = !self.resolutionBtn.selected;
        self.bottomToolView.y        = self.height - self.bottomToolView.height;
    }
    self.lockBtn.left                = iPhoneX ? 50: 18;
    self.player.statusBarHidden      = NO;
    if (self.player.isLockedScreen) {
        self.topToolView.alpha       = 0;
        self.bottomToolView.alpha    = 0;
    } else {
        self.topToolView.alpha       = 1;
        self.bottomToolView.alpha    = 1;
    }
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.y               = -self.topToolView.height;
    self.resolutionView.hidden       = YES;
    self.bottomToolView.y            = self.height;
    self.lockBtn.left                = iPhoneX ? -82: -47;
    self.player.statusBarHidden      = YES;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.lockBtn.alpha               = 0;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    self.lockBtn.hidden = self.player.orientationObserver.fullScreenMode == ZFFullScreenModePortrait;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    //    if (!self.slider.isdragging) {
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
    self.currentTimeLabel.text = currentTimeString;
    NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
    self.totalTimeLabel.text = totalTimeString;
    self.slider.value = videoPlayer.progress;
    //    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
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

#pragma mark - setter

- (void)setFullScreenMode:(ZFFullScreenMode)fullScreenMode {
    _fullScreenMode = fullScreenMode;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:imageName(@"ic_start_v2_5") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:imageName(@"ic_stop_v2_5") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = HK_TIME_FONT(11);// [UIFont systemFontOfSize:11.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_currentTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = HKColorFromHex(0xFFD305, 0.5);
        
        _slider.minimumTrackTintColor = HKColorFromHex(0xFFD305, 1.0);
        [_slider setThumbImage:imageName(@"hkplayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = HK_TIME_FONT(11);// [UIFont systemFontOfSize:11.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_totalTimeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:imageName(@"ic_unlock_v2_5") forState:UIControlStateNormal];
        [_lockBtn setImage:imageName(@"ic_lock_v2_5") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:imageName(@"ic_shrink_v2_5") forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}



- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11];
        //_resolutionBtn.backgroundColor = RGBA(0, 0, 0, 0.6);
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:isHiddenView:) forControlEvents:UIControlEventTouchUpInside];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        
        [_resolutionBtn setBackgroundImage:imageName(@"hkplayer_rate_nomal") forState:UIControlStateNormal];
        [_resolutionBtn setBackgroundImage:imageName(@"hkplayer_rate_selected") forState:UIControlStateSelected];
        [_resolutionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resolutionBtn setTitleColor:COLOR_27323F forState:UIControlStateSelected];
        [_resolutionBtn setEnlargeEdgeWithTop:PADDING_25 right:PADDING_15 bottom:0 left:PADDING_10];
    }
    return _resolutionBtn;
}

- (CAShapeLayer*)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
    }
    return _borderLayer;
}


- (void)setResolutionBtnCorner {
    
    if (self.borderLayer) {
        [self.borderLayer removeFromSuperlayer];
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.resolutionBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 0)];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame       = self.resolutionBtn.bounds;
    borderLayer.path        = maskPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor   = [UIColor clearColor].CGColor;
    borderLayer.lineWidth   = 1;
    
    self.borderLayer = borderLayer;
    [self.resolutionBtn.layer addSublayer:self.borderLayer];
}

/** isHiddenView yes - 点击播放界面 隐藏分辨率View  */
- (void)resolutionBtnClick:(UIButton *)sender isHiddenView:(BOOL)isHiddenView{
    sender.selected = !sender.selected;
    // 显示隐藏分辨率View
    self.resolutionView.hidden = !sender.isSelected;
    // add 0402
    if (self.isFirst && !isHiddenView) {
        if (self.borderLayer) {
            [self.borderLayer removeFromSuperlayer];
        }
    }else{
        [self setResolutionBtnCorner:NO];
    }
    self.isFirst = YES;
}

- (void)hk_playerResolutionArray:(NSArray *)resolutionArray {
    
    // **** 重新排序  汤彬添加倍速 ****
    resolutionArray = @[@"0.75x", @"1.0x", @"1.25x", @"1.5x", @"2.0x",@"3.0x"];
    //     **** 重新排序  汤彬添加倍速 ****
    
    _resolutionArray = resolutionArray;
    [_resolutionBtn setTitle:resolutionArray.firstObject forState:UIControlStateNormal];
    // 添加分辨率按钮和分辨率下拉列表
    self.resolutionView = [[UIView alloc] init];
    self.resolutionView.hidden = YES;
    self.resolutionView.backgroundColor = RGBA(0, 0, 0, 0.6); //RGBA(0, 0, 0, 0.2);
    [self addSubview:self.resolutionView];
    
    
    [self.resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(IS_IPHONE6PLUS ?40 :36);
        make.height.mas_equalTo(29*resolutionArray.count);
        make.leading.equalTo(self.resolutionBtn.mas_leading).offset(0);
        make.trailing.equalTo(self.resolutionBtn.mas_trailing).offset(0);
        make.top.equalTo(self.resolutionBtn.mas_bottom);
    }];
    
    
    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 200+i;
        btn.frame = CGRectMake(0, 29*i, (IS_IPHONE6PLUS ?40 :36), 28);
        btn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ?12 :11];
        [btn setTitle:resolutionArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            self.resoultionCurrentBtn = btn;
            btn.selected = YES;
        }
        [btn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_FFD305 forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeResolution:isDefault:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.resolutionView addSubview:btn];
        //默认选中第2个
        //if (i == 1) {   [self changeResolution:btn];    }
    }
    
    [self setPlayerRate];
}

/** 设置播放速率 */
- (void)setPlayerRate {
    
    // 记录的播放速率
    NSInteger selected = [HKNSUserDefaults integerForKey:HKPlayerPlayRate];
    if (selected) {
        UIButton *btn = [self.resolutionView viewWithTag:200 + (selected-1)];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([btn isKindOfClass:[UIButton class]] ) {
                [self changeResolution:btn isDefault:YES];
            }
        });
    }else{
        // 默认选中第2个
        UIButton *btn = [self.resolutionView viewWithTag:201];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([btn isKindOfClass:[UIButton class]] ) {
                [self changeResolution:btn isDefault:YES];
            }
        });
    }
}

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender  isDefault:(BOOL)isDefault {
    if (![sender isKindOfClass:[UIButton class]]) return;
    sender.selected = YES;
    if (sender.isSelected) {
        //        sender.backgroundColor = RGBA(86, 143, 232, 1);
        
    } else {
        //        sender.backgroundColor = [UIColor clearColor];
    }
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    NSLog(@"------ %@",self.delegate);
    if ([self.delegate respondsToSelector:@selector(hk_controlView:resolutionAction:rate:)]) {
        [self savePlayRate:(sender.tag - 200)+1];
        
        // 这里开启倍速功能
        CGFloat rate = ((sender.tag - 200) * 0.25) + 0.75;
        if (rate > 1.75) rate = 2.0;
        
        [self.delegate hk_controlView:self resolutionAction:sender rate:rate];
        //友盟倍速统计事件
        [MobClick event:UM_RECORD_DETAIL_PAGE_SPEED];
    }
    
    // add 0402
    self.resolutionBtn.backgroundColor = [UIColor clearColor];
    [self setResolutionBtnCorner:NO];
    
    // 发送通知
    NSString *indexString = [NSString stringWithFormat:@"%ld", (sender.tag - 200)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetSameIJKPlayerRate1" object:@{@"index" : indexString}];
}

/**
 *  同步全屏点击切换分别率按钮
 */
- (void)changeResolutionCurrent:(UIButton *)sender {
    if (![sender isKindOfClass:[UIButton class]]) return;
    // 同一个倍速无需重新设置
    if (sender == self.resoultionCurrentBtn) return;
    
    sender.selected = YES;
    if (sender.isSelected) {
        //        sender.backgroundColor = RGBA(86, 143, 232, 1);
        
    } else {
        //        sender.backgroundColor = [UIColor clearColor];
    }
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    
    // 隐藏分辨率View
    self.resolutionView.hidden  = YES;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    // add 0402
    self.resolutionBtn.backgroundColor = [UIColor clearColor];
    [self setResolutionBtnCorner:NO];
}

- (void)listenSetSameIJKPlayerRateNotification:(NSNotification *)notic {
    NSInteger index = ((NSString *)notic.object[@"index"]).intValue;
    UIButton *button = self.resolutionView.subviews[index];
    if ([button isKindOfClass:[UIButton class]]) {
        [self changeResolutionCurrent:button];
    }
}

//存储播放速率（编号）
- (void)savePlayRate:(NSInteger)selected {
    NSInteger state = [HKNSUserDefaults integerForKey:HKRatePlay];
    if (0 == state) {
        [HKNSUserDefaults setInteger:selected forKey:HKPlayerPlayRate];
        [HKNSUserDefaults synchronize];
    }
}


/** 设置分辨率按钮 圆角  yes - 延迟设置 */
- (void)setResolutionBtnCorner:(BOOL)isdelay {
    
}


- (void)hk_pauseOrStart {
    [self playPauseButtonClickAction:nil];
}



- (UIButton *)airPlayBtn {
    if (!_airPlayBtn) {
        _airPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_airPlayBtn setBackgroundImage:imageName(@"hkplay_airplay_tv") forState:UIControlStateNormal];
        [_airPlayBtn setBackgroundImage:imageName(@"hkplay_airplay_tv") forState:UIControlStateSelected];
        [_airPlayBtn addTarget:self action:@selector(airPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_airPlayBtn setHKEnlargeEdge:30];
        [_airPlayBtn sizeToFit];
    }
    return _airPlayBtn;
}


- (void)airPlayBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hk_playBackLandScapeControlView:airPlayBtn:)]) {
        [self.delegate hk_playBackLandScapeControlView:self airPlayBtn:btn];
    }
}


- (void)showOrhiddenTopToolView:(BOOL)isShow {
    self.resolutionBtn.hidden = !isShow;
    self.airPlayBtn.hidden = !isShow;
}


@end
