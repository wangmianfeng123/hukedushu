//
//  TXLiteAVPlayerManager+Category.m
//  Code
//
//  Created by eon Z on 2021/11/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import "TXLiteAVPlayerManager+Category.h"

@implementation TXLiteAVPlayerManager (Category)

#pragma mark - 锁屏界面开启和监控远程控制事件
- (void)setNormalAVPlayerRemoteCommandCenter {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    // 播放
    WeakSelf
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        NSLog(@"MPRemoteCommandCenter  ======= playCommand");
         if (state == UIApplicationStateActive){
             NSLog(@"1 ======= %d",weakSelf.isPlaying);
             if (!weakSelf.isPlaying && weakSelf.vodPlayer) {
                 [weakSelf play];
             }
         }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 暂停
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        NSLog(@"MPRemoteCommandCenter  ======= pauseCommand");
        if (state == UIApplicationStateActive){
            NSLog(@"2 ======= %d",weakSelf.isPlaying);
            if (weakSelf.isPlaying && weakSelf.vodPlayer) {
                [weakSelf pause];
            }
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
        
    // 播放和暂停按钮（耳机控制）
    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
    playPauseCommand.enabled = YES;
    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        NSLog(@"MPRemoteCommandCenter  ======= togglePlayPauseCommand");
        if (state == UIApplicationStateActive){
//            showTipDialog(@"3");
            if (weakSelf.vodPlayer) {
                if (weakSelf.isPlaying) {
                    [weakSelf pause];
                }else {
                    [weakSelf play];
                }
            }
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    
    
    
    //快进
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= nextTrackCommand");
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateActive && weakSelf.vodPlayer){
            
            CGFloat currentPlayTime = weakSelf.vodPlayer.currentPlaybackTime;
            NSLog(@"播放视频当前时间：%f",currentPlayTime);
            if (currentPlayTime + 5 < weakSelf.vodPlayer.duration) {
                NSLog(@"播放视频快进当前时间：%f",currentPlayTime + 5);
                [weakSelf.vodPlayer seek:currentPlayTime + 5];
            }
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //快退
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= previousTrackCommand");
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateActive && weakSelf.vodPlayer){
            CGFloat currentPlayTime = weakSelf.vodPlayer.currentPlaybackTime;
            NSLog(@"播放视频当前时间：%f",currentPlayTime);
            if (  currentPlayTime > 5 && (currentPlayTime - 5 < weakSelf.vodPlayer.duration)) {
                NSLog(@"播放视频快退当前时间：%f",currentPlayTime - 5);
                [weakSelf.vodPlayer seek:currentPlayTime - 5];
            }
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.skipForwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= skipForwardCommand");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.skipBackwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= skipBackwardCommand");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.seekForwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= seekForwardCommand");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
        
    [commandCenter.seekBackwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= seekBackwardCommand");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.skipBackwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= skipBackwardCommand");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    [commandCenter.skipBackwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"MPRemoteCommandCenter  ======= skipBackwardCommand");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}


#pragma mark -- 关闭远程控制中心
- (void)closeNormalAVPlayerRemoteCommandCenter {
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.pauseCommand removeTarget:self];
    [commandCenter.playCommand removeTarget:self];
    [commandCenter.togglePlayPauseCommand removeTarget:self];
    commandCenter = nil;
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"MPRemoteCommandCenter  ======= receivedEvent : %ld",(long)receivedEvent.type);
}

#pragma mark -- 锁屏界面显示信息
- (void)setNormalAVPlayerNowPlayingInfoCenter {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 3. 设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
    playingInfo[MPMediaItemPropertyAlbumTitle] = self.videoDetailModel.video_titel;
    playingInfo[MPMediaItemPropertyArtist]  = self.videoDetailModel.teacher_info.username;
    playingInfo[MPMediaItemPropertyTitle] = self.videoDetailModel.class_name;
    
    //锁屏图片
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:(self.videoDetailModel.cover_image) ?self.videoDetailModel.cover_image : HK_PlaceholderImage];
    playingInfo[MPMediaItemPropertyArtwork] = artwork;
    // 当前播放的时间
    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:self.currentTime];
    // 进度的速度
    playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0];
    // 总时间
    playingInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithFloat:self.totalTime ];
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
        if (self.totalTime >0) {
            float progress = self.currentTime/self.totalTime;
            playingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = [NSNumber numberWithFloat:progress];
        }
    }
    playingCenter.nowPlayingInfo = playingInfo;

}

@end
