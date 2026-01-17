//
//  ZFHKNormalPlayerControlView.m
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

#import "ZFHKNormalPlayerControlView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+ZFHKNormalFrame.h"
#import "ZFHKNormalSliderView.h"
#import "ZFHKNormalUtilities.h"
#import "UIImageView+ZFHKNormalCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZFHKNormalVolumeBrightnessView.h"
#import "ZFHKNormalSmallFloatControlView.h"
#import "ZFHKNormalPlayer.h"

#import "ZFHKNormalAVPlayerManager.h"
#import "ZFHNomalCustom.h"
#import "ZFHKNormalPlayerControlView+Category.h"

//#import "AirPlayDeviceAutoSelect.h"
#import "HKAirPlayCoverView.h"
#import "ZFHKNormalPlayerErrorView.h"
#import "LBLelinkKitManager.h"
#import "UMpopView.h"

#import "HKVideoPlayParamesModel.h"
#import "HKStatistDataTool.h"

@interface ZFHKNormalPlayerControlView () <ZFHKNormalSliderViewDelegate,ZFHKNormalPortraitControlViewDelegate,ZFHKNormalLandScapeControlViewDelegate,ZFHKNormalPlayerBuyVipViewDelegate,MZTimerLabelDelegate,ZFHKNormalPlayerSeekTimeTipViewDelegate,ZFHKPlayerCountDownViewDelegate,ZFHKPlayerPortraitSimilarVideoViewDelagate,ZFHKPlayerLandScapeSimilarVideoViewDelegate,HKAirPlayCoverViewDelegate,ZFHKNormalPlayerErrorViewDelegate>
/// 竖屏控制层的View
@property (nonatomic, strong) ZFHKNormalPortraitControlView *portraitControlView;
/// 横屏控制层的View
@property (nonatomic, strong) ZFHKNormalLandScapeControlView *landScapeControlView;

@property (nonatomic, strong) HKLivingSpeedLoadingView *activity;

/// 快进快退View
@property (nonatomic, strong) UIView *fastView;
/// 快进快退进度progress
@property (nonatomic, strong) ZFHKNormalSliderView *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong) UILabel *fastTimeLabel;
/// 快进快退ImageView
@property (nonatomic, strong) UIImageView *fastImageView;
/// 加载失败按钮
//@property (nonatomic, strong) UIButton *failBtn;
/// 底部播放进度
@property (nonatomic, strong) ZFHKNormalSliderView *bottomPgrogress;
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
/// 是否显示了控制层
@property (nonatomic, assign, getter=isShowing) BOOL showing;

@property (nonatomic, assign) BOOL controlViewAppeared;

@property (nonatomic, assign) NSTimeInterval sumTime;

@property (nonatomic, strong) dispatch_block_t afterBlock;

@property (nonatomic, strong) ZFHKNormalVolumeBrightnessView *volumeBrightnessView;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;

@property (nonatomic, strong) UIView *topToolView;


@property (nonatomic,strong) HKAirPlayCoverView *airPlayCoverView;
/// 是否在 拖动播放
@property (nonatomic,assign) BOOL isSlideing;

@property (nonatomic,strong) ZFHKNormalPlayerErrorView *playerErrorView;
/// 记录播放速率
@property (nonatomic,assign) CGFloat playerRate;

@property (nonatomic, strong) NSDate *touchDate;

@property (nonatomic, assign) LBVideoCastState lbCastState;


@property (nonatomic ,strong)HKVideoPlayParamesModel * videoParams ;

@property (nonatomic , strong)NSTimer * timer;

@property (nonatomic , assign)NSTimeInterval playTime;

@property (nonatomic , assign) NSInteger timeDiff ;

@property (nonatomic , assign) NSInteger reportDiff ;

@property (nonatomic ,assign) NSInteger currentSecond ;

@end

@implementation ZFHKNormalPlayerControlView
@synthesize player = _player;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.timeDiff = 0;
        [self addAllSubViews];
        self.landScapeControlView.hidden = YES;
        self.seekToPlay = YES;
        self.effectViewShow = YES;
        self.autoFadeTimeInterval = 0.0;
        self.autoHiddenTimeInterval = 0.0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        //  Airplay
        [self setAirPlay];
        self.isLandScapeShowBackBtn = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.zf_width;
    CGFloat min_view_h = self.zf_height;
    
    min_w = min_view_w;
    min_h = min_view_h;
    self.portraitControlView.frame = self.bounds;
    self.landScapeControlView.frame = self.bounds;
    self.coverImageView.frame = self.bounds;
    self.bgImgView.frame = self.bounds;
    self.effectView.frame = self.bounds;
    
    min_w = 80;
    min_h = 90;
    self.activity.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.activity.zf_centerX = self.zf_centerX;
    self.activity.zf_centerY = self.zf_centerY;
    
    min_w = 150;
    min_h = 30;
    self.playerErrorView.center = self.center;
    self.playerErrorView.frame = self.bounds;
    
    self.playerEndView.center = self.center;
    self.playerEndView.frame = self.bounds;
    
    min_w = 210;
    min_h = 80;
    self.fastView.frame = self.bounds;
    self.fastView.center = self.center;
    
    min_w = 32;
    min_x = (self.fastView.zf_width - min_w) / 2;
    min_y = 5;
    min_h = 32;
    self.fastImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = self.fastImageView.zf_bottom + 2;
    min_w = self.fastView.zf_width;
    min_h = 20;
    self.fastTimeLabel.frame = CGRectMake(min_x, 30, min_w, min_h);
    self.fastTimeLabel.centerY = self.centerY-10;
    
    min_x = 12;
    min_y = self.fastTimeLabel.zf_bottom + 10;
    min_w = 210;
    min_h = 10;
    self.fastProgressView.size = CGSizeMake(min_w, min_h);
    self.fastProgressView.centerX = self.centerX;
    self.fastProgressView.y = min_y;
    
    
    min_x = 0;
    min_y = min_view_h - 1;
    min_w = min_view_w;
    min_h = 1;
    
    min_x = 0;
    min_y = 0;
    min_w = 160;
    min_h = 40;
    self.volumeBrightnessView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.volumeBrightnessView.center = self.center;
    
    self.centerPlayeBtn.center = self.center;
    self.repeatBtn.center = self.center;
    
    if (iPhoneX) {
        min_x = 15;
        min_y = (iPhoneX && self.player.isFullScreen) ? 35: 15;
        [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(@available(iOS 11.0, *)) {
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(min_x);
            }else{
                make.left.equalTo(self).offset(min_x);
            }
            make.top.equalTo(self.mas_top).offset(min_y);
        }];
    }else{
        min_x = 15;
        min_y = 35;
        [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(@available(iOS 11.0, *)) {
                make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(min_x);
            }else{
                make.left.equalTo(self).offset(min_x);
            }
            make.top.equalTo(self.mas_top).offset(min_y);
        }];
    }
    
    min_x = 0;
    min_y = iPhoneX ? -15 :0;
    min_w = min_view_w;
    //min_h = 70;
    min_h = 15;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    [self makeAirPlayCoverVieConstraints];
    [self remakeBuyVipShareViewConstraints];
    
    if (_nextVideoCountDownView) {
        _nextVideoCountDownView.isFullScreen = self.player.isFullScreen;
        
    }
    [self setDeviceChangeSimilarVideoView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self cancelAutoFadeOutControlView];
    [self.materialTimerLabel pause];
    [self.playerProgressLabel pause];
    [self stopLocalServer];
}

/// 添加所有子控件
- (void)addAllSubViews {
    [self addSubview:self.portraitControlView];
    [self addSubview:self.landScapeControlView];
    
    [self addSubview:self.activity];
    [self addSubview:self.playerErrorView];
    
    [self addSubview:self.volumeBrightnessView];
    
    [self addSubview:self.centerPlayeBtn];
    [self addSubview:self.repeatBtn];
    
    [self addSubview:self.materialTimerLabel];
    [self addSubview:self.playerProgressLabel];
    
    [self addSubview:self.topToolView];
    [self addSubview:self.backBtn];
    [self addSubview:self.fastView];
    [self.fastView addSubview:self.fastImageView];
    [self.fastView addSubview:self.fastTimeLabel];
    [self.fastView addSubview:self.fastProgressView];
}

- (void)autoFadeOutControlView {
    self.controlViewAppeared = YES;
    [self cancelAutoFadeOutControlView];
    @weakify(self)
    self.afterBlock = dispatch_block_create(0, ^{
        @strongify(self)
        [self hideControlViewWithAnimated:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoHiddenTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(),self.afterBlock);
}

/// 取消延时隐藏controlView的方法
- (void)cancelAutoFadeOutControlView {
    if (self.afterBlock) {
        dispatch_block_cancel(self.afterBlock);
        self.afterBlock = nil;
    }
}

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = NO;
    if (self.controlViewAppearedCallback) {
        self.controlViewAppearedCallback(NO);
    }
    
    NSTimeInterval time = self.hideControlViewWithAnimated ? (animated ? self.autoFadeTimeInterval : 0) :0;
    [UIView animateWithDuration:time animations:^{
        if (self.player.isFullScreen) {
            [self.landScapeControlView hideControlView];
        } else {
            if (!self.player.isSmallFloatViewShow) {
                [self.portraitControlView hideControlView];
            }
        }
    } completion:^(BOOL finished) {
        self.bottomPgrogress.hidden = NO;
    }];
}

/// 显示控制层
- (void)showControlViewWithAnimated:(BOOL)animated {
    self.controlViewAppeared = YES;
    if (self.controlViewAppearedCallback) {
        self.controlViewAppearedCallback(YES);
    }
    [self autoFadeOutControlView];
    [UIView animateWithDuration:animated ? self.autoFadeTimeInterval : 0 animations:^{
        if (self.player.isFullScreen) {
            [self.landScapeControlView showControlView];
        } else {
            if (!self.player.isSmallFloatViewShow) {
                [self.portraitControlView showControlView];
            }
        }
    } completion:^(BOOL finished) {
        self.bottomPgrogress.hidden = YES;
    }];
}

/// 音量改变的通知
- (void)volumeChanged:(NSNotification *)notification {
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    if (self.player.isFullScreen) {
        NSString *reason = [[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
        // iOS 3 播放时会触发音量通知 故多判断下 音量是否真的改变
        if ([reason isEqualToString:@"ExplicitVolumeChange"]) {
            [self.volumeBrightnessView updateProgress:volume withVolumeBrightnessType:ZFHKNormalVolumeBrightnessTypeVolume];
        }
    } else {
        [self.volumeBrightnessView addSystemVolumeView];
    }
    
    if ([LBLelinkKitManager sharedManager].isLBlink) {
        [[LBLelinkKitManager sharedManager].lelinkPlayer setVolume:volume*100];
    }
}


/// APP 进入前台
- (void)applicationDidBecomeActiveNotification {
    if (self.player.isViewControllerDisappear) return;
    
    if (self.player.currentPlayerManager.isPreparedToPlay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([ZFHKNormalReachabilityManager sharedManager].networkReachabilityStatus == ZFHKNormalReachabilityStatusReachableViaWiFi || self.isDownloadFinsh) {
                // 1-（WI-FI 情况） 2-（下载的） 继续播放
            }else{
                if (NO == self.player.isPauseByEvent) self.player.pauseByEvent = YES;
            }
        });
    }
    
}


#pragma mark - Public Method

/// 重置控制层
- (void)resetControlView {
    self.isLandScapeShowBackBtn = NO;
    [self.portraitControlView resetControlView];
    [self.landScapeControlView resetControlView];
    [self cancelAutoFadeOutControlView];
    self.bottomPgrogress.value = 0;
    self.bottomPgrogress.bufferValue = 0;
    self.playerErrorView.hidden = YES;
    self.portraitControlView.hidden = self.player.isFullScreen;
    self.landScapeControlView.hidden = !self.player.isFullScreen;
    
    [self hideControlViewWithAnimated:NO];
    [self.portraitControlView showPortraitShadowCoverView];
    [self.landScapeControlView showLandScapeShadowCoverView];
    
    self.centerPlayeBtn.hidden = NO;
    self.coverImageView.hidden = NO;
    self.repeatBtn.hidden = YES;
    
    self.playerSeekTime = 0;
    [self.materialTimerLabel pause];
    [self pauseProgressTimer];
    if (self.similarVideoArray.count) {
        [self.similarVideoArray removeAllObjects];
    }
    self.playEnd = NO;
    
    if (iPhoneX) {
        self.topToolView.hidden = NO;
    }
    // 移除投屏封面
    [self removeAirPlayCoverView];
    
    // 移除 播放完view
    if (_playerEndView) {
        _playerEndView.hidden = YES;
        TTVIEW_RELEASE_SAFELY(_playerEndView);
    }
    //移除 无VIP提示
    TTVIEW_RELEASE_SAFELY(_playerVipTipLB);
    //移除观看时间提示
    TTVIEW_RELEASE_SAFELY(_playerSeekTimeTipView);
    
}

/// 设置标题、封面、全屏模式
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFHKNormalFullScreenMode)fullScreenMode {
    [self resetControlView];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self.portraitControlView showTitle:title fullScreenMode:fullScreenMode];
    [self.landScapeControlView showTitle:title fullScreenMode:fullScreenMode];
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:coverUrl]] placeholderImage:imageName(@"ZFHKNormalPlayer_bgView")];
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:coverUrl]] placeholderImage:imageName(@"ZFHKNormalPlayer_bgView")];
}

/// 设置标题、UIImage封面、全屏模式
- (void)showTitle:(NSString *)title coverImage:(UIImage *)image fullScreenMode:(ZFHKNormalFullScreenMode)fullScreenMode {
    [self resetControlView];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self.portraitControlView showTitle:title fullScreenMode:fullScreenMode];
    [self.landScapeControlView showTitle:title fullScreenMode:fullScreenMode];
    self.coverImageView.image = image;
    self.bgImgView.image = image;
}

#pragma mark - ZFHKNormalPlayerControlViewDelegate

/// 手势筛选，返回NO不响应该手势
- (BOOL)gestureTriggerCondition:(ZFHKNormalPlayerGestureControl *)gestureControl gestureType:(ZFHKNormalPlayerGestureType)gestureType gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer touch:(nonnull UITouch *)touch {
    
    // 未开始播放
    if (NO == self.player.currentPlayerManager.isPreparedToPlay) {
        return NO;
    }
    CGPoint point = [touch locationInView:self];
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen && gestureType != ZFHKNormalPlayerGestureTypeSingleTap) {
        return NO;
    }
    
    if (gestureType == ZFHKNormalPlayerGestureTypePan) {
        //播放结束 禁止快进 快退
        if (self.playEnd) {
            return NO;
        }
    }
    
    
    if (_airPlayCoverView && (ZFHKNormalPlayerGestureTypeSingleTap == gestureType) && (!self.controlViewAppeared)) {
        //
        CGPoint point = [touch locationInView:_airPlayCoverView];
        CGRect changeDeviceBtnRect = [self convertRect:_airPlayCoverView.changeDeviceBtn.frame toView:self];
        CGRect quitBtnRect = [self convertRect:_airPlayCoverView.quitBtn.frame toView:self];
        NSTimeInterval seconde = 0;
        if (self.touchDate) {//增加时间 为了避免快速点击问题
            seconde = [DateChange secondWithStarDate:self.touchDate endDate:[NSDate date]];
        }
        BOOL isOk = (seconde>1 || seconde == 0);
        if (CGRectContainsPoint(changeDeviceBtnRect, point) && isOk ) {
            //切换设备
            [_airPlayCoverView.changeDeviceBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            self.touchDate = [NSDate date];
            return NO;
        }
        if (CGRectContainsPoint(quitBtnRect, point) && isOk) {
            //退出投屏
            self.touchDate = [NSDate date];
            [_airPlayCoverView.quitBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            return NO;
        }
    }
    
    if (self.player.isFullScreen) {
        return [self.landScapeControlView shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
    } else {
        return [self.portraitControlView shouldResponseGestureWithPoint:point withGestureType:gestureType touch:touch];
    }
}

/// 单击手势事件
- (void)gestureSingleTapped:(ZFHKNormalPlayerGestureControl *)gestureControl {
    if (!self.player) return;
    if (self.player.isSmallFloatViewShow && !self.player.isFullScreen) {
        [self.player enterFullScreen:YES animated:YES];
    } else {
        if (self.controlViewAppeared) {
            [self hideControlViewWithAnimated:YES];
        } else {
            /// 显示之前先把控制层复位，先隐藏后显示
            [self hideControlViewWithAnimated:NO];
            [self showControlViewWithAnimated:YES];
        }
    }
}

/// 双击手势事件
- (void)gestureDoubleTapped:(ZFHKNormalPlayerGestureControl *)gestureControl {
    if (self.player.currentPlayerManager.loadState == 1) return;
    if (self.player.isFullScreen) {
        [self.landScapeControlView playOrPause];
    } else {
        [self.portraitControlView playOrPause];
    }
}

-(void)gestureLongPressTap:(ZFHKNormalPlayerGestureControl *)gestureControl startOrEnd:(BOOL)start{
    // 设置倍速
    if (self.playerRate >0) {
    }else{
        self.playerRate = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateFloat];
    }
    CGFloat rate = start ? 2.0 : self.playerRate;
    self.player.currentPlayerManager.rate = rate;
}

- (void)clickForwardPlay:(BOOL)isForward {
    self.sumTime = [self playerCurrentTime];
    if (isForward) {
        // 快进
        self.sumTime = self.sumTime + self.fastTimeInterval;
    }else{
        // 快退
        self.sumTime = self.sumTime - self.fastTimeInterval;
    }
    if (self.sumTime > self.player.totalTime) self.sumTime = self.player.totalTime;
    if (self.sumTime < 0) self.sumTime = 0;
    
    @weakify(self);
    self.reportDiff = 0;
    [self.player seekToTime:self.sumTime completionHandler:^(BOOL finished) {
        @strongify(self)
        [self.portraitControlView sliderChangeEnded];
        [self.landScapeControlView sliderChangeEnded];
        [self autoFadeOutControlView];
        [self.player.currentPlayerManager play];
        //乐播快进
        [self lBlinkSeekToTime:self.sumTime];
    }];
    
    CGFloat value = self.sumTime/self.player.totalTime;
    NSString *draggedTime = [ZFHKNormalUtilities convertTimeSecond:self.player.totalTime*value];
    /// 更新滑杆
    [self.portraitControlView sliderValueChanged:value currentTimeString:draggedTime];
    [self.landScapeControlView sliderValueChanged:value currentTimeString:draggedTime];
}


/// 开始滑动手势事件
- (void)gestureBeganPan:(ZFHKNormalPlayerGestureControl *)gestureControl panDirection:(ZFHKNormalPanDirection)direction panLocation:(ZFHKNormalPanLocation)location {
    if (direction == ZFHKNormalPanDirectionH) {
        
        self.sumTime = [self playerCurrentTime];
    }
}



- (NSTimeInterval)playerCurrentTime {
    ZFHKNormalPlayerLoadState loadstate = self.player.currentPlayerManager.loadState;
    NSTimeInterval time;
    if (loadstate == ZFHKNormalPlayerLoadStatePlaythroughOK) {
        //缓冲好了的时候 拖动快进
        time = self.player.currentTime;
    }else{
        time = (0 == self.sumTime) ? self.player.currentTime :self.sumTime;
    }
    return time;
}



/// 滑动中手势事件
- (void)gestureChangedPan:(ZFHKNormalPlayerGestureControl *)gestureControl panDirection:(ZFHKNormalPanDirection)direction panLocation:(ZFHKNormalPanLocation)location withVelocity:(CGPoint)velocity {
    if (direction == ZFHKNormalPanDirectionH) {
        // 每次滑动需要叠加时间
        self.sumTime += velocity.x / 200;
        // 需要限定sumTime的范围
        NSTimeInterval totalMovieDuration = self.player.totalTime;
        if (totalMovieDuration == 0) return;
        if (self.sumTime > totalMovieDuration) self.sumTime = totalMovieDuration;
        if (self.sumTime < 0) self.sumTime = 0;
        BOOL style = NO;
        if (velocity.x > 0) style = YES;
        if (velocity.x < 0) style = NO;
        if (velocity.x == 0) return;
        
        self.isSlideing = YES;
        //NSLog(@" <<<<<<< 滑动中手势事件 --- %0.1f \n",self.sumTime);
        [self sliderValueChangingValue:self.sumTime/totalMovieDuration isForward:style];
    } else if (direction == ZFHKNormalPanDirectionV) {
        if (location == ZFHKNormalPanLocationLeft) { /// 调节亮度
            self.player.brightness -= (velocity.y) / 10000;
            [self.volumeBrightnessView updateProgress:self.player.brightness withVolumeBrightnessType:ZFHKNormalVolumeBrightnessTypeumeBrightness];
        } else if (location == ZFHKNormalPanLocationRight) { /// 调节声音
            self.player.volume -= (velocity.y) / 10000;
            if (self.player.isFullScreen) {
                [self.volumeBrightnessView updateProgress:self.player.volume withVolumeBrightnessType:ZFHKNormalVolumeBrightnessTypeVolume];
            }
        }
    }
}

/// 滑动结束手势事件
- (void)gestureEndedPan:(ZFHKNormalPlayerGestureControl *)gestureControl panDirection:(ZFHKNormalPanDirection)direction panLocation:(ZFHKNormalPanLocation)location {
    
    self.isSlideing = NO;
    if (self.playEnd) {
        return; //播放结束 禁止滑动播放
    }
    @weakify(self)
    if (direction == ZFHKNormalPanDirectionH && self.sumTime >= 0 && self.player.totalTime > 0) {
        [self.player seekToTime:self.sumTime completionHandler:^(BOOL finished) {
            @strongify(self)
            /// 左右滑动调节播放进度
            [self.portraitControlView sliderChangeEnded];
            [self.landScapeControlView sliderChangeEnded];
            [self autoFadeOutControlView];
            [self.player.currentPlayerManager play];
            [self lBlinkSeekToTime:self.sumTime];
        }];
        if (self.seekToPlay && !self.player.currentPlayerManager.isPlaying) {
            [self.player.currentPlayerManager play];
        }
    }
}

/// 捏合手势事件，这里改变了视频的填充模式
- (void)gesturePinched:(ZFHKNormalPlayerGestureControl *)gestureControl scale:(float)scale {
    self.player.currentPlayerManager.scalingMode = ZFHKNormalPlayerScalingModeAspectFit;
}

/// 准备播放
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer prepareToPlay:(NSURL *)assetURL {
    [self hideControlViewWithAnimated:NO];
    self.topToolView.hidden = YES;
    
    if ([LBLelinkKitManager sharedManager].isLBlink) {
        if ([HkNetworkManageCenter shareInstance].networkStatus != AFNetworkReachabilityStatusReachableViaWiFi) {
            // 无网络不投屏
            self.lbCastState = LBVideoCastStateUnNetworkUnCastConnected;
        }
    }
    [self setAirPlayStateWithPgrogress:0];
}


/// 播放结束
- (void)videoPlayerPlayEnd:(ZFHKNormalPlayerController *)videoPlayer {
    if (self.playerDidToEndCallback) {
        self.playerDidToEndCallback(self.videoDetailModel.video_id);
    }

    //播放结束
    self.playEnd = YES;
    [self showNextTimeTipView];
    if (!self.fromTrainCourse) {
        [self showSimilarVideoView];
    }
    
    [self showPlayEndAchieveDialog];
    //暂停统计
    [self pauseProgressTimer];
    [self recordVideoProgress];
    
    NSString *videoId = self.videoDetailModel.next_video_info.video_id;
    if (isEmpty(videoId)) { // 无下一节视频
        self.repeatBtn.hidden = NO;
    }
}

/// 播放出错
- (void)videoPlayerPlayFailed:(ZFHKNormalPlayerController *)videoPlayer error:(id)error {
    
    if (NO == [LBLelinkKitManager sharedManager].isConnected && self.isDownloadFinsh) {
        [self.player.currentPlayerManager reloadPlayer];
    }
    NSLog(@"videoPlayerPlayFailed");
}



/// 播放状态改变
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer playStateChanged:(ZFHKNormalPlayerPlaybackState)state {
    if (state == ZFHKNormalPlayerPlayStatePlaying) {
        [self.portraitControlView playBtnSelectedState:YES];
        [self.landScapeControlView playBtnSelectedState:YES];
        self.playerErrorView.hidden = YES;
        [self startProgressTimer];
        /// 开始播放时候判断是否显示loading
        if (videoPlayer.currentPlayerManager.loadState == ZFHKNormalPlayerLoadStateStalled || videoPlayer.currentPlayerManager.loadState == ZFHKNormalPlayerLoadStatePrepare ||
            videoPlayer.currentPlayerManager.loadState == ZFHKNormalPlayerLoadStateUnknown) {
            [self.activity startAnimating];
            [self pauseProgressTimer];
            [self reopenLocalServer];
        }
        
    } else if (state == ZFHKNormalPlayerPlayStatePaused) {
        [self.portraitControlView playBtnSelectedState:NO];
        [self.landScapeControlView playBtnSelectedState:NO];
        /// 暂停的时候隐藏loading
        [self.activity stopAnimating];
        [self pauseProgressTimer];
        
    } else if (state == ZFHKNormalPlayerPlayStatePlayFailed) {
        if (NO ==  self.isDownloadFinsh) {
            // 已下载视频 不显示播放错误
            self.playerErrorView.hidden = NO;
            if (self.player.isFullScreen) {
                self.isLandScapeShowBackBtn = YES;
                self.backBtn.hidden = NO;
            }
        }
        [self.activity stopAnimating];
        [self pauseProgressTimer];
        
    }else if (state == ZFHKNormalPlayerPlayStatePlayStopped) {
        self.sumTime = 0;
    }
}

/// 加载状态改变
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer loadStateChanged:(ZFHKNormalPlayerLoadState)state {
    
    if (state == ZFHKNormalPlayerLoadStatePrepare) {
        [self pauseProgressTimer];
    } else if (state == ZFHKNormalPlayerLoadStatePlaythroughOK || state == ZFHKNormalPlayerLoadStatePlayable) {
        self.coverImageView.hidden = YES;
        if (self.effectViewShow) {
            self.effectView.hidden = NO;
        } else {
            self.effectView.hidden = YES;
        }
    }
    
    if ((state == ZFHKNormalPlayerLoadStatePrepare || state == ZFHKNormalPlayerLoadStateStalled ) && videoPlayer.currentPlayerManager.isPlaying) {
        //点击开始播放 和缓冲 都显示加载动画
        [self.activity startAnimating];
        [self reopenLocalServer];
        
    } else {
        [self.activity stopAnimating];
        if (!self.isSlideing) {
            self.sumTime = 0;
        }
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    [self.portraitControlView videoPlayer:videoPlayer currentTime:currentTime totalTime:totalTime];
    [self.landScapeControlView videoPlayer:videoPlayer currentTime:currentTime totalTime:totalTime];
    self.bottomPgrogress.value = videoPlayer.progress;
    
    [self setAirPlayStateWithPgrogress:currentTime];
    
    
    self.timeDiff++;
    if (_timeDiff > 9) {
        [self recordVideoProgress];
        _timeDiff = 0;
    }
    
    self.reportDiff++;
    if (self.reportDiff > 9) {
        //上传
        //播放数据统计
        self.videoParams.video_length = totalTime;
        self.videoParams.current_play_time = currentTime;
        
        self.videoParams.video_play_at = [[DateChange getNowTimeTimestamp] intValue];
        
        self.videoParams.video_all_segment = ceil(totalTime/10.0) ;
        self.videoParams.video_watch_seq = ceil(currentTime/10.0);
        self.videoParams.wifi = [HkNetworkManageCenter shareInstance].networkStatus == 2 ? @"1":@"0";
        self.videoParams.real_played_time = self.playTime;
        NSLog(@"self.videoParams=============currentTime: %f",currentTime);
        NSLog(@"self.videoParams=============real_played_time: %f",self.playTime);
        [HKStatistDataTool reportVideoPlayData:self.videoParams];
        _reportDiff = 0;
    }


}

/// 缓冲改变回调
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    [self.portraitControlView videoPlayer:videoPlayer bufferTime:bufferTime];
    [self.landScapeControlView videoPlayer:videoPlayer bufferTime:bufferTime];
    self.bottomPgrogress.bufferValue = videoPlayer.bufferProgress;
}

- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    [self.landScapeControlView videoPlayer:videoPlayer presentationSizeChanged:size];
}

/// 视频view即将旋转
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer orientationWillChange:(ZFHKNormalOrientationObserver *)observer {
    self.portraitControlView.hidden = observer.isFullScreen;
    self.landScapeControlView.hidden = !observer.isFullScreen;
    if (videoPlayer.isSmallFloatViewShow) {
        self.portraitControlView.hidden = YES;
        if (observer.isFullScreen) {
            self.controlViewAppeared = NO;
            [self cancelAutoFadeOutControlView];
        }
    }
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
    
    if (observer.isFullScreen) {
        [self.volumeBrightnessView removeSystemVolumeView];
    } else {
        [self.volumeBrightnessView addSystemVolumeView];
    }
    
    if (self.isLandScapeShowBackBtn) {
        self.backBtn.hidden = NO;
    }else{
        [self showOrhiddenBackBtn];
    }
    [[UMpopView sharedInstance] immediateRemoveView];
    
}



/** backBtn  显示 隐藏 */
- (void)showOrhiddenBackBtn {
    if (self.player) {
        self.backBtn.hidden = (self.player.currentPlayerManager.isPreparedToPlay) && self.player.isFullScreen;
    }
}



/// 视频view已经旋转
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer orientationDidChanged:(ZFHKNormalOrientationObserver *)observer {
    if (self.controlViewAppeared) {
        [self showControlViewWithAnimated:NO];
    } else {
        [self hideControlViewWithAnimated:NO];
    }
    //有素材
    if ([self.videoDetailModel.is_show_tips isEqualToString:@"1"]) {
        if (self.player.currentPlayerManager.isPreparedToPlay) {
            [self.materialTimerLabel reset];
            [self.materialTimerLabel start];
        }
    }
    
    if (!observer.isFullScreen) {
        // 屏幕旋转后 更新横屏布局约束
        [self.portraitControlView setNeedsLayout];
        [self.portraitControlView layoutIfNeeded];
    }
    
    /// 移除倍速 view
    [self.portraitControlView removePlayerResolutionView];
    [self.landScapeControlView orientationDidChanged];
}

/// 锁定旋转方向
- (void)lockedVideoPlayer:(ZFHKNormalPlayerController *)videoPlayer lockedScreen:(BOOL)locked {
    //[self showControlViewWithAnimated:YES];
    [self showControlViewWithAnimated:NO];
}

#pragma mark - Private Method

- (void)sliderValueChangingValue:(CGFloat)value isForward:(BOOL)forward {
    
    //隐藏加载view
    self.activity.hidden = YES;
    
    self.fastProgressView.value = value;
    /// 显示控制层
    [self cancelAutoFadeOutControlView];
    
    self.fastView.hidden = NO;
    self.fastView.alpha = 1;
    if (forward) {
        self.fastImageView.image = ZFHKNormalPlayer_Image(@"ZFPlayer_fast_forward");
    } else {
        self.fastImageView.image = ZFHKNormalPlayer_Image(@"ZFPlayer_fast_backward");
    }
    NSString *draggedTime = [ZFHKNormalUtilities convertTimeSecond:self.player.totalTime*value];
    NSString *totalTime = [ZFHKNormalUtilities convertTimeSecond:self.player.totalTime];
    
    totalTime = [NSString stringWithFormat:@" / %@",totalTime];
    NSMutableAttributedString *attributedStr = [NSMutableAttributedString mutableAttributedString:draggedTime endString:totalTime LineSpace:1 color:[UIColor whiteColor] endColor:COLOR_EFEFF6 font:HK_FONT_SYSTEM_WEIGHT(25, UIFontWeightSemibold) endFont:HK_FONT_SYSTEM(14) isWrap:NO textAlignment:NSTextAlignmentCenter];
    
    self.fastTimeLabel.attributedText = attributedStr;
    /// 更新滑杆
    [self.portraitControlView sliderValueChanged:value currentTimeString:draggedTime];
    [self.landScapeControlView sliderValueChanged:value currentTimeString:draggedTime];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFastView) object:nil];
    [self performSelector:@selector(hideFastView) withObject:nil afterDelay:0.1];
    
    if (self.fastViewAnimated) {
        [UIView animateWithDuration:0.4 animations:^{
            self.fastView.transform = CGAffineTransformMakeTranslation(forward?8:-8, 0);
        }];
    }
}

/// 隐藏快进视图
- (void)hideFastView {
    [UIView animateWithDuration:0.4 animations:^{
        self.fastView.transform = CGAffineTransformIdentity;
        self.fastView.alpha = 0;
    } completion:^(BOOL finished) {
        self.fastView.hidden = YES;
    }];
}

/// 加载失败
- (void)failBtnClick:(UIButton *)sender {
    [self.player.currentPlayerManager reloadPlayer];
}

#pragma mark - setter

- (void)setPlayer:(ZFHKNormalPlayerController *)player {
    _player = player;
    self.landScapeControlView.player = player;
    self.portraitControlView.player = player;
    /// 解决播放时候黑屏闪一下问题
    [player.currentPlayerManager.view insertSubview:self.bgImgView atIndex:0];
    [self.bgImgView addSubview:self.effectView];
    [player.currentPlayerManager.view insertSubview:self.coverImageView atIndex:1];
    self.coverImageView.frame = player.currentPlayerManager.view.bounds;
    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.bgImgView.frame = player.currentPlayerManager.view.bounds;
    self.bgImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.effectView.frame = self.bgImgView.bounds;
    self.effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.player.currentPlayerManager.view.backgroundColor = [UIColor blackColor];
}

- (void)setSeekToPlay:(BOOL)seekToPlay {
    _seekToPlay = seekToPlay;
    self.portraitControlView.seekToPlay = seekToPlay;
    self.landScapeControlView.seekToPlay = seekToPlay;
}

- (void)setEffectViewShow:(BOOL)effectViewShow {
    _effectViewShow = effectViewShow;
    if (effectViewShow) {
        self.bgImgView.hidden = NO;
    } else {
        self.bgImgView.hidden = YES;
    }
}

#pragma mark - getter

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
    }
    return _effectView;
}

- (ZFHKNormalPortraitControlView *)portraitControlView {
    if (!_portraitControlView) {
        @weakify(self)
        _portraitControlView = [[ZFHKNormalPortraitControlView alloc] init];
        _portraitControlView.sliderValueChanging = ^(CGFloat value, BOOL forward) {
            @strongify(self)
            [self cancelAutoFadeOutControlView];
            [self sliderValueChangingValue:value isForward:forward];
        };
        _portraitControlView.sliderValueChanged = ^(CGFloat value) {
            @strongify(self)
            self.reportDiff = 0;
            [self autoFadeOutControlView];
            if (self.player) {
                // v2.18
                self.sumTime = self.player.totalTime * value;
                [self lBlinkSeekToTime:self.sumTime];
            }
        };
        _portraitControlView.portraitGraphicBtnClickCallback = ^(UIButton * _Nonnull btn, BOOL isCenterBtnClick, NSString * _Nonnull webUrl) {
            @strongify(self)
            if (self.portraitGraphicBtnClickCallback) {
                self.portraitGraphicBtnClickCallback(btn, isCenterBtnClick, webUrl);
            }
        };
        _portraitControlView.portraitVipBtnClickCallback = ^(UIButton * _Nonnull btn) {
            @strongify(self)
            if (self.portraitVipBtnClickCallback) {
                self.portraitVipBtnClickCallback(btn, self.videoDetailModel, self.permissionModel);
            }
        };
        _portraitControlView.portraitFastForwardBtnClickCallback = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            [self clickForwardPlay:YES];
        };
        _portraitControlView.portraitBackForwardBtnClickCallback = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            [self clickForwardPlay:NO];
        };
        _portraitControlView.delegate = self;
    }
    return _portraitControlView;
}



- (ZFHKNormalLandScapeControlView *)landScapeControlView {
    if (!_landScapeControlView) {
        @weakify(self)
        _landScapeControlView = [[ZFHKNormalLandScapeControlView alloc] init];
        _landScapeControlView.sliderValueChanging = ^(CGFloat value, BOOL forward) {
            @strongify(self)
            [self cancelAutoFadeOutControlView];
            [self sliderValueChangingValue:value isForward:forward];
        };
        _landScapeControlView.sliderValueChanged = ^(CGFloat value) {
            @strongify(self)
            self.reportDiff = 0;
            [self autoFadeOutControlView];
            if (self.player) {
                // v2.18
                self.sumTime = self.player.totalTime * value;
                [self lBlinkSeekToTime:self.sumTime];
            }
        };
        
        _landScapeControlView.landScapeGraphicBtnClickCallback = ^(UIButton * _Nonnull btn, NSString * _Nonnull webUrl) {
            @strongify(self)
            if (self.landScapeGraphicBtnClickCallback) {
                //切换到竖屏
                [self setPlayerPortrait];
                self.landScapeGraphicBtnClickCallback(btn, webUrl);
            }
        };
        _landScapeControlView.landScapeFeedBackBtnClickCallback = ^{
            @strongify(self)
            if (self.landScapeFeedBackCallback) {
                [self setPlayerPortrait];
                self.landScapeFeedBackCallback();
            }
        };
        _landScapeControlView.landScapeVipBtnClickCallback = ^(UIButton * _Nonnull btn) {
            @strongify(self)
            if (self.landScapeVipBtnClickCallback) {
                [self setPlayerPortrait];
                self.landScapeVipBtnClickCallback(btn, self.videoDetailModel,self.permissionModel);
            }
        };
        _landScapeControlView.landScapeFastForwardBtnClickCallback = ^(UIButton * _Nonnull btn) {
            @strongify(self)
            [self clickForwardPlay:YES];
        };
        
        _landScapeControlView.landScapeBackForwardBtnClickCallback = ^(UIButton * _Nonnull btn) {
            @strongify(self)
            [self clickForwardPlay:NO];
        };
        
        _landScapeControlView.didCourseBlock = ^(NSString * _Nonnull changeCourseId, NSString * _Nonnull sectionId, NSString * _Nonnull frontCourseId) {
            @strongify(self)
            if (self.didCourseBlock) {
                self.didCourseBlock(changeCourseId, sectionId, frontCourseId);
            }
        };
        
        _landScapeControlView.didNextBlock = ^(DetailModel * _Nonnull videoDetailModel) {
            @strongify(self)
            if (self.didNextBlock) {
                self.didNextBlock(videoDetailModel);
            }
        };
        _landScapeControlView.delegate = self;
    }
    return _landScapeControlView;
}



- (HKLivingSpeedLoadingView *)activity {
    if (!_activity) {
        _activity = [[HKLivingSpeedLoadingView alloc] init];
        _activity.hidden = YES;
    }
    return _activity;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView = [[UIView alloc] init];
        _fastView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _fastView.hidden = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
        _fastImageView.hidden = YES;
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel = [[UILabel alloc] init];
        _fastTimeLabel.textColor = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _fastTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _fastTimeLabel;
}

- (ZFHKNormalSliderView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView = [[ZFHKNormalSliderView alloc] init];
        _fastProgressView.maximumTrackTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _fastProgressView.minimumTrackTintColor = HKColorFromHex(0xFFD305, 1.0);
        _fastProgressView.sliderHeight = 3;
        _fastProgressView.isHideSliderBlock = NO;
    }
    return _fastProgressView;
}

- (ZFHKNormalSliderView *)bottomPgrogress {
    return _bottomPgrogress;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = IS_IPAD ? UIViewContentModeScaleAspectFit:UIViewContentModeScaleAspectFill ;//UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

- (ZFHKNormalVolumeBrightnessView *)volumeBrightnessView {
    if (!_volumeBrightnessView) {
        _volumeBrightnessView = [[ZFHKNormalVolumeBrightnessView alloc] init];
    }
    return _volumeBrightnessView;
}

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [ZFHKNormalUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)];
    }
    return _placeholderImage;
}

- (UIButton *)centerPlayeBtn {
    if (!_centerPlayeBtn) {
        _centerPlayeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerPlayeBtn setImage:imageName(@"ic_startxl_v2_5") forState:UIControlStateNormal];
        [_centerPlayeBtn setImage:imageName(@"ic_startxl_v2_5") forState:UIControlStateHighlighted];
        [_centerPlayeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_centerPlayeBtn sizeToFit];
        [_centerPlayeBtn setHKEnlargeEdge:30];
    }
    return _centerPlayeBtn;
}

- (void)setBackBtnClickCallback:(void (^)(void))backBtnClickCallback {
    _backBtnClickCallback = [backBtnClickCallback copy];
}

- (void)setPortraitBackBtnClickCallback:(void (^)(void))portraitBackBtnClickCallback {
    _portraitBackBtnClickCallback = [portraitBackBtnClickCallback copy];
    self.portraitControlView.portraitBackBtnClickCallback = _portraitBackBtnClickCallback;
}

#pragma mark delegate
#pragma mark - 速率   //PortraitControlView
- (void)zfHKNormalPortraitControlView:(UIView *)view resolutionBtn:(UIButton *)btn rate:(CGFloat)rate index:(NSInteger)index {
    [self setPlayerRateWithRate:rate];
    [self.landScapeControlView changeResolutionCurrent:index];
}

#pragma mark - LandScapeControlView
- (void)zfHKNormalLandScapeControlView:(UIView *)view resolutionBtn:(UIButton*)btn rate:(CGFloat)rate index:(NSInteger)index {
    [self setPlayerRateWithRate:rate];
    [self.portraitControlView changeResolutionCurrent:index];
}

- (void)setPlayerRateWithRate:(CGFloat)rate {
    if (!self.player) { return;}
    self.playerRate = rate;
    self.player.currentPlayerManager.rate = rate;
}

#pragma mark - -- ----自定义部分

#pragma mark - 开启本地服务器
- (HTTPServer *)httpServer {
    if (nil == _httpServer) {
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:12345];
    }
    return _httpServer;
}

- (ZFHKNormalPlayerVipTipLB*)playerVipTipLB {
    if (!_playerVipTipLB) {
        _playerVipTipLB = [[ZFHKNormalPlayerVipTipLB alloc]init];
    }
    return  _playerVipTipLB;
}

- (ZFHKNormalPlayerBuyVipView*)vipShareView {
    if (!_vipShareView) {
        _vipShareView = [[ZFHKNormalPlayerBuyVipView alloc]initWithModel:self.permissionModel detailModel:self.videoDetailModel];
        _vipShareView.tag = 2000;// 标记 用于遍历视图
        _vipShareView.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.8];
        _vipShareView.delegate = self;
    }
    return _vipShareView;
}

#pragma mark  --- 素材下载提示 部分
- (MZTimerLabel*)materialTimerLabel {
    if (!_materialTimerLabel) {
        _materialTimerLabel = [[MZTimerLabel alloc] initWithFrame:CGRectZero];
        _materialTimerLabel.timerType = MZTimerLabelTypeTimer;
        _materialTimerLabel.backgroundColor = [UIColor clearColor];
        _materialTimerLabel.hidden = YES;
        _materialTimerLabel.delegate = self;
        [_materialTimerLabel setCountDownTime:10];
        _materialTimerLabel.tag = 200;
    }
    return _materialTimerLabel;
}


#pragma mark 播放时长 计时器
- (MZTimerLabel*)playerProgressLabel {
    if (!_playerProgressLabel) {
        _playerProgressLabel = [[MZTimerLabel alloc] initWithFrame:CGRectZero];
        _playerProgressLabel.timerType = MZTimerLabelTypeStopWatch;
        _playerProgressLabel.backgroundColor = [UIColor clearColor];
        _playerProgressLabel.hidden = YES;
        _playerProgressLabel.tag = 100;
        _playerProgressLabel.delegate = self;
    }
    return _playerProgressLabel;
}


- (void)timerLabel:(MZTimerLabel *)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType {
    
}

- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    if (timerLabel.tag == 200) {
        [timerLabel pause];
        [self showMaterialTipView];
    }
}


#pragma mark - 进度提示 部分
- (ZFHKNormalPlayerSeekTimeTipView *)playerSeekTimeTipView {
    if (!_playerSeekTimeTipView) {
        _playerSeekTimeTipView = [[ZFHKNormalPlayerSeekTimeTipView alloc]initWithFrame:CGRectZero];
        _playerSeekTimeTipView.delegate = self;
        _playerSeekTimeTipView.model = self.videoDetailModel;
        _playerSeekTimeTipView.playerSeekTime = self.playerSeekTime;
        
    }
    return _playerSeekTimeTipView;
}


- (void)showPlayerSeekTimeTipView {
    
    if (self.playerSeekTime > 0) {
        [self addSubview:self.playerSeekTimeTipView];
        [self.playerSeekTimeTipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(self.player.isFullScreen ?(-66) : -50);
            make.left.equalTo(self.mas_left).offset(PADDING_15);
            //make.size.mas_equalTo(CGSizeMake(370/2 + [self timeWordWidth], 30));
            make.size.mas_equalTo(CGSizeMake(340/2 + [self timeWordWidth], 30));
        }];
    }
}


- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:imageName(@"ZFNormalPlayer_repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_repeatBtn setHKEnlargeEdge:30];
        [_repeatBtn sizeToFit];
        _repeatBtn.hidden = YES;
    }
    return _repeatBtn;
}


// 重播按钮
- (void)repeatBtnClick:(UIButton*)btn {
    btn.hidden = YES;
    if (self.player) {
        [self.player.currentPlayerManager replay];
        //播放结束
        self.playEnd = NO;
        if (self.similarVideoArray.count) {
            [self.similarVideoArray removeAllObjects];
        }
    }
    self.isLandScapeShowBackBtn = NO;
    [self showOrhiddenBackBtn];
}

// 重播
- (void)repeatPlay {
    [self repeatBtnClick:self.repeatBtn];
    [self LBLinkresetPlay];
}



#pragma mark - 播放设置部分

- (void)setCourseDataArray:(NSMutableArray *)courseDataArray{
    self.landScapeControlView.index = self.index;
    self.landScapeControlView.courseDataArray = courseDataArray;
}



- (void)setVideoDetailModel:(DetailModel *)videoDetailModel {
    
    _videoDetailModel = videoDetailModel;
    self.portraitControlView.videoDetailModel = videoDetailModel;
    self.landScapeControlView.videoDetailModel = videoDetailModel;
    [self resetProgressTimer];
    
    if (nil == [HKAccountTool shareAccount]) {
        return;
    }
    self.downloadFinsh = [self isDownloadFinsh:videoDetailModel];
    
    self.landScapeControlView.downloadFinsh = self.downloadFinsh;
    
    if (self.downloadFinsh) {
        [self checkUserPermissionWithModel:self.videoDetailModel isLocalVideo:YES];
        // 下载完成 直接播放
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            //state 0 - 关闭 1 -开启
            NSInteger state = [HKNSUserDefaults integerForKey:HKAutoPlay];
            if (1 == state && AFNetworkReachabilityStatusReachableViaWiFi == [HkNetworkManageCenter shareInstance].networkStatus) {
                [self userPermission:nil];
            }
        });
    }
    else{
        //if (videoDetailModel.is_auto_play) {
        [self WiFiAutoPlayWithModel:videoDetailModel.is_auto_play];
        //}
    }
    [self removeBuyVipShareView];
    
    /** 设置音频 播放的 基本信息 */
    self.videoDetailModel.cover_image = self.coverImageView.image;
    self.player.currentPlayerManager.videoDetailModel = self.videoDetailModel;
}



- (void)centerPlayBtnClick:(UIButton*)btn {
    
    //通过短视频跳转 播放点击统计
    if (!isEmpty(self.alilogModel.shortVideoToVideoPlayFlag)) {
        [[HKALIYunLogManage sharedInstance] hkShortVideoClickLogWithFlag:self.alilogModel.shortVideoToVideoPlayFlag];
    }
    
    if (APPSTATUS && TOURIST_VIP_STATUS) {
        
    }else{
        if (nil == [HKAccountTool shareAccount]) {
            if (self.centerPlayBtnClick) {
                self.centerPlayBtnClick();
            }
            return;
        }
    }
    
    if (self.downloadFinsh) {
        btn.hidden = YES;
        [self userPermission:nil];
        return;
    }
    [self readyRequest];
}


#pragma mark - wifi 自动播放
- (void)WiFiAutoPlayWithModel:(BOOL)isAuto {
    
    if (NO == isAuto) {
        return;
    }
    
    if (self.videoDetailModel.isNextAutoPlay) {
        //自动播放 模拟点击按钮
        //vip_class：5-分类限五vip 4-套餐vip 3-终身全站通 2-全站通VIP 1-分类无限VIP 0-非VIP
        //video_type 视频类型 0-普通视频 1-软件入门 2-系列课视频  3-有上下集  4--PGC 课
        //NSInteger type = [self.videoDetailModel.video_type integerValue];
        
        //state 0 - 关闭 1 -开启
        NSInteger state = [HKNSUserDefaults integerForKey:HKAutoPlay];
        if (1 == state || self.isNeedAutoPlay) {
            NSInteger vip = [self.videoDetailModel.vip_class integerValue];
            switch (vip) {
                case 0:
                {    // 直接播放
                    [self centerPlayBtnClick:self.centerPlayeBtn];
                }
                    break;
                case 1: case 2: case 3:
                {   // 直接播放
                    [self centerPlayBtnClick:self.centerPlayeBtn];
                }
                    break;
                case 5:
                    break;
            }
        }
    }else{
        if (AFNetworkReachabilityStatusReachableViaWiFi == [HkNetworkManageCenter shareInstance].networkStatus) {
            //state 0 - 关闭 1 -开启
            NSInteger state = [HKNSUserDefaults integerForKey:HKAutoPlay];
            if (1 == state || self.isNeedAutoPlay) {
                //自动播放 模拟点击按钮
                [self centerPlayBtnClick:self.centerPlayeBtn];
            }
        }
    }
}



#pragma mark - 检测网络 请求播放权限
- (void)readyRequest {
    @weakify(self);
    AFNetworkReachabilityStatus networkStatus = [HkNetworkManageCenter shareInstance].networkStatus;
    switch (networkStatus) {
        case AFNetworkReachabilityStatusNotReachable: case AFNetworkReachabilityStatusUnknown:
            // 无网络
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            // 移动网络
            [self playtipByWWAN:^{
                @strongify(self)
                [self checkUserPermissionWithModel:self.videoDetailModel isLocalVideo:NO];
            } cancelAction:^{
                @strongify(self)
                if (self.player.currentPlayerManager.isPreparedToPlay) {
                    [self.player.currentPlayerManager pause];
                }
            }];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            [self checkUserPermissionWithModel:self.videoDetailModel isLocalVideo:NO];
        }
            break;
    }
}



#pragma mark - 观看权限
- (void)checkUserPermissionWithModel:(DetailModel *)detailModel isLocalVideo:(BOOL)isLocal{
    
    if (isEmpty(detailModel.video_id)) {
        return;
    }
    
    @weakify(self);
    NSString *type = detailModel.video_type;
    
    // 职业路径
    if (type.intValue == HKVideoType_JobPath || type.intValue == HKVideoType_JobPath_Practice) {
        NSDictionary *param = @{@"chapter_id" : detailModel.chapterId, @"section_id" : detailModel.sectionId, @"video_id" : detailModel.video_id, @"career_id" : detailModel.career_id};
        [HKHttpTool POST:CAREER_VIDEO_PLAY parameters:param success:^(id responseObject) {
            if (HKReponseOK && !isLocal) {
                @strongify(self)
                //is_paly：0-不可观看 1-可观看
                HKPermissionVideoModel *model = [HKPermissionVideoModel mj_objectWithKeyValues:responseObject[@"data"]];
                model.video_type = type;
                self.permissionModel = model;
                [self resetPlayTime:model];
                [self userPermission:model];
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        
        
        [[UserInfoServiceMediator sharedInstance] seeAndDownloadByVideoId:detailModel.video_id
                                                              VideoDetail:detailModel
                                                                videoType:[type integerValue]
                                                                    token:nil
                                                                searchkey:detailModel.searchkey
                                                           searchIdentify:detailModel.searchIdentify
                                                               completion:^(FWServiceResponse *response) {
            
            if ([response.code isEqualToString:SERVICE_RESPONSE_OK] && !isLocal) {
                @strongify(self)
                //is_paly：0-不可观看 1-可观看
                HKPermissionVideoModel *model = [HKPermissionVideoModel mj_objectWithKeyValues:response.data];
                
                if (model.business_code != 200 && model.business_message.length) {
                    //showTipDialog(model.business_message);
                    showWarningDialog(model.business_message, self, 3);
                }else{
                    model.video_type = type;
                    self.permissionModel = model;
                    
                    [self resetPlayTime:model];
                    [self userPermission:model];
                }
            }
        } failBlock:^(NSError *error) {
            
        }];
    }
}




/**
 is_vip：0-非VIP（不可下载） 1-限5VIP（不可下载） 2-全站VIP或分类无限VIP（可下载）
 is_paly：0-不可观看 1-可观看
 
 @param model
 */
- (void)userPermission:(HKPermissionVideoModel*)model {
    //将视频信息赋值给播放器
    self.player.currentPlayerManager.permissionModel = model;
    
    if (self.downloadFinsh) {
        [self startPlayLocalVideo];
        
    }else{
        if (!model) {
            return;
        }
        BOOL isPGC = ([model.video_type integerValue] == HKVideoType_PGC );
        
        if ([model.is_paly isEqualToString:@"0"] && isPGC) {
            // 不能观看的 PGC 课程
            //showTipDialog(GO_TO_PC_BUY_PGC);
            showWarningDialog(GO_TO_PC_BUY_PGC, self, 3);
            return;
        }
        
        if ([model.is_paly isEqualToString:@"0"] && !isPGC) {
            // 建立购买视图
            [self showBuyVipShareView];
            // 移除投屏视图
            [self removeAirPlayCoverView];
            return;
        }
        [self startPlayVideoWithModel:model];
    }
}

#pragma mark - 播放本地视频
- (void)startPlayLocalVideo {
    NSURL *url = [self downloadFilePath];
    if (!url) {
        return;
    }
    if (!self.player) {
        return;
    }
    @weakify(self);
    self.player.currentPlayerManager.isDown = YES;
    self.player.currentPlayerManager.assetURL = url;
    // 设置倍速
    if (self.playerRate >0) {
        
    }else{
        self.playerRate = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateFloat];
    }
    [self setPlayerRateWithRate:self.playerRate];
    [self startLocalServer:^{
        @strongify(self);
        self.centerPlayeBtn.hidden = YES;
        [self startProgressTimer];
        if (self.playerPrepareToPlayCallback) {
            self.playerPrepareToPlayCallback(self.videoDetailModel.video_id);
        }
        [self setPlayerSeekTime];
    } fail:^{
        self.centerPlayeBtn.hidden = YES;
        if (self.playerPrepareToPlayCallback) {
            self.playerPrepareToPlayCallback(self.videoDetailModel.video_id);
        }
    }];
    if (self.videoDetailModel.isFromDownload) {
        if (!self.player.isFullScreen) {
            //自动全屏
            [self.player enterFullScreen:YES animated:YES];
            self.videoDetailModel.isFromDownload = NO;
        }
    }
}



#pragma mark - 设置 assetURL 播放
- (void)startPlayVideoWithModel:(HKPermissionVideoModel*)permissionModel {
    
    if (permissionModel.is_mute) {
        // 静音视频
        NSString *text = @"为确保更好的学习效果，我们正在优化讲师音频，当前视频暂时无声音，您可通过字幕学习哦~";
        if (self.player.isFullScreen) {
            playerShowDialog(text, self, 4);
        }else{
            playerShowDialog(text, nil, 4);
        }
    }
    
    NSString *url = permissionModel.video_url;
    if (isEmpty(url)) {
        url = permissionModel.tx_video_url;
    }
    
    if (isEmpty(url)) {
        return;
    }
    if (!self.player) {
        return;
    }
    
    @weakify(self);
    self.player.playerPrepareToPlay = ^(id<ZFHKNormalPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self);
        self.centerPlayeBtn.hidden = YES;
        self.portraitControlView.permissionModel = self.permissionModel;
        self.landScapeControlView.permissionModel = self.permissionModel;
        [self startProgressTimer];
        
        [self showOrhiddenBackBtn];
        if (self.playerPrepareToPlayCallback) {
            self.playerPrepareToPlayCallback(self.videoDetailModel.video_id);
        }
    };
    
    self.player.playerReadyToPlay = ^(id<ZFHKNormalPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self);
        [self.timer invalidate];
        self.timer = nil;

        [self setPlayerSeekTime];
        self.playTime = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(statisticTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        NSLog(@"=============playTime: 关闭");

        
        if (self.playerRate >0) {
            
        }else{
            self.playerRate = [ZFHKNormalPlayerPlayRate normalPlayerPlayRateFloat];
        }
        [self setPlayerRateWithRate:self.playerRate];
        //初始化统计model
        [self initVideoPlayParames:self.videoDetailModel];
    };
    
    
    self.player.playerPlayStateChanged = ^(id<ZFHKNormalPlayerMediaPlayback>  _Nonnull asset, ZFHKNormalPlayerPlaybackState playState) {
        NSLog(@"=============playState: %lu",(unsigned long)playState);
        if (playState == 1 && self.player.currentPlayerManager.loadState == ZFHKNormalPlayerLoadStatePlaythroughOK) {
            [self.timer setFireDate:[NSDate distantPast]]; //很远的过去，开启定时器
        }else{
            [self.timer setFireDate:[NSDate distantFuture]]; //很远的将来,关闭定时器
        }
    };
    
    self.player.playerLoadStateChanged = ^(id<ZFHKNormalPlayerMediaPlayback>  _Nonnull asset, ZFHKNormalPlayerLoadState loadState) {
        NSLog(@"=============loadState: %lu",(unsigned long)loadState);
        if (loadState == 1) {
            [self.timer setFireDate:[NSDate distantFuture]]; //很远的将来,关闭定时器
        }
    };
    
    [self.portraitControlView hiddenPortraitCenterGraphicBtn];
    //    url = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:url];
    [self showPlayerVipTipLbWithModel:permissionModel];
}

- (void)statisticTime{
    NSLog(@"self.videoParams=============playTime: %f",self.playTime);
    self.playTime++ ;
}

- (void)initVideoPlayParames:(DetailModel *)videoDetailModel{
    self.videoParams = [[HKVideoPlayParamesModel alloc] init];
    self.videoParams.video_id = self.videoDetailModel.video_id;
    self.videoParams.video_cid = self.videoDetailModel.video_type;
    self.videoParams.video_author_id = self.videoDetailModel.teacher_info.teacher_id;
    self.videoParams.video_random_id = [CommonFunction makeRandomNumber];
    self.videoParams.start_play_time = [NSString stringWithFormat:@"%ld",self.currentSecond];
    NSLog(@"video_random_id============ %@",self.videoParams.video_random_id);
}



#pragma mark - 设置播放时间
- (void)setPlayerSeekTime {
    if (self.player.currentPlayerManager.seekTime <= 0 || self.notesSeekTime) {
        // 由于切换线路时 seekTime有值, 无需设置
        self.currentSecond = [self resetPlayTime:self.permissionModel];
        self.player.currentPlayerManager.seekTime = self.currentSecond;
        [self showPlayerSeekTimeTipView];
    }
}


#pragma mark - 开始播放计时
- (void)startProgressTimer {
    if (self.playEnd) {
        [self.playerProgressLabel pause];
    }else{
        [self.playerProgressLabel start];
    }
}


#pragma mark - 暂停播放计时
- (void)pauseProgressTimer {
    [self.playerProgressLabel pause];
}

#pragma mark - 重置播放计时
- (void)resetProgressTimer {
    [self.playerProgressLabel reset];
}



/**  下一视频倒计时 提示 */
- (ZFHKPlayerCountDownView*)nextVideoCountDownView {
    if (!_nextVideoCountDownView) {
        _nextVideoCountDownView = [[ZFHKPlayerCountDownView alloc]init];
        _nextVideoCountDownView.delegate = self;
        _nextVideoCountDownView.detailModel = self.videoDetailModel;
        _nextVideoCountDownView.tag = 300;
    }
    return _nextVideoCountDownView;
}


- (ZFHKPlayerPortraitSimilarVideoView *) portraitSimilarVideoView {
    if (!_portraitSimilarVideoView) {
        _portraitSimilarVideoView = [[ZFHKPlayerPortraitSimilarVideoView alloc]initWithFrame:CGRectZero];
        _portraitSimilarVideoView.playerSimilarVideoDelagate = self;
    }
    return _portraitSimilarVideoView;
}

- (ZFHKPlayerLandScapeSimilarVideoView*)landScapeSimilarVideoView {
    
    if (!_landScapeSimilarVideoView) {
        _landScapeSimilarVideoView = [ZFHKPlayerLandScapeSimilarVideoView new];
        _landScapeSimilarVideoView.delegate = self;
    }
    return _landScapeSimilarVideoView;
}


- (ZFHKPlayerEndView*)playerEndView {
    if (!_playerEndView) {
        _playerEndView = [[ZFHKPlayerEndView alloc]init];
        _playerEndView.detailModel = self.videoDetailModel;
        _playerEndView.hidden = YES;
    }
    return _playerEndView;
}

- (NSMutableArray*)similarVideoArray {
    if(!_similarVideoArray) {
        _similarVideoArray = [NSMutableArray array];
    }
    return _similarVideoArray;
}


- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setHKEnlargeEdge:40];
        [_backBtn sizeToFit];
    }
    return _backBtn;
}


- (void)backButtonClickAction:(UIButton*)sender {
    
    if (self.player.isFullScreen) {
        if (self.player.orientationObserver.supportInterfaceOrientation & ZFHKNormalInterfaceOrientationMaskPortrait) {
            [self.player enterFullScreen:NO animated:YES];
        }
    }else{
        
        if (self.backBtnClickCallback) {
            self.backBtnClickCallback();
        }
    }
}


- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer reachabilityChanged:(ZFHKNormalReachabilityStatus)status {
    
    switch (status) {
        case ZFHKNormalReachabilityStatusNotReachable:{
            if (NO == videoPlayer.viewControllerDisappear && (!self.isDownloadFinsh)) {
                playerShowDialog(NETWORK_ALREADY_LOST, self, 2);
                [self.activity stopAnimating];
            }
        }
        case ZFHKNormalReachabilityStatusUnknown:
            // 无网络
            break;
        case ZFHKNormalReachabilityStatusReachableVia2G:
        case ZFHKNormalReachabilityStatusReachableVia3G:
        case ZFHKNormalReachabilityStatusReachableVia4G:
        {
            if (!self.isDownloadFinsh) {
                
                if (self.player && self.player.currentPlayerManager.isPreparedToPlay) {
                    
                    [self.player.currentPlayerManager pause];
                    if (NO == videoPlayer.viewControllerDisappear) {
                        //playerReachabilityDialog (Mobile_Network, self);
                        @weakify(self);
                        [self playtipByWWAN:^{
                            @strongify(self);
                            [self.player.currentPlayerManager play];
                        }cancelAction:^{
                            @strongify(self)
                            if (self.player.currentPlayerManager.isPreparedToPlay) {
                                [self.player.currentPlayerManager pause];
                            }
                        }];
                    }
                }
            }
        }
            break;
        case ZFHKNormalReachabilityStatusReachableViaWiFi:
        {
            
        }
            break;
    }
}

/************************  AIrplay 投屏  ************************/

- (void)setAirPlay {
    self.lbCastState = LBVideoCastStateUnCastUnConnect;
    [LBLelinkKitManager sharedManager].volumView = self.volumeView;
    [self addSubview:self.volumeView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeViewWirelessRoutesAvailableDidChangeNotification:)
                                                 name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeViewWirelessRouteActiveDidChangeNotification:)
                                                 name:MPVolumeViewWirelessRouteActiveDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lBLelinkKitManagerPlayerStatusNotification:)
                                                 name:LBLelinkKitManagerPlayerStatusNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lBLelinkKitManagerConnectionDidConnectedNotification:)
                                                 name:LBLelinkKitManagerConnectionDidConnectedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lBLelinkKitManagerConnectionDisConnectedNotification:)
                                                 name:LBLelinkKitManagerConnectionDisConnectedNotification
                                               object:nil];
    
}



- (void)lBLelinkKitManagerPlayerStatusNotification:(NSNotification*)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSString *url = dict[@"lbVideoUrl"];
    NSNumber *number = dict[@"playStatus"];
    NSInteger status = number.intValue;
    switch (status) {
        case LBLelinkPlayStatusLoading:
            break;
        case LBLelinkPlayStatusPlaying:
        {
            if (!isEmpty(url) && [url isEqualToString:self.permissionModel.video_url]) {
                if (LBLelinkPlayStatusPlaying == status) {
                    //连接后，开始播放
                    self.lbCastState = LBVideoCastStateCastedConnected;
                    [self setAirPlayStateWithPgrogress:1];
                }
            }
        }
            break;
            
        case LBLelinkPlayStatusPause:
            break;
            
        case LBLelinkPlayStatusStopped:
            // 退出播放状态
            break;
            
        case LBLelinkPlayStatusCommpleted:
            break;
            
        case LBLelinkPlayStatusError:
            // 播放完成状态
            break;
            
        default:
            break;
    }
}


#pragma mark -- 乐播连接
- (void)lBLelinkKitManagerConnectionDidConnectedNotification:(NSNotification*)noti {
    NSLog(@"------- LBLelinkKitManager  is connent -----");
    NSString *url = noti.userInfo[@"lbVideoUrl"];
    if (!isEmpty(url) && [url isEqualToString:self.permissionModel.video_url]) {
        self.lbCastState = LBVideoCastStateCastedConnected;
        [self setAirPlayStateWithPgrogress:0];
    }
}

#pragma mark -- 乐播断开
- (void)lBLelinkKitManagerConnectionDisConnectedNotification:(NSNotification*)noti {
    TTVIEW_RELEASE_SAFELY(_airPlayCoverView);
    NSString *url = noti.userInfo[@"lbVideoUrl"];
    if (!isEmpty(url) && [url isEqualToString:self.permissionModel.video_url]) {
        self.lbCastState = LBVideoCastStateUnCastUnConnect;
        if (self.player.currentPlayerManager.isPreparedToPlay) {
            [self.portraitControlView showOrhiddenTopToolView:YES];
            [self.landScapeControlView showOrhiddenTopToolView:YES];
        }
    }
    //恢复声音
    [self.player.currentPlayerManager setVolume:self.player.volume];
}





- (MPVolumeView*)volumeView {
    if (!_volumView) {
        _volumView = [MPVolumeView new];
        _volumView.showsVolumeSlider = YES;//投屏
        [_volumView setRouteButtonImage:nil forState:UIControlStateNormal];
        _volumView.hidden = YES;
    }
    return _volumView;
}




- (HKAirPlayCoverView*)airPlayCoverView {
    if (!_airPlayCoverView) {
        _airPlayCoverView = [[HKAirPlayCoverView alloc]initWithFrame:self.bounds];
        _airPlayCoverView.delegate = self;
        _airPlayCoverView.tag = 2020;
    }
    return _airPlayCoverView;
}


#pragma mark -
- (void)setAirPlayStateWithPgrogress:(NSTimeInterval)pgrogress {
    if ([LBLelinkKitManager sharedManager].isConnected && self.player.currentPlayerManager.isPreparedToPlay) {
        if (self.downloadFinsh) {
            [self.airPlayCoverView changeStateWithText:@"连接中..."];
            self.airPlayCoverView.isPickSucess = NO;
        }else{
            self.airPlayCoverView.isPickSucess = (pgrogress >0);
            NSString *status = (pgrogress >0)? @"正在播放中":@"连接中...";
            if (pgrogress <= 0) {
                tb_showWaitingDialogWithStr(@"连接中，请稍后...");
            }else{
                closeWaitingDialog();
            }
            
            if ([HkNetworkManageCenter shareInstance].networkStatus != AFNetworkReachabilityStatusReachableViaWiFi) {
                if ([LBLelinkKitManager sharedManager].isLBlink) {
                    status = @"设备中断";
                }
            }
            [self.airPlayCoverView changeStateWithText:status];
        }
        self.airPlayCoverView.isDownFinish = self.downloadFinsh;
        
        NSString *deviceName = [LBLelinkKitManager sharedManager].connectDeviceName;
        [self.airPlayCoverView setPortNameWithText:deviceName];
        
        if ([LBLelinkKitManager sharedManager].isLBlink) {
            [self playLBLink];
            if (self.lbCastState == LBVideoCastStateUnNetworkUnCastConnected) {
                [self removeAirPlayCoverView];
                closeWaitingDialog();
                [self.portraitControlView showOrhiddenTopToolView:YES];
                [self.landScapeControlView showOrhiddenTopToolView:YES];
                //恢复声音
                [self.player.currentPlayerManager setVolume:self.player.volume];
            }else{
                [self addAirPlayCoverView];
            }
        }else{
            if ([LBLelinkKitManager sharedManager].isAirPlay && [LBLelinkKitManager sharedManager].isMirroring) {
                [self removeAirPlayCoverView];
                closeWaitingDialog();
                //恢复声音
                [self.player.currentPlayerManager setVolume:self.player.volume];
                //TTVIEW_RELEASE_SAFELY(airPlayCoverView);
            }else{
                [self addAirPlayCoverView];
            }
        }
    }else{
        [self removeAirPlayCoverView];
        closeWaitingDialog();
        if (self.player.currentPlayerManager.isPreparedToPlay) {
            [self.portraitControlView showOrhiddenTopToolView:YES];
            [self.landScapeControlView showOrhiddenTopToolView:YES];
        }
    }
}

#pragma mark - 乐播投屏
- (void)playLBLink {
    if ([LBLelinkKitManager sharedManager].isLBlink) {
        
        NSString *videoUrl = self.permissionModel.video_url;
        BOOL isUrlEqual = [[LBLelinkKitManager sharedManager].videoUrl isEqualToString:videoUrl];
        if (!isEmpty(videoUrl) && (NO == isUrlEqual)) {
            NSTimeInterval time = [self playerCurrentTime];
            time = (time>0) ?time :self.playerSeekTime;// 当前时间 0 则选上次记录的时间
            [[LBLelinkKitManager sharedManager]playLBLinkWithVideoUrl:videoUrl startTime:time];
        }
        if (self.player.currentPlayerManager.isPlaying) {
            //静音
            [self.player.currentPlayerManager setVolume:0];
        }
    }
}

#pragma mark - 乐播重播
- (void)LBLinkresetPlay {
    NSString *videoUrl = self.permissionModel.video_url;
    if ([LBLelinkKitManager sharedManager].isLBlink) {
        if (self.lbCastState == LBVideoCastStateCastedConnected) {
            [[LBLelinkKitManager sharedManager]playLBLinkWithVideoUrl:videoUrl startTime:0];
        }
    }
}

#pragma mark - 乐播快进快退
- (void)lBlinkSeekToTime:(NSTimeInterval)time {
    if ([LBLelinkKitManager sharedManager].isLBlink && self.player.currentPlayerManager.isPlaying) {
        [[LBLelinkKitManager sharedManager].lelinkPlayer seekTo:time];
    }
}

- (void)volumeViewWirelessRoutesAvailableDidChangeNotification:(NSNotification*)noti  {
    // 有投屏设备
    BOOL show = self.volumView.areWirelessRoutesAvailable;
}


- (void)volumeViewWirelessRouteActiveDidChangeNotification:(NSNotification*)noti {
    // 连接投屏设备
    BOOL show = self.volumView.isWirelessRouteActive;
    if (show) {
        NSString *airName = [self audioSessionUsingAirplayOutputRoute];
        if (!isEmpty(airName) && self.player.currentPlayerManager.isPreparedToPlay) {
            //            [self removeAirPlayCoverView];
            //            [self addSubview:self.airPlayCoverView];
            //            [self makeAirPlayCoverVieConstraints];
            //            [self setAirPlayStateWithPgrogress:0];
            //            [self.airPlayCoverView setPortNameWithText:[self audioSessionUsingAirplayOutputRoute]];
        }else{
            // 蓝牙
            [self removeAirPlayCoverView];
        }
    }else{
        [self removeAirPlayCoverView];
    }
}

#pragma mark - 插入投屏视图
- (void)addAirPlayCoverView {
    [self.activity stopAnimating];
    UIView *view = [self viewWithTag:2020];
    if (nil == view) {
        [self insertSubview:self.airPlayCoverView belowSubview:self.portraitControlView];
    }
    [self.portraitControlView showOrhiddenTopToolView:NO];
    [self.landScapeControlView showOrhiddenTopToolView:NO];
}

#pragma mark - 移除投屏视图
- (void)removeAirPlayCoverView {
    TTVIEW_RELEASE_SAFELY(_airPlayCoverView);
}


- (void)makeAirPlayCoverVieConstraints {
    UIView *view = [self viewWithTag:2020];
    if (view) {
        self.airPlayCoverView.isFullScreen = (self.player.isFullScreen);
        [self.airPlayCoverView setTitleWithText:self.videoDetailModel.video_titel];
        [self.airPlayCoverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.top.equalTo(self.mas_top).offset(iPhoneX ? -15 :0);
        }];
    }
}

- (NSString*)audioSessionUsingAirplayOutputRoute {
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription* currentRoute = audioSession.currentRoute;
    for (AVAudioSessionPortDescription* outputPort in currentRoute.outputs) {
        if ([outputPort.portType isEqualToString:AVAudioSessionPortAirPlay])
            return outputPort.portName;
    }
    return @" ";
}

/** 重新 开启本地服务*/
- (void)reopenLocalServer {
    if (self.player.currentPlayerManager.isPlaying) {
        if (_httpServer && self.isDownloadFinsh) {
            NSInteger count = [self.httpServer numberOfHTTPConnections];
            if (0 == count) {
                // 本地 tcp 连接全部断开导致本地视频不能继续播放，开启重新连接
                NSLog(@"tcp connect count ---------------- %ld",count);
                [self startLocalServer:^{
                    
                } fail:^{
                    
                }];
            }
        }
    }
}

- (ZFHKNormalPlayerErrorView*)playerErrorView {
    if (!_playerErrorView) {
        _playerErrorView = [[ZFHKNormalPlayerErrorView alloc]init];
        _playerErrorView.delegate = self;
        _playerErrorView.hidden = YES;
    }
    return _playerErrorView;
}

@end



