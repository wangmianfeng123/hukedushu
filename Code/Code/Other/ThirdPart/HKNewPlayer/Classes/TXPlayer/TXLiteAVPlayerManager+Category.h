//
//  TXLiteAVPlayerManager+Category.h
//  Code
//
//  Created by eon Z on 2021/11/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import "TXLiteAVPlayerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXLiteAVPlayerManager (Category)
#pragma mark - 锁屏界面开启和监控远程控制事件
- (void)setNormalAVPlayerRemoteCommandCenter;

#pragma mark -- 关闭远程控制中心
- (void)closeNormalAVPlayerRemoteCommandCenter;

#pragma mark -- 锁屏界面显示信息
- (void)setNormalAVPlayerNowPlayingInfoCenter;
@end

NS_ASSUME_NONNULL_END
