//
//  ZFHKNormalPlayer.h
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
#import <UIKit/UIKit.h>
#import "ZFHKNormalPlayerMediaPlayback.h"
#import "ZFHKNormalOrientationObserver.h"
#import "ZFHKNormalPlayerMediaControl.h"
#import "ZFHKNormalPlayerGestureControl.h"
#import "ZFHKNormalPlayerNotification.h"
#import "ZFHKNormalFloatView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFHKNormalPlayerController : NSObject

/// The video contrainerView in normal model.
@property (nonatomic, strong) UIView *containerView;

/// The currentPlayerManager must conform `ZFHKNormalPlayerMediaPlayback` protocol.
@property (nonatomic, strong) id<ZFHKNormalPlayerMediaPlayback> currentPlayerManager;

/// The custom controlView must conform `ZFHKNormalPlayerMediaControl` protocol.
@property (nonatomic, strong) UIView<ZFHKNormalPlayerMediaControl> *controlView;

/// The notification manager class.
@property (nonatomic, strong, readonly) ZFHKNormalPlayerNotification *notification;

/// The container view type.
@property (nonatomic, assign) ZFPlayerContainerType containerType;

/// The player's small container view.
@property (nonatomic, strong, readonly) ZFFloatView *smallFloatView;

/// Whether the small window is displayed.
@property (nonatomic, assign, readonly) BOOL isSmallFloatViewShow;

/*!
 @method            playerWithPlayerManager:
 @abstract          Create an ZFHKNormalPlayerController that plays a single audiovisual item.
 @param             playerManager must conform `ZFHKNormalPlayerMediaPlayback` protocol.
 @param             containerView to see the video frames must set the contrainerView.
 @result            An instance of ZFHKNormalPlayerController.
 */
+ (instancetype)playerWithPlayerManager:(id<ZFHKNormalPlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            playerWithPlayerManager:
 @abstract          Create an ZFHKNormalPlayerController that plays a single audiovisual item.
 @param             playerManager must conform `ZFHKNormalPlayerMediaPlayback` protocol.
 @param             containerView to see the video frames must set the contrainerView.
 @result            An instance of ZFHKNormalPlayerController.
 */
- (instancetype)initWithPlayerManager:(id<ZFHKNormalPlayerMediaPlayback>)playerManager containerView:(UIView *)containerView;

/*!
 @method            playerWithScrollView:playerManager:
 @abstract          Create an ZFHKNormalPlayerController that plays a single audiovisual item. Use in `tableView` or `collectionView`.
 @param             scrollView is `tableView` or `collectionView`.
 @param             playerManager must conform `ZFHKNormalPlayerMediaPlayback` protocol.
 @param             containerViewTag to see the video at scrollView must set the contrainerViewTag.
 @result            An instance of ZFHKNormalPlayerController.
 */
//+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView playerManager:(id<ZFHKNormalPlayerMediaPlayback>)playerManager containerViewTag:(NSInteger)containerViewTag;

/*!
 @method            playerWithScrollView:playerManager:
 @abstract          Create an ZFHKNormalPlayerController that plays a single audiovisual item. Use in `tableView` or `collectionView`.
 @param             scrollView is `tableView` or `collectionView`.
 @param             playerManager must conform `ZFHKNormalPlayerMediaPlayback` protocol.
 @param             containerViewTag to see the video at scrollView must set the contrainerViewTag.
 @result            An instance of ZFHKNormalPlayerController.
 */
//- (instancetype)initWithScrollView:(UIScrollView *)scrollView playerManager:(id<ZFHKNormalPlayerMediaPlayback>)playerManager containerViewTag:(NSInteger)containerViewTag;

@end

@interface ZFHKNormalPlayerController (ZFHKNormalPlayerTimeControl)

/// The player current play time.
@property (nonatomic, readonly) NSTimeInterval currentTime;

/// The player total time.
@property (nonatomic, readonly) NSTimeInterval totalTime;

/// The player buffer time.
@property (nonatomic, readonly) NSTimeInterval bufferTime;

/// The player progress, 0...1
@property (nonatomic, readonly) float progress;

/// The player bufferProgress, 0...1
@property (nonatomic, readonly) float bufferProgress;

/// Use this method to seek to a specified time for the current player and to be notified when the seek operation is complete.
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;

@end

@interface ZFHKNormalPlayerController (ZFHKNormalPlayerPlaybackControl)
/// Resume playback record.default is NO.
/// Memory storage playback records.
@property (nonatomic, assign) BOOL resumePlayRecord;

/// 0...1.0
/// Only affects audio volume for the device instance and not for the player.
/// You can change device volume or player volume as needed,change the player volume you can conform the `ZFHKNormalPlayerMediaPlayback` protocol.
@property (nonatomic) float volume;

/// The device muted.
/// Only affects audio muting for the device instance and not for the player.
/// You can change device mute or player mute as needed,change the player mute you can conform the `ZFHKNormalPlayerMediaPlayback` protocol.
@property (nonatomic, getter=isMuted) BOOL muted;

// 0...1.0, where 1.0 is maximum brightness. Only supported by main screen.
@property (nonatomic) float brightness;

/// The play asset URL.
@property (nonatomic) NSURL *assetURL;

/// if tableView or collectionView has only one section , use sectionAssetURLs.
/// if normal model set this can use `playTheNext` `playThePrevious` `playTheIndex:`.
@property (nonatomic, copy, nullable) NSArray <NSURL *>*assetURLs;

/// The currently playing index,limited to one-dimensional arrays.
@property (nonatomic) NSInteger currentPlayIndex;

/// is the last asset URL in `assetURLs`.
@property (nonatomic, readonly) BOOL isLastAssetURL;

/// is the first asset URL in `assetURLs`.
@property (nonatomic, readonly) BOOL isFirstAssetURL;

/// If Yes, player will be called pause method When Received `UIApplicationWillResignActiveNotification` notification.
/// default is YES.
@property (nonatomic) BOOL pauseWhenAppResignActive;

/// When the player is playing, it is paused by some event,not by user click to pause
/// For example, when the player is playing, application goes into the background or pushes to another viewController
@property (nonatomic, getter=isPauseByEvent) BOOL pauseByEvent;

/// The current player controller is disappear, not dealloc
@property (nonatomic, getter=isViewControllerDisappear) BOOL viewControllerDisappear;

/// You can custom the AVAudioSession,
/// default is NO.
@property (nonatomic, assign) BOOL customAudioSession;

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

/// Play the next url ,while the `assetURLs` is not NULL.
- (void)playTheNext;

/// Play the previous url ,while the `assetURLs` is not NULL.
- (void)playThePrevious;

/// Play the index of url ,while the `assetURLs` is not NULL.
- (void)playTheIndex:(NSInteger)index;

/// Player stop and playerView remove from super view,remove other notification.
- (void)stop;

/*!
 @method           replaceCurrentPlayerManager:
 @abstract         Replaces the player's current playeranager with the specified player item.
 @param            manager must conform `ZFHKNormalPlayerMediaPlayback` protocol
 @discussion       The playerManager that will become the player's current playeranager.
 */
- (void)replaceCurrentPlayerManager:(id<ZFHKNormalPlayerMediaPlayback>)manager;

///**
// Add video to cell.
// */
//- (void)addPlayerViewToCell;
//
///**
// Add video to container view.
// */
//- (void)addPlayerViewToContainerView:(UIView *)containerView;
//
///**
// Add to small float view.
// */
//- (void)addPlayerViewToSmallFloatView;

/**
 Stop the current playing video and remove the playerView.
 */
//- (void)stopCurrentPlayingView;

/**
 stop the current playing video on cell.
 */
//- (void)stopCurrentPlayingCell;
@end

@interface ZFHKNormalPlayerController (ZFHKNormalPlayerOrientationRotation)

@property (nonatomic, readonly) ZFHKNormalOrientationObserver *orientationObserver;

/// Whether automatic screen rotation is supported.
/// iOS8.1~iOS8.3 the value is YES, other iOS version the value is NO.
/// This property is used for the return value of UIViewController `shouldAutorotate` method.
@property (nonatomic, readonly) BOOL shouldAutorotate;

/// Whether allow the video orientation rotate.
/// default is YES.
@property (nonatomic) BOOL allowOrentitaionRotation;

/// When ZFHKNormalFullScreenMode is ZFHKNormalFullScreenModeLandscape the orientation is LandscapeLeft or LandscapeRight, this value is YES.
/// When ZFHKNormalFullScreenMode is ZFHKNormalFullScreenModePortrait, while the player fullSceen this value is YES.
@property (nonatomic, readonly) BOOL isFullScreen;

/// Lock the screen orientation.
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(ZFHKNormalPlayerController *player, BOOL isFullScreen);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(ZFHKNormalPlayerController *player, BOOL isFullScreen);

/// default is  UIStatusBarStyleLightContent.
@property (nonatomic, assign) UIStatusBarStyle fullScreenStatusBarStyle;

/// defalut is UIStatusBarAnimationSlide.
@property (nonatomic, assign) UIStatusBarAnimation fullScreenStatusBarAnimation;

/// The statusbar hidden.
@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

/// Add the device orientation observer.
- (void)addDeviceOrientationObserver;

/// Remove the device orientation observer.
- (void)removeDeviceOrientationObserver;


/**
 Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModeLandscape.

 @param orientation is UIInterfaceOrientation.
 @param animated is animated.
*/
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/**
 Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModeLandscape.

 @param orientation is UIInterfaceOrientation.
 @param animated is animated.
 @param completion rotating completed callback.
*/
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

/**
 Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModePortrait.

 @param fullScreen is fullscreen.
 @param animated is animated.
 @param completion rotating completed callback.
 */
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

/// Enter the fullScreen while the ZFHKNormalFullScreenMode is ZFHKNormalFullScreenModePortrait.
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;


/// Enter the fullScreen while the ZFHKNormalFullScreenMode is ZFHKNormalFullScreenModeLandscape.
//- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;


- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;

// FullScreen mode is determined by ZFHKNormalFullScreenMode
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end

@interface ZFHKNormalPlayerController (ZFHKNormalPlayerViewGesture)

/// An instance of ZFHKNormalPlayerGestureControl.
@property (nonatomic, readonly) ZFHKNormalPlayerGestureControl *gestureControl;

/// The gesture types that the player not support.
@property (nonatomic, assign) ZFHKNormalPlayerDisableGestureTypes disableGestureTypes;

@end


NS_ASSUME_NONNULL_END
