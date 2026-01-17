//
//  GKPlayer.h
//  GKAudioPlayerDemo
//
//  Created by QuintGao on 2017/9/7.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKLyricParser.h"
#import "GKTool.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

#define HKBookPlayer [GKPlayer sharedInstance]

typedef NS_ENUM(NSUInteger, GKPlayerStatus) {
    GKPlayerStatusBuffering,   // 加载中
    GKPlayerStatusPlaying,     // 播放中
    GKPlayerStatusPaused,      // 暂停
    GKPlayerStatusStopped,     // 停止
    GKPlayerStatusEnded,       // 播放结束
    GKPlayerStatusError        // 播放出错
};


typedef NS_ENUM(NSUInteger, GKPlayerLoadState) {
    
    GKPlayerLoadStateUnknown        = 0,
    GKPlayerLoadStatePrepare        = 1 << 0,
    GKPlayerLoadStatePlayable       = 1 << 1,
    GKPlayerLoadStatePlaythroughOK  = 1 << 2,
    GKPlayerLoadStateStalled        = 1 << 3,
};


@class GKPlayer,HKBookModel,HKBookPlayInfoModel,HKRelateBookModel;

@protocol GKPlayerDelegate <NSObject>

@optional

// 获取当前播放状态的代理方法
- (void)gkPlayer:(GKPlayer *)player statusChanged:(GKPlayerStatus)status;

// 获取当前时间（00:00）和进度的代理方法
- (void)gkPlayer:(GKPlayer *)player currentTime:(NSString *)currentTime progress:(float)progress;

// 获取总时间（00:00）的代理方法
- (void)gkPlayer:(GKPlayer *)player totalTime:(NSString *)totalTime;

// 获取当前时间（单位：毫秒，更加精确）、总时间(单位：毫秒，更加精确)和进度的代理方法
- (void)gkPlayer:(GKPlayer *)player currentTime:(NSTimeInterval)currentTime
       totalTime:(NSTimeInterval)totalTime
      bufferProgress:(float)bufferProgress
        progress:(float)progress;

// 获取总时间（单位：毫秒，更加精确）
- (void)gkPlayer:(GKPlayer *)player duration:(NSTimeInterval)duration;

// 获取当前缓冲的代理方法
- (void)gkPlayer:(GKPlayer *)player loadState:(GKPlayerLoadState)loadState;
/// 更新 倒计时
- (void)gkPlayer:(GKPlayer *)player updateDownTime:(NSInteger)DownTime;
/// 播放结束
- (void)gkPlayer:(GKPlayer *)player playerDidToEnd:(BOOL)playerDidToEnd;

/// 播放失败
- (void)gkPlayer:(GKPlayer *)player playbackError:(GKPlayerStatus)playbackError;

/// 准备播放
- (void)gkPlayer:(GKPlayer *)player preparedToPlay:(BOOL)preparedToPlay;

/// 刷新view
- (void)gkPlayer:(GKPlayer *)player resetControlView:(BOOL)resetControlView
       bookModel:(HKBookModel*)bookModel
 relateBookModel:(HKRelateBookModel*)relateBookModel;

// 获取当前播放状态的代理方法
- (void)gkPlayerDidCancel:(GKPlayer *)player;



@end

@interface GKPlayer : NSObject

@property (nonatomic, weak) id<GKPlayerDelegate> delegate;
/** 播放地址 */
@property (nonatomic, copy) NSString *playUrlStr;
/** 播放状态 */
@property (nonatomic, readonly) GKPlayerStatus playState;
/** 缓冲状态 */
@property (nonatomic, readonly) GKPlayerLoadState loadState;
/** 快进时间 */
@property (nonatomic, assign) NSTimeInterval seekTime;
/** 播放当前时间 */
@property (nonatomic, assign,readonly) NSTimeInterval currentTime;
/** 音频总时间 */
@property (nonatomic, assign,readonly) NSTimeInterval totalTime;
/** 准备播放 */
@property (nonatomic, assign,readonly) BOOL isPreparedToPlay;
/** 播放中*/
@property (nonatomic, assign,readonly)  BOOL isPlaying;
//定时时间
@property(nonatomic, assign) NSInteger timerSeconds;
//定时类型
@property(nonatomic,assign)HKBookTimerType timerType;
// 虎课读书
@property(nonatomic, assign) BOOL isHKBookAudio;
//可以播放虎课读书
@property(nonatomic, assign) BOOL isBookCanPlay;
//免费观看时间
@property(nonatomic, assign) NSInteger freePlaySecond;
/** 封面URL */
@property (nonatomic, copy) NSString *coverUrl;
/** yes - 读书VC 消失 */
@property(nonatomic, assign) BOOL isListeningVCDisappr;
/** yes - 返回前一页面 */
@property (nonatomic,assign) BOOL isBackFrontVC;

@property (nonatomic, strong)HKBookModel *bookModel;

@property (nonatomic, strong)HKBookPlayInfoModel  *playInfoModel;

@property (nonatomic, strong)HKMapModel *mapModel;

@property (nonatomic, strong)ShareModel *shareModel;

@property (nonatomic, strong)HKRelateBookModel *relateModel;

@property (nonatomic, strong)HKMapModel *bookMapModel;

/** 锁屏播放 封面 **/
@property (nonatomic, strong)UIImage *lockScreenImage;
/** yes - 强制显示控制窗口 */
@property(nonatomic, assign) BOOL forceShowWindowBooKView;

@property (nonatomic, strong) IJKFFMoviePlayerController *player;


+ (instancetype)sharedInstance;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 恢复播放
 */
- (void)resume;

/**
 停止播放
 */
- (void)stop;


/**
  停止播放 并隐藏小浮标
 */
- (void)stopAndHiddenWindowBooKView;

/**
 暂停读书播放

 @param hidden YES（隐藏小浮标)
 */
- (void)pauseAndHiddenWindowBooKView:(BOOL)hidden;


/**
 小浮标显示

 @param hidden YES（隐藏小浮标)
 */
- (void)hiddenWindowBooKView:(BOOL)hidden;

- (void)pauseReadBooK;
- (void)stopReadBooK;
/**
 快进 快退
 
 @param time
 @param completionHandler
 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;


/**
 重置当前播放时间
 */
- (void)resetCurrentTime;


- (void)setPlayUrl:(NSString *_Nonnull)playUrl  isNeedPlay:(BOOL)isNeedPlay;

/** 设置播放速率 */
- (void)setPlayRate:(float)playRate;

/// 播放 暂停读书
- (void)playOrPauseAudio;

///
- (void)setPlayerWithBookId:(NSString*_Nullable)bookId courseId:(NSString*_Nullable)courseId isNeedquerRecord:(NSString *)isNeed;

- (void)getBookInfoWithBookId:(NSString*)bookId courseId:(NSString*)courseId isNeedquerRecord:(NSString *)isNeed isLoginUpdate:(BOOL)islogin;
/// 播放上一课
- (void)playPreviousMedia;

/// 播放下一课
- (void)playNextMedia;

@end







