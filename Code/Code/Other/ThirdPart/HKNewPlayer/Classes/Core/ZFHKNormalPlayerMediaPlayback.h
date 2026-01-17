//
//  ZFHKNormalMediaPlayback.h
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

#import <Foundation/Foundation.h>
#import "ZFHKNormalPlayerView.h"
#import "HKPermissionVideoModel.h"
#import "ZFPlayerConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZFHKNormalPlayerPlaybackState) {
    ZFHKNormalPlayerPlayStateUnknown,
    ZFHKNormalPlayerPlayStatePlaying,
    ZFHKNormalPlayerPlayStatePaused,
    ZFHKNormalPlayerPlayStatePlayFailed,
    ZFHKNormalPlayerPlayStatePlayStopped
};

typedef NS_OPTIONS(NSUInteger, ZFHKNormalPlayerLoadState) {
    ZFHKNormalPlayerLoadStateUnknown        = 0,
    ZFHKNormalPlayerLoadStatePrepare        = 1 << 0,
    ZFHKNormalPlayerLoadStatePlayable       = 1 << 1,
    ZFHKNormalPlayerLoadStatePlaythroughOK  = 1 << 2, // Playback will be automatically started.
    ZFHKNormalPlayerLoadStateStalled        = 1 << 3, // Playback will be automatically paused in this state, if started.
};

typedef NS_ENUM(NSInteger, ZFHKNormalPlayerScalingMode) {
    ZFHKNormalPlayerScalingModeNone,       // No scaling.
    ZFHKNormalPlayerScalingModeAspectFit,  // Uniform scale until one dimension fits.
    ZFHKNormalPlayerScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents.
    ZFHKNormalPlayerScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds.
};

@protocol ZFHKNormalPlayerMediaPlayback <NSObject>

@required
/// The view must inherited `ZFHKNormalPlayerView`,this view deals with some gesture conflicts.
@property (nonatomic,strong) ZFHKNormalPlayerView * view;

@optional
/// The player volume.
/// Only affects audio volume for the player instance and not for the device.
/// You can change device volume or player volume as needed,change the player volume you can folllow the `ZFHKNormalPlayerMediaPlayback` protocol.
@property (nonatomic) float volume;

/// The player muted.
/// indicates whether or not audio output of the player is muted. Only affects audio muting for the player instance and not for the device.
/// You can change device volume or player muted as needed,change the player muted you can folllow the `ZFHKNormalPlayerMediaPlayback` protocol.
@property (nonatomic, getter=isMuted) BOOL muted;

/// Playback speed,0.5...2
@property (nonatomic) float rate;

/// The player current play time.
@property (nonatomic, readonly) NSTimeInterval currentTime;

/// The player total time.
@property (nonatomic, readonly) NSTimeInterval totalTime;

/// The player buffer time.
@property (nonatomic, readonly) NSTimeInterval bufferTime;

/// The player seek time.
@property (nonatomic) NSTimeInterval seekTime;

/// The player play state,playing or not playing.
@property (nonatomic, readonly) BOOL isPlaying;

/// Determines how the content scales to fit the view. Defaults to ZFHKNormalPlayerScalingModeNone.
@property (nonatomic, assign) ZFHKNormalPlayerScalingMode scalingMode;

/**
 @abstract Check whether video preparation is complete.
 @discussion isPreparedToPlay processing logic
 
 * If isPreparedToPlay is TRUE, you can call [ZFHKNormalPlayerMediaPlayback play] API start playing;
 * If isPreparedToPlay to FALSE, direct call [ZFHKNormalPlayerMediaPlayback play], in the play the internal automatic call [ZFHKNormalPlayerMediaPlayback prepareToPlay] API.
 * Returns YES if prepared for playback.
 */
@property (nonatomic, readonly) BOOL isPreparedToPlay;

/// The player should auto player, default is YES.
@property (nonatomic) BOOL shouldAutoPlay;


/// The play asset URL.
@property (nonatomic) NSURL *assetURL;

/// The video size.
@property (nonatomic, readonly) CGSize presentationSize;

/// The playback state.
@property (nonatomic, readonly) ZFHKNormalPlayerPlaybackState playState;

/// The player load state.
@property (nonatomic, readonly) ZFHKNormalPlayerLoadState loadState;

///------------------------------------
/// If you don't appoint the controlView, you can called the following blocks.
/// If you appoint the controlView, The following block cannot be called outside, only for `ZFHKNormalPlayerController` calls.
///------------------------------------

/// The block invoked when the player is Prepare to play.
@property (nonatomic, copy, nullable) void(^playerPrepareToPlay)(id<ZFHKNormalPlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player is Ready to play.
@property (nonatomic, copy, nullable) void(^playerReadyToPlay)(id<ZFHKNormalPlayerMediaPlayback> asset, NSURL *assetURL);

/// The block invoked when the player play progress changed.
@property (nonatomic, copy, nullable) void(^playerPlayTimeChanged)(id<ZFHKNormalPlayerMediaPlayback> asset, NSTimeInterval currentTime, NSTimeInterval duration);

/// The block invoked when the player play buffer changed.
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(id<ZFHKNormalPlayerMediaPlayback> asset, NSTimeInterval bufferTime);

/// The block invoked when the player playback state changed.
@property (nonatomic, copy, nullable) void(^playerPlayStateChanged)(id<ZFHKNormalPlayerMediaPlayback> asset, ZFHKNormalPlayerPlaybackState playState);

/// The block invoked when the player load state changed.
@property (nonatomic, copy, nullable) void(^playerLoadStateChanged)(id<ZFHKNormalPlayerMediaPlayback> asset, ZFHKNormalPlayerLoadState loadState);

/// The block invoked when the player play failed.
@property (nonatomic, copy, nullable) void(^playerPlayFailed)(id<ZFHKNormalPlayerMediaPlayback> asset, id error);

/// The block invoked when the player play end.
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(id<ZFHKNormalPlayerMediaPlayback> asset);

// The block invoked when video size changed.
@property (nonatomic, copy, nullable) void(^presentationSizeChanged)(id<ZFHKNormalPlayerMediaPlayback> asset, CGSize size);
/** 退出音频播放 回调 */
@property (nonatomic, copy, nullable) void(^quitAudioPlayCallBack)(id<ZFHKNormalPlayerMediaPlayback> asset);

/** 音频播放 */
@property (nonatomic, assign) BOOL isAudioplay;
/** 详情Moddel */
@property (nonatomic,strong) DetailModel *videoDetailModel;
@property (nonatomic) BOOL isDown;//标记为本地已经下载
@property (nonatomic) HKPermissionVideoModel * permissionModel;//视频信息

///------------------------------------
/// end
///------------------------------------

/// Prepares the current queue for playback, interrupting any active (non-mixible) audio sessions.
- (void)prepareToPlay;

/// Reload player.
- (void)reloadPlayer;

/// Play playback.
- (void)play;

/// Pauses playback.
- (void)pause;

/// Replay playback.
- (void)replay;

/// Stop playback.
- (void)stop;

/// Video UIImage at the current time.
- (UIImage *)thumbnailImageAtCurrentTime;

/// Use this method to seek to a specified time for the current player and to be notified when the seek operation is complete.
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;

/// Replace the current playback URL.
- (void)replaceCurrentAssetURL:(NSURL *)assetURL __attribute__((deprecated("use the property `assetURL` instead.")));
/// 播放失败 暂停
@property (nonatomic, assign) BOOL isFailPause;

@end

NS_ASSUME_NONNULL_END
