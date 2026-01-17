//
//  ZFHKNormalPlayerMediaControl.h
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
#import "ZFHKNormalPlayerMediaPlayback.h"
#import "ZFHKNormalOrientationObserver.h"
#import "ZFHKNormalPlayerGestureControl.h"
#import "ZFHKNormalReachabilityManager.h"
@class ZFHKNormalPlayerController;

NS_ASSUME_NONNULL_BEGIN

@protocol ZFHKNormalPlayerMediaControl <NSObject>

@required
/// Current playerController
@property (nonatomic, weak) ZFHKNormalPlayerController *player;

@optional

#pragma mark - Playback state

/// When the player prepare to play the video.
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer prepareToPlay:(NSURL *)assetURL;

/// When th player playback state changed.
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer playStateChanged:(ZFHKNormalPlayerPlaybackState)state;

/// When th player loading state changed.
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer loadStateChanged:(ZFHKNormalPlayerLoadState)state;

#pragma mark - progress

/**
 When the playback changed.
 
 @param videoPlayer the player.
 @param currentTime the current play time.
 @param totalTime the video total time.
 */
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer
        currentTime:(NSTimeInterval)currentTime
          totalTime:(NSTimeInterval)totalTime;

/**
 When buffer progress changed.
 */
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer
         bufferTime:(NSTimeInterval)bufferTime;

/**
 When you are dragging to change the video progress.
 */
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer
       draggingTime:(NSTimeInterval)seekTime
          totalTime:(NSTimeInterval)totalTime;

/**
 When play end.
 */
- (void)videoPlayerPlayEnd:(ZFHKNormalPlayerController *)videoPlayer;

/**
 When play failed.
 */
- (void)videoPlayerPlayFailed:(ZFHKNormalPlayerController *)videoPlayer error:(id)error;

#pragma mark - lock screen

/**
 When set `videoPlayer.lockedScreen`.
 */
- (void)lockedVideoPlayer:(ZFHKNormalPlayerController *)videoPlayer lockedScreen:(BOOL)locked;

#pragma mark - Screen rotation

/**
 When the fullScreen maode will changed.
 */
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer orientationWillChange:(ZFHKNormalOrientationObserver *)observer;

/**
 When the fullScreen maode did changed.
 */
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer orientationDidChanged:(ZFHKNormalOrientationObserver *)observer;

#pragma mark - The network changed

/**
 When the network changed
 */
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer reachabilityChanged:(ZFHKNormalReachabilityStatus)status;

#pragma mark - The video size changed

/**
 When the video size changed
 */
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size;

#pragma mark - Gesture

/**
 When the gesture condition
 */
- (BOOL)gestureTriggerCondition:(ZFHKNormalPlayerGestureControl *)gestureControl
                    gestureType:(ZFHKNormalPlayerGestureType)gestureType
              gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
                          touch:(UITouch *)touch;

/**
 When the gesture single tapped
 */
- (void)gestureSingleTapped:(ZFHKNormalPlayerGestureControl *)gestureControl;

/**
 When the gesture double tapped
 */
- (void)gestureDoubleTapped:(ZFHKNormalPlayerGestureControl *)gestureControl;

/**
 When the gesture begin panGesture
 */
- (void)gestureBeganPan:(ZFHKNormalPlayerGestureControl *)gestureControl
           panDirection:(ZFHKNormalPanDirection)direction
            panLocation:(ZFHKNormalPanLocation)location;

/**
 When the gesture paning
 */
- (void)gestureChangedPan:(ZFHKNormalPlayerGestureControl *)gestureControl
             panDirection:(ZFHKNormalPanDirection)direction
              panLocation:(ZFHKNormalPanLocation)location
             withVelocity:(CGPoint)velocity;

/**
 When the end panGesture
 */
- (void)gestureEndedPan:(ZFHKNormalPlayerGestureControl *)gestureControl
           panDirection:(ZFHKNormalPanDirection)direction
            panLocation:(ZFHKNormalPanLocation)location;

/**
 When the pinchGesture changed
 */
- (void)gesturePinched:(ZFHKNormalPlayerGestureControl *)gestureControl
                 scale:(float)scale;



/**
 When the gesture double tapped
 */
- (void)gestureLongPressTap:(ZFHKNormalPlayerGestureControl *)gestureControl startOrEnd:(BOOL)start;

//
///// 退出音频
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer quitAudioPlay:(BOOL)quitAudioPlay;

@end

NS_ASSUME_NONNULL_END

