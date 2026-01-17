//
//  TXLiteAVPlayerManager.h
//  Code
//
//  Created by ivan on 2020/7/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFHKNormalPlayerMediaPlayback.h"
#import "ZFPlayerMediaPlayback.h"
#import <TXLiteAVSDK_Player/TXLiteAVSDK.h>
#import <SuperPlayer/SuperPlayer.h>
#import <SuperPlayer/SuperPlayerModelInternal.h>
#import <SuperPlayer/TXBitrateItemHelper.h>

@interface TXLiteAVPlayerManager : NSObject <ZFHKNormalPlayerMediaPlayback,ZFPlayerMediaPlayback>

/** Yes GPRS 流量播放 受限 (普通会员视频)   */
@property (nonatomic,assign)BOOL  isNoGPRSPlayVideo;

/** Yes GPRS 流量播放 受限  (短视频)  */
@property (nonatomic,assign)BOOL  isNoGPRSPlayShortVideo;

/** Yes 播放开始暂停 读书，NO 不暂停  */
@property (nonatomic,assign)BOOL  isPauseHkAudio;

@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;

@property (nonatomic, strong) TXVodPlayer  *vodPlayer;

@end


