//
//  ZFHKNormalPlayerControlView+Category.h
//  Code
//
//  Created by Ivan li on 2019/3/12.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "ZFHKNormalPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFHKNormalPlayerControlView (Category)

/**
 @return Yes 已下载
 */
- (BOOL)isDownloadFinsh:(DetailModel *)detailModel;

/**
 终止本地服务
 */
- (void)stopLocalServer;

/**
 开启本地服务
 
 @param sucess 回调
 @param fail
 */
- (void)startLocalServer:(void(^)())sucess fail:(void(^)())fail;

/**
 已下载的视频 NSURL
 
 @return NSURL
 */
- (NSURL *)downloadFilePath;

/**
 重置开始播放时间
 
 @return
 */
- (NSInteger)resetPlayTime:(HKPermissionVideoModel *)model;


/**
 
 显示无 VIP 提示label
 
 @param model 权限
 */
- (void)showPlayerVipTipLbWithModel:(HKPermissionVideoModel *)model;


/**
 播放时 移动流量 提醒
 
 @param sure (确定按钮 回调)
 
 @param cancelAction (取消按钮 回调)
 
 */

- (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction;


/**
 显示 VIP购买 视频分享view
 */
- (void)showBuyVipShareView;

/**
 移除 VIP购买 视频分享view
 */
- (void)removeBuyVipShareView;

/**
 更新 VIP 购买 收藏 视图约束
 */
- (void)remakeBuyVipShareViewConstraints;


/** 强制设置竖屏 */
- (void)setPlayerPortrait;


/** 素材下载提示  显示后 自动消失 */
- (void)showMaterialTipView;


/**
 记录播放进度
 *  @param currentTime
 *  @param videoId
 *  @param totalTime
 */

- (void)recordVideoProgress:(NSInteger)currentTime  videoId:(NSString*)videoId  totalTime:(NSInteger)totalTime;


/**
 播放时长 进度 统计
 */
- (void)recordPlayTimeAndVideoProgress;

/**
 进度 统计
 */
- (void)recordVideoProgress;



/** 计算 时间 字符串 宽度 */
- (float)timeWordWidth;


/** 到计时提示 播放下一节视频 */
- (void)showNextTimeTipView;

/** 播放完 推荐视频 */
- (void)showSimilarVideoView;

/** 屏幕方向变化 推荐视频显示 */
- (void)setDeviceChangeSimilarVideoView;

/** 软件入门 播放完了 弹窗 */
- (void)showPlayEndAchieveDialog;

- (void)airPlayButtonAction;

- (void)showAirPlayBtn:(BOOL)hidden;

- (void)removeViewplayerVipTipLB;

- (void)changeConnectAirPlay;

@end

NS_ASSUME_NONNULL_END

