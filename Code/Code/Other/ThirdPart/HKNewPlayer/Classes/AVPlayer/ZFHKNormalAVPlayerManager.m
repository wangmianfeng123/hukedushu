//
//  ZFHKNormalAVPlayerManager.m
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

#import "ZFHKNormalAVPlayerManager.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZFHKNormalPlayer.h"

#import "ZFHNomalCustom.h"
#import "HKPlaytipByWWANTool.h"
#import "ZFHKNormalAVPlayerManager+Category.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

/*!
 *  Refresh interval for timed observations of AVPlayer
 */
static float const kTimeRefreshInterval          = 0.1;
static NSString *const kStatus                   = @"status";
static NSString *const kLoadedTimeRanges         = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty      = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp   = @"playbackLikelyToKeepUp";
static NSString *const kPresentationSize         = @"presentationSize";

static NSString *const kTimeControlStatus = @"timeControlStatus";

@interface ZFHKNormalPlayerPresentView : ZFHKNormalPlayerView

@property (nonatomic, strong) AVPlayer *player;
/// default is AVLayerVideoGravityResizeAspect.
@property (nonatomic, strong) AVLayerVideoGravity videoGravity;
/// 音频播放封面
@property (nonatomic, strong)ZFHKNormalPlayerAudioCoverView *audioCoverView;

@property(nonatomic,copy)void (^hKNormalPlayerPresentView)(ZFHKNormalPlayerPresentView *view ,UIButton *audioBtn);

@end

@implementation ZFHKNormalPlayerPresentView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)avLayer {
    return (AVPlayerLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.audioCoverView];
//        [self.audioCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
    }
    return self;
}

- (void)setPlayer:(AVPlayer *)player {
    if (player == _player) return;
    self.avLayer.player = player;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if (videoGravity == self.videoGravity) return;
    [self avLayer].videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return [self avLayer].videoGravity;
}


- (ZFHKNormalPlayerAudioCoverView*)audioCoverView {
    if (!_audioCoverView) {
        @weakify(self);
        _audioCoverView = [[ZFHKNormalPlayerAudioCoverView alloc]initWithFrame:self.bounds];
        _audioCoverView.hKNormalPlayerAudioCoverViewCallback = ^(ZFHKNormalPlayerAudioCoverView * _Nonnull view, UIButton * _Nonnull audioBtn) {
            @strongify(self);
            if (self.hKNormalPlayerPresentView) {
                self.hKNormalPlayerPresentView(self, audioBtn);
            }
        };
    }
    return _audioCoverView;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // Determine whether you can receive touch events
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    // Determine if the touch point is out of reach
    if (![self pointInside:point withEvent:event]) return nil;
    NSInteger count = self.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childPoint withEvent:event];

        if (self.audioCoverView.hidden == NO) {
            CGPoint buttonPoint = [self.audioCoverView.audioBtn convertPoint:point fromView:self];
            if ([self.audioCoverView.audioBtn pointInside:buttonPoint withEvent:event]) {
                //响应 返回视频按钮点击
                return self.audioCoverView.audioBtn;
            }
        }
        if (fitView) {
            return fitView;
        }
    }
    return self;
}


@end

@interface ZFHKNormalAVPlayerManager () {
    id _timeObserver;
    id _itemEndObserver;
    id _playerFailEndObserver;
    id _playerPlaybackStalled;
    
    ZFHKNormalKVOController *_playerItemKVO;
}
@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isReadyToPlay;
//截屏
@property (nonatomic,strong)AVPlayerItemVideoOutput * videoOutput;
@end


@implementation ZFHKNormalAVPlayerManager

@synthesize view                           = _view;
@synthesize currentTime                    = _currentTime;
@synthesize totalTime                      = _totalTime;
@synthesize playerPlayTimeChanged          = _playerPlayTimeChanged;
@synthesize playerBufferTimeChanged        = _playerBufferTimeChanged;
@synthesize playerDidToEnd                 = _playerDidToEnd;
@synthesize bufferTime                     = _bufferTime;
@synthesize playState                      = _playState;
@synthesize loadState                      = _loadState;
@synthesize assetURL                       = _assetURL;
@synthesize playerPrepareToPlay            = _playerPrepareToPlay;
@synthesize playerReadyToPlay              = _playerReadyToPlay;
@synthesize playerPlayStateChanged         = _playerPlayStateChanged;
@synthesize playerLoadStateChanged         = _playerLoadStateChanged;
@synthesize seekTime                       = _seekTime;
@synthesize muted                          = _muted;
@synthesize volume                         = _volume;
@synthesize presentationSize               = _presentationSize;
@synthesize isPlaying                      = _isPlaying;
@synthesize rate                           = _rate;
@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize scalingMode                    = _scalingMode;
@synthesize playerPlayFailed               = _playerPlayFailed;
@synthesize presentationSizeChanged        = _presentationSizeChanged;

@synthesize isAudioplay                    = _isAudioplay;
@synthesize quitAudioPlayCallBack          = _quitAudioPlayCallBack;
@synthesize videoDetailModel               = _videoDetailModel;
@synthesize isFailPause                    = _isFailPause;




- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = ZFHKNormalPlayerScalingModeAspectFit;
        _isPauseHkAudio = YES;
    }
    return self;
}

- (void)prepareToPlay {
    
    if (!_assetURL) return;
    _isPreparedToPlay = YES;
    [self initializePlayer];
    [self play];
    self.loadState = ZFHKNormalPlayerLoadStatePrepare;
    if (_playerPrepareToPlay) _playerPrepareToPlay(self, self.assetURL);
    
}

- (void)reloadPlayer {
    self.seekTime = self.currentTime;
    [self prepareToPlay];
}

//- (void)play {
//    if (!_isPreparedToPlay) {
//        [self prepareToPlay];
//    } else {
//        [self.player play];
//        self.player.rate = self.rate;
//        self->_isPlaying = YES;
//        self.playState = ZFHKNormalPlayerPlayStatePlaying;
//    }
//}

- (void)play {
    /// 移动网络不播放 ( 短视频 )
    if (([ZFHKNormalReachabilityManager sharedManager].networkReachabilityStatus != ZFHKNormalReachabilityStatusReachableViaWiFi ) && self.isNoGPRSPlayShortVideo) {
//        BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKGPRSSwitch];
//        if (on) {
//            // 开启流量观看
//        }else{
//            [self pause];
//            return;
//        }
    }
    
    // 暂停虎课读书
    if (_isPauseHkAudio) {
        [HKBookPlayer pauseAndHiddenWindowBooKView:YES];
    }
    
    if (!_isPreparedToPlay) {
        [self prepareToPlay];

    } else {
        [self.player play];
        self.player.rate = self.rate;
        self->_isPlaying = YES;
        self.playState = ZFHKNormalPlayerPlayStatePlaying;
        
        if (_isAudioplay) {
            [self setNormalAVPlayerNowPlayingInfoCenter];
            ((ZFHKNormalPlayerPresentView *)self.view).audioCoverView.hidden = !_isAudioplay;
        }
    }
}

- (void)pause {
    [self.player pause];
    self->_isPlaying = NO;
    self.playState = ZFHKNormalPlayerPlayStatePaused;
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
}

- (void)stop {
    
    //隐藏音频封面
    ((ZFHKNormalPlayerPresentView *)self.view).audioCoverView.hidden = YES;
    if (_isAudioplay) {
        //[self closeNormalAVPlayerRemoteCommandCenter];
    }
    [_playerItemKVO safelyRemoveAllObservers];
    
    self.loadState = ZFHKNormalPlayerLoadStateUnknown;
    if (self.player.rate != 0) [self.player pause];
    [self.player removeTimeObserver:_timeObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    _timeObserver = nil;
    // 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:_itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    _itemEndObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:_playerFailEndObserver name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
    _playerFailEndObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:_playerPlaybackStalled name:AVPlayerItemPlaybackStalledNotification object:self.playerItem];
    _playerPlaybackStalled = nil;
    
    _isPlaying = NO;
    _player = nil;
    _assetURL = nil;
    _playerItem = nil;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    self.isReadyToPlay = NO;
    self.playState = ZFHKNormalPlayerPlayStatePlayStopped;
}

- (void)replay {
    @weakify(self)
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        @strongify(self)
        [self play];
    }];
}

/// Replace the current playback address
- (void)replaceCurrentAssetURL:(NSURL *)assetURL {
    self.assetURL = assetURL;
}

//- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
//    if (self.totalTime > 0) {
//        CMTime seekTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
//        //[_player seekToTime:seekTime toleranceBefore:kCMTimePositiveInfinity toleranceAfter:kCMTimePositiveInfinity completionHandler:completionHandler];
//        //CMTime seekTime = CMTimeMake(time, 1);
//        [_player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
//    } else {
//        self.seekTime = time;
//    }
//    NSLog(@"seekTime --- %.f,",time);
//}


- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if (self.totalTime > 0) {
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay ) {
            @weakify(self);
            CMTime seekTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC); // CMTimeMake(time, 1);
            [_player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                @strongify(self);
                if (completionHandler ) completionHandler(finished);
            }];
        }
    } else {
        self.seekTime = time;
    }
}

#pragma mark - private method

/// Calculate buffer progress
- (NSTimeInterval)availableDuration {
    NSArray *timeRangeArray = _playerItem.loadedTimeRanges;
    CMTime currentTime = [_player currentTime];
    BOOL foundRange = NO;
    CMTimeRange aTimeRange = {0};
    if (timeRangeArray.count) {
        aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        if (CMTimeRangeContainsTime(aTimeRange, currentTime)) {
            foundRange = YES;
        }
    }
    
    if (foundRange) {
        CMTime maxTime = CMTimeRangeGetEnd(aTimeRange);
        NSTimeInterval playableDuration = CMTimeGetSeconds(maxTime);
        if (playableDuration > 0) {
            return playableDuration;
        }
    }
    return 0;
}



- (nullable NSError *)playerError {
    
    if ( _player.error != nil ) {
        return _player.error;
    }
    
    if (_player.currentItem.error != nil ) {
        return _player.currentItem.error;
    }
    
    if (_playerItem.error != nil ) {
        return _playerItem.error;
    }
    AVPlayerItemErrorLog *log = self.playerItem.errorLog;
    return nil;
}


- (void)initializePlayer {
    _asset = [AVURLAsset assetWithURL:self.assetURL];
    _playerItem = [AVPlayerItem playerItemWithAsset:_asset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    //_videoOutput = [[AVPlayerItemVideoOutput alloc]initWithPixelBufferAttributes:nil];
    _videoOutput = [[AVPlayerItemVideoOutput alloc] init];
    [_playerItem addOutput:_videoOutput];


    
    [self enableAudioTracks:YES inPlayerItem:_playerItem];
    
    ZFHKNormalPlayerPresentView *presentView = (ZFHKNormalPlayerPresentView *)self.view;
    //presentView.player = _player;
    if (_isAudioplay) {
        
    }else{
        presentView.player = _player;
    }
    
    self.scalingMode = _scalingMode;
    if (@available(iOS 9.0, *)) {
        _playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
    }
    if (@available(iOS 10.0, *)) {
        // 缓冲时间
//        if (DEBUG) {
//            _playerItem.preferredForwardBufferDuration = 100;
//        }else{
//            _playerItem.preferredForwardBufferDuration = 600;
//        }
        _playerItem.preferredForwardBufferDuration = 600;
        
        // m3u8 设为YES(快进时有时不能跳转到指定位置) 。MP4格式 NO
        //_player.automaticallyWaitsToMinimizeStalling = NO;
    }
    [self itemObserving];
}

/// Playback speed switching method
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem {
    for (AVPlayerItemTrack *track in playerItem.tracks){
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo]) {
            track.enabled = enable;
        }
    }
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    if (self.isBuffering || self.playState == ZFHKNormalPlayerPlayStatePlayStopped) return;
    /// 没有网络
    if ([ZFHKNormalReachabilityManager sharedManager].networkReachabilityStatus == ZFHKNormalReachabilityStatusNotReachable) return;
    self.isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.isPlaying) {
            self.isBuffering = NO;
            return;
        }
        // v2.18 注释 由于有监听 缓冲播放，
        //[self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        self.isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) [self bufferingSomeSecond];
    });
}

- (void)itemObserving {
    [_playerItemKVO safelyRemoveAllObservers];
    _playerItemKVO = [[ZFHKNormalKVOController alloc] initWithTarget:_playerItem];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kStatus
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackBufferEmpty
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackLikelyToKeepUp
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kLoadedTimeRanges
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPresentationSize
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    
    //CMTime interval = CMTimeMakeWithSeconds(kTimeRefreshInterval, NSEC_PER_SEC);
    CMTime interval = CMTimeMakeWithSeconds(self.timeRefreshInterval > 0 ? self.timeRefreshInterval : 0.1, NSEC_PER_SEC);
    
    
    @weakify(self)
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @strongify(self)
        if (!self) return;
        NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
        /// 大于0才把状态改为可以播放，解决黑屏问题
        if (CMTimeGetSeconds(time) > 0 && !self.isReadyToPlay) {
            self.isReadyToPlay = YES;
            self.loadState = ZFHKNormalPlayerLoadStatePlaythroughOK;
        }
        if (loadedRanges.count > 0) {
            if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
        }
        self.isFailPause = NO;
    }];
    
    _itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        if (!self) return;
        self.playState = ZFHKNormalPlayerPlayStatePlayStopped;
        if (self.playerDidToEnd) self.playerDidToEnd(self);
    }];
    
    
    _playerFailEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        if (!self) return;
        NSError *error = note.userInfo[AVPlayerItemFailedToPlayToEndTimeErrorKey];
        if (error) {
            _isFailPause = YES;
            self.playState = ZFHKNormalPlayerPlayStatePlayFailed;
            if (self.playerPlayFailed) self.playerPlayFailed(self, [self playerError]);
        }
    }];


    _playerPlaybackStalled = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemPlaybackStalledNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        if (!self) return;
        if ([ZFHKNormalReachabilityManager sharedManager].networkReachabilityStatus == ZFHKNormalReachabilityStatusNotReachable) {
            /// 无网
            NSError *error = [NSError errorWithDomain:@"hkNetworkLoss" code:1000 userInfo:nil];
            if (error) {
                _isFailPause = YES;
                self.playState = ZFHKNormalPlayerPlayStatePlayFailed;
                if (self.playerPlayFailed) self.playerPlayFailed(self, error);
            }
        }
    }];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:kStatus]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                /// 第一次初始化
                if (self.loadState == ZFHKNormalPlayerLoadStatePrepare) {
                    if (self.playerReadyToPlay) self.playerReadyToPlay(self, self.assetURL);
                }
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                    self.seekTime = 0;
                }
                if (self.isPlaying) [self play];
                self.player.muted = self.muted;
                NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
                if (loadedRanges.count > 0) {
                    /// Fix https://github.com/renzifeng/ZFHKNormalPlayer/issues/475
                    if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.playState = ZFHKNormalPlayerPlayStatePlayFailed;
                NSError *error = self.player.currentItem.error;
                if (self.playerPlayFailed) self.playerPlayFailed(self, error);
            }
        } else if ([keyPath isEqualToString:kPlaybackBufferEmpty]) {
            // When the buffer is empty
            if (self.playerItem.playbackBufferEmpty) {
                self.loadState = ZFHKNormalPlayerLoadStateStalled;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) {
            // When the buffer is good
            if (self.playerItem.playbackLikelyToKeepUp) {
                self.loadState = ZFHKNormalPlayerLoadStatePlayable;
                if (self.isPlaying) [self play];
            }
        } else if ([keyPath isEqualToString:kLoadedTimeRanges]) {
            NSTimeInterval bufferTime = [self availableDuration];
            self->_bufferTime = bufferTime;
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, bufferTime);
        } else if ([keyPath isEqualToString:kPresentationSize]) {
            self->_presentationSize = self.playerItem.presentationSize;
            if (self.presentationSizeChanged) {
                self.presentationSizeChanged(self, self->_presentationSize);
            }
        } else if ([keyPath isEqualToString:kTimeControlStatus]) {
            NSLog(@"kTimeControlStatus");
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}

#pragma mark - getter

- (UIView *)view {
    if (!_view) {
        @weakify(self);
        _view = [[ZFHKNormalPlayerPresentView alloc] init];
        ((ZFHKNormalPlayerPresentView *)_view).hKNormalPlayerPresentView = ^(ZFHKNormalPlayerPresentView *view, UIButton *audioBtn) {
            @strongify(self);
            if (self.quitAudioPlayCallBack) {
                self.quitAudioPlayCallBack(self);
            }
        };
    }
    return _view;
}

- (float)rate {
    return _rate == 0 ?1:_rate;
}

- (NSTimeInterval)totalTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (NSTimeInterval)currentTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.playerItem.currentTime);
    if (isnan(sec) || sec < 0) {
        return 0;
    }
    return sec;
}

#pragma mark - setter

- (void)setPlayState:(ZFHKNormalPlayerPlaybackState)playState {
    _playState = playState;
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setLoadState:(ZFHKNormalPlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)setAssetURL:(NSURL *)assetURL {
    if (self.player) [self stop];
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    if (self.player && fabsf(_player.rate) > 0.00001f) {
        self.player.rate = rate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.muted = muted;
}

- (void)setScalingMode:(ZFHKNormalPlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    ZFHKNormalPlayerPresentView *presentView = (ZFHKNormalPlayerPresentView *)self.view;
    switch (scalingMode) {
        case ZFHKNormalPlayerScalingModeNone:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case ZFHKNormalPlayerScalingModeAspectFit:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case ZFHKNormalPlayerScalingModeAspectFill:
            presentView.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case ZFHKNormalPlayerScalingModeFill:
            presentView.videoGravity = AVLayerVideoGravityResize;
            break;
        default:
            break;
    }
}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.volume = volume;
}


- (void)setIsAudioplay:(BOOL)isAudioplay {
    _isAudioplay = isAudioplay;
    ((ZFHKNormalPlayerPresentView *)self.view).audioCoverView.hidden = !isAudioplay;
    
    if (isAudioplay) {
        ZFHKNormalPlayerPresentView *presentView = (ZFHKNormalPlayerPresentView *)self.view;
        presentView.player = nil;
        presentView.avLayer.player = nil;
        
        [self setNormalAVPlayerRemoteCommandCenter];
        [self setNormalAVPlayerNowPlayingInfoCenter];
    }else{
        ZFHKNormalPlayerPresentView *presentView = (ZFHKNormalPlayerPresentView *)self.view;
        presentView.player = _player;
        [self closeNormalAVPlayerRemoteCommandCenter];
    }
}


- (void)failedToPlayToEndTime:(NSNotification *)note {
    NSError *_Nullable error = note.userInfo[AVPlayerItemFailedToPlayToEndTimeErrorKey];
    if ( error != nil ) {
        
    }
}

- (UIImage *)thumbnailImageAtCurrentTime{
    UIImage * image =[self screenshotsm3u8WithCurrentTime:self.player.currentTime playerItemVideoOutput:self.videoOutput];
    return image;
    //UIImageWriteToSavedPhotosAlbum(image,nil, nil,nil);
}

-(UIImage *)screenshotsm3u8WithCurrentTime:(CMTime)currentTime playerItemVideoOutput:(AVPlayerItemVideoOutput *)output{
    
    CVPixelBufferRef pixelBuffer = [output copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage
                                                   fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    UIImage *frameImg = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    //不释放会造成内存泄漏
    CVBufferRelease(pixelBuffer);
    return frameImg;
}

-(void)dealloc{
    HK_NOTIFICATION_REMOVE();
}


//- (UIImage *)thumbnailImageAtCurrentTime {
//    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:_asset];
//    CMTime expectedTime = _playerItem.currentTime;
//    CGImageRef cgImage = NULL;
//
//    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
//    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
//    cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
//
//    if (!cgImage) {
//        imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
//        imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
//        cgImage = [imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
//    }
//
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    return image;
//}

//- (void)getImageFromVedio{
//    CGSize size = CGSizeMake(self.view.width, self.view.height);
//    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
//    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageWriteToSavedPhotosAlbum(image,nil, nil,nil);
//    UIGraphicsEndImageContext();
//
//}

//- (void)getImageFromVedio{
//    NSDictionary * opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset * urlAsset = [AVURLAsset URLAssetWithURL:self.assetURL options:opts];
//    AVAssetImageGenerator * generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
//    generator.appliesPreferredTrackTransform = YES;
//     generator.maximumSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//    NSError *error = nil;
//    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
//    if (error != nil) {
//        NSLog(@"--------");
//    }else{
//        //这里写你需要展示的地方 img就是拿到的图片 //[UIImage imageWithCGImage:img] 用这个方法转换成UIImage对象
//        UIImage * image = [UIImage imageWithCGImage:img];
//        NSLog(@"--------");
//    }
//}

//- (void)getImageFromVedio{
//    AVURLAsset *urlSet = [AVURLAsset assetWithURL:self.assetURL];
//    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
//
//    NSError *error = nil;
//    CMTime time = CMTimeMake(50,10);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
//    CMTime actucalTime; //缩略图实际生成的时间
//    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
//    if (error) {
//        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
//    }
//    CMTimeShow(actucalTime);
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    UIImageWriteToSavedPhotosAlbum(image,nil, nil,nil);
//    CGImageRelease(cgImage);
//
//    NSLog(@"视频截取成功");
//}


//-(void)getImageFromVedio{
//
////     AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.assetURL options:nil];
//
//     AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
//
//    gen.appliesPreferredTrackTransform = YES;//按正确方向对视频进行截图,关键点是将AVAssetImageGrnerator对象的appliesPreferredTrackTransform属性设置为YES。
//
//     CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//
//     NSError *error = nil;
//
//     CMTime actualTime;
//
//     CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//
//     UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
//
//     CGImageRelease(image);
//}




//-(void)getImageFromVedio{
////    UIImage *image = [self thumbnailImageForVideo];
////    UIImage * image = [self getPixelBufferForItem:self.playerItem];
//
//
//    UIImage * image =[self screenshotsm3u8WithCurrentTime:self.player.currentTime playerItemVideoOutput:self.videoOutput];
//
//    UIImageWriteToSavedPhotosAlbum(image,nil, nil,nil);
//}
//- (NSData *)imageDataScreenShot{
//    CGSize imageSize = CGSizeZero;
//    imageSize = [UIScreen mainScreen].bounds.size;
//
//    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    for (UIWindow *window in [[UIApplication sharedApplication] windows])
//    {
//        CGContextSaveGState(context);
//        CGContextTranslateCTM(context, window.center.x, window.center.y);
//        CGContextConcatCTM(context, window.transform);
//        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
//        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
//        {
//            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//        }
//        else
//        {
//            [window.layer renderInContext:context];
//        }
//        CGContextRestoreGState(context);
//    }
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return UIImagePNGRepresentation(image);
//}

//获取视频封面  videoURL:视频网络地址
//- (UIImage*)thumbnailImageForVideo{
//
////    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
//
//    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:self.asset];
//
//    gen.appliesPreferredTrackTransform = YES;
//
//    CMTime time = CMTimeMakeWithSeconds(2.0, 600);
//
//    NSError *error = nil;
//
//    CMTime actualTime;
//
//    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//
//    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
//
//    return thumbImg;
//
//}
@end

#pragma clang diagnostic pop









