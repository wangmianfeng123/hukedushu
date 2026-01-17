//
//  ZFHKNormalAVPlayerManager+Category.h
//  Code
//
//  Created by Ivan li on 2019/8/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "ZFHKNormalAVPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFHKNormalAVPlayerManager (Category)

#pragma mark - 锁屏界面开启和监控远程控制事件
- (void)setNormalAVPlayerRemoteCommandCenter;

#pragma mark -- 关闭远程控制中心
- (void)closeNormalAVPlayerRemoteCommandCenter;

#pragma mark -- 锁屏界面显示信息
- (void)setNormalAVPlayerNowPlayingInfoCenter;

@end

NS_ASSUME_NONNULL_END
