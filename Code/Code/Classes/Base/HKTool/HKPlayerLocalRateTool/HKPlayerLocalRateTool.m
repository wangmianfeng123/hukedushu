//
//  HKPlayerLocalRateTool.m
//  Code
//
//  Created by Ivan li on 2018/4/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayerLocalRateTool.h"
#import "HKDownloadModel.h"

#import "DetailModel.h"
#import "HKDownloadManager.h"


@implementation HKPlayerLocalRateTool


#pragma mark - 记录播放进度
+ (void)savePlayerCurrentTime:(NSInteger)currentTime
                    totalTime:(NSInteger)totalTime
                      videoId:(NSString*)videoId
                    videoType:(int)videoType
               isFromDownload:(BOOL)isFromDownload
                  detailModel:(DetailModel*)detailModel  {
    
    //(currentTime-3) 续播时间 减3秒
    if ((currentTime-3) <= 0) {
        
    }else{
        if (!isEmpty(videoId)) {
            HKSeekTimeModel *seekTimeModel = [[HKSeekTimeModel alloc] init];
            seekTimeModel.videoId = videoId;
            seekTimeModel.seekTimeUpdate = [DateChange getCurrentTime];
            // 无网络 已下载的视频 videoType 使用本地记录
            if (isFromDownload) {
                seekTimeModel.videoType = videoType;
            }else{
                seekTimeModel.videoType = [detailModel.video_type intValue];
            }
            if (currentTime > 10 && currentTime < (totalTime - 10)) {
                seekTimeModel.seekTime = currentTime -3;
            }else{
                seekTimeModel.seekTime = 0;
            }
            [[HKDownloadManager shareInstance] saveOrUpdateSeekModel:seekTimeModel];
        }
    }
}


#pragma mark - 查询 本地 播放进度
+ (HKSeekTimeModel*)querySeekModel:(DetailModel*)model  {
    
    if (isEmpty(model.video_id) || model == nil) {
        return nil;
    }
    HKSeekTimeModel *temp = [[HKSeekTimeModel alloc] init];
    temp.videoId = model.video_id;
    temp.videoType = model.video_type.length? [model.video_type intValue] : 0;
    
    HKSeekTimeModel *seekMode = [[HKDownloadManager shareInstance] querySeekModel:temp];
    return seekMode;
}



#pragma mark - 视频 总时长( 分钟)
+ (NSInteger)videoTotalTime:(DetailModel*)model {
    
    NSString *str = model.video_duration;
    if (!isEmpty(str)) {
        if ([str hasSuffix:@"分钟"]) {
            NSRange range = [str rangeOfString:@"分钟"];
            if (range.location != NSNotFound) {
                str = [str substringToIndex:range.location];
                NSInteger durMin = isEmpty(str)? 0 :[str intValue];//分钟
                return  durMin;
            }else{
                return  0;
            }
        }
    }
    return  0;
}

//HKPermissionVideoModel * permissionModel;
//直播课回看记录播放进度
+ (void)saveLivePlayerCurrentTime:(NSInteger)currentTime
                    totalTime:(NSInteger)totalTime
                      videoId:(NSString*)videoId{
    
    //(currentTime-3) 续播时间 减3秒
    if ((currentTime-3) <= 0) {
        
    }else{
        if (!isEmpty(videoId)) {
            HKSeekTimeModel *seekTimeModel = [[HKSeekTimeModel alloc] init];
            seekTimeModel.videoId = videoId;
            seekTimeModel.seekTimeUpdate = [DateChange getCurrentTime];
            // 无网络 已下载的视频 videoType 使用本地记录
            seekTimeModel.videoType = 999;
            if (currentTime > 10 && currentTime < (totalTime - 10)) {
                seekTimeModel.seekTime = currentTime;
            }else{
                seekTimeModel.seekTime = 0;
            }
            [[HKDownloadManager shareInstance] saveOrUpdateSeekModel:seekTimeModel];
        }
    }
}
@end
