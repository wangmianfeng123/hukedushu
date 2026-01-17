//
//  ZFHKNormalAVPlayerManager+Category.m
//  Code
//
//  Created by Ivan li on 2019/8/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "ZFHKNormalAVPlayerManager+Category.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation ZFHKNormalAVPlayerManager (Category)



#pragma mark - 锁屏界面开启和监控远程控制事件
- (void)setNormalAVPlayerRemoteCommandCenter {
    
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//
//    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//    // 锁屏播放
//    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        if (!self.isPlaying) {
//            [self play];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    // 锁屏暂停
//    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        if (self.isPlaying) {
//            [self pause];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    [commandCenter.stopCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        [self stop];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 喜欢按钮
//    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
//    likeCommand.enabled        = NO;
//    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 上一首
//    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
//    dislikeCommand.enabled = NO;
//    dislikeCommand.localizedTitle = @" ";
//    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 播放和暂停按钮（耳机控制）
//    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
//    playPauseCommand.enabled = YES;
//    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        if (self.isPlaying) {
//            [self pause];
//        }else {
//            [self play];
//        }
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 上一曲
//    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
//    previousCommand.enabled = NO;
//    [previousCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 下一曲
//    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
//    nextCommand.enabled = NO;
//    [nextCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 快进
//    MPRemoteCommand *forwardCommand = commandCenter.seekForwardCommand;
//    forwardCommand.enabled = YES;
//    [forwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 快退
//    MPRemoteCommand *backwardCommand = commandCenter.seekBackwardCommand;
//    backwardCommand.enabled = YES;
//    [backwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
    
    
}


#pragma mark -- 关闭远程控制中心
- (void)closeNormalAVPlayerRemoteCommandCenter {
//    
//    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//    [commandCenter.pauseCommand removeTarget:self];
//    [commandCenter.stopCommand removeTarget:self];
//    [commandCenter.playCommand removeTarget:self];
//    [commandCenter.previousTrackCommand removeTarget:self];
//    [commandCenter.nextTrackCommand removeTarget:self];
//    [commandCenter.changePlaybackPositionCommand removeTarget:self];
//    [commandCenter.togglePlayPauseCommand removeTarget:self];
//    commandCenter = nil;
//    
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
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
