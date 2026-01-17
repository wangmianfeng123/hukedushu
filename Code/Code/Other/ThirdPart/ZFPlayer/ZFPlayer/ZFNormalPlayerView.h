//
//  ZFNormalPlayerView.h
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
#import "ZFNormalPlayer.h"
#import "ZFNormalPlayerModel.h"
#import "ZFNormalPlayerControlViewDelegate.h"

@class DetailModel,ZFNormalPlayerControlView;

@protocol ZFNormalPlayerDelegate <NSObject>
@optional
/** 返回按钮事件 */
- (void)zf_playerBackAction;
/** 下载视频 */
- (void)zf_playerDownload:(NSString *)url;
/** 控制层即将显示 */
- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen;
/** 控制层即将隐藏 */
- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen;

//------- add 907 --------//
#pragma mark - 购买VIP
- (void)zf_playerBuyVip:(UIButton *)sender  detailModel:(DetailModel*)detailModel;

/** 播放按钮事件 */
- (void)zf_playerAction:(UIView *)controlView;

/** 登录过期 重新登录 */
- (void)zf_loginAction:(UIButton *)sender;

/** 播放按钮事件 */
- (void)zf_controlView:(UIView *)controlView playAction:(UIButton *)sender;

/** 跳转下一视频 */
//- (void)zf_playNextVideo:(UIView *)controlView nextVideoAction:(id)sender ;

- (void)zf_playNextVideo:(UIView *)controlView nextVideoAction:(id)sender isFullscreen:(BOOL)isFullscreen;

/**  分享视频 解锁 */
- (void)zf_playerControlView:(UIView *)controlView shareVideoAction:(id)sender;
/**  横竖屏 变化 */
- (void)zf_playerOrientationChange:(id)sender isFullscreen:(BOOL)isFullscreen;

/** 点击全屏按钮 由全屏 到小屏-----用于处理下载完成视频 返回前一界面（wifi 视频详情 无wifi 下载列表） */
- (void)zf_playerOrientationPortrait:(id)sender;

/** 全屏状态下 返回按钮事件（ 用于处理 下载完成的视频 返回操作 ）*/
- (void)zf_playerFullScreenBackAction;

- (void)zf_controlView:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;

/** 播放时间提示 下一节课程跳转 */
- (void)zf_playerView:(UIView *)controlView playTimeTipAction:(ZFNormalPlayerModel *)model;

/** 播放完了 */
- (void)zf_playerView:(UIView *)controlView playEnd:(id )sender isFullscreen:(BOOL)fullscreen;

/** 中心的图文按钮*/
- (void)zf_playerView:(UIView *)controlView picUrl:(NSString*)picUrl centerGraphicBtnClick:(UIButton *)sender;

/** 顶部图文按钮*/
- (void)zf_playerView:(UIView *)controlView picUrl:(NSString*)picUrl topGraphicBtnClick:(UIButton *)sender;

/** 举报视频*/
- (void)zf_playerView:(UIView *)controlView feedBack:(NSString*)feedBack;

@end

// playerLayer的填充模式（默认：等比例填充，直到一个维度到达区域边界）
typedef NS_ENUM(NSInteger, ZFNormalPlayerLayerGravity) {
     ZFNormalPlayerLayerGravityResize,           // 非均匀模式。两个维度完全填充至整个视图区域
     ZFNormalPlayerLayerGravityResizeAspect,     // 等比例填充，直到一个维度到达区域边界
     ZFNormalPlayerLayerGravityResizeAspectFill  // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
};

// 播放器的几种状态
typedef NS_ENUM(NSInteger, ZFNormalPlayerState) {
    ZFNormalPlayerStateFailed,     // 播放失败
    ZFNormalPlayerStateBuffering,  // 缓冲中
    ZFNormalPlayerStatePlaying,    // 播放中
    ZFNormalPlayerStateStopped,    // 停止播放
    ZFNormalPlayerStatePause       // 暂停播放
};


//  add yang 0903

@class  HKPermissionVideoModel;

@interface ZFNormalPlayerView : UIView <ZFNormalPlayerControlViewDelagate>

/** 设置playerLayer的填充模式 */
@property (nonatomic, assign) ZFNormalPlayerLayerGravity    playerLayerGravity;
/** 是否有下载功能(默认是关闭) */
@property (nonatomic, assign) BOOL                    hasDownload;
/** 是否开启预览图 */
@property (nonatomic, assign) BOOL                    hasPreviewView;
/** 设置代理 */
@property (nonatomic, weak) id<ZFNormalPlayerDelegate>      delegate;
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL          isPauseByUser;
/** 播发器的几种状态 */
@property (nonatomic, assign, readonly) ZFNormalPlayerState state;
/** 静音（默认为NO）*/
@property (nonatomic, assign) BOOL                    mute;
/** 当cell划出屏幕的时候停止播放（默认为NO） */
@property (nonatomic, assign) BOOL                    stopPlayWhileCellNotVisable;
/** 当cell播放视频由全屏变为小屏时候，是否回到中间位置(默认YES) */
@property (nonatomic, assign) BOOL                    cellPlayerOnCenter;
/** player在栈上，即此时push或者模态了新控制器 */
@property (nonatomic, assign) BOOL                    playerPushedOrPresented;

@property (nonatomic, strong) UIView                 *controlView;

//@property (nonatomic, strong) ZFNormalPlayerControlView        *controlView;

@property (nonatomic, strong) ZFNormalPlayerModel          *playerModel;

// add yang  0825
//@property (nonatomic, strong) id  videoModel;//用于历史记录 和 查询视频状态（下载，未下载）

@property (nonatomic, copy) HKPermissionVideoModel  *permissionVideoModel;

/// 播放时候默认自动全屏
@property (nonatomic, assign) BOOL              fullScreenPlay;


/**
 *  单例，用于列表cell上多个视频
 *
 *  @return ZFNormalPlayer
 */
+ (instancetype)sharedPlayerView;

/**
 * 指定播放的控制层和模型
 * 控制层传nil，默认使用ZFNormalPlayerControlView(如自定义可传自定义的控制层)
 */
- (void)playerControlView:(UIView *)controlView playerModel:(ZFNormalPlayerModel *)playerModel;

/**
 * 使用自带的控制层时候可使用此API
 */
- (void)playerModel:(ZFNormalPlayerModel *)playerModel;

/**
 *  自动播放，默认不自动播放
 */
- (void)autoPlayTheVideo;

/**
 *  重置player
 */
- (void)resetPlayer;

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(ZFNormalPlayerModel *)playerModel;

/**
 *  播放
 */
- (void)play;

/**
  * 暂停
 */
- (void)pause;


/**
 * 全屏播放
 */
- (void)zf_fullScreenPlayAction;

/**
 移除VIP 视图
 */
- (void)zf_controlRemoveBuyVipView;

/**
 * 自动播放，模拟点击播放按钮
 */
- (void)zf_autoPlayAction;

/**
 * 自动全屏，模拟点击全屏按钮
 */
- (void)zf_autoFullScreenAction;


/**
 *  无观看权限 提示购买VIP 视图
 */
- (void)zf_buyVipView;

@end
