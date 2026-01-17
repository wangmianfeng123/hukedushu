//
//  ZFHKNormalPlayerControlView.h
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
#import "ZFHKNormalPortraitControlView.h"
#import "ZFHKNormalLandScapeControlView.h"
#import "ZFHKNormalPlayerMediaControl.h"
#import "HKLivingSpeedLoadingView.h"


@class HKDownloadModel,HKPermissionVideoModel,HTTPServer,ZFHKNormalPlayerVipTipLB,ZFHKNormalPlayerBuyVipView,
MZTimerLabel,ZFHKNormalPlayerMaterialTipView,ZFHKNormalPlayerSeekTimeTipView,ZFHKPlayerCountDownView,
ZFHKPlayerPortraitSimilarVideoView,ZFHKPlayerLandScapeSimilarVideoView,ZFHKNormalPlayerControlView,MPVolumeView,ZFHKPlayerEndView;


@protocol ZFHKNormalPlayerControlViewDelegate <NSObject>

#pragma mark - -- 虎课自定义部分
@optional
/** 点击分享 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  shareAction:(id)sender videoDetailModel:(DetailModel *)model permissionVideoModel:(HKPermissionVideoModel *)permissionModel;
/** 点击购买VIP */
- (void)zfHKNormalPlayerControlView:(UIView*)view  buyVipAction:(UIButton*)sender videoDetailModel:(DetailModel *)model permissionModel:(HKPermissionVideoModel*)permissionModel;
/** 收藏视频 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  collectVideoAction:(UIButton*)sender videoDetailModel:(DetailModel *)model;
/** 进度提示 点击下一节视频 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  nextVideoModel:(DetailModel *)model;
/** 播放完成倒计时 下一节视频 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  countDownNextVideoModel:(DetailModel *)model;
/** 推荐视频 竖屏 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  portraitSimilarVideoView:(VideoModel *)model;
/** 推荐视频 全屏*/
- (void)zfHKNormalPlayerControlView:(UIView*)view  landScapeSimilarVideoView:(VideoModel *)model;
/** 播放完了 用于软件入门 证书弹框 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  playEnd:(BOOL)playEnd videoModel:(DetailModel *)model;

/** 投屏 */
- (void)zfHKNormalPlayerControlView:(ZFHKNormalPlayerControlView *)view airPlayBtn:(UIButton*)airPlayBtn isFullScreen:(BOOL)isFullScreen;
/** 添加笔记*/
- (void)zfHKNormalPlayerControlView:(ZFHKNormalPlayerControlView *)view addTxtNote:(UIImage *)img isFullScreen:(BOOL)isFullScreen currentTime:(NSInteger)currentTime videoModel:(DetailModel *)videoModel;

@end



@interface ZFHKNormalPlayerControlView : UIView <ZFHKNormalPlayerMediaControl>
/// 竖屏控制层的View
@property (nonatomic, strong, readonly) ZFHKNormalPortraitControlView *portraitControlView;
/// 横屏控制层的View
@property (nonatomic, strong, readonly) ZFHKNormalLandScapeControlView *landScapeControlView;
/// 加载loading
@property (nonatomic, strong, readonly) HKLivingSpeedLoadingView *activity;
/// 快进快退View
@property (nonatomic, strong, readonly) UIView *fastView;
/// 快进快退进度progress
@property (nonatomic, strong, readonly) ZFHKNormalSliderView *fastProgressView;
/// 快进快退时间
@property (nonatomic, strong, readonly) UILabel *fastTimeLabel;
/// 快进快退ImageView
@property (nonatomic, strong, readonly) UIImageView *fastImageView;
/// 底部播放进度
@property (nonatomic, strong, readonly) ZFHKNormalSliderView *bottomPgrogress;
/// 封面图
@property (nonatomic, strong, readonly) UIImageView *coverImageView;
/// 高斯模糊的背景图
@property (nonatomic, strong, readonly) UIImageView *bgImgView;
/// 高斯模糊视图
@property (nonatomic, strong, readonly) UIView *effectView;
/// 占位图，默认是灰色
@property (nonatomic, strong) UIImage *placeholderImage;
/// 快进视图是否显示动画，默认NO.
@property (nonatomic, assign) BOOL fastViewAnimated;
/// 视频之外区域是否高斯模糊显示，默认YES.
@property (nonatomic, assign) BOOL effectViewShow;
/// 直接进入全屏模式，只支持全屏模式
@property (nonatomic, assign) BOOL fullScreenOnly;
/// 如果是暂停状态，seek完是否播放，默认YES
@property (nonatomic, assign) BOOL seekToPlay;
/// 返回按钮点击回调
@property (nonatomic, copy) void(^backBtnClickCallback)(void);
/// 控制层显示或者隐藏
@property (nonatomic, readonly) BOOL controlViewAppeared;
/// 控制层显示或者隐藏的回调
@property (nonatomic, copy) void(^controlViewAppearedCallback)(BOOL appeared);
/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;
/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;
/// 中间播放按钮
@property (nonatomic, strong) UIButton *centerPlayeBtn;
/// （YES 动画）NO（无动画） 隐藏ControlView
@property (nonatomic, assign) BOOL hideControlViewWithAnimated;

/// 点击快进时间
@property (nonatomic, assign) NSTimeInterval fastTimeInterval;

/// 设置标题、封面、全屏模式
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFHKNormalFullScreenMode)fullScreenMode;

/// 设置标题、UIImage封面、全屏模式
- (void)showTitle:(NSString *)title coverImage:(UIImage *)image fullScreenMode:(ZFHKNormalFullScreenMode)fullScreenMode;

/// 重置控制层
- (void)resetControlView;

/// 竖屏返回按钮点击回调
@property (nonatomic, copy) void(^portraitBackBtnClickCallback)(void);

/// 是否播放结束
@property (nonatomic, assign, getter=isPlayEnd) BOOL playEnd;


#pragma mark - -- 虎课自定义部分

@property(nonatomic,weak)id <ZFHKNormalPlayerControlViewDelegate> delegate;

/** 竖屏图文按钮 */
@property (nonatomic, copy) void(^portraitGraphicBtnClickCallback)(UIButton *btn,BOOL isCenterBtnClick,NSString *webUrl);

@property (nonatomic, copy) void(^portraitVipBtnClickCallback)(UIButton *btn,DetailModel *detailModel,HKPermissionVideoModel *permissionModel);

/** 横屏图文按钮 */
@property (nonatomic, copy) void(^landScapeGraphicBtnClickCallback)(UIButton *btn,NSString *webUrl);

@property (nonatomic, copy) void(^landScapeVipBtnClickCallback)(UIButton *btn,DetailModel *detailModel,HKPermissionVideoModel *permissionModel);
@property (nonatomic , strong) void(^didCourseBlock)(NSString * changeCourseId,NSString * sectionId,NSString * frontCourseId);//横屏切换课程
@property (nonatomic , strong) void(^didNextBlock)(DetailModel *videoDetailModel);

/** 设置按钮 */
@property (nonatomic, copy) void(^landScapeSettingBtnClickCallback)(UIButton *btn);
/** 举报视频 */
@property (nonatomic, copy) void(^landScapeFeedBackCallback)();

@property (nonatomic, copy) void(^centerPlayBtnClick)();
/** 开始播放 */
@property (nonatomic, copy) void(^playerPrepareToPlayCallback)(NSString *videoId);

/** 播放完成 */
@property (nonatomic, copy) void(^playerDidToEndCallback)(NSString *videoId);

@property (nonatomic, copy) void(^playerPlayTimeChanged)(NSTimeInterval currentTime, NSTimeInterval duration);



/** 视频详情 */
@property (nonatomic,strong) DetailModel *videoDetailModel;

@property(nonatomic,strong)NSMutableArray *courseDataArray;//课程目录数据源
@property(nonatomic,strong)NSIndexPath * index;//当前播放的位置

@property (nonatomic,assign, getter = isDownloadFinsh) BOOL downloadFinsh;
/** 视频下载情况 */
@property (nonatomic,strong) HKDownloadModel *downloadModel;

@property (nonatomic,strong) HKPermissionVideoModel *permissionModel;
/** 本地服务器 */
@property (nonatomic, strong)HTTPServer * httpServer;
/** vip 提示 */
@property (nonatomic, strong)ZFHKNormalPlayerVipTipLB *playerVipTipLB;
/** vip购买 分享view  */
@property (nonatomic, strong)ZFHKNormalPlayerBuyVipView *vipShareView;
/** 素材下载提示 计时器 */
@property (nonatomic, strong)MZTimerLabel   *materialTimerLabel;
/** 播放时长 计时器 */
@property (nonatomic, strong)MZTimerLabel  *playerProgressLabel;

@property (nonatomic, strong)ZFHKNormalPlayerSeekTimeTipView *playerSeekTimeTipView;
/** 播放进度 */
@property (nonatomic,assign) NSInteger playerSeekTime;
/** 笔记定位播放位置 */
@property (nonatomic,assign) NSInteger notesSeekTime;
/** 重播 */
@property (nonatomic, strong) UIButton *repeatBtn;
/** 下一节视频 倒计时 */
@property (nonatomic, strong) ZFHKPlayerCountDownView *nextVideoCountDownView;
/** 竖屏推荐视频 */
@property (nonatomic, strong) ZFHKPlayerPortraitSimilarVideoView *portraitSimilarVideoView;
/** 全屏推荐视频 */
@property (nonatomic, strong) ZFHKPlayerLandScapeSimilarVideoView *landScapeSimilarVideoView;
/** 目录课播放结束 */
@property (nonatomic, strong) ZFHKPlayerEndView *playerEndView;
/** 推荐视频 */
@property (nonatomic, strong) NSMutableArray   *similarVideoArray;

/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic,strong) MPVolumeView *volumView;

@property (nonatomic,strong) HKAlilogModel *alilogModel;

@property (nonatomic , assign) BOOL isNeedAutoPlay ;//笔记过来需要自动播放

/// YES 需要显示 (用于播放完后 覆盖的封面需要返回按钮)
@property (nonatomic,assign) BOOL isLandScapeShowBackBtn;

@property (nonatomic , assign) BOOL fromTrainCourse ;
//@property (nonatomic , assign) NSInteger timeDiff ;
/** 重置播放计时 */
- (void)resetProgressTimer;

/** 重播 */
- (void)repeatPlay;

/// 隐藏控制层
- (void)hideControlViewWithAnimated:(BOOL)animated;

@end



