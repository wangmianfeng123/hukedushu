//
//  HKShortVideoControlView.m
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoControlView.h"
#import "UIView+ZFHKNormalFrame.h"

#import <ZFPlayer/ZFUtilities.h>
#import "ZFLoadingView.h"
#import <ZFPlayer/ZFSliderView.h>
#import "HKShortVideoControlView+Category.h"
#import "MZTimerLabel.h"
#import "HKShortVideoModel.h"
#import "HKLivingSpeedLoadingView.h"



@interface HKShortVideoControlView ()<MZTimerLabelDelegate>
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) ZFSliderView *sliderView;
/// 加载loading
//@property (nonatomic, strong) ZFLoadingView *activity;
@property (nonatomic, strong) HKLivingSpeedLoadingView *activity;

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIView *effectView;
/** 播放失败 */
@property (nonatomic, strong) UIButton *failBtn;
/** 播放时长 */
@property (nonatomic, strong)MZTimerLabel *playerTimeLb;

@property (nonatomic, strong) LOTAnimationView *loadAnimationView;

/** bottom 阴影背景*/
@property (nonatomic, strong) UIView *bottomToolView;

@end

@implementation HKShortVideoControlView
@synthesize player = _player;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.bottomToolView];
        [self addSubview:self.activity];
        [self addSubview:self.playBtn];
        [self addSubview:self.sliderView];
        [self addSubview:self.failBtn];
        
        [self addSubview:self.playerTimeLb];
        [self resetControlView];

        [self addSubview:self.loadAnimationView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}


/// APP 进入前台
- (void)applicationDidBecomeActiveNotification {
    
    if (self.player.isViewControllerDisappear) return;
//    if (self.player.currentPlayerManager.isPreparedToPlay) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([ZFHKNormalReachabilityManager sharedManager].networkReachabilityStatus != ZFHKNormalReachabilityStatusReachableViaWiFi) {
//                if (NO == self.player.isPauseByEvent) self.player.pauseByEvent = YES;
//            }
//        });
//    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverImageView.frame = self.player.currentPlayerManager.view.bounds;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.zf_width;
    CGFloat min_view_h = self.zf_height;
    
    min_w = 75;
    min_h = 75;
    self.activity.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.activity.center = self.center;
    
    
    min_x = 0;
    //min_y = min_view_h - (IS_IPHONE_X ?KTabBarHeight49+1 :KTabBarHeight49);
    min_y = min_view_h - (IS_IPHONE_X ?1 :KTabBarHeight49);
    min_w = min_view_w;
    min_h = 1;
    self.sliderView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.bgImgView.frame = self.bounds;
    self.effectView.frame = self.bgImgView.bounds;
    
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    self.loadAnimationView.frame = CGRectMake(min_x, min_y, SCREEN_WIDTH, 1.5);
    self.loadAnimationView.centerX = self.centerX;
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(538/2);
    }];
}


- (void)resetControlView {
    self.playBtn.hidden = YES;
    self.sliderView.value = 0;
    self.sliderView.bufferValue = 0;
    self.failBtn.hidden = YES;
    //重置 时长统计
    [self resetProgressTimer];
    self.videoModel = nil;
}


/// 播放状态改变
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer playStateChanged:(ZFHKNormalPlayerPlaybackState)state {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoControlView:videoPlayer:playStateChanged:)]) {
        [self.delegate hkShortVideoControlView:self videoPlayer:videoPlayer playStateChanged:state];
    }
    
    if (state == ZFHKNormalPlayerPlayStatePlaying) {
        self.playBtn.hidden = YES;
        self.failBtn.hidden = YES;
        [self startProgressTimer];
        /// 开始播放时候判断是否显示loading
        if (videoPlayer.currentPlayerManager.loadState == ZFHKNormalPlayerLoadStateStalled) {
            //[self.activity startAnimating];
            [self startLoad];
            [self pauseProgressTimer];
        }
        
    } else if (state == ZFHKNormalPlayerPlayStatePaused) {
        self.playBtn.hidden = NO;
        self.failBtn.hidden = YES;
        [self pauseProgressTimer];
        //[self.activity stopAnimating];
        [self endLoad];
        
    }else if (state == ZFHKNormalPlayerPlayStateUnknown) {
        [self pauseProgressTimer];
        
    } else if (state == ZFHKNormalPlayerPlayStatePlayStopped) {
        [self pauseProgressTimer];
        
    }else if (state == ZFHKNormalPlayerPlayStatePlayFailed) {
        self.failBtn.hidden = NO;
        [self setFailBtnTitle];
        [self pauseProgressTimer];
        //[self.activity stopAnimating];
        [self endLoad];
    }
}




/// 加载状态改变
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer loadStateChanged:(ZFHKNormalPlayerLoadState)state {
    if (state == ZFHKNormalPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
        [self pauseProgressTimer];
        //[self.activity startAnimating];
        [self startLoad];
        
    } else if (state == ZFHKNormalPlayerLoadStatePlaythroughOK || state == ZFHKNormalPlayerLoadStatePlayable) {
        self.coverImageView.hidden = YES;
        self.effectView.hidden = NO;
        self.failBtn.hidden = YES;
        //[self.activity stopAnimating];
        [self endLoad];
    }
    
    if (state == ZFHKNormalPlayerLoadStateStalled && videoPlayer.currentPlayerManager.isPlaying) {
        //[self.activity startAnimating];
        [self startLoad];
    }
    else {
        //[self.activity stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    self.sliderView.value = videoPlayer.progress;
}


/// 播放结束
- (void)videoPlayerPlayEnd:(ZFHKNormalPlayerController *)videoPlayer {
    //暂停统计
    [self pauseProgressTimer];
}


/// 单击手势事件
- (void)gestureSingleTapped:(ZFHKNormalPlayerGestureControl *)gestureControl {
    
    
    if (!self.player) return;
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager pause];
        self.playBtn.hidden = NO;
        self.playBtn.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        [UIView animateWithDuration:0.2f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.playBtn.transform = CGAffineTransformIdentity;
                            } completion:^(BOOL finished) {
                            }];
    } else {
        [self.player.currentPlayerManager play];
        self.playBtn.hidden = YES;
    }
}


/// 双击手势事件
- (void)gestureDoubleTapped:(ZFHKNormalPlayerGestureControl *)gestureControl {
    
    if (!isLogin()) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hkShortVideoControlView:login:)]) {
            [self.delegate hkShortVideoControlView:self login:NO];
        }
        return;
    }
    if (self.gestureDoubleCallback) {
        self.gestureDoubleCallback();
    }
}




- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer reachabilityChanged:(ZFHKNormalReachabilityStatus)status {
    
    switch (status) {
        case ZFHKNormalReachabilityStatusNotReachable:
            if (NO == videoPlayer.viewControllerDisappear) {
                playerShowDialog(NETWORK_ALREADY_LOST, self, 2);
                [self endLoad];
            }
        case ZFHKNormalReachabilityStatusUnknown:
            // 无网络
            break;
        case ZFHKNormalReachabilityStatusReachableVia2G:
        case ZFHKNormalReachabilityStatusReachableVia3G:
        case ZFHKNormalReachabilityStatusReachableVia4G:
        {
            if (self.player && self.player.currentPlayerManager.isPreparedToPlay) {
            //if (self.player && (NO== isViaWWANPlayVideo) && self.player.currentPlayerManager.isPreparedToPlay) {
                
                [self.player.currentPlayerManager pause];
                if (NO == videoPlayer.viewControllerDisappear) {
                    
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
            break;
        case ZFHKNormalReachabilityStatusReachableViaWiFi:
        {
            switch (self.player.currentPlayerManager.playState) {
                case ZFHKNormalPlayerPlayStatePlayFailed:
                    [self.player.currentPlayerManager reloadPlayer];
                    break;
                case ZFHKNormalPlayerPlayStatePaused:
                    if (NO == self.player.currentPlayerManager.isPreparedToPlay) {
                        //[self.player.currentPlayerManager reloadPlayer];
                        if (self.wiFiplayCallback) {
                            self.wiFiplayCallback();
                        }
                    }else{
                        [self.player.currentPlayerManager play];
                    }
                    break;
                default:

                    [self.player.currentPlayerManager play];
                    break;
            }
        }
            break;
    }
}




- (void)setPlayer:(ZFHKNormalPlayerController *)player {
    _player = player;
    [player.currentPlayerManager.view insertSubview:self.bgImgView atIndex:0];
    [self.bgImgView addSubview:self.effectView];
    [player.currentPlayerManager.view insertSubview:self.coverImageView atIndex:1];
}



- (void)showCoverViewWithUrl:(NSString *)coverUrl {
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:coverUrl]]  placeholderImage:imageName(@"bg_video_v2_10")];
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:[HKLoadingImageTool transitionImageUrlString:coverUrl]] placeholderImage:imageName(@"bg_video_v2_10")];    
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
        /**
         if (@available(iOS 8.0, *)) {
         UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
         _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
         } else {
         UIToolbar *effectView = [[UIToolbar alloc] init];
         effectView.barStyle = UIBarStyleBlackTranslucent;
         _effectView = effectView;
         }
         */
        _effectView = [UIView new];
        _effectView.backgroundColor = [UIColor blackColor];
    }
    return _effectView;
}


//- (ZFLoadingView *)activity {
- (HKLivingSpeedLoadingView *)activity {
    if (!_activity) {
        _activity = [[HKLivingSpeedLoadingView alloc] init];
        _activity.hidden = YES;
        _activity.speedTextLabel.text = @"拼命加载中..";
    }
    return _activity;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.userInteractionEnabled = NO;
        [_playBtn setImage:imageName(@"hkplayer_center_play") forState:UIControlStateNormal];
        [_playBtn setImage:imageName(@"hkplayer_center_play") forState:UIControlStateHighlighted];
    }
    return _playBtn;
}

- (ZFSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[ZFSliderView alloc] init];
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.minimumTrackTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.6];
        _sliderView.bufferTrackTintColor  = [UIColor clearColor];
        _sliderView.sliderHeight = 0.8;
        _sliderView.isHideSliderBlock = NO;
    }
    return _sliderView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}


- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"当前视频已过期" forState:UIControlStateNormal];
        [_failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        //_failBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _failBtn.hidden = YES;
        [_failBtn setHKEnlargeEdge:20];
    }
    return _failBtn;
}


- (void)setFailBtnTitle {
    BOOL isNetwork = (AFNetworkReachabilityStatusNotReachable == [HkNetworkManageCenter shareInstance].networkStatus);
    NSString *title =  isNetwork ?@"网络未连接，请检查网络设置":@"加载失败,点击重试";
    [_failBtn setTitle:title forState:UIControlStateNormal];
}


/// 加载失败
- (void)failBtnClick:(UIButton *)sender {
    [self.player.currentPlayerManager reloadPlayer];
}



#pragma mark 播放时长 计时器
- (MZTimerLabel*)playerTimeLb {
    if (!_playerTimeLb) {
        _playerTimeLb = [[MZTimerLabel alloc] initWithFrame:CGRectZero];
        _playerTimeLb.timerType = MZTimerLabelTypeStopWatch;
        _playerTimeLb.backgroundColor = [UIColor clearColor];
        _playerTimeLb.hidden = YES;
        _playerTimeLb.tag = 100;
        _playerTimeLb.delegate = self;
    }
    return _playerTimeLb;
}


- (void)timerLabel:(MZTimerLabel *)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType {
    
//    NSLog(@"200---- %.f",time);
}


- (void)setVideoModel:(HKShortVideoModel *)videoModel {
    _videoModel = videoModel;
}


#pragma mark - 开始播放计时
- (void)startProgressTimer {
    [self.playerTimeLb start];
}


#pragma mark - 暂停播放计时
- (void)pauseProgressTimer {
    [self.playerTimeLb pause];
}

#pragma mark - 重置播放计时
- (void)resetProgressTimer {
    [self.playerTimeLb reset];
}


- (void)dealloc {
    [self pauseProgressTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (NSTimeInterval)playVideoTime {
    return [self.playerTimeLb getTimeCounted];
}




- (LOTAnimationView*)loadAnimationView {
    if (!_loadAnimationView) {
        _loadAnimationView = [LOTAnimationView animationNamed:@"hkdata.json"];
        _loadAnimationView.loopAnimation = YES;
    }
    return _loadAnimationView;
}



- (void)startLoad {
    self.loadAnimationView.hidden = NO;
    [self.loadAnimationView play];
    self.sliderView.hidden = !self.loadAnimationView.hidden;
}


- (void)endLoad {
    self.loadAnimationView.hidden = YES;
    [self.loadAnimationView pause];
    self.sliderView.hidden = !self.loadAnimationView.hidden;
}


- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = imageName(@"bg_videogradual_v2_10");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

@end


