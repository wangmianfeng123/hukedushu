
//
//  GKPlayer.m
//  GKAudioPlayerDemo
//
//  Created by QuintGao on 2017/9/7.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "HKListeningBookVC+Category.h"
#import "HKWindowBooKView.h"
#import "HKH5PushToNative.h"
#import "HKListeningBookVC.h"
#import "HKNavigationController.h"
#import "HKBookModel.h"
#import "GKPlayer+Category.h"
#import "UIView+SNFoundation.h"

#import "ZFHKNormalAVPlayerManager.h"
#import "HKVIPCategoryVC.h"



@interface GKPlayer()

/** 播放状态 */
@property (nonatomic, assign) GKPlayerStatus playState;
/** 加载缓冲状态 */
@property (nonatomic, assign) GKPlayerLoadState loadState;

@property (nonatomic, strong) IJKFFOptions *options;


@property (nonatomic, weak) NSTimer *updateUITimer;
/** 准备播放 */
@property (nonatomic, assign) BOOL isPreparedToPlay;
/** 播放中*/
@property (nonatomic, assign) BOOL isPlaying;
/** 播放当前时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;
/** 音频总时间 */
@property (nonatomic, assign) NSTimeInterval totalTime;
/** 音频缓冲时间 */
@property (nonatomic, assign) NSTimeInterval bufferTime;
/** 播放速率 */
@property (nonatomic, assign) float playRate;
/** 静音 */
@property (nonatomic, assign) BOOL muted;
/** 音量 */
@property (nonatomic, assign) float volume;

@property (nonatomic, assign) CGFloat lastVolume;
/** 倒计时 关闭音频 */
@property (nonatomic, weak) NSTimer *countDownTimer;

@property (nonatomic, strong) HKWindowBooKView *windowBooKView;

@property (nonatomic, assign) BOOL pauseByEvent;

@property (nonatomic, assign) NSTimeInterval currentTimePauseByEvent;

@property (nonatomic, assign) BOOL isApplicationActive;

@property (nonatomic, assign) BOOL isUserCloseWindow;

@property (nonatomic, strong)NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@property (nonatomic, strong) ZFHKNormalAVPlayerManager *playerManager;

@end


@implementation GKPlayer

- (void)dealloc {
    [self stop];
}


+ (instancetype)sharedInstance {
    static GKPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [GKPlayer new];
        player.isHKBookAudio = YES;
    });
    return player;
}



- (instancetype)init {
    self = [super init];
    if (self) {
        self.playState = GKPlayerStatusStopped;
        [self setRemoteCommandCenter];
    }
    return self;
}


- (void)reloadPlayer {
    [self prepareToPlay];
}


- (void)prepareToPlay {
    
    if (isEmpty(_playUrlStr)) return;
    _isPreparedToPlay = YES;
    [self initializePlayer];
    self.loadState = GKPlayerLoadStatePrepare;
    self.isPlaying = YES;
    self.isUserCloseWindow = NO;
}


- (void)play {
    
    if (NO == self.isHKBookAudio) {
        //音频播放时 暂停读书播放
        [HKBookPlayer pauseAndHiddenWindowBooKView:YES];
    }
    
    if ([self isEndFreePlaySecond]) {
        //免费试听时间结束
        return;
    }
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.playRate = 1;
        if (self.isHKBookAudio) {
            self.playRate = [self playerRecordRate];
        }
        self.player.playbackRate = self.playRate;
        self.isPlaying = YES;
        self.playState = GKPlayerStatusPlaying;
        self.isUserCloseWindow = NO;
    }
    [self setCountDownTimer];
}

//-(void)setIsPlaying:(BOOL)isPlaying{
//    _isPlaying = isPlaying;
//    if (_windowBooKView.hidden == NO) {
//        [_windowBooKView chageViewWidth:isPlaying];
//    }
//}

- (void)pause {
    [self.player pause];
    self.isPlaying = NO;
    
    self.playState = GKPlayerStatusPaused;
    
    [self deallocUpdateUITimer];
    [self recordBookPlayTime];
}


#pragma mark - 播放 暂停读书
- (void)playOrPauseAudio {
    if (self.isPlaying) {
        [self pause];
    }else {
        [self play];
    }
}


#pragma mark - 播放 读书
- (void)playAudio {
    if (!self.isPlaying) {
        //[self play];
        [self setBookPlayURLWtihModel:self.playInfoModel];
    }
}


- (void)resume {
    if (self.playState == GKPlayerStatusPaused) {
        [self play];
    }
}


- (void)stop {
    [self recordBookPlayTime];
    
    [self removeMovieNotificationObservers];
    self.playState = GKPlayerStatusStopped;
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
    
    [self deallocUpdateUITimer];
    
    _playUrlStr = nil;
    self.isPlaying = NO;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    
    self.pauseByEvent = NO;
    self.currentTimePauseByEvent = 0;
    
    [self closeRemoteCommandCenter];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gkPlayer:statusChanged:)]) {
        [self.delegate gkPlayer:self statusChanged:self.playState];
    }
}

- (void)cancelPlayAudio{
    self.bookModel = nil;
    self.playInfoModel = nil;

    if ([self.delegate respondsToSelector:@selector(gkPlayerDidCancel:)]) {
        [self.delegate gkPlayerDidCancel:self];
    }
}


#pragma mark - 重置当前播放时间
- (void)resetCurrentTime {
    
    self->_currentTime = 0;
}


#pragma mark -- 暂停读书播放  YES（隐藏小浮标)
- (void)pauseAndHiddenWindowBooKView:(BOOL)hidden {
    if (self.isPlaying) {
        [self pause];
    }
    [self hiddenWindowBooKView:hidden];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)pauseReadBooK{
    [self pause];
    [self hiddenWindowBooKView:YES];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)stopReadBooK{
    [self stop];
    [self hiddenWindowBooKView:YES];
    [self removeWindowBooKView];
}


#pragma mark - YES（隐藏小浮标)
- (void)hiddenWindowBooKView:(BOOL)hidden {
    if (isEmpty(_playUrlStr)) {
        if (_windowBooKView) {
            _windowBooKView.hidden = hidden;
        }
    }else{
        if (_windowBooKView) {
            _windowBooKView.hidden = hidden;
        }
    }
}



- (void)stopAndHiddenWindowBooKView {
    [self stop];
    [self removeWindowBooKView];
    self.bookModel = nil;
    self.playInfoModel = nil;
    self.mapModel = nil;
    self.isBookCanPlay = 0;
    self.freePlaySecond = 0;
    self.isBackFrontVC = NO;
    _timerSeconds = 0;
    [self deallocCountDownTimer];
}



/** 重播 */
- (void)replay {
    WeakSelf;
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        StrongSelf;
        [strongSelf play];
    }];
}



- (void)setSeekTime:(NSTimeInterval)seekTime {
    _seekTime = seekTime;
    self.player.currentPlaybackTime = seekTime;
    [self playTryAudioEndAlert:seekTime];
}


- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    
    [self setSeekTime:time];
    if (completionHandler) completionHandler(YES);
}




#pragma mark - setter

- (void)setIsHKBookAudio:(BOOL)isHKBookAudio {
    _isHKBookAudio = isHKBookAudio;
}

- (void)setPlayState:(GKPlayerStatus)playState {
    _playState = playState;
}


- (void)setLoadState:(GKPlayerLoadState)loadState {
    _loadState =  loadState;
    if ([self.delegate respondsToSelector:@selector(gkPlayer:loadState:)]) {
        [self.delegate gkPlayer:self loadState:self.loadState];
    }
}



- (void)setPlayUrl:(NSString *)playUrl  isNeedPlay:(BOOL)isNeedPlay {
    if (isNeedPlay) {//在读书页面
        // 赋值播放
        [self setPlayUrlStr:playUrl];
    }else{//不在读书页面
        // 赋值
        //_playUrlStr = playUrl;
        // 赋值播放
        [self setPlayUrlStr:playUrl];
    }
}


- (void)setPlayUrlStr:(NSString *)playUrlStr {
    if (self.player) {
        [self stop];
    }
    _playUrlStr = playUrlStr;
    [self play];
    
    if (self.isHKBookAudio) {
    }
    
}



- (void)setPlayRate:(float)playRate {
    //_playRate = playRate;
    _playRate = (playRate == 0) ?1 :playRate;
    if (self.player && fabsf(_player.playbackRate) > 0.00001f) {
        self.player.playbackRate = playRate;
    }
}



- (void)setMuted:(BOOL)muted {
    _muted = muted;
    if (muted) {
        self.lastVolume = self.player.playbackVolume;
        self.player.playbackVolume = 0;
    } else {
        /// Fix first called the lastVolume is 0.
        if (self.lastVolume == 0) self.lastVolume = self.player.playbackVolume;
        self.player.playbackVolume = self.lastVolume;
    }
}


- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.playbackVolume = volume;
}




#pragma mark - private method

- (void)initializePlayer {
    //http://m3u8.huke88.com/audio/hls/2019-08-12/652FE6C1-9652-CE22-1E3B-0C8021B2F9A5.m3u8?pm3u8/0/deadline/1631038550&e=1631002550&token=HUwgVvJnrW6fXOzqd_myfnE3FFoFLWJnNktg7ThD:jZOu0V2aDiUOe0otr4UA4mNX8ek=
    if (nil == self.player) {
        self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:HKURL(_playUrlStr) withOptions:self.options];
        self.player.shouldAutoplay = YES;
        self.player.allowsMediaAirPlay = NO;
        [self.player prepareToPlay];
        [self addPlayerNotificationObservers];
    }
}



- (IJKFFOptions *)options {
    if (!_options) {
        _options = [IJKFFOptions optionsByDefault];
        /// 精准seek
        [_options setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
        /// 解决http播放不了
        [_options setOptionIntValue:1 forKey:@"dns_cache_clear" ofCategory:kIJKFFOptionCategoryFormat];
        //某些视频在SeekTo的时候，会跳回到拖动前的位置，这是因为视频的关键帧的问题，通俗一点就是FFMPEG不兼容，视频压缩过于厉害，seek只支持关键帧，出现这个情况就是原始的视频文件中i 帧比较少
//        [_options setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
//        ////播放前的探测Size，默认是1M, 改小一点会出画面更快
//        [_options setPlayerOptionIntValue:1024 * 10 forKey:@"probesize"];
//        //设置seekTo能够快速seek到指定位置并播放
//        [_options setPlayerOptionValue:@"fastseek" forKey:@"fflags"];
//
//        [_options setPlayerOptionIntValue:30 forKey:@"max-fps"];
//        [_options setPlayerOptionIntValue:30 forKey:@"framedrop"];
//        [_options setPlayerOptionIntValue:1L forKey:@"flush_packets"];
        //[_options setPlayerOptionIntValue:@"1L" forKey:@"flush_packets"];

        //[_options setPlayerOptionIntValue:@"fastseek" forKey:@"fflags"];

    }
    return _options;    
}


- (void)addPlayerNotificationObservers {
    /// 准备播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    /// 播放完成或者用户退出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    /// 准备开始播放了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    /// 播放状态改变了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    // 插拔耳机
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification object:_player];
    // 播放打断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification object:_player];
    
    /// 网络状态改变了
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkStateDidChange:)
                                                 name:KNetworkStatusNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    // 注销登录
    HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, userlogoutSuccessNotification);
}




- (void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionRouteChangeNotification
                                                  object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVAudioSessionInterruptionNotification
                                                  object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KNetworkStatusNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HKLogoutSuccessNotification object:nil];
}



- (void)userlogoutSuccessNotification {
    if (self.isHKBookAudio) {
        [self stopAndHiddenWindowBooKView];
    }
}


- (void)applicationWillResignActiveNotification {
    
}


- (void)applicationDidBecomeActiveNotification {
    if (self.isPlaying) {
        [self play];
    }
}



/// 读书播放完成
- (void)bookFinishPlaybackEnded {
    @weakify(self);
    if (self.relateModel.is_play_voice) {
        //播放 免费学习即将结束
        [self playTryEndAudio:^{
            @strongify(self);
            if (self.isPlaying) {
                [self pause];
            }
            [self setTryAudioAlert];
        }];
    }else{
        [self playEndAudio:^{
            @strongify(self);
            if (self.isPlaying) {
                [self pause];
            }
        }];
    }
}


#pragma - notification
/*** 播放完成 */
- (void)moviePlayBackFinish:(NSNotification *)notification {
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded: {
            ///播放完毕
            self.playState = GKPlayerStatusEnded;
            [self recordBookPlayTime];
            @weakify(self);
           NSTimeInterval duration = self.player.duration;
           NSTimeInterval currentTime = self.player.currentPlaybackTime;
            //播放完成后 时间可能会相差1到2 秒
            if (((int)duration - (int)currentTime) >3) {
                //未播放完 停止
                [self setPlayWithNetworkStatus:^{
                    @strongify(self);
                    if (self.isPlaying) {
                        self.pauseByEvent = YES;
                        self.currentTimePauseByEvent = currentTime;
                        [self play];
                    }
                }];
            }else{
                if (_isHKBookAudio) {
                    [self bookFinishPlaybackEnded];
                }else{
                    if (self.isPlaying) {
                        [self pause];
                    }
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(gkPlayer:playerDidToEnd:)]) {
                [self.delegate gkPlayer:self playerDidToEnd:YES];
            }
        }
            break;
            
        case IJKMPMovieFinishReasonUserExited: {
            //NSLog(@"playbackStateDidChange: 用户退出播放: %d\n", reason);
        }
            break;
            
        case IJKMPMovieFinishReasonPlaybackError: {
            //播放出现错误
            NSLog(@"playbackStateDidChange: 播放出现错误: %d\n", reason);
            self.playState = GKPlayerStatusError;
            @weakify(self);
            [self setPlayWithNetworkStatus:^{
                @strongify(self);
                //重新加载播放
                if (self.isPlaying) {
                    NSString *url = self.playUrlStr;
                    [self stop];
                    [self setPlayUrlStr:url];
                }
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(gkPlayer:playbackError:)]) {
                [self.delegate gkPlayer:self playbackError:self.playState];
            }
        }
            break;
            
        default:
            //NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}


#pragma mark - 准备开始播放了
- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification {
    //加载状态变成了已经缓存完成，如果设置了自动播放, 会自动播放;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loadState = GKPlayerLoadStatePlaythroughOK;
    });
    
    /// 准备播放
    if (self.delegate && [self.delegate respondsToSelector:@selector(gkPlayer:preparedToPlay:)]) {
        [self.delegate gkPlayer:self preparedToPlay:YES];
    }
    
    if (self.isPlaying)
        if (self.isHKBookAudio) {
        //同步播放进度
        NSInteger second = self.bookModel.last_play_second;
        NSTimeInterval duration = self.player.duration;
        if ((int)duration - second < 5) {
            // 小于 10 秒 重新播放
            second = 1;
        }
        if (self.pauseByEvent){
            second = (second > self.currentTimePauseByEvent) ?second :self.currentTimePauseByEvent;
        }
        if (second) {
            if (YES == self.isBookCanPlay) {
                //同步播放进度
                [self seekToTime:second completionHandler:^(BOOL finished) {
                    
                }];
            }
//            self.bookModel.last_play_second = 0;
            
            self.currentTimePauseByEvent = 0;
        }
    }
}


#pragma mark - 加载状态改变
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = self.player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlayable)) {
        // 加载状态变成了缓存数据足够开始播放，但是视频并没有缓存完全
        self.loadState = GKPlayerLoadStatePlayable;
        if (self.isPlaying) {
            [self play];
        }
        
    } else if ((loadState & IJKMPMovieLoadStatePlaythroughOK)) {
        self.loadState = GKPlayerLoadStatePlaythroughOK;
        // 加载完成，即将播放，停止加载的动画，并将其移除
        
    } else if ((loadState & IJKMPMovieLoadStateStalled)) {
        // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
        self.loadState = GKPlayerLoadStateStalled;
        
    } else {
        //加载状态变成了未知状态
        self.loadState = GKPlayerLoadStateUnknown;
    }
}




// 播放状态改变
- (void)moviePlayBackStateDidChange:(NSNotification *)notification {
    switch (self.player.playbackState) {
        case IJKMPMoviePlaybackStateStopped: {
            //NSLog(@"播放器的播放状态变了，现在是停止状态 %d: stoped", (int)_player.playbackState);
            // 这里的回调也会来多次(一次播放完成, 会回调三次), 所以, 这里不设置
            self.playState = GKPlayerStatusStopped;
        }
            break;
            
        case IJKMPMoviePlaybackStatePlaying: {
            self.playState = GKPlayerStatusPlaying;
            self.isPlaying = YES;
            // 视频播放 开启计时器
            [self setUpdateUITimer];
            [self setCountDownTimer];
        }
            break;
            
        case IJKMPMoviePlaybackStatePaused: {
            self.playState = GKPlayerStatusPaused;
            
        }
            break;
            
        case IJKMPMoviePlaybackStateInterrupted: {

        }
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward: {
            //快进
        }
            break;
        case IJKMPMoviePlaybackStateSeekingBackward: {
            //快退
        }
            break;
            
        default: {
            //NSLog(@"播放器的播放状态变了，现在是未知状态 %d: unknown", (int)_player.playbackState);
        }
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(gkPlayer:statusChanged:)]) {
        [self.delegate gkPlayer:self statusChanged:self.playState];
    }
}



#pragma mark -  播放完 试听
- (void)playTryAudioEndAlert:(NSTimeInterval)currentPlaybackTime {
    if (self.isHKBookAudio) {
        // 免费试听
        if (NO == self.isBookCanPlay) {
            if (currentPlaybackTime >= self.freePlaySecond) {
                
                [self deallocUpdateUITimer];
                if (!self.isListeningVCDisappr) {
                    // VIP受限弹窗
                    [self setTryAudioAlert];
                }
                if (self.isPlaying) {
                    [self playTryEndAudio:nil];
                    [self pause];
                }
                return;
            }
        }
    }
}



#pragma mark - (YES 播放完 试听)
- (BOOL)isEndFreePlaySecond {
    if (self.isHKBookAudio) {
        // 免费试听
        if (NO == self.isBookCanPlay) {
            if (self.player.currentPlaybackTime > self.freePlaySecond) {
            //if (self.currentTime >= self.freePlaySecond) {
                if (!self.isListeningVCDisappr) {
                    // VIP受限弹窗
                    [self setTryAudioAlert];
                }
                
                if (self.isPlaying) {
                    [self pause];
                }
                return YES;
            }
        }
    }
    return NO;
}



#pragma mark -- VIP受限弹窗
- (void)setTryAudioAlert {
    @weakify(self);
    [HKListeningBookVC tryAudioAlert:^{
        @strongify(self);
//          if (!isEmpty(self.bookModel.vip_type)) {
            HKVIPCategoryVC * VC = [HKVIPCategoryVC new];
            VC.class_type = self.bookModel.vip_type;
            UIViewController *resultVC = [HKH5PushToNative topViewController];
            if (resultVC) {
                if (resultVC.navigationController) {
                    VC.hidesBottomBarWhenPushed = YES;
                    [resultVC.navigationController pushViewController:VC animated:YES];
                }else{
                    HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:VC];
                    [resultVC presentViewController:loginVC animated:YES completion:nil];
                }
            }
//          }
    } cancelAction:^{
        
    }];
}





#pragma mark - 时间 进度条 更新
- (void)mediaPlayerTimeChanged {
    
    NSTimeInterval time = self.player.currentPlaybackTime;
    NSTimeInterval totalTime = self.player.duration;
    NSTimeInterval bufferTime = self.player.playableDuration;
    
    [self playTryAudioEndAlert:time];
    
    float progress = (time/totalTime);
    float bufferProgress = (bufferTime/totalTime);
    
    if ([self.delegate respondsToSelector:@selector(gkPlayer:currentTime:progress:)]) {
        [self.delegate gkPlayer:self currentTime:[NSString stringWithFormat:@"%f",time] progress:progress];
    }
    
    if ([self.delegate respondsToSelector:@selector(gkPlayer:currentTime:totalTime:bufferProgress:progress:)]) {
        // 毫秒
        [self.delegate gkPlayer:self currentTime:time totalTime:totalTime bufferProgress:bufferProgress progress:progress];
    }
    
    if (self.totalTime) {
        self.totalTime = totalTime;
        if ([self.delegate respondsToSelector:@selector(gkPlayer:totalTime:)]) {
            [self.delegate gkPlayer:self totalTime:[NSString stringWithFormat:@"%f",totalTime]];
        }
        
        if ([self.delegate respondsToSelector:@selector(gkPlayer:duration:)]) {
            [self.delegate gkPlayer:self duration:totalTime];
        }
    }
}




- (void)setTimerSeconds:(NSInteger)timerSeconds {
    _timerSeconds = timerSeconds;
    if (timerSeconds) {
        [self setCountDownTimer];
    }else{
        if (_timerSeconds) {
            _timerSeconds  = 0;
        }
        [self deallocCountDownTimer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(gkPlayer:updateDownTime:)]) {
            [self.delegate gkPlayer:self updateDownTime:_timerSeconds];
        }
    }
}

/// 倒 计时器 开启
- (void)setCountDownTimer {
    
    if (GKPlayerStatusEnded == self.playState) {
        //播放结束
        [self deallocCountDownTimer];
        return;
    }
    if (!self.countDownTimer && (self.timerSeconds>0)) {
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountDownTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
    }
}


/// 视频开始播放的时候开启计时器 更新UI
- (void)setUpdateUITimer {
    if (!self.updateUITimer) {
        self.updateUITimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.updateUITimer forMode:NSRunLoopCommonModes];
    }
}


/** 更新 时间 等 UI */
- (void)updateUI {
    self->_currentTime = self.player.currentPlaybackTime;
    self->_totalTime = self.player.duration;
    self->_bufferTime = self.player.playableDuration;
    [self mediaPlayerTimeChanged];
    
    [self setNowPlayingInfoCenter];
}




///注销计时器
- (void)deallocCountDownTimer {
    
    self.timerType = HKBookTimerType_none;
    TT_INVALIDATE_TIMER(self.countDownTimer);
}


- (void)deallocUpdateUITimer {
    TT_INVALIDATE_TIMER(self.updateUITimer);
}



- (void)updateCountDownTime {
    if (0 == _timerSeconds) {
        //停止计时器
        [self deallocCountDownTimer];
        [self pause];
        return;
    }
    if(self.timerSeconds > 0) {
        _timerSeconds -= 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(gkPlayer:updateDownTime:)]) {
            [self.delegate gkPlayer:self updateDownTime:_timerSeconds];
        }
    }
}



#pragma mark - Notifications
- (void)audioSessionRouteChange:(NSNotification *)notify {
    NSDictionary *interuptionDict = notify.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            ///耳机插入  继续播放音频，什么也不用做
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {   //耳机拔出
            
        }
            break;
        default:
            break;
    }
}




- (void)audioSessionInterruption:(NSNotification *)notify {
    NSDictionary *interuptionDict = notify.userInfo;
    NSInteger interruptionType = [interuptionDict[AVAudioSessionInterruptionTypeKey] integerValue];
    NSInteger interruptionOption = [interuptionDict[AVAudioSessionInterruptionOptionKey] integerValue];
    
    if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
        // 收到播放中断的通知，暂停播放
        if (self.isPlaying) {
            [self pause];
        }
    }else {
        // 中断结束，判断是否需要恢复播放
        if (interruptionOption == AVAudioSessionInterruptionOptionShouldResume) {
            if (!self.isPlaying) {
                [self play];
            }
        }
    }
}




- (void)networkStateDidChange:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status  = [dict[@"status"] integerValue];
    
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            //断网
            showTipDialog(NETWORK_ALREADY_LOST);
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            //流量
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            //WI-FI
            break;
        default:
            break;
    }
}






- (HKWindowBooKView*)windowBooKView {
    
    @weakify(self);
    if (!_windowBooKView) {
        _windowBooKView = [[HKWindowBooKView alloc]init];
        //_windowBooKView.size = CGSizeMake(93, 62);
        _windowBooKView.size = CGSizeMake(133, 74);
        _windowBooKView.player = self;
        
        _windowBooKView.isKeepBounds = YES;
        _windowBooKView.dragDirection = WMDragDirectionVertical;
        
        _windowBooKView.x = 0;
        _windowBooKView.bottom = SCREEN_HEIGHT - KTabBarHeight49 - 46;
        _windowBooKView.tag = 100;
        _windowBooKView.hkWindowBooKViewCloseBtnClickCallBack = ^{
            @strongify(self);
            //[self stopAndHiddenWindowBooKView];
            self.isUserCloseWindow = YES;
            [self removeWindowBooKView];
            [MobClick event:UM_RECORD_AUDIO_FALIATING_WINDOW_CLOSE];
        };
        
        _windowBooKView.hkWindowBooKViewBgIVClickCallBack = ^{
            @strongify(self);
            UIViewController *resultVC = [HKH5PushToNative topViewController];
            if (resultVC) {
                if (resultVC.navigationController) {
                    __block UIViewController *vcTemp = nil;
                    __block NSInteger index = 0;
                    [resultVC.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isKindOfClass:[HKListeningBookVC class]]) {
                            // 查找 HKListeningBookVC
                            vcTemp = obj;
                            index = idx;
                            *stop = YES;
                        }
                    }];
                    if (vcTemp) {
                        //基于堆栈数组实例化新的数组
                        NSMutableArray *newControllers = resultVC.navigationController.viewControllers.mutableCopy;
                        //[newControllers exchangeObjectAtIndex:index withObjectAtIndex:(newControllers.count-1)];
                        for (NSInteger i = index; i<newControllers.count-1; i++) {
                            // 将读书VC 移到最顶层
                            [newControllers exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                        //为堆栈重新赋值
                        [resultVC.navigationController setViewControllers:newControllers animated:YES];
                    }else{
                        HKListeningBookVC *bookVC = [self listeningBookVC];
                        [resultVC.navigationController pushViewController:bookVC animated:YES];
                    }
                }else{
                    HKListeningBookVC *bookVC = [self listeningBookVC];
                    HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:bookVC];
                    [resultVC presentViewController:loginVC animated:YES completion:nil];
                }
            }
        };
        _windowBooKView.hidden = YES;
    }
    _windowBooKView.imageUrl = self.coverUrl;
    return _windowBooKView;
}



- (HKListeningBookVC*)listeningBookVC {
    HKListeningBookVC *bookVC = [[HKListeningBookVC alloc]init];
    bookVC.bookId = self.bookModel.book_id;
    bookVC.courseId = self.bookModel.course_id;
    bookVC.isFromBookPlayer = YES;
    bookVC.hidesBottomBarWhenPushed = YES;
    return bookVC;
}



- (void)showWindowBooKView {
    //处理是否显示UI
    if(_windowBooKView == nil) {
        self.windowBooKView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self.windowBooKView];
        [MobClick event:UM_RECORD_AUDIO_FALIATING_WINDOW_CLICK];
    }else{
        _windowBooKView.imageUrl = self.coverUrl;
    }
}


- (void)removeWindowBooKView {
    TTVIEW_RELEASE_SAFELY(self.windowBooKView);
}



- (void)setIsListeningVCDisappr:(BOOL)isListeningVCDisappr {

    _isListeningVCDisappr = isListeningVCDisappr;
    if (self.isHKBookAudio) {
        [self showOrRemoveWindowBooKView];
    }
    
    if (isListeningVCDisappr) {
        self.forceShowWindowBooKView = NO;
    }
}


- (void)setIsBackFrontVC:(BOOL)isBackFrontVC {
    
    _isBackFrontVC =  isBackFrontVC;
    if (self.isHKBookAudio) {
        [self showOrRemoveWindowBooKView];
    }
}



- (void)setForceShowWindowBooKView:(BOOL)forceShowWindowBooKView {
    _forceShowWindowBooKView = forceShowWindowBooKView;
    if (self.isHKBookAudio) {
        [self showOrRemoveWindowBooKView];
    }
}


#pragma mark - 小浮标 1-移除  2-创建
- (void)showOrRemoveWindowBooKView {
    
    if (_isListeningVCDisappr) {
        if (self.isPreparedToPlay && !self.isUserCloseWindow) {
            [self showWindowBooKView];
        }
    }else{
        if (self.forceShowWindowBooKView) {
            if (self.isPreparedToPlay && !self.isUserCloseWindow) {
                [self showWindowBooKView];
            }else{
                [self removeWindowBooKView];
            }
        }else{
            [self removeWindowBooKView];
        }
    }
}




- (void)setPlayWithNetworkStatus:(void(^)())callBack {
    AFNetworkReachabilityStatus status = [HkNetworkManageCenter shareInstance].networkStatus;
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            showTipDialog(NETWORK_ALREADY_LOST);
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:
            callBack ();
        default:
            break;
    }
}




- (void)testPlayerManager {
//    @property (nonatomic, strong)ZFHKNormalAVPlayerManager *playerManager;
//    self.playerManager = [[ZFHKNormalAVPlayerManager alloc] init];
//    self.playerManager.assetURL = HKURL(self.playUrlStr);
//    [self.playerManager play];
//    self.playerManager.playerPrepareToPlay = ^(id<ZFHKNormalPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
//
//    };
}



- (void)setPlayerWithBookId:(NSString*_Nullable)bookId courseId:(NSString*_Nullable)courseId isNeedquerRecord:(NSString *)isNeed{
    [self getBookInfoWithBookId:bookId courseId:courseId isNeedquerRecord:isNeed isLoginUpdate:NO];
}

//- (void)setPlayerWithBookId:(NSString*_Nullable)bookId courseId:(NSString*_Nullable)courseId {
//
//    [self getBookInfoWithBookId:bookId courseId:courseId];
//}



- (void)getBookInfoWithBookId:(NSString*)bookId courseId:(NSString*)courseId isNeedquerRecord:(NSString *)isNeed isLoginUpdate:(BOOL)islogin{
    
    if (isEmpty(bookId) || isEmpty(courseId) || (0 == [courseId intValue])) {
        return;
    }
        
    __block BOOL isCommonBookId = [self.bookModel.book_id isEqualToString:bookId];
    __block BOOL isCommonCourseId = [self.bookModel.course_id isEqualToString:courseId];
    if (isCommonBookId && isCommonCourseId && islogin == NO) {
        //  同一课程
        [self refreshListenControlViewDelegate];
        if (!self.isListeningVCDisappr) {
            [self playAudio];
        }
    }
    
    [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"3" bookId:bookId courseId:courseId];

    @weakify(self);
    [self removeSessionTask];
    NSDictionary *dict =  @{@"book_id":bookId, @"course_id":courseId, @"need_query_record":isNeed};
    NSURLSessionDataTask *sessionTask = [HKHttpTool hk_taskPost:BOOK_DETAIL allUrl:nil isGet:NO parameters:dict success:^(id responseObject) {
            @strongify(self);
               if (HKReponseOK) {
                   NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"business_message"]];
                   NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"business_code"]];

                   if (!isEmpty(msg) && ([code intValue] != 200)) {
                       //异常
                       showTipDialog(msg);
                   }else{
                       HKBookModel *bookModel = [HKBookModel mj_objectWithKeyValues:responseObject[@"data"][@"book_info"]];
                       self.mapModel = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"][@"context_redirect"]];
                       HKBookPlayInfoModel *playInfoModel = [HKBookPlayInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"playInfo"]];
                       self.shareModel = [ShareModel mj_objectWithKeyValues:responseObject[@"data"][@"share_data"]];
                       /// 上下节课程
                       HKRelateBookModel *relateModel = [HKRelateBookModel mj_objectWithKeyValues:responseObject[@"data"][@"relate_book"]];
                       self.relateModel = relateModel;
                       
                       //if ((NO == isCommonCourseId) && (NO == isCommonBookId)) {
                       if (isCommonBookId && isCommonCourseId  && islogin == NO) {
                           //正在播放的 更新书本信息
                           bookModel.book_id = bookId;
                           bookModel.course_id = playInfoModel.course_id;
                           self.bookModel = bookModel;
                           self.bookModel.last_play_second = playInfoModel.last_degree;
                           self.bookModel.vip_type = self.playInfoModel.vip_type;
                       }else{
                           
                           //  切换的不是 正在播放的
                           bookModel.book_id = bookId;
                           bookModel.course_id = playInfoModel.course_id;
                           self.bookModel = bookModel;
                           // 统计播放时长
                           [self resetCurrentTimeAndRecordPlayTime];
                           
                           self.playInfoModel = playInfoModel;
                           self.playInfoModel.cover_url = self.bookModel.cover;
                           // 赋值播放进度
                           self.bookModel.last_play_second = playInfoModel.last_degree;
                           self.bookModel.vip_type = self.playInfoModel.vip_type;
                           [self setPlayPermissionWithModel:self.playInfoModel];
                       }
//                       [self setPlayInfo:self.playInfoModel bookModel:self.bookModel];
//                       _playUrlStr = self.playInfoModel.play_url_qn;
                       [self refreshListenControlViewDelegate];
                   }
               }
    } failure:^(NSError *error) {
        
    }];
    [self.sessionTaskArray removeAllObjects];
    [self.sessionTaskArray addObject:sessionTask];
}



- (void)setPlayPermissionWithModel:(HKBookPlayInfoModel*)playInfoModel {
    
    if (!playInfoModel || (NO == isLogin())) {
        return;
    }
    if (playInfoModel.can_play || (playInfoModel.free_time >0)) {
        //可以播放
        [self setBookPlayURLWtihModel:playInfoModel];
    }else{
        // VIP受限弹窗
        if (self.isPlaying) {
            //停止播放
            [self pause];
        }
        @weakify(self);
        if (NO == self.isListeningVCDisappr) {
            [HKListeningBookVC buyVipAlert:^{
                @strongify(self);
                NSString *type = playInfoModel.vip_type;
                if (!isEmpty(type)) {
                    HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
                    VC.class_type = type;
                    UIViewController *resultVC = [HKH5PushToNative topViewController];
                    if (resultVC) {
                        VC.hidesBottomBarWhenPushed = YES;
                        [resultVC.navigationController pushViewController:VC animated:YES];
                    }
                }
            } cancelAction:^{
                [self cancelPlayAudio];
            }];
        }
    }
}



- (void)setBookPlayURLWtihModel:(HKBookPlayInfoModel*)model {
    // 设置播放地址
        AFNetworkReachabilityStatus networkStatus = [HkNetworkManageCenter shareInstance].networkStatus;
        switch (networkStatus) {
            case AFNetworkReachabilityStatusNotReachable: case AFNetworkReachabilityStatusUnknown:
                // 无网络
                if (self.isListeningVCDisappr) {
                    showTipDialog(NETWORK_ALREADY_LOST);
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                // 移动网络
                if (self.isListeningVCDisappr) {
                    // 不在读书页面
                    [self setPlayURLWtihModel:model];
                }else{
                    @weakify(self);
                    [HKListeningBookVC playtipByWWAN:^{
                        @strongify(self);
                        [self setPlayURLWtihModel:model];
                    }cancelAction:^{
                        [self cancelPlayAudio];
                    }];
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [self setPlayURLWtihModel:model];
            }
                break;
        }
}




- (void)setPlayURLWtihModel:(HKBookPlayInfoModel*)model {
    //切换课程 ,上传播放进度
    //[self resetCurrentTimeAndRecordPlayTime];
    [self setPlayInfo:self.playInfoModel bookModel:self.bookModel];
    [self setPlayUrl:model.play_url_qn isNeedPlay:!self.isListeningVCDisappr];
    [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"4" bookId:self.bookModel.book_id courseId:self.bookModel.course_id];
}


-(void)setCoverUrl:(NSString *)coverUrl{
    _coverUrl = coverUrl;
    _windowBooKView.imageUrl = coverUrl;
}

#pragma mark - 刷新读书view代理
- (void)refreshListenControlViewDelegate {
    if (!self.isListeningVCDisappr) {
         if (self.delegate &&[self.delegate respondsToSelector:@selector(gkPlayer:resetControlView:bookModel:relateBookModel:)]){
             [self.delegate gkPlayer:self resetControlView:YES bookModel:self.bookModel relateBookModel:self.relateModel];
         }
    }
}



- (void)setPlayInfo:(HKBookPlayInfoModel*)model bookModel:(HKBookModel*)bookModel{
    // 试听时长 model.free_time = 180;
    self.playInfoModel = model;
    self.bookModel = bookModel;
    self.coverUrl = model.cover_url;
    self.isBookCanPlay = model.can_play;
    self.freePlaySecond = model.free_time;
}

/// 取消网络请求
- (void)removeSessionTask  {
    [self.sessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == NSURLSessionTaskStateRunning || obj.state == NSURLSessionTaskStateSuspended ) {
            [obj cancel];
        }
    }];
}


- (NSMutableArray <NSURLSessionDataTask *> *)sessionTaskArray{
    if (!_sessionTaskArray) {
        _sessionTaskArray = [NSMutableArray array];
    }
    return _sessionTaskArray;
}




- (ZFHKNormalAVPlayerManager*)playerManager {
    if (!_playerManager) {
        _playerManager = [[ZFHKNormalAVPlayerManager alloc] init];
        _playerManager.isPauseHkAudio = NO;
    }
    return _playerManager;
}


/// 播放上一课
- (void)playPreviousMedia {
    [self setPlayerWithBookId:self.relateModel.last_book.book_id courseId:self.relateModel.last_book.course_id isNeedquerRecord:@"0"];
}

/// 播放下一课
- (void)playNextMedia {
    [self setPlayerWithBookId:self.relateModel.next_book.book_id courseId:self.relateModel.next_book.course_id isNeedquerRecord:@"0"];
}

///播放结束提示语音
- (void)playEndAudio:(void(^)())playerAudioToEnd {
    if (_isHKBookAudio) {
        
        NSString *nextId = self.relateModel.next_book.book_id;
        if (isEmpty(nextId) || (0 == [nextId intValue])) {
            // 没有下一节
            if (playerAudioToEnd) {
                playerAudioToEnd();
            }
            return;
        }
        NSURL *filePathUrl = [NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:@"audio_book_next" ofType:@"mp3"]];
        self.playerManager.assetURL = filePathUrl;
        @weakify(self);
        self.playerManager.playerDidToEnd = ^(id<ZFHKNormalPlayerMediaPlayback>  _Nonnull asset) {
            @strongify(self);
            [self playNextMedia];
        };
    }
}



///播放试听提示语音
- (void)playTryEndAudio:(void(^)())playerAudioToEnd {
    NSURL *filePathUrl = [NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:@"audio_book_try" ofType:@"mp3"]];
    self.playerManager.assetURL = filePathUrl;
    self.playerManager.playerDidToEnd = ^(id<ZFHKNormalPlayerMediaPlayback>  _Nonnull asset) {
        if (playerAudioToEnd) {
            playerAudioToEnd();
        }
    };
}

@end




