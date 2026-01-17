//
//  ZFHKNormalPlayerGestureControl.h
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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZFHKNormalPlayerGestureType) {
    ZFHKNormalPlayerGestureTypeUnknown,
    ZFHKNormalPlayerGestureTypeSingleTap,
    ZFHKNormalPlayerGestureTypeDoubleTap,
    ZFHKNormalPlayerGestureTypePan,
    ZFHKNormalPlayerGestureTypePinch,
    ZFHKNormalPlayerGestureTypeLongPress
};

typedef NS_ENUM(NSUInteger, ZFHKNormalPanDirection) {
    ZFHKNormalPanDirectionUnknown,
    ZFHKNormalPanDirectionV,
    ZFHKNormalPanDirectionH,
};

typedef NS_ENUM(NSUInteger, ZFHKNormalPanLocation) {
    ZFHKNormalPanLocationUnknown,
    ZFHKNormalPanLocationLeft,
    ZFHKNormalPanLocationRight,
};

typedef NS_ENUM(NSUInteger, ZFHKNormalPanMovingDirection) {
    ZFHKNormalPanMovingDirectionUnkown,
    ZFHKNormalPanMovingDirectionTop,
    ZFHKNormalPanMovingDirectionLeft,
    ZFHKNormalPanMovingDirectionBottom,
    ZFHKNormalPanMovingDirectionRight,
};

/// This enumeration lists some of the gesture types that the player has by default.
typedef NS_OPTIONS(NSUInteger, ZFHKNormalPlayerDisableGestureTypes) {
    ZFHKNormalPlayerDisableGestureTypesNone         = 0,
    ZFHKNormalPlayerDisableGestureTypesSingleTap    = 1 << 0,
    ZFHKNormalPlayerDisableGestureTypesDoubleTap    = 1 << 1,
    ZFHKNormalPlayerDisableGestureTypesPan          = 1 << 2,
    ZFHKNormalPlayerDisableGestureTypesPinch        = 1 << 3,
    ZFHKNormalPlayerDisableGestureTypesAll          = 1 << 4
};

@interface ZFHKNormalPlayerGestureControl : NSObject

@property (nonatomic, copy, nullable) BOOL(^triggerCondition)(ZFHKNormalPlayerGestureControl *control, ZFHKNormalPlayerGestureType type, UIGestureRecognizer *gesture, UITouch *touch);

@property (nonatomic, copy, nullable) void(^singleTapped)(ZFHKNormalPlayerGestureControl *control);

@property (nonatomic, copy, nullable) void(^doubleTapped)(ZFHKNormalPlayerGestureControl *control);

@property (nonatomic, copy, nullable) void(^beganPan)(ZFHKNormalPlayerGestureControl *control, ZFHKNormalPanDirection direction, ZFHKNormalPanLocation location);

@property (nonatomic, copy, nullable) void(^changedPan)(ZFHKNormalPlayerGestureControl *control, ZFHKNormalPanDirection direction, ZFHKNormalPanLocation location, CGPoint velocity);

@property (nonatomic, copy, nullable) void(^endedPan)(ZFHKNormalPlayerGestureControl *control, ZFHKNormalPanDirection direction, ZFHKNormalPanLocation location);

@property (nonatomic, copy, nullable) void(^pinched)(ZFHKNormalPlayerGestureControl *control, float scale);

//@property (nonatomic, copy, nullable) void(^longPressed)(ZFHKNormalPlayerGestureControl *control);

@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTap;

@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTap;

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGR;

@property (nonatomic, strong, readonly) UIPinchGestureRecognizer *pinchGR;

@property (nonatomic, strong,readonly) UILongPressGestureRecognizer  *longPressGR;


@property (nonatomic, readonly) ZFHKNormalPanDirection panDirection;

@property (nonatomic, readonly) ZFHKNormalPanLocation panLocation;

@property (nonatomic, readonly) ZFHKNormalPanMovingDirection panMovingDirection;

@property (nonatomic) ZFHKNormalPlayerDisableGestureTypes disableTypes;

@property (nonatomic, assign)CGPoint touchPoint;


@property (nonatomic, copy, nullable) void(^longPressTap)(ZFHKNormalPlayerGestureControl *control, BOOL srartOrEnd);

- (void)addGestureToView:(UIView *)view;
- (void)removeGestureToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END


