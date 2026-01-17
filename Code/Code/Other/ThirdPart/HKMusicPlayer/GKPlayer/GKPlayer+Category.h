//
//  GKPlayer+Category.h
//  Code
//
//  Created by Ivan li on 2019/7/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "GKPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface GKPlayer (Category)

/**
 锁屏界面开启和监控远程控制事件
 */
- (void)setRemoteCommandCenter;

/**
 关闭远程控制中心
 */
- (void)closeRemoteCommandCenter;

/**
 锁屏界面显示信息
 */
- (void)setNowPlayingInfoCenter;

/**
 统计播放时长
 */
- (void)recordBookPlayTime;

#pragma mark - 统计播放时长
- (void)resetCurrentTimeAndRecordPlayTime;


- (float)playerRecordRate;

@end

NS_ASSUME_NONNULL_END


