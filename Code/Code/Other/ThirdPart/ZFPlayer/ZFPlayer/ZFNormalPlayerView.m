//
//  ZFNormalPlayerView.m
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

#import "ZFNormalPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+CustomControlView.h"
#import "ZFNormalPlayer.h"

// add yang
#import "VideoModel.h"
#import "HKDownloadModel.h"
#import "DownloadCacher.h"
#import "HTTPServer.h"
  
#import "HKPermissionVideoModel.h"
#import "AFNetworkReachabilityManager.h"
#import "VideoPlayVC.h"
#import "DetailModel.h"
#import "HKDownloadManager.h"
#import "ZFNormalPlayerControlView.h"
#import "HKPlayerAutoPlayConfigView.h"
#import "HKPlayerAutoPlayBaseView.h"
#import "HKAutoPlayTipIView.h"



#define CellPlayerFatherViewTag  200

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

// 标记是否是本地视频
typedef enum {
    VideoLocalStatusLocalVideo = 0,
    VideoLocalStatusInternetVideo = 1,
}VideoLocalStatus;


// 标记是否是第一次播放
typedef enum {
    OnceOnlyLookVideo = 0,
    OnceOnlyTwoLookVideo = 1,
}OnceOnly;


// 标记是否是第一次查询视频状态
typedef enum {
    OnceOnlyCheckStatus = 0,
    OnceOnlyTwoCheckStatus = 1,
}OnceOnlyCheck;



#pragma mark - 登录状态
typedef NS_ENUM(NSInteger, LoginStatus) {
    LoginStatusNoLogin = 0,     //未登录
    LoginStatusOverTimes,  // 登录过期
    LoginStatusNowIn    // 登录中
};



@interface ZFNormalPlayerView () <UIGestureRecognizerDelegate,UIAlertViewDelegate>

/** 播放属性 */
@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) AVURLAsset             *urlAsset;
@property (nonatomic, strong) AVAssetImageGenerator  *imageGenerator;
/** playerLayer */
@property (nonatomic, strong) AVPlayerLayer          *playerLayer;
@property (nonatomic, strong) id                     timeObserve;
/** 滑杆 */
@property (nonatomic, strong) UISlider               *volumeViewSlider; 
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat                sumTime;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection           panDirection;
/** 播发器的几种状态 */
@property (nonatomic, assign) ZFNormalPlayerState          state;
/** 是否为全屏 */
@property (nonatomic, assign) BOOL                   isFullScreen;
/** 是否锁定屏幕方向 */
@property (nonatomic, assign) BOOL                   isLocked;
/** 是否在调节音量*/
@property (nonatomic, assign) BOOL                   isVolume;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                   isPauseByUser;
/** 是否播放本地文件 */
@property (nonatomic, assign) BOOL                   isLocalVideo;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat                sliderLastValue;
/** 是否再次设置URL播放视频 */
@property (nonatomic, assign) BOOL                   repeatToPlay;
/** 播放完了*/
@property (nonatomic, assign) BOOL                   playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                   didEnterBackground;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL                   isAutoPlay;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 视频URL的数组 */
@property (nonatomic, strong) NSArray                *videoURLArray;
/** slider预览图 */
@property (nonatomic, strong) UIImage                *thumbImg;
/** 亮度view */
@property (nonatomic, strong) ZFNormalBrightnessView       *brightnessView;
/** 视频填充模式 */
@property (nonatomic, copy) NSString                 *videoGravity;

#pragma mark - UITableViewCell PlayerView

/** palyer加到tableView */
@property (nonatomic, strong) UIScrollView           *scrollView;
/** player所在cell的indexPath */
@property (nonatomic, strong) NSIndexPath            *indexPath;
/** ViewController中页面是否消失 */
@property (nonatomic, assign) BOOL                   viewDisappear;
/** 是否在cell上播放video */
@property (nonatomic, assign) BOOL                   isCellVideo;
/** 是否缩小视频在底部 */
@property (nonatomic, assign) BOOL                   isBottomVideo;
/** 是否切换分辨率*/
@property (nonatomic, assign) BOOL                   isChangeResolution;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL                   isDragged;
/** 小窗口距屏幕右边和下边的距离 */
@property (nonatomic, assign) CGPoint                shrinkRightBottomPoint;

@property (nonatomic, strong) UIPanGestureRecognizer *shrinkPanGesture;

//@property (nonatomic, strong) UIView                 *controlView;
//@property (nonatomic, strong) ZFNormalPlayerModel          *playerModel;
@property (nonatomic, assign) NSInteger              seekTime;
@property (nonatomic, strong) NSURL                  *videoURL;
@property (nonatomic, strong) NSDictionary           *resolutionDic;

// 倍速速率
@property (nonatomic, assign)CGFloat rate;

// add  yang 0826
@property (nonatomic, strong)HTTPServer * httpServer;//本地服务器

@property (nonatomic, assign) VideoLocalStatus videoLocalStatus;

@property (atomic, assign) OnceOnly onceOnly;

@property (atomic, assign) OnceOnlyCheck onceOnlyCheck;

@property (atomic, assign) NSInteger playInternetStatus;

@end



@implementation ZFNormalPlayerView

#pragma mark - life Cycle

/**
 *  代码初始化调用此方法
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeThePlayer];
        [self createObserver];
    }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeThePlayer];
}

/**
 *  初始化player
 */
- (void)initializeThePlayer {
    self.cellPlayerOnCenter = YES;
}

- (void)dealloc {
    
    self.playerItem = nil;
    self.scrollView  = nil;
    ZFNormalPlayerShared.isLockScreen = NO;
    [self.controlView zf_playerCancelAutoFadeOutControlView];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    // 移除time观察者
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
}

/**
 *  在当前页面，设置新的Player的URL调用此方法
 */
- (void)resetToPlayNewURL {
    self.repeatToPlay = YES;
    [self resetPlayer];
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}



#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}



#pragma mark - Public Method

/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFNormalPlayer
 */
+ (instancetype)sharedPlayerView {
    static ZFNormalPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[ZFNormalPlayerView alloc] init];
    });
    return playerView;
}

- (void)playerControlView:(UIView *)controlView playerModel:(ZFNormalPlayerModel *)playerModel {
    
    if (!controlView) {
        // 指定默认控制层
        ZFNormalPlayerControlView *defaultControlView = [[ZFNormalPlayerControlView alloc] init];
        // modify yang  隐藏 全屏按钮
        defaultControlView.fullScreenBtn.hidden = YES;
        //[defaultControlView zf_hiddenFullScreenBtn];
        defaultControlView.videoId = playerModel.videoId;//传入 videoId;
        defaultControlView.videoType = playerModel.videoType;
        defaultControlView.videoUrl =  [playerModel.videoURL absoluteString];//传入 videoUrl;
        self.controlView = defaultControlView;
        
    } else {
        self.controlView = controlView;
    }
    self.playerModel = playerModel;
}

/**
 * 使用自带的控制层时候可使用此API
 */
- (void)playerModel:(ZFNormalPlayerModel *)playerModel {
    [self playerControlView:nil playerModel:playerModel];
}

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo {
    // 设置Player相关参数
    [self configZFNormalPlayer];
}



/**
 * 自动播放，模拟点击播放按钮
 */
- (void)zf_autoPlayAction {
    ZFNormalPlayerControlView *view = ((ZFNormalPlayerControlView*) self.controlView);
    if (view) {
        [(view) playBtnClick:view.startBtn];
        //[view performSelector:@selector(playBtnClick:) withObject:view.startBtn withObject:nil];
    }
}

/**
 *  无观看权限 提示购买VIP 视图
 */
- (void)zf_buyVipView {
    ZFNormalPlayerControlView *view = ((ZFNormalPlayerControlView*) self.controlView);
    if (view) {
        [(view) setBuyVipView];
    }
}


/**
 * 自动全屏，模拟点击全屏按钮
 */
- (void)zf_autoFullScreenAction {
    ZFNormalPlayerControlView *view = ((ZFNormalPlayerControlView*) self.controlView);
    if (view) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view fullScreenBtnClick:view.fullScreenBtn];
            //[view performSelector:@selector(fullScreenBtnClick:) withObject:view.fullScreenBtn afterDelay:0.01];
        });
    }
}


/**
 * 全屏播放
 */
-(void)zf_fullScreenPlayAction {
    [self _fullScreenAction];
}



/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    // 这里应该添加判断，因为view有可能为空，当view为空时[view addSubview:self]会crash
    if (view) {
        [self removeFromSuperview];
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
}

/**
 *  重置player
 */
- (void)resetPlayer {
    // 改为为播放完
    self.playDidEnd         = NO;
    self.playerItem         = nil;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil]; // modify 0207 注释该行
    // 把player置为nil
    self.imageGenerator = nil;
    self.player         = nil;
    if (self.isChangeResolution) { // 切换分辨率
        [self.controlView zf_playerResetControlViewForResolution];
        self.isChangeResolution = NO;
    }else { // 重置控制层View
        [self.controlView zf_playerResetControlView];
    }
    self.controlView   = nil;
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) { [self removeFromSuperview]; }
    // 底部播放video改为NO
    self.isBottomVideo = NO;
    // cell上播放视频 && 不是重播时
    if (self.isCellVideo && !self.repeatToPlay) {
        // vicontroller中页面消失
        self.viewDisappear = YES;
        self.isCellVideo   = NO;
        self.scrollView     = nil;
        self.indexPath     = nil;
    }
}

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(ZFNormalPlayerModel *)playerModel {
    self.repeatToPlay = YES;
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configZFNormalPlayer];
}

/**
 *  播放
 */
- (void)play {
    
    // 插入观看记录 Url yang
    [self insertLookRecordAndChangeStatus];
    
    [self.controlView zf_playerPlayBtnState:YES];
    if (self.state == ZFNormalPlayerStatePause) { self.state = ZFNormalPlayerStatePlaying; }
    self.isPauseByUser = NO;
    
//    [_player play];
    [self tb_playWithRate];
}

/**
 * 暂停
 */
- (void)pause {
    [self.controlView zf_playerPlayBtnState:NO];
    if (self.state == ZFNormalPlayerStatePlaying) { self.state = ZFNormalPlayerStatePause;}
    self.isPauseByUser = YES;

    [_player pause];
}

#pragma mark - Private Method

/**
 *  用于cell上播放player
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
- (void)cellVideoWithScrollView:(UIScrollView *)scrollView
                    AtIndexPath:(NSIndexPath *)indexPath {
    // 如果页面没有消失，并且playerItem有值，需要重置player(其实就是点击播放其他视频时候)
    if (!self.viewDisappear && self.playerItem) { [self resetPlayer]; }
    // 在cell上播放视频
    self.isCellVideo      = YES;
    // viewDisappear改为NO
    self.viewDisappear    = NO;
    // 设置tableview
    self.scrollView       = scrollView;
    // 设置indexPath
    self.indexPath        = indexPath;
    // 在cell播放
    [self.controlView zf_playerCellPlay];
    
    self.shrinkPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(shrikPanAction:)];
    self.shrinkPanGesture.delegate = self;
    [self addGestureRecognizer:self.shrinkPanGesture];
}

/**
 *  设置Player相关参数
 */
- (void)configZFNormalPlayer {
    
    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
//     每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.backgroundColor = [UIColor blackColor];
    // 此处为默认视频填充模式
    self.playerLayer.videoGravity = self.videoGravity;
    
    // 自动播放
    self.isAutoPlay = YES;
    
    // 添加播放进度计时器
    [self createTimer];
    
    // 获取系统音量
    [self configureVolume];
    
    // 本地文件不设置ZFNormalPlayerStateBuffering状态
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ZFNormalPlayerStatePlaying;
        self.isLocalVideo = YES;
        [self.controlView zf_playerDownloadBtnState:NO];
    } else {
        
        self.state = ZFNormalPlayerStateBuffering;
        self.isLocalVideo = NO;
        [self.controlView zf_playerDownloadBtnState:YES];
    }
    // 开始播放
    [self play];
    self.isPauseByUser = NO;
}

/**
 *  创建手势
 */
- (void)createGesture {

    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    [self addGestureRecognizer:self.doubleTap];

    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isAutoPlay) {
        UITouch *touch = [touches anyObject];
        //NSString *view = NSStringFromClass([touch.view class]);
        
        if ([touch.view isKindOfClass:[HKAutoPlayTipIView class]]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            return;
        }
        
        /** 自动播放 view 手势冲突 **/
        if ([touch.view isKindOfClass:[HKPlayerAutoPlayConfigView class]]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            return;
        }
        if ([touch.view isKindOfClass:[HKPlayerAutoPlayBaseView class]]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            return;
        }
        
        if(touch.tapCount == 1) {
            [self performSelector:@selector(singleTapAction:) withObject:@(NO) ];
        } else if (touch.tapCount == 2) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            [self doubleTapAction:touch.gestureRecognizers.lastObject];
        }
    }
}

- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.controlView zf_playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
            
            // add 将播放时间 传入 videoPlayVC 控制器
            if (weakSelf.delegate &&[weakSelf.delegate respondsToSelector:@selector(zf_controlView:totalTime:sliderValue:)]) {
                [weakSelf.delegate zf_controlView:currentTime totalTime:totalTime sliderValue:value];
            }
        }
    }];
}

/**
 *  获取系统音量
 */
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [self play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

/**
 兼容iPhoneX的NavBaf顶部高度 （statusHeight）
 
 @return iPhoneX：44 other:20
 */
+ (CGFloat )getNavBarTopHeight {
    if (ScreenWidth == 375 && ScreenHeight == 812) {
        return 44;
    }
    return 20;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                [self setNeedsLayout];
                [self layoutIfNeeded];
                // 添加playerLayer到self.layer
                [self.layer insertSublayer:self.playerLayer atIndex:0];
                self.state = ZFNormalPlayerStatePlaying;
                // 加载完成后，再添加平移手势
                // 添加平移手势，用来控制音量、亮度、快进快退
                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
                panRecognizer.delegate = self;
                [panRecognizer setMaximumNumberOfTouches:1];
                [panRecognizer setDelaysTouchesBegan:YES];
                [panRecognizer setDelaysTouchesEnded:YES];
                [panRecognizer setCancelsTouchesInView:YES];
                [self addGestureRecognizer:panRecognizer];
                
                // 跳到xx秒播放视频
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                }
                self.player.muted = self.mute;
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.state = ZFNormalPlayerStateFailed;
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            [self.controlView zf_playerSetProgress:timeInterval / totalDuration];
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
                self.state = ZFNormalPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            // 当缓冲好的时候
            if (self.playerItem.playbackLikelyToKeepUp && self.state == ZFNormalPlayerStateBuffering){
                self.state = ZFNormalPlayerStatePlaying;
            }
        }
    } else if (object == self.scrollView) {
        if ([keyPath isEqualToString:kZFNormalPlayerViewContentOffset]) {
            if (self.isFullScreen) { return; }
            // 当tableview滚动时处理playerView的位置
            [self handleScrollOffsetWithDict:change];
        }
    }
}

#pragma mark - tableViewContentOffset

/**
 *  KVO TableViewContentOffset
 *
 *  @param dict void
 */
- (void)handleScrollOffsetWithDict:(NSDictionary*)dict {
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.indexPath];
        NSArray *visableCells = tableView.visibleCells;
        if ([visableCells containsObject:cell]) {
            // 在显示中
            [self updatePlayerViewToCell];
        } else {
            if (self.stopPlayWhileCellNotVisable) {
                [self resetPlayer];
            } else {
                // 在底部
                [self updatePlayerViewToBottom];
            }
        }
    } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.indexPath];
        if ( [collectionView.visibleCells containsObject:cell]) {
            // 在显示中
            [self updatePlayerViewToCell];
        } else {
            if (self.stopPlayWhileCellNotVisable) {
                [self resetPlayer];
            } else {
                // 在底部
                [self updatePlayerViewToBottom];
            }
        }
    }
}

/**
 *  缩小到底部，显示小视频
 */
- (void)updatePlayerViewToBottom {
    if (self.isBottomVideo) { return; }
    self.isBottomVideo = YES;
    if (self.playDidEnd) { // 如果播放完了，滑动到小屏bottom位置时，直接resetPlayer
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    if (CGPointEqualToPoint(self.shrinkRightBottomPoint, CGPointZero)) { // 没有初始值
        self.shrinkRightBottomPoint = CGPointMake(10, self.scrollView.contentInset.bottom+10);
    } else {
        [self setShrinkRightBottomPoint:self.shrinkRightBottomPoint];
    }
    // 小屏播放
    [self.controlView zf_playerBottomShrinkPlay];
}

/**
 *  回到cell显示
 */
- (void)updatePlayerViewToCell {
    if (!self.isBottomVideo) { return; }
    self.isBottomVideo = NO;
    [self setOrientationPortraitConstraint];
    [self.controlView zf_playerCellPlay];
}

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    [self toOrientation:orientation];
    self.isFullScreen = YES;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    if (self.isCellVideo) {
        if ([self.scrollView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)self.scrollView;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.indexPath];
            self.isBottomVideo = NO;
            if (![tableView.visibleCells containsObject:cell]) {
                [self updatePlayerViewToBottom];
            } else {
                UIView *fatherView = [cell.contentView viewWithTag:self.playerModel.fatherViewTag];
                [self addPlayerToFatherView:fatherView];
            }
        } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)self.scrollView;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.indexPath];
            self.isBottomVideo = NO;
            if (![collectionView.visibleCells containsObject:cell]) {
                [self updatePlayerViewToBottom];
            } else {
                UIView *fatherView = [cell viewWithTag:self.playerModel.fatherViewTag];
                [self addPlayerToFatherView:fatherView];
            }
        }
    } else {
        [self addPlayerToFatherView:self.playerModel.fatherView];
    }
    
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullScreen = NO;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            ZFNormalBrightnessView *brightnessView = [ZFNormalBrightnessView sharedBrightnessView];
            // add 0207
            [[UIApplication sharedApplication].keyWindow bringSubviewToFront:brightnessView];
            [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:brightnessView];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenHeight));
                make.height.equalTo(@(ScreenWidth));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle {
    
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark 屏幕转屏相关

/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
        // add 1231
        //if (videoType == HKVideoType_PGC) {
            NSString *videoId  =  self.playerModel.videoId;
            NSDictionary *dict = @{@"direction":@"1",@"videoId":videoId};
            HK_NOTIFICATION_POST_DICT(KPlayVideoScreenRotationNotification, nil, dict);

    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
        // add 1231
        //if (videoType == HKVideoType_PGC) {
            NSString *videoId  =  self.playerModel.videoId;
            NSDictionary *dict = @{@"direction":@"1",@"videoId":videoId};// 0--竖屏  1-- 全屏
            HK_NOTIFICATION_POST_DICT(KPlayVideoScreenRotationNotification, nil, dict);
    }
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    
    if (!self.player) { return; }
    if (ZFNormalPlayerShared.isLockScreen) { return; }
    if (self.didEnterBackground) { return; };
    if (self.playerPushedOrPresented) { return; }
    
    //add 0116 解决自动屏幕旋转问题 只旋转当前屏幕
    UIViewController *currentVC = [UIWindow zf_currentViewController];
    if (![currentVC isKindOfClass:[VideoPlayVC class]]) {
        return;
    }
    VideoPlayVC *VC = (VideoPlayVC*)currentVC;

    BOOL iscommonType = (self.playerModel.videoType == (VC.videoType));
    if ([self.playerModel.videoId isEqualToString:[VC valueForKey:@"videoId"]] && iscommonType) {
        // 正在显示的
    }else{
        return;
    }

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            if (self.isFullScreen) {
                [self toOrientation:UIInterfaceOrientationPortrait];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            }
        }
            break;
        default:
            break;
    }
}

// 状态条变化通知（在前台播放才去处理）
- (void)onStatusBarOrientationChange {
    if (!self.didEnterBackground) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];
            if (self.cellPlayerOnCenter) {
                if ([self.scrollView isKindOfClass:[UITableView class]]) {
                    UITableView *tableView = (UITableView *)self.scrollView;
                    [tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

                } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
                    UICollectionView *collectionView = (UICollectionView *)self.scrollView;
                    [collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                }
            }
            [self.brightnessView removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(155);
                make.leading.mas_equalTo((ScreenWidth-155)/2);
                make.top.mas_equalTo((ScreenHeight-155)/2);
            }];
        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else if (currentOrientation == UIDeviceOrientationLandscapeLeft){
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            [self.brightnessView removeFromSuperview];
            [self addSubview:self.brightnessView];
            [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.width.height.mas_equalTo(155);
            }];
            
        }
    }
}

/**
 *  锁定屏幕方向按钮
 *
 *  @param sender UIButton
 */
- (void)lockScreenAction:(UIButton *)sender {
    sender.selected             = !sender.selected;
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏，在TabBarController设置哪些页面支持旋转
    ZFNormalPlayerShared.isLockScreen = sender.selected;
}

/**
 *  解锁屏幕方向锁定
 */
- (void)unLockTheScreen {
    // 调用AppDelegate单例记录播放状态是否锁屏
    ZFNormalPlayerShared.isLockScreen = NO;
    [self.controlView zf_playerLockBtnState:NO];
    self.isLocked = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    self.state = ZFNormalPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
       
    });
}

#pragma mark - 计算缓冲进度

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    
    if ([gesture isKindOfClass:[NSNumber class]] && ![(id)gesture boolValue]) {
        //轻拍全屏
        //[self _fullScreenAction];
         return;
    }
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        
        // modify 0302 首次 单击手势 播放视频
        if (self.onceOnlyCheck == OnceOnlyCheckStatus) {
            [self zf_autoPlayAction];
        } else {
            
            if (self.isBottomVideo && !self.isFullScreen) {
                [self _fullScreenAction];
            }else {
                
                if (self.playDidEnd) { return; }
                else {
                    if ([self.controlView isKindOfClass:[ZFNormalPlayerControlView class]]) {
                        [self.controlView zf_playerShowOrHideControlView];
                    }
                }
            }
        }
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playDidEnd) { return;  }
    
    if ([self.controlView isKindOfClass:[ZFNormalPlayerControlView class]]) {
        
        [self.controlView zf_hiddenVipBtn]; // add yang
        // 显示控制层
        if ([self.controlView isKindOfClass:[ZFNormalPlayerControlView class]]) {
            [self.controlView zf_playerShowControlView];
        }
    }
    
    // modify
    if (self.onceOnly == OnceOnlyTwoLookVideo ){
        
         if (self.isPauseByUser) {
             [self play];
         }
         else { [self pause]; }
         
         if (!self.isAutoPlay) {
             self.isAutoPlay = YES;
             [self configZFNormalPlayer];
        }
    }
}

- (void)shrikPanAction:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:[UIApplication sharedApplication].keyWindow];
    ZFNormalPlayerView *view = (ZFNormalPlayerView *)gesture.view;
    const CGFloat width = view.frame.size.width;
    const CGFloat height = view.frame.size.height;
    const CGFloat distance = 10;  // 离四周的最小边距
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        // x轴的的移动
        if (point.x < width/2) {
            point.x = width/2 + distance;
        } else if (point.x > ScreenWidth - width/2) {
            point.x = ScreenWidth - width/2 - distance;
        }
        // y轴的移动
        if (point.y < height/2) {
            point.y = height/2 + distance;
        } else if (point.y > ScreenHeight - height/2) {
            point.y = ScreenHeight - height/2 - distance;
        }

        [UIView animateWithDuration:0.5 animations:^{
            view.center = point;
            self.shrinkRightBottomPoint = CGPointMake(ScreenWidth - view.frame.origin.x - width, ScreenHeight - view.frame.origin.y - height);
        }];
    
    } else {
        view.center = point;
        self.shrinkRightBottomPoint = CGPointMake(ScreenWidth - view.frame.origin.x- view.frame.size.width, ScreenHeight - view.frame.origin.y-view.frame.size.height);
    }
}

/** 全屏 */
- (void)_fullScreenAction {
    
    if (ZFNormalPlayerShared.isLockScreen) {
        [self unLockTheScreen];
        return;
    }
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullScreen = NO;
        return;
    } else {
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        self.isFullScreen = YES;
    }
}

#pragma mark - NSNotification Action

/**
 *  播放完了
 *
 *  @param notification 通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification {
    self.state = ZFNormalPlayerStateStopped;
    if (self.isBottomVideo && !self.isFullScreen) { // 播放完了，如果是在小屏模式 && 在bottom位置，直接关闭播放器
        self.repeatToPlay = NO;
        self.playDidEnd   = NO;
        [self resetPlayer];
        
    } else {
        if (!self.isDragged) { // 如果不是拖拽中，直接结束播放
            self.playDidEnd = YES;
            [self.controlView zf_playerPlayEnd];
            
            // 播放完了  用于 软件入门 播放完了 弹窗
            if ([self.delegate respondsToSelector:@selector(zf_playerView:playEnd:isFullscreen:)]) {
                if (HKVideoType_LearnPath == [self.playerModel.detailModel.video_type intValue]) {
                    
                    if ([self.playerModel.detailModel.is_last_video isEqualToString:@"1"]) {
                        //最后一节课
                        if (self.isFullScreen) {
                            [self _fullScreenAction];
                        }
                    }
                    [self.delegate zf_playerView:nil playEnd:self.playerModel.detailModel isFullscreen:self.isFullScreen];
                }
            }
        }
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    self.didEnterBackground     = YES;
    // 退到后台锁定屏幕方向
    ZFNormalPlayerShared.isLockScreen = YES;
    [_player pause];
    self.state                  = ZFNormalPlayerStatePause;
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    self.didEnterBackground     = NO;
    // 根据是否锁定屏幕方向 来恢复单例里锁定屏幕的方向
    ZFNormalPlayerShared.isLockScreen = self.isLocked;
    if (!self.isPauseByUser) {
        self.state         = ZFNormalPlayerStatePlaying;
        self.isPauseByUser = NO;
        [self play];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        [self.controlView zf_playerActivity:YES];
        [self.player pause];
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1); //kCMTimeZero
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
            [weakSelf.controlView zf_playerActivity:NO];
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            [weakSelf.player play];
            
            //如果想实现倍速播放,必须调用此方法
            [self enableAudioTracks:YES inPlayerItem:_playerItem];
            weakSelf.player.rate = self.rate > 0.1? self.rate : 1.0;
            
            
            weakSelf.seekTime = 0;
            weakSelf.isDragged = NO;
            // 结束滑动
            [weakSelf.controlView zf_playerDraggedEnd];
            if (!weakSelf.playerItem.isPlaybackLikelyToKeepUp && !weakSelf.isLocalVideo) { weakSelf.state = ZFNormalPlayerStateBuffering; }
            
        }];
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    // 先使用默认的方法来寻找 hit-TestView
//    UIView *result = [super hitTest:point withEvent:event];
//    
//    HKPlayerAutoPlayConfigView *playerAutoPlayConfigView = nil;
//    // 到这里说明触摸事件不发生在 tabBar 里面 // 这里遍历那些超出的部分就可以了，不过这么写比较通用。
//    for (UIView *subview in self.subviews) {
//        
//        if ([subview isKindOfClass:[HKPlayerAutoPlayConfigView class]]) {
//            playerAutoPlayConfigView = (HKPlayerAutoPlayConfigView *)subview;
//            break;
//        }
//    }
//    
//    // 如果 result 不为 nil，说明触摸事件发生在 tabbar 里面，直接返回就可以了
//    if (playerAutoPlayConfigView) {
//        return playerAutoPlayConfigView;
//    } else {
//        return result;
//    }
//}

#pragma mark - UIPanGestureRecognizer手势方法

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                CMTime time       = self.player.currentTime;
                self.sumTime      = time.value/time.timescale;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime completionHandler:nil];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CMTime totalTime           = self.playerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.isDragged = YES;
    [self.controlView zf_playerDraggedTime:self.sumTime totalTime:totalMovieDuration isForward:style hasPreview:NO];
}

/**
 *  根据时长求出字符串
 *
 *  @param time 时长
 *
 *  @return 时长字符串
 */
- (NSString *)durationStringWithTime:(int)time {
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //NSString *str = NSStringFromClass([touch.view class]);
    //NSLog(@"----- %@",str);
    
    if ([touch.view isKindOfClass:[HKAutoPlayTipIView class]]) {
        return NO;
    }
    
    if ([touch.view isKindOfClass:[HKPlayerAutoPlayConfigView class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[HKPlayerAutoPlayBaseView class]]) {
        return NO;
    }
    
    //HKPlayerCollectionViewCell 推荐视频 手势冲突
    if([touch.view isKindOfClass:[UIImageView class]]) {
        NSString *view = NSStringFromClass(touch.view.superview.superview.class);
        if([view isEqualToString:@"HKPlayerCollectionViewCell"]) {
            return NO;
        }
    }
    
    // add yang 按钮点击冲突
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    //if ([NSStringFromClass(touch.view.class) isEqualToString:@"MMMaterialDesignSpinner"]){return NO;}
    
    if (gestureRecognizer == self.shrinkPanGesture && self.isCellVideo) {
        if (!self.isBottomVideo || self.isFullScreen) {
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && gestureRecognizer != self.shrinkPanGesture) {
        if ((self.isCellVideo && !self.isFullScreen) || self.playDidEnd || self.isLocked){
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.isBottomVideo && !self.isFullScreen) {
            return NO;
        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }

    return YES;
}

#pragma mark - Setter 

/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    
    // 添加通知
    [self addNotifications];
    
    self.isPauseByUser = YES;
    
    // 添加手势
    [self createGesture];
    
}

/**
 *  设置播放的状态
 *
 *  @param state ZFNormalPlayerState
 */
- (void)setState:(ZFNormalPlayerState)state {
    _state = state;
    // 控制菊花显示、隐藏
    [self.controlView zf_playerActivity:state == ZFNormalPlayerStateBuffering];
    if (state == ZFNormalPlayerStatePlaying || state == ZFNormalPlayerStateBuffering) {
        // 隐藏占位图
        [self.controlView zf_playerItemPlaying];
    } else if (state == ZFNormalPlayerStateFailed) {
        NSError *error = [self.playerItem error];
        [self.controlView zf_playerItemStatusFailed:error];
        NSLog(@"error ------>>>> %@",error );
        NSLog(@"error  localizedDescription ------>>>> %@",[error localizedDescription]);
        NSLog(@"[[self.playerItem errorLog]] -- %@",[self.playerItem errorLog]);
    }
}

/**
 *  根据playerItem，来添加移除观察者
 *
 *  @param playerItem playerItem
 */
- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem == playerItem) {return;}

    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/**
 *  根据tableview的值来添加、移除观察者
 *
 *  @param tableView tableView 
 */
- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView == scrollView) { return; }
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:kZFNormalPlayerViewContentOffset];
    }
    _scrollView = scrollView;
    if (scrollView) { [scrollView addObserver:self forKeyPath:kZFNormalPlayerViewContentOffset options:NSKeyValueObservingOptionNew context:nil]; }
}

/**
 *  设置playerLayer的填充模式
 *
 *  @param playerLayerGravity playerLayerGravity
 */
- (void)setPlayerLayerGravity:(ZFNormalPlayerLayerGravity)playerLayerGravity {
    _playerLayerGravity = playerLayerGravity;
    switch (playerLayerGravity) {
        case ZFNormalPlayerLayerGravityResize:
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            self.videoGravity = AVLayerVideoGravityResize;
            break;
        case ZFNormalPlayerLayerGravityResizeAspect:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            self.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case ZFNormalPlayerLayerGravityResizeAspectFill:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
}

/**
 *  是否有下载功能
 */
- (void)setHasDownload:(BOOL)hasDownload {
    _hasDownload = hasDownload;
    [self.controlView zf_playerHasDownloadFunction:hasDownload];
}

- (void)setResolutionDic:(NSDictionary *)resolutionDic {
    _resolutionDic = resolutionDic;
    self.videoURLArray = [resolutionDic allValues];
}

- (void)setControlView:(UIView *)controlView {
    if (_controlView) { return; }
    _controlView = controlView;
    controlView.delegate = self;
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setPlayerModel:(ZFNormalPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    if (playerModel.seekTime) { self.seekTime = playerModel.seekTime; }
    [self.controlView zf_playerModel:playerModel];
    // 分辨率
    if (playerModel.resolutionDic) {
       self.resolutionDic = playerModel.resolutionDic;
    }

    if (playerModel.scrollView && playerModel.indexPath && playerModel.videoURL) {
        NSCAssert(playerModel.fatherViewTag, @"请指定playerViews所在的faterViewTag");
        [self cellVideoWithScrollView:playerModel.scrollView AtIndexPath:playerModel.indexPath];
        if ([self.scrollView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)playerModel.scrollView;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:playerModel.indexPath];
            UIView *fatherView = [cell.contentView viewWithTag:playerModel.fatherViewTag];
            [self addPlayerToFatherView:fatherView];
        } else if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)playerModel.scrollView;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:playerModel.indexPath];
            UIView *fatherView = [cell.contentView viewWithTag:playerModel.fatherViewTag];
            [self addPlayerToFatherView:fatherView];
        }
    } else {
        NSCAssert(playerModel.fatherView, @"请指定playerView的faterView");
        [self addPlayerToFatherView:playerModel.fatherView];
    }
    self.videoURL = playerModel.videoURL;
}

- (void)setShrinkRightBottomPoint:(CGPoint)shrinkRightBottomPoint {
    _shrinkRightBottomPoint = shrinkRightBottomPoint;
    CGFloat width = ScreenWidth*0.5-20;
    CGFloat height = (self.bounds.size.height / self.bounds.size.width);
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.equalTo(self.mas_width).multipliedBy(height);
        make.trailing.mas_equalTo(-shrinkRightBottomPoint.x);
        make.bottom.mas_equalTo(-shrinkRightBottomPoint.y);
    }];
}

- (void)setPlayerPushedOrPresented:(BOOL)playerPushedOrPresented {
    _playerPushedOrPresented = playerPushedOrPresented;
    if (playerPushedOrPresented) {
        [self pause];
    } else {
        [self play];
    }
}


- (void)setFullScreenPlay:(BOOL)fullScreenPlay {
    _fullScreenPlay = fullScreenPlay;
    if (fullScreenPlay) [self _fullScreenAction];
}


#pragma mark - Getter

- (AVAssetImageGenerator *)imageGenerator {
    if (!_imageGenerator) {
        _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.urlAsset];
    }
    return _imageGenerator;
}

- (ZFNormalBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [ZFNormalBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}

- (NSString *)videoGravity {
    if (!_videoGravity) {
        _videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _videoGravity;
}

#pragma mark - ZFNormalPlayerControlViewDelegate

- (void)zf_controlView:(UIView *)controlView playAction:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(zf_playerAction:)]) {
        [self.delegate zf_playerAction:controlView];
    }
    sender.selected = !sender.selected;
    
    ZFNormalPlayerControlView  *playerView = (ZFNormalPlayerControlView*)controlView;
    
    [self checkModelStatus];
    if (self.onceOnlyCheck == OnceOnlyCheckStatus) {
        [playerView zf_playerShowTopGraphicBtn];
    }
    self.onceOnlyCheck = OnceOnlyTwoCheckStatus; // 标记第二次查询状态
    self.isPauseByUser = !self.isPauseByUser;
    if (self.isPauseByUser) {
        [self pause];
        if (self.state == ZFNormalPlayerStatePlaying) { self.state = ZFNormalPlayerStatePause;}
    } else {
        [self play];
        if (self.state == ZFNormalPlayerStatePause) { self.state = ZFNormalPlayerStatePlaying; }
    }
    
    // 当播放时显示 全屏按钮。 add
    playerView.fullScreenBtn.hidden = NO;
    if (!self.isAutoPlay) {
        self.isAutoPlay = YES;
        [self configZFNormalPlayer];
    }
}



//------------------- add 907 -----------------------//

- (void)zf_controlView:(UIView *)controlView buyVipAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_playerBuyVip:detailModel:)]) {
        if (self.isFullScreen) {
            [self _fullScreenAction];
        }
        [self.delegate zf_playerBuyVip:sender detailModel:self.playerModel.detailModel];
    }
}


#pragma mark - 重新登录
- (void)zf_controlView:(UIView *)controlView loginAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_loginAction:)]) {
        [self.delegate zf_loginAction:sender];
    }
}

#pragma mark - 播放下一视频
- (void)zf_controlView:(UIView *)controlView nextVideoAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_playNextVideo :nextVideoAction: isFullscreen:)]) {
        
        BOOL isFullScreen = self.isFullScreen;
        if (self.isFullScreen) {
            [self _fullScreenAction];
        }
        [self.delegate zf_playNextVideo:controlView nextVideoAction:sender isFullscreen:isFullScreen];
    }
}

#pragma mark  权限 model
- (void)zf_controlView:(UIView *)controlView permission:(id)sender {
    
    HKPermissionVideoModel *model = (HKPermissionVideoModel*)sender;
    
    ZFNormalPlayerModel *zfModel = self.playerModel;
    zfModel.videoURL = [NSURL URLWithString:model.video_url];
    self.playerModel = zfModel;
    //_playerModel.videoURL = [NSURL URLWithString:model.video_url];
}


/** 分享解锁视频 */  //add 0106
- (void)zf_controlView:(UIView *)controlView shareVideoAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_playerControlView:shareVideoAction:)]) {
        if (self.isFullScreen) {
            [self _fullScreenAction];
        }
        [self.delegate zf_playerControlView:controlView shareVideoAction:self.playerModel];
    }
}



#pragma mark - 举报视频
- (void)zf_controlView:(UIView *)controlView feedBack:(NSString*)feedBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zf_playerView:feedBack:)]) {
        if (self.isFullScreen) {
            [self _fullScreenAction];
        }
        [self.delegate zf_playerView:controlView feedBack:feedBack];
    }
}


//------------------- add 907 -----------------------//


- (void)zf_controlView:(UIView *)controlView backAction:(UIButton *)sender {
    if (ZFNormalPlayerShared.isLockScreen) {
        [self unLockTheScreen];
    } else {
        if (!self.isFullScreen) {
            // player加到控制器上，只有一个player时候
            [self pause];
            if ([self.delegate respondsToSelector:@selector(zf_playerBackAction)]) { [self.delegate zf_playerBackAction]; }
        } else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
            // 0302 全屏状态下 返回按钮事件（用于处理 下载完成的视频 返回操作）
//            if (self.delegate && [self.delegate respondsToSelector:@selector(zf_playerFullScreenBackAction)]) {
//                [self.delegate zf_playerFullScreenBackAction];
//            }
        }
    }
}

- (void)zf_controlView:(UIView *)controlView closeAction:(UIButton *)sender {
    [self resetPlayer];
    [self removeFromSuperview];
}

- (void)zf_controlView:(UIView *)controlView fullScreenAction:(UIButton *)sender {
    
    [self _fullScreenAction];
    // add 0302 用于处理 下载完成视频 返回 前一界面（wifi 视频详情 无wifi 下载列表）
    if (self.delegate && [self.delegate respondsToSelector:@selector(zf_playerOrientationPortrait:)]) {
        [self.delegate zf_playerOrientationPortrait:@""];
    }
}

- (void)zf_controlView:(UIView *)controlView lockScreenAction:(UIButton *)sender {
    self.isLocked               = sender.selected;
    // 调用AppDelegate单例记录播放状态是否锁屏
    ZFNormalPlayerShared.isLockScreen = sender.selected;
}

- (void)zf_controlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender {
    [self configZFNormalPlayer];
}

- (void)zf_controlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender {
    // 没有播放完
    self.playDidEnd   = NO;
    // 重播改为NO
    self.repeatToPlay = NO;
    [self seekToTime:0 completionHandler:nil];
    
    if ([self.videoURL.scheme isEqualToString:@"file"]) {
        self.state = ZFNormalPlayerStatePlaying;
    } else {
        self.state = ZFNormalPlayerStateBuffering;
    }
}

/** 加载失败按钮事件 */
- (void)zf_controlView:(UIView *)controlView failAction:(UIButton *)sender {
     [self configZFNormalPlayer];
}



- (void)zf_controlView:(UIView *)controlView resolutionAction:(UIButton *)sender{
    
    // 这里开启倍速功能
    CGFloat rate = ((sender.tag - 200) * 0.25) + 0.75;
    if (rate > 1.75) rate = 2.0;
    self.rate = rate;
    
    // 立马转换倍速播放
    if (self.state == ZFNormalPlayerStatePlaying) {
        [self play];
    }
    return;
    
    // 记录切换分辨率的时刻
    NSInteger currentTime = (NSInteger)CMTimeGetSeconds([self.player currentTime]);
    NSString *videoStr = self.videoURLArray[sender.tag - 200];
    NSURL *videoURL = [NSURL URLWithString:videoStr];
    if ([videoURL isEqual:self.videoURL]) { return; }
    self.isChangeResolution = YES;
    // reset player
    [self resetToPlayNewURL];
    self.videoURL = videoURL;
    // 从xx秒播放
    self.seekTime = currentTime;
    // 切换完分辨率自动播放
    [self autoPlayTheVideo];
}

// ***** 倍速播放 *****
- (void)tb_playWithRate{
    [self.player play];
    //如果想实现倍速播放,必须调用此方法
    [self enableAudioTracks:YES inPlayerItem:_playerItem];
    self.player.rate = self.rate > 0.1? self.rate : 1.0;
}

- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem
{
    for (AVPlayerItemTrack *track in playerItem.tracks)
    {
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeAudio])
        {
            track.enabled = enable;
        }
    }
}
// ***** 倍速播放 *****

- (void)zf_controlView:(UIView *)controlView downloadVideoAction:(UIButton *)sender {
    NSString *urlStr = self.videoURL.absoluteString;
    if ([self.delegate respondsToSelector:@selector(zf_playerDownload:)]) {
        [self.delegate zf_playerDownload:urlStr];
    }
}

- (void)zf_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value {
    // 视频总时间长度
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * value);
    
    //[self.controlView zf_playerPlayBtnState:YES];  modify yang 0910  双击进度条 播放视频
    [self seekToTime:dragedSeconds completionHandler:^(BOOL finished) {}];

}

- (void)zf_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider {
    // 拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value   = slider.value - self.sliderLastValue;
        if (value > 0) { style = YES; }
        if (value < 0) { style = NO; }
        if (value == 0) { return; }
        
        self.sliderLastValue  = slider.value;
        
        CGFloat totalTime     = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * slider.value);

        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime   = CMTimeMake(dragedSeconds, 1);
   
        [controlView zf_playerDraggedTime:dragedSeconds totalTime:totalTime isForward:style hasPreview:self.isFullScreen ? self.hasPreviewView : NO];
        
        if (totalTime > 0) { // 当总时长 > 0时候才能拖动slider
            if (self.isFullScreen && self.hasPreviewView) {
                
                [self.imageGenerator cancelAllCGImageGeneration];
                self.imageGenerator.appliesPreferredTrackTransform = YES;
                self.imageGenerator.maximumSize = CGSizeMake(100, 56);
                AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                    NSLog(@"%zd",result);
                    if (result != AVAssetImageGeneratorSucceeded) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [controlView zf_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : ZFNormalPlayerImage(@"ZFNormalPlayer_loading_bgView")];
                        });
                    } else {
                        self.thumbImg = [UIImage imageWithCGImage:im];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [controlView zf_playerDraggedTime:dragedSeconds sliderImage:self.thumbImg ? : ZFNormalPlayerImage(@"ZFNormalPlayer_loading_bgView")];
                        });
                    }
                };
                [self.imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:dragedCMTime]] completionHandler:handler];
            }
        } else {
            // 此时设置slider值为0
            slider.value = 0;
        }
        
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }

}

- (void)zf_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isPauseByUser = NO;
        self.isDragged = NO;
        // 视频总时间长度
        CGFloat total           = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}

- (void)zf_controlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    if ([self.delegate respondsToSelector:@selector(zf_playerControlViewWillShow:isFullscreen:)]) {
        [self.delegate zf_playerControlViewWillShow:controlView isFullscreen:fullscreen];
    }
}

- (void)zf_controlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    if ([self.delegate respondsToSelector:@selector(zf_playerControlViewWillHidden:isFullscreen:)]) {
        [self.delegate zf_playerControlViewWillHidden:controlView isFullscreen:fullscreen];
    }
}

#pragma mark - 移除VIP 视图
- (void)zf_controlRemoveBuyVipView {
    if (self.controlView) {
        [(ZFNormalPlayerControlView*)self.controlView removeBuyVipView];
    }
}


- (void)zf_controlView:(UIView *)controlView playTimeTipAction:(ZFNormalPlayerModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(zf_playerView:playTimeTipAction:)]) {
        [self.delegate zf_playerView:controlView playTimeTipAction:model];
    }
}

#pragma makr  中心的图文按钮
- (void)zf_controlView:(UIView *)controlView picUrl:(NSString*)picUrl centerGraphicBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_playerView:picUrl: centerGraphicBtnClick:)]) {
        if (self.isFullScreen) {
            [self _fullScreenAction];
        }
        [self.delegate zf_playerView:controlView picUrl:picUrl centerGraphicBtnClick:sender];
    }
}

#pragma makr  顶部图文按钮
- (void)zf_controlView:(UIView *)controlView picUrl:(NSString*)picUrl topGraphicBtnClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(zf_playerView:picUrl: topGraphicBtnClick:)]) {
        if (self.isFullScreen) {
            [self _fullScreenAction];
        }
        [self.delegate zf_playerView:controlView picUrl:picUrl topGraphicBtnClick:sender];
    }
}




/********************** add yang 0826************************/

#pragma mark - 判断是否 是第一次 然后查询 视频状态 改变Url
- (void)checkModelStatus {
    
    if (self.onceOnlyCheck == OnceOnlyCheckStatus ){
        
        [self postPlayCommentNotification];
        [self queryDownloadStatusBlock:^(HKDownloadStatus status) {
            [self changModelUrlByStatus:status];
        }];
    }
}


#pragma mark - 发送可以评论 通知
- (void)postPlayCommentNotification {
    NSString *videoId  = self.playerModel.videoId;
    NSDictionary *dict =  @{@"videoId":videoId};
    [MyNotification postNotificationName:KPlayCommentNotification object:nil userInfo:dict];
}



#pragma mark - 判断是否 是第一次 然后插入记录 并改变标记状态
- (void)insertLookRecordAndChangeStatus {
    
    if (self.onceOnly == OnceOnlyLookVideo ){
        self.onceOnly = OnceOnlyTwoLookVideo;
    }
}



#pragma mark - 判断是否是已经下载的视频 已经下载的视频改变 NSURL
- (void)changModelUrlByStatus:(HKDownloadStatus)status {
    
    if (status == HKDownloadFinished) {
        HKDownloadModel *modelTemp = [[HKDownloadManager shareInstance] queryWidthID:self.playerModel.videoId videoType:self.playerModel.videoType];;
        
        [self httpServer:modelTemp];
        self.videoLocalStatus = VideoLocalStatusLocalVideo;
        
        NSString *playurl = nil;
        if (modelTemp.saveInCache) {
            // 1.6前的cache文件
            VideoModel  *tempModel = [VideoModel new];
            tempModel.video_url = [NSString stringWithFormat:@"%@",self.playerModel.videoURL];
            NSString *temp = [CommonFunction getM3U8LocalUrlWithVideoUrl:tempModel.video_url];
            playurl = [NSString stringWithFormat:@"http://127.0.0.1:12345/%@/movie.m3u8", temp];
        } else {
            // 1.7 document文件
            playurl = [NSString stringWithFormat:@"http://127.0.0.1:12345/download/%@/movie.m3u8",self.playerModel.videoId];
            
            // 1.8版本
            BOOL isDirectory1_7 = NO;
            BOOL exist1_7 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/download/%@/movie.m3u8",HKDocumentPath, self.playerModel.videoId] isDirectory:&isDirectory1_7];
            if (!exist1_7) {
                playurl = [NSString stringWithFormat:@"http://127.0.0.1:12345/download/%@_%d/movie.m3u8",self.playerModel.videoId, self.playerModel.videoType];
            }
        }
        
        ZFNormalPlayerModel *model = self.playerModel;
        model.videoURL = [NSURL URLWithString:playurl];
        // 设置开始播放时间
        //HKSeekTimeModel *tempM = [HKPlayerLocalRateTool querySeekModel: self.playerModel.detailModel];
        //model.seekTime ;
        self.playerModel = model;
    
    }else{
        self.videoLocalStatus = VideoLocalStatusInternetVideo;
    }
}





#pragma mark - 查询下载状态
- (void)queryDownloadStatusBlock:(void(^)(HKDownloadStatus status))statusBlock {
    HKDownloadStatus status = HKDownloadNotExist;
    HKDownloadModel  *tempModel = [[HKDownloadModel alloc] init];
    
//    NSString *videoId = isEmpty(self.playerModel.detailModel.video_id) ?self.playerModel.videoId :self.playerModel.detailModel.video_id;
//
//    NSInteger type = isEmpty(self.playerModel.detailModel.video_id) ?self.playerModel.videoType :[self.playerModel.detailModel.video_type integerValue];
//
//    tempModel.videoId = videoId;
//    tempModel.videoType = type;
    
    tempModel.videoId = self.playerModel.videoId;
    tempModel.videoType = self.playerModel.videoType;
    
    status = [[HKDownloadManager shareInstance] queryStatus:tempModel];
    !statusBlock? : statusBlock(status);
}





#pragma mark - 开启服务器
- (HTTPServer *)httpServer:(HKDownloadModel *)model {
    
    if (!_httpServer) {
        
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:12345];
        
        NSString *webPath = nil;
        if (model.saveInCache) {
            webPath =  kLibraryCache;
        } else {
            webPath =  HKDocumentPath;
        }
        // 设置服务器路径
        [_httpServer setDocumentRoot:webPath];
        NSError *error;
        if ([_httpServer start:&error]) {
            //NSLog(@"开启HTTP服务器 端口:%hu",[_httpServer listeningPort]);
        }
        else{
//            if (DEBUG) {
//                NSLog(@"服务器启动失败错误为:%@",error);
//            }
        }
    }
    return _httpServer ;
}




#pragma mark - 网络状态改变通知
- (void)createObserver {
    
    [MyNotification addObserver:self
                       selector:@selector(networkNotification:)
                           name:KNetworkStatusNotification
                         object:nil];
}



- (void)networkNotification:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSInteger  status = [dict[@"status"] integerValue];
    
    self.playInternetStatus = status;
    if (status == AFNetworkReachabilityStatusNotReachable && self.videoLocalStatus == VideoLocalStatusInternetVideo && self.isFullScreen == YES){

        showNetWorkDialog(@"网络中断",self,4);

    }else if (status == AFNetworkReachabilityStatusReachableViaWWAN && self.videoLocalStatus == VideoLocalStatusInternetVideo && self.onceOnlyCheck == OnceOnlyTwoCheckStatus) {
        showNetWorkDialog(Mobile_Network ,self,4);
    }
}




void showNetWorkDialog (NSString * strText, UIView* view ,int time) {
    
    __block MBProgressHUD *mbProgressHUD = nil;
    mbProgressHUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:mbProgressHUD];
    mbProgressHUD.label.text = strText;
    mbProgressHUD.mode = MBProgressHUDModeText;
    mbProgressHUD.label.font = [UIFont systemFontOfSize: (IS_IPHONE6PLUS ? 15:14)];
    mbProgressHUD.yOffset = SCREEN_HEIGHT/3;
    
    mbProgressHUD.bezelView.color = [UIColor blackColor];
    mbProgressHUD.bezelView.alpha = 0.5f;
    mbProgressHUD.contentColor = [UIColor whiteColor];
    
    [mbProgressHUD showAnimated:YES];
    [mbProgressHUD setRemoveFromSuperViewOnHide:YES];
    [mbProgressHUD hideAnimated:YES afterDelay:time];
}



- (void)continuePlayVideo {
    
    //暂停
    [self pause];
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"流量提醒";
        label.textColor = [UIColor blackColor];
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = Mobile_Network;
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"稍后观看";
        action.titleColor = COLOR_ff7c00;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            return ;
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"继续观看";
        action.titleColor = COLOR_333333;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            [self play];
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}




#pragma clang diagnostic pop

@end
