//
//  ZFHKNormalPortraitControlView.h
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
#import "ZFHKNormalPlayerController.h"
#import "ZFHKNormalSliderView.h"

NS_ASSUME_NONNULL_BEGIN

@class HKPermissionVideoModel;

@protocol ZFHKNormalPortraitControlViewDelegate <NSObject>

@optional

- (void)zfHKNormalPortraitControlView:(UIView *)view resolutionBtn:(UIButton*)btn rate:(CGFloat)rate
index:(NSInteger)index;

/** 投屏 */ 
- (void)zfHKNormalPortraitControlView:(UIView *)view airPlayBtn:(UIButton*)airPlayBtn;
/** 音频切换 */
- (void)zfHKNormalPortraitControlView:(UIView *)view  audioBtn:(UIButton*)audioBtn;

@end


@interface ZFHKNormalPortraitControlView : UIView 
/// 底部工具栏
@property (nonatomic, strong, readonly) UIView *bottomToolView;
/// 顶部工具栏
@property (nonatomic, strong, readonly) UIView *topToolView;
/// 标题
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 播放或暂停按钮
@property (nonatomic, strong, readonly) UIButton *playOrPauseBtn;
/// 播放的当前时间 
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong, readonly) ZFHKNormalSliderView *slider;
/// 视频总时间
@property (nonatomic, strong, readonly) UILabel *totalTimeLabel;
/// 全屏按钮
@property (nonatomic, strong, readonly) UIButton *fullScreenBtn;
/// 播放器
@property (nonatomic, weak) ZFHKNormalPlayerController *player;
/// slider滑动中
@property (nonatomic, copy, nullable) void(^sliderValueChanging)(CGFloat value,BOOL forward);
/// slider滑动结束
@property (nonatomic, copy, nullable) void(^sliderValueChanged)(CGFloat value);
/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;
/// 返回按钮点击回调
@property (nonatomic, copy) void(^portraitBackBtnClickCallback)(void);

/** 图文按钮 isCenterBtnClick (YES 中间图文按钮 NO 顶部图文按钮)*/
@property (nonatomic, copy) void(^portraitGraphicBtnClickCallback)(UIButton *btn,BOOL isCenterBtnClick,NSString *webUrl);

@property (nonatomic, weak)id<ZFHKNormalPortraitControlViewDelegate> delegate;

/// 重置控制层
- (void)resetControlView;
/// 显示控制层
- (void)showControlView;
/// 隐藏控制层
- (void)hideControlView;
/// 设置播放时间
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
/// 设置缓冲时间
- (void)videoPlayer:(ZFHKNormalPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime;
/// 是否响应该手势
- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFHKNormalPlayerGestureType)type touch:(nonnull UITouch *)touch;
/// 标题和全屏模式
- (void)showTitle:(NSString *_Nullable)title fullScreenMode:(ZFHKNormalFullScreenMode)fullScreenMode;
/// 根据当前播放状态取反
- (void)playOrPause;
/// 播放按钮状态
- (void)playBtnSelectedState:(BOOL)selected;
/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString;
/// 滑杆结束滑动
- (void)sliderChangeEnded;
///同步全屏点击切换分别率按钮
- (void)changeResolutionCurrent:(NSInteger)index;
/** 显示顶部图文按钮 */
- (void)portraitShowTopGraphicBtn;
/** 显示中间图文按钮 */
- (void)portraitShowCenterGraphicBtn;


#pragma mark - -- 虎课自定义部分

/** 视频详情 */
@property (nonatomic,strong,nullable) DetailModel *videoDetailModel;
/** 权限 */
@property (nonatomic,strong,nullable) HKPermissionVideoModel *permissionModel;
/** vip按钮 */
@property (nonatomic, copy) void(^portraitVipBtnClickCallback)(UIButton *btn);
/** 快进 按钮 */
@property (nonatomic, copy) void(^portraitFastForwardBtnClickCallback)(UIButton *btn);
/** 快退 按钮 */
@property (nonatomic, copy) void(^portraitBackForwardBtnClickCallback)(UIButton *btn);

- (void)hiddenPortraitCenterGraphicBtn;

/**
 投屏按钮
 @param hidden 显示 - NO  隐藏 -Yes
 */
- (void)showPortraitControlViewAirPlayBtn:(BOOL)hidden;

- (void)showPortraitShadowCoverView;


- (void)removePlayerResolutionView;

- (void)showOrhiddenTopToolView:(BOOL)isShow;
    
@end

NS_ASSUME_NONNULL_END
