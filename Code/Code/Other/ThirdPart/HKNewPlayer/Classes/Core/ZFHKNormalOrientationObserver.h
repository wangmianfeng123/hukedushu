//
//  ZFHKNormalOrentationObserver.h
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

#import <UIKit/UIKit.h>
#import "ZFPlayerController.h"

NS_ASSUME_NONNULL_BEGIN

/// Full screen mode
typedef NS_ENUM(NSUInteger, ZFHKNormalFullScreenMode) {
    ZFHKNormalFullScreenModeAutomatic,  // Determine full screen mode automatically
    ZFHKNormalFullScreenModeLandscape,  // Landscape full screen mode
    ZFHKNormalFullScreenModePortrait    // Portrait full screen Model
};

/// Portrait full screen mode.
typedef NS_ENUM(NSUInteger, ZFHKPortraitFullScreenMode) {
    ZFHKPortraitFullScreenModeScaleToFill,    // Full fill
    ZFHKPortraitFullScreenModeScaleAspectFit  // contents scaled to fit with fixed aspect. remainder is transparent
};
/// Full screen mode on the view
typedef NS_ENUM(NSUInteger, ZFHKNormalRotateType) {
    ZFHKNormalRotateTypeNormal,         // Normal
    ZFHKNormalRotateTypeCell,           // Cell
    ZFHKNormalRotateTypeCellOther       // Cell mode add to other view
};

/**
 Rotation of support direction
 */
typedef NS_OPTIONS(NSUInteger, ZFHKNormalInterfaceOrientationMask) {
    ZFHKNormalInterfaceOrientationMaskPortrait = (1 << 0),
    ZFHKNormalInterfaceOrientationMaskLandscapeLeft = (1 << 1),
    ZFHKNormalInterfaceOrientationMaskLandscapeRight = (1 << 2),
    ZFHKNormalInterfaceOrientationMaskPortraitUpsideDown = (1 << 3),
    ZFHKNormalInterfaceOrientationMaskLandscape = (ZFHKNormalInterfaceOrientationMaskLandscapeLeft | ZFHKNormalInterfaceOrientationMaskLandscapeRight),
    ZFHKNormalInterfaceOrientationMaskAll = (ZFHKNormalInterfaceOrientationMaskPortrait | ZFHKNormalInterfaceOrientationMaskLandscapeLeft | ZFHKNormalInterfaceOrientationMaskLandscapeRight | ZFHKNormalInterfaceOrientationMaskPortraitUpsideDown),
    ZFHKNormalInterfaceOrientationMaskAllButUpsideDown = (ZFHKNormalInterfaceOrientationMaskPortrait | ZFHKNormalInterfaceOrientationMaskLandscapeLeft | ZFHKNormalInterfaceOrientationMaskLandscapeRight),
};

@interface ZFHKNormalOrientationObserver : NSObject

- (void)updateRotateView:(UIView *)rotateView
           containerView:(UIView *)containerView;

/// Container view of a full screen state player.
@property (nonatomic, strong) UIView *fullScreenContainerView;

/// Container view of a small screen state player.
@property (nonatomic, weak) UIView *containerView;

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(ZFHKNormalOrientationObserver *observer, BOOL isFullScreen);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(ZFHKNormalOrientationObserver *observer, BOOL isFullScreen);

/// Full screen mode, the default landscape into full screen
@property (nonatomic) ZFHKNormalFullScreenMode fullScreenMode;

@property (nonatomic, assign) ZFHKPortraitFullScreenMode portraitFullScreenMode;

/// rotate duration, default is 0.30
@property (nonatomic) NSTimeInterval duration;

/// If the full screen.
@property (nonatomic, readonly, getter=isFullScreen) BOOL fullScreen;

///// Use device orientation, default NO.
//@property (nonatomic, assign) BOOL forceDeviceOrientation;

/// Lock screen orientation
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

/// The fullscreen statusbar hidden.
@property (nonatomic, assign) BOOL fullScreenStatusBarHidden;

/// default is  UIStatusBarStyleLightContent.
@property (nonatomic, assign) UIStatusBarStyle fullScreenStatusBarStyle;

/// defalut is UIStatusBarAnimationSlide.
@property (nonatomic, assign) UIStatusBarAnimation fullScreenStatusBarAnimation;

@property (nonatomic, assign) CGSize presentationSize;

/// Whether allow the video orientation rotate.
/// default is YES.
@property (nonatomic, assign) BOOL allowOrientationRotation;

///// The statusbar hidden.
@property (nonatomic, assign) ZFInterfaceOrientationMask supportInterfaceOrientation;

/// Add the device orientation observer.
- (void)addDeviceOrientationObserver;

/// Remove the device orientation observer.
- (void)removeDeviceOrientationObserver;


/// Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModeLandscape.
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/// Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModeLandscape.
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;


/// Enter the fullScreen while the ZFHKNormalFullScreenMode is ZFHKNormalFullScreenModePortrait.
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

/// Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModePortrait.
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void(^ __nullable)(void))completion;


/// FullScreen mode is determined by ZFFullScreenMode.
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

/// FullScreen mode is determined by ZFFullScreenMode.
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;
///// Enter the fullScreen while the ZFHKNormalFullScreenMode is ZFHKNormalFullScreenModeLandscape.

@end

NS_ASSUME_NONNULL_END


