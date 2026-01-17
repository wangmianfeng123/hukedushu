//
//  GKPlayer+Category.m
//  Code
//
//  Created by Ivan li on 2019/7/21.
//  Copyright © 2019 pg. All rights reserved.
//

#import "GKPlayer+Category.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HKBookModel.h"

@implementation GKPlayer (Category)



#pragma mark - 锁屏界面开启和监控远程控制事件
- (void)setRemoteCommandCenter {
    
//    if (!self.isHKBookAudio) {
//        return;
//    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    // 锁屏播放
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        NSLog(@"1 ======= %d",self.isPlaying);
        if (!self.isPlaying && self.player) {
            [self play];
        }        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 锁屏暂停
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//        NSLog(@"2 ======= %d",self.isPlaying);

        if (self.isPlaying && self.player) {
            [self pause];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.stopCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"3");
//        NSLog(@"3 ======= %d",self.isPlaying);
        if (self.player) {
            [self stop];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 喜欢按钮
    MPFeedbackCommand *likeCommand = commandCenter.likeCommand;
    likeCommand.enabled = NO;
    [likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"4");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 上一首
    MPFeedbackCommand *dislikeCommand = commandCenter.dislikeCommand;
    dislikeCommand.enabled = NO;
    dislikeCommand.localizedTitle = @" ";
    [dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"5");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 播放和暂停按钮（耳机控制）
    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
    playPauseCommand.enabled = YES;
    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"6");
//        NSLog(@"4 ======= %d",self.isPlaying);
        if (self.player) {
            if (self.isPlaying) {
                [self pause];
            }else {
                [self play];
            }
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 上一曲
    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
    //previousCommand.enabled = NO;
    [previousCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"7");
        if (self.player) {
            [self playPreviousMedia];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 下一曲
    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
    //nextCommand.enabled = NO;
    [nextCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"8");
        if (self.player) {
            [self playNextMedia];
        }
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 快进
    MPRemoteCommand *forwardCommand = commandCenter.seekForwardCommand;
    forwardCommand.enabled = YES;
    [forwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"9");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 快退
    MPRemoteCommand *backwardCommand = commandCenter.seekBackwardCommand;
    backwardCommand.enabled = YES;
    [backwardCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        //showTipDialog(@"10");
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 拖动进度条
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
        [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
            [self seekToTime: playbackPositionEvent.positionTime  completionHandler:^(BOOL finished) {
            }];
            return MPRemoteCommandHandlerStatusSuccess;
        }];
    }
}


#pragma mark -- 关闭远程控制中心
- (void)closeRemoteCommandCenter {

//    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//    [commandCenter.pauseCommand removeTarget:self];
//    [commandCenter.playCommand removeTarget:self];
//    [commandCenter.previousTrackCommand removeTarget:self];
//    [commandCenter.nextTrackCommand removeTarget:self];
//    [commandCenter.changePlaybackPositionCommand removeTarget:self];
//    commandCenter = nil;
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}



#pragma mark -- 锁屏界面显示信息
- (void)setNowPlayingInfoCenter {
    
    if (!self.isHKBookAudio) {
        return;
    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 3. 设置展示的信息
    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
    
    if (self.isHKBookAudio) {
        playingInfo[MPMediaItemPropertyAlbumTitle] = self.bookModel.title;
        playingInfo[MPMediaItemPropertyTitle] = self.bookModel.course_title;
        playingInfo[MPMediaItemPropertyArtist]  = self.bookModel.author;
    }
    
    //锁屏图片
    //MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:self.lockScreenImage];
    //playingInfo[MPMediaItemPropertyArtwork] = artwork;
    
    // 当前播放的时间
    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:self.currentTime]; /// 1000];
    // 进度的速度
    playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0];
    // 总时间
    playingInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithFloat:self.totalTime ];/// 1000];
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 10.0) {
        if (self.totalTime >0) {
            float progress = self.currentTime/self.totalTime;
            playingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = [NSNumber numberWithFloat:progress];
        }
    }
    playingCenter.nowPlayingInfo = playingInfo;
}



#pragma mark - 统计播放时长
- (void)recordBookPlayTime {
    
    if (!self.isBookCanPlay) {
        // 试听课不记录时长
        return;
    }
    
    if (isEmpty(self.bookModel.book_id) || isEmpty(self.bookModel.course_id)) {
        return;
    }
    
    if (self.currentTime <=0) {
        return;
    }
    
    if (self.totalTime <=0) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.bookModel.book_id forKey:@"book_id"];
    [dict setValue:self.bookModel.course_id forKey:@"course_id"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.currentTime] forKey:@"play_degree_time"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.totalTime] forKey:@"full_time"];
    
    [HKHttpTool POST:BOOK_RECOED_PLAY_TIME parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            NSLog(@"BOOK_RECOED_PLAY_TIME");
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 统计播放时长
- (void)resetCurrentTimeAndRecordPlayTime {
    
    if (!self.isBookCanPlay) {
        // 试听课不记录时长
        return;
    }
    
    if (isEmpty(self.bookModel.book_id) || isEmpty(self.bookModel.course_id)) {
        return;
    }
    
    if (self.currentTime <=0) {
        return;
    }
    
    if (self.totalTime <=0) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.bookModel.book_id forKey:@"book_id"];
    [dict setValue:self.bookModel.course_id forKey:@"course_id"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.currentTime] forKey:@"play_degree_time"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)self.totalTime] forKey:@"full_time"];
    
    [self resetCurrentTime];
    [HKHttpTool POST:BOOK_RECOED_PLAY_TIME parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            NSLog(@"BOOK_RECOED_PLAY_TIME");
        }
    } failure:^(NSError *error) {
        
    }];
}


- (float)playerRecordRate {
    NSInteger index = [HKNSUserDefaults integerForKey:HKBookPlayRateIndex];
    float rate = 1;
    switch (index) {
        case 0: case 2:
            rate = 1;
            break;
        break;
        
        case 1:
            rate = 0.7;
        break;
        
        case 3:
            rate = 1.25;
        break;
        
        case 4:
            rate = 1.5;
        break;
        
        case 5:
            rate = 2.0;
        break;
        
    default:
        break;
    }
    return rate;
}


@end
