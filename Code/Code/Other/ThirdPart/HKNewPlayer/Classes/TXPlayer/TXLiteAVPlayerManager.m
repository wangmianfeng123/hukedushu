//
//  TXLiteAVPlayerManager.m
//  Code
//
//  Created by ivan on 2020/7/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import "TXLiteAVPlayerManager.h"
#import "TXLiteAVPlayerManager+Category.h"
//#import "VideoPlayVC.h"
//#import "HKLiveCourseVC.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZFHKNormalPlayer.h"

#import "ZFHNomalCustom.h"
#import "HKPlaytipByWWANTool.h"
#import "ZFHKNormalAVPlayerManager+Category.h"


#import "NSString+URL.h"
#import "HKPermissionVideoModel.h"
#import "NetWatcher.h"
#import "HKVideoPlaylnstance.h"
#import "VideoPlayVC.h"
#import "HKLiveCourseVC.h"
#import "HKShortVideoHomeVC.h"
#import "LBLelinkKitManager.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

#define SUPPORT_PARAM_MAJOR_VERSION (8)
#define SUPPORT_PARAM_MINOR_VERSION (2)

/*!
 *  Refresh interval for timed observations of AVPlayer
 */

static NSString *const kStatus                   = @"status";
static NSString *const kLoadedTimeRanges         = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty      = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp   = @"playbackLikelyToKeepUp";
static NSString *const kPresentationSize         = @"presentationSize";

static NSString *const kTimeControlStatus = @"timeControlStatus";

@interface ZFHKTXLitePlayerPresentView : ZFHKNormalPlayerView

/// 音频播放封面
@property (nonatomic, strong)ZFHKNormalPlayerAudioCoverView *audioCoverView;

@property(nonatomic,copy)void (^hKNormalPlayerPresentView)(ZFHKTXLitePlayerPresentView *view ,UIButton *audioBtn);

@end

@implementation ZFHKTXLitePlayerPresentView


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

-(void)layoutSubviews{
    [super layoutSubviews];
    self.audioCoverView.center = self.center;
    self.audioCoverView.frame = self.bounds;
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


@interface TXLiteAVPlayerManager ()<TXVodPlayListener,TXVideoCustomProcessDelegate>{
    id _timeObserver;
    id _itemEndObserver;
    id _playerFailEndObserver;
    id _playerPlaybackStalled;
    
    ZFHKNormalKVOController *_playerItemKVO;
    
    NSURLSessionTask *_currentLoadingTask;
}


@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;

@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isReadyToPlay;

@property (nonatomic, strong) SuperPlayerModel *playerModel;
/// 由协议解析出分辨率定义表
@property (strong, nonatomic) NSArray<SPSubStreamInfo *> *resolutions;
@property NetWatcher *netWatcher;
@property (nonatomic , assign) CVPixelBufferRef pixelBuffer ;
@end


@implementation TXLiteAVPlayerManager

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
@synthesize isDown                         = _isDown;
@synthesize permissionModel                = _permissionModel;



- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = ZFHKNormalPlayerScalingModeAspectFit;
        _isPauseHkAudio = YES;
        [self setNormalAVPlayerRemoteCommandCenter];
    }
    return self;
}

//- (void)thumbnailTXImageAtCurrentTime:(void(^)(UIImage * image))Imgblock{
//    [self.vodPlayer snapshot:^(UIImage * img) {
//        Imgblock(img);
//    }];
//}


- (void)prepareToPlay {
    
    if (!_assetURL) return;
    _isPreparedToPlay = YES;
    
//    if (self.permissionModel.tx_file_id.length) {
        [self _playWithModel:self.playerModel];
//    }else{
//        [self initializePlayer];
//    }
    [self play];
    self.loadState = ZFHKNormalPlayerLoadStatePrepare;
    if (_playerPrepareToPlay) _playerPrepareToPlay(self, self.assetURL);
    
}

- (void)updatePlayStatus{
//    self.playState = ZFHKNormalPlayerPlayStatePlaying;
}

- (void)reloadPlayer {
    //    // 移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    self.vodPlayer = nil;
    
    self.seekTime = self.currentTime;
    
    [self prepareToPlay];
}

- (void)play {
    
    UIViewController *topVC = [CommonFunction topViewController];
    if ([topVC isKindOfClass:[VideoPlayVC class]] || [topVC isKindOfClass:[HKLiveCourseVC class]] || [topVC isKindOfClass:[HKShortVideoHomeVC class]]) {
        [HKBookPlayer stopReadBooK];
    }
    
    if (!_isPreparedToPlay) {
        [self prepareToPlay];

    } else {
        
        [self.vodPlayer resume];
        [self.vodPlayer setRate:self.rate];
        _isPlaying = YES;
        
        if (self.playState != ZFHKNormalPlayerPlayStatePlayFailed) {
            self.playState = ZFHKNormalPlayerPlayStatePlaying;
        }
        
        if (_isAudioplay) {
            ((ZFHKTXLitePlayerPresentView *)self.view).audioCoverView.hidden = !_isAudioplay;
        }
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)pause {
    [self.vodPlayer pause];
    _isPlaying = NO;
    if (self.playState != ZFHKNormalPlayerPlayStatePlayFailed) {
        self.playState = ZFHKNormalPlayerPlayStatePaused;
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)stop {
    //隐藏音频封面
    ((ZFHKTXLitePlayerPresentView *)self.view).audioCoverView.hidden = YES;
    if (_isAudioplay) {
        //[self closeNormalAVPlayerRemoteCommandCenter];
    }
    
    self.loadState = ZFHKNormalPlayerLoadStateUnknown;
    
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    self.vodPlayer = nil;
    
    _isPlaying = NO;
    _assetURL = nil;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    self.isReadyToPlay = NO;
    self.playState = ZFHKNormalPlayerPlayStatePlayStopped;
    
    [self _removeOldPlayer];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


- (void)replay {
    @weakify(self)
    [self seekToTime:0.0 completionHandler:^(BOOL finished) {
        @strongify(self)
        [self play];
    }];
}

/// Replace the current playback address
- (void)replaceCurrentAssetURL:(NSURL *)assetURL {
    self.assetURL = assetURL;
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if (self.totalTime > 0) {
        //if (self.playerItem.status == AVPlayerItemStatusReadyToPlay ) {
        
        [self.vodPlayer resume];
        [self.vodPlayer seek:time];
        if (completionHandler) completionHandler(NO);
    } else {
        self.seekTime = time;
    }
}

#pragma mark - private method

/// Calculate buffer progress
- (NSTimeInterval)availableDuration {
    if (self.vodPlayer) {
        return self.vodPlayer.playableDuration;
    }
    
    return 0;
}

- (void)initializePlayer {
//    if (!self.isNoGPRSPlayShortVideo) {
//        TXVodPlayer * player = [HKVideoPlaylnstance sharedInstance].vodPlayer;
//        [player stopPlay];
//        [player removeVideoWidget];
//        [self _removeOldPlayer];
//        player = nil;
//        [HKVideoPlaylnstance sharedInstance].vodPlayer = nil;
//    }

    
    //投屏问题
    if ([LBLelinkKitManager sharedManager].isAirPlay &&
        ![LBLelinkKitManager sharedManager].isMirroring){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initVodPlayer];
        });
    }else{
        [self initVodPlayer];
    }
}

- (void)initVodPlayer{
    self.netWatcher = [[NetWatcher alloc] init];
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    [self.vodPlayer exitPictureInPicture];

    self.vodPlayer = nil;
    self.vodPlayer = [[TXVodPlayer alloc] init];
    self.vodPlayer.vodDelegate = self;
    
    [TXLiveBase setConsoleEnabled:NO];
    // 时移
    [TXLiveBase setAppID:[NSString stringWithFormat:@"%ld", _playerModel.appId]];

    
    TXVodPlayConfig *config = [[TXVodPlayConfig alloc] init];
//    config.smoothSwitchBitrate = YES;
    config.progressInterval = 1;
    //config.preferredResolution = 720 * 1280;
    config.playerType = PLAYER_AVPLAYER;
    config.maxPreloadSize = 1;

    
    self.vodPlayer.enableHWAcceleration = YES;
    self.vodPlayer.videoProcessDelegate = self;
    [self.vodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    [self.vodPlayer setConfig:config];

    //insertIndex:0 短视频播放会黑屏
    [self.vodPlayer setupVideoWidget:self.view insertIndex:1];
    
    //https://m3u8.huke88.com/video/hls/v_1/2021-07-01/5FDC4824-2765-0F05-744E-E8F21725310F.m3u8?pm3u8/0/deadline/1666866217&e=1666853617&token=HUwgVvJnrW6fXOzqd_myfnE3FFoFLWJnNktg7ThD:AP_e9Q_AlISjK_GVd4lkvb71GHE=
    if (_isDown == YES) {
        [self.vodPlayer startPlay:[self.assetURL absoluteString]];
    }else{
        
        NSInteger line = [HKNSUserDefaults integerForKey:HKVideoPlayerPlayLine];
        if (line == 2) {
            if (_permissionModel.tx_file_id.length && _permissionModel.tx_token.length) {
                self.vodPlayer.token = self.playerModel.drmToken;
                NSString *videoURL = self.playerModel.playingDefinitionUrl;
                if (!videoURL.length) return;
                self.netWatcher.playerModel = self.playerModel;

                NSString *appParameter = [NSString stringWithFormat:@"spappid=%ld",self.playerModel.appId];
                NSString *fileidParameter = [NSString stringWithFormat:@"spfileid=%@",self.playerModel.videoId.fileId];
                NSString *drmtypeParameter = [NSString stringWithFormat:@"spdrmtype=%@",
                                              self.playerModel.drmType == SPDrmTypeSimpleAES ? @"SimpleAES" : @"plain"];
                NSString *vodParamVideoUrl = [NSString appendParameter:appParameter WithOriginUrl:videoURL];
                vodParamVideoUrl = [NSString appendParameter:fileidParameter WithOriginUrl:vodParamVideoUrl];
                vodParamVideoUrl = [NSString appendParameter:drmtypeParameter WithOriginUrl:vodParamVideoUrl];

                BOOL isSupport = [self isSupportAppendParam];
                [self.vodPlayer startPlay:(isSupport ? vodParamVideoUrl : videoURL)];
                [self.netWatcher startWatch];
                [self.netWatcher setNotifyTipsBlock:^(NSString *msg) {
                }];
                NSLog(@"========vodParamVideoUrl:%@ \n videoURL:%@ \n isSupport:%d",vodParamVideoUrl,videoURL,isSupport);

            }else{
                [self.vodPlayer startPlay:[self.assetURL absoluteString]];
            }
        }else{
            [self.vodPlayer startPlay:[self.assetURL absoluteString]];
        }
    }
    
    if (_isAudioplay) {
        
    }else{
        //presentView.player = _player;
    }
    self.scalingMode = _scalingMode;
}


#pragma mark - getter

- (UIView *)view {
    if (!_view) {
        @weakify(self);
        _view = [[ZFHKTXLitePlayerPresentView alloc] init];

        ((ZFHKTXLitePlayerPresentView *)_view).hKNormalPlayerPresentView = ^(ZFHKTXLitePlayerPresentView *view, UIButton *audioBtn) {
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
        
    NSTimeInterval sec = self.vodPlayer.duration;
    //CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}


- (NSTimeInterval)currentTime {
    NSTimeInterval sec = [self.vodPlayer currentPlaybackTime];
    //CMTimeGetSeconds(self.playerItem.currentTime);
    //NSLog(@"-------------播放时间：%f",sec);
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


-(void)setIsDown:(BOOL)isDown{
    _isDown = isDown;
}



-(void)setPermissionModel:(HKPermissionVideoModel *)permissionModel{
    _permissionModel = permissionModel;
    self.playerModel = [[SuperPlayerModel alloc] init];
    self.playerModel.appId = 1256517420;// 配置 AppId
    self.playerModel.videoId = [[SuperPlayerVideoId alloc] init];

    self.playerModel.videoId.fileId = _permissionModel.tx_file_id; // 配置 FileId
    self.playerModel.videoId.psign = _permissionModel.tx_token;
//    self.playerModel.videoURL = _permissionModel.video_url;
//    self.playerModel.videoId.fileId = @"5285890816164896353";
//    self.playerModel.videoId.psign = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTI1NjUxNzQyMCwiZmlsZUlkIjoiNTI4NTg5MDgxNjE3MzkzMjMxNiIsImN1cnJlbnRUaW1lU3RhbXAiOjE2NjIzNjA1OTQsImV4cGlyZVRpbWVTdGFtcCI6MTY2MjYxOTc5NCwicGNmZyI6ImJhc2ljRHJtUHJlc2V0IiwidXJsQWNjZXNzSW5mbyI6eyJ0IjoiNjMxOTkwOTIiLCJybGltaXQiOjEwMCwidXMiOiIxNjYyMzYwNTk0In19.6UdQBTbsgc-qGcWOrlsUIseLFlGlllo6pktGGOUbLPc";
}

- (void)setAssetURL:(NSURL *)assetURL {
    if (self.vodPlayer) [self stop];
    _assetURL = assetURL;
//    _assetURL = [NSURL URLWithString:@"http://m3u8.huke88.com/video/hls/v_1/2021-03-10/B298C414-081F-3606-6982-CE74C0028FBF.m3u8?pm3u8/0/deadline/1674959138&e=1662359138&token=HUwgVvJnrW6fXOzqd_myfnE3FFoFLWJnNktg7ThD:qEPC_eCg9FfmfPzCKZCqJo9t-To="];
    
    if (self.permissionModel == nil) {
        SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
        playerModel.videoURL          = [self.assetURL absoluteString];

        self.playerModel = playerModel;
    }
    
    [self prepareToPlay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    if (self.vodPlayer && fabsf(rate) > 0.00001f) {
        [self.vodPlayer setRate:rate];
    }
}


- (void)setMuted:(BOOL)muted {
    _muted = muted;
    [self.vodPlayer setMute:muted];
}


- (void)setScalingMode:(ZFHKNormalPlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
}


- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    //self.vodPlayer.volume = volume;
}


- (void)setIsAudioplay:(BOOL)isAudioplay {
    _isAudioplay = isAudioplay;
    ((ZFHKTXLitePlayerPresentView *)self.view).audioCoverView.hidden = !isAudioplay;
//
//    if (isAudioplay) {
//        ZFHKTXLitePlayerPresentView *presentView = (ZFHKTXLitePlayerPresentView *)self.view;
//        //presentView.player = nil;
//        //presentView.avLayer.player = nil;
//
//        //[self setNormalAVPlayerRemoteCommandCenter];
//        //[self setNormalAVPlayerNowPlayingInfoCenter];
//    }else{
//        ZFHKTXLitePlayerPresentView *presentView = (ZFHKTXLitePlayerPresentView *)self.view;
//        //presentView.player = _player;
//        //[self closeNormalAVPlayerRemoteCommandCenter];
//    }
}






- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *desc = [param description];
//        NSLog(@"EvtID === %d,%@",EvtID, [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);

        
        if (EvtID == EVT_VIDEO_PLAY_BEGIN) {//视频播放
            self.playState = ZFHKNormalPlayerPlayStatePlaying;
            self.loadState = ZFHKNormalPlayerLoadStatePlaythroughOK;
            
            [self updateBitrates:player.supportedBitrates];
        }
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {//视频加载完毕
            /// 第一次初始化
            if (self.loadState == ZFHKNormalPlayerLoadStatePrepare|| self.loadState == ZFHKNormalPlayerLoadStatePlaythroughOK) {
               if (self.playerReadyToPlay) self.playerReadyToPlay(self, self.assetURL);
            }
            if (self.seekTime) {
                [self seekToTime:self.seekTime completionHandler:nil];
                self.seekTime = 0;
            }
            if (self.isPlaying) [self play];
            [self.vodPlayer setMute:self.muted];
                /// Fix https://github.com/renzifeng/ZFHKNormalPlayer/issues/475
                if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
        }
        if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            // 播放进度更新
            if ((self.playState == ZFHKNormalPlayerPlayStatePlayStopped) || self.playState == (ZFHKNormalPlayerPlayStatePlayFailed)) {
                
                return;
            }
            
            if (self.isPlaying == NO) {
                [self pause];
            }
            self.playState = ZFHKNormalPlayerPlayStatePlaying;

            NSTimeInterval bufferTime = [self availableDuration];
            self->_bufferTime = bufferTime;
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, bufferTime);
                
            if (self.playerPlayTimeChanged){
                self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_END) {
            // 播放结束
            if (!self) return;
            if (self.playerPlayTimeChanged){
                self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
            }
            self.playState = ZFHKNormalPlayerPlayStatePlayStopped;
            [self moviePlayDidEnd];
            if (self.playerDidToEnd) self.playerDidToEnd(self);
            
        } else if (EvtID == PLAY_ERR_FILE_NOT_FOUND || EvtID == PLAY_ERR_HLS_KEY /*|| EvtID == PLAY_ERR_VOD_LOAD_LICENSE_FAIL*/) {
            self.playState = ZFHKNormalPlayerPlayStatePlayFailed;
            closeWaitingDialog();
            if ([LBLelinkKitManager sharedManager].isAirPlay &&
                ![LBLelinkKitManager sharedManager].isMirroring){
                
            }else{
                [player stopPlay];
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_LOADING) {
            // 当缓冲是空的时候
            self.loadState = ZFHKNormalPlayerLoadStatePrepare;
        } else if (EvtID == PLAY_EVT_VOD_LOADING_END) {
            //[self.spinner stopAnimating];
            // 缓冲结束
            self.loadState = ZFHKNormalPlayerLoadStatePlaythroughOK;
            
        } else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
            if (player.height != 0) {
                //self.videoRatio = (GLfloat)player.width / player.height;
            }
        }else if (EvtID == PLAY_ERR_NET_DISCONNECT){
            closeWaitingDialog();
            self.playState = ZFHKNormalPlayerPlayStatePlayFailed;
        }
     });
}


-(void) onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*)param {
    
}



- (void)_removeOldPlayer
{
    for (UIView *w in [self.view subviews]) {
        if ([w isKindOfClass:NSClassFromString(@"TXCRenderView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXCAVPlayerView")])
            [w removeFromSuperview];
    }
}

- (void)_playWithModel:(SuperPlayerModel *)playerModel {
    [_currentLoadingTask cancel];
    _currentLoadingTask = nil;

    _playerModel = playerModel;

    //[self pause];
    
    NSString *videoURL = playerModel.playingDefinitionUrl;
    if (videoURL != nil) {
        [self initializePlayer];
    } else if (playerModel.videoId || playerModel.videoIdV2) {
        if(playerModel.videoId.fileId.length && playerModel.videoId.psign.length){
            __weak __typeof(self) weakSelf = self;
            _currentLoadingTask = [_playerModel requestWithCompletion:
                                   ^(NSError *error,SuperPlayerModel *model) {
                if (error) {
                    
                } else {
                    [weakSelf _onModelLoadSucceed:model];
                }
            }];
            
        }else{
            self.playerModel.videoURL = self.permissionModel.video_url;
            [self _playWithModel:self.playerModel];
        }
        return;

    } else {
        NSLog(@"无播放地址");
        return;
    }
}

- (void)_onModelLoadSucceed:(SuperPlayerModel *)model {
    if (model == _playerModel) {
        [self _playWithModel:_playerModel];
    }
}

#pragma mark - Private Method
- (BOOL)isSupportAppendParam {
    NSString* version = [TXLiveBase getSDKVersionStr];
    NSArray* vers = [version componentsSeparatedByString:@"."];
    if (vers.count <= 1) {
        return NO;
    }
    NSInteger majorVer = [vers[0] integerValue]?:0;
    NSInteger minorVer = [vers[1] integerValue]?:0;
    return majorVer >= SUPPORT_PARAM_MAJOR_VERSION && minorVer >= SUPPORT_PARAM_MINOR_VERSION;
}

// 更新当前播放的视频信息，包括清晰度、码率等
- (void)updateBitrates:(NSArray<TXBitrateItem *> *)bitrates;
{
    if (bitrates.count > 0) {
        [self.vodPlayer setBitrateIndex:bitrates.lastObject.index];
    }
}

/**
 *  播放完了
 *
 */
- (void)moviePlayDidEnd {
    [self.netWatcher stopWatch];
    [self resetPlayer];
}

/**
 *  重置player
 */
- (void)resetPlayer {
    LOG_ME;
    // 暂停
    [self pause];
}


-(void)dealloc{
   LOG_ME
}
@end

#pragma clang diagnostic pop









