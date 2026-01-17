//
//  HKPlayBackPlayerControlView+Category.m
//  Code
//
//  Created by eon Z on 2021/12/24.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPlayBackPlayerControlView+Category.h"
#import "ZFHNomalCustom.h"

@implementation HKPlayBackPlayerControlView (Category)
/**
 @return Yes 已下载
 */
- (BOOL)isDownloadFinsh:(HKPermissionVideoModel *)detailModel {
    
    if (isEmpty(detailModel.videoId)) {
        return NO;
    }
    HKDownloadModel *model = [[HKDownloadManager shareInstance] queryWidthID:detailModel.videoId videoType:[detailModel.video_type intValue]];
    self.downloadModel = model;
    if (HKDownloadFinished == model.status) {
        return YES;
    }
    return NO;
}

/**
 已下载的视频 NSURL
 
 @return NSURL
 */
- (NSURL *)downloadFilePath {
    
    if (self.downloadFinsh) {
        // 1.6前的cache文件 存放在缓存文件下，存储不够时 视频会被清除
        //if (self.downloadModel.saveInCache)
        
        // 1.7 document文件
        NSString *videoId = self.permissionModel.videoId;
        int videoType = [self.permissionModel.video_type intValue];
        
        NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:12345/download/%@/movie.m3u8",videoId];
        // 1.8版本
        BOOL isDirectory1_7 = NO;
        BOOL exist1_7 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/download/%@/movie.m3u8",HKDocumentPath, videoId] isDirectory:&isDirectory1_7];
        if (!exist1_7) {
            url = [NSString stringWithFormat:@"http://127.0.0.1:12345/download/%@_%d/movie.m3u8",videoId, videoType];
        }
        return [NSURL URLWithString:url];
    }
    return nil;
}

/**
 开启本地服务
 */
- (void)startLocalServer:(void(^)())sucess fail:(void(^)())fail {
    
    // 1.6前的cache文件 存放在缓存文件下，存储不够时 视频会被清除
    //if (model.saveInCache) {webPath =  kLibraryCache}
    
    [self stopLocalServer];
    // 设置服务器路径
    [self.httpServer setDocumentRoot:HKDocumentPath];
    NSError *err = nil;
    if ([self.httpServer start:&err]) {
        NSLog(@"开启HTTP服务器 端口:%hu",[self.httpServer listeningPort]);
        sucess();
    }else{
        fail();
    }
}


/**
 终止本地服务
 */
- (void)stopLocalServer {
    if ([self.httpServer isRunning]) {
        [self.httpServer stop:YES];
    }
}

/**
 重置开始播放时间
 @return
 */
- (NSInteger)resetPlayTime:(HKPermissionVideoModel *)model {
    
    NSInteger second = 0;
    NSString *date = [DateChange DateFromNetWorkString:model.play_time.updated_at];
    
    DetailModel * detailmodel = [DetailModel new];
    detailmodel.video_id = model.videoId;
    detailmodel.video_type = @"999";
    //本地时间记录
    HKSeekTimeModel *seekTimeM = [HKPlayerLocalRateTool querySeekModel:detailmodel];
    if (!seekTimeM) {
        second = model.play_time.time;
    }else{
        int day = [DateChange compareDate:seekTimeM.seekTimeUpdate withDate:date];
        if (day>=0) {//date小于或者等于本地的时间
            // seekTimeUpdate 时间更近
            second = (seekTimeM == nil) ?0 :seekTimeM.seekTime;
        }else{
            second = model.play_time.time;
        }
    }
    
    self.playerSeekTime = second;
    return second;
}

#pragma mark - 记录播放进度
- (void)recordVideoProgress {
    //记录本地播放进度
    NSInteger currentTime = lround(self.player.currentTime);
    
    NSInteger totalTime = lround(self.player.totalTime);
    
    NSString *videoId = self.permissionModel.videoId;
    [HKPlayerLocalRateTool saveLivePlayerCurrentTime:currentTime totalTime:totalTime videoId:videoId];
    //记录播放进度到后台
    [self recordVideoProgress:currentTime videoId:videoId totalTime:totalTime];
}
   
#pragma mark - 记录播放进度
- (void)recordVideoProgress:(NSInteger)currentTime  videoId:(NSString*)videoId  totalTime:(NSInteger)totalTime{
    
    if (isEmpty(videoId)) {
        return;
    }
    
    //video_id   视频id    //video_time 学习的时长，单位:s   //is_end   是否观看完毕 0否 1是      //total_time  视频总时长，单位:s
    //if ((currentTime > 10) && 10 <(totalTime - currentTime)) {
    if ((currentTime > 10)) {
        // 10秒之内不记录
        BOOL isend = 0;
        if ((totalTime - currentTime)<= 15) {
            isend = 1;
        }else{
            isend = 0;
        }
        
        NSDictionary *dict = @{@"video_time":@(currentTime),@"video_id":videoId,@"total_time":@(totalTime),@"is_end":@(isend)};
        [HKHttpTool POST:VIDEO_SET_PLAY_VIDEO_TIME parameters:dict success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(NSError *error) {
            
        }];
    }
}

@end
