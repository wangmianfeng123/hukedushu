//
//  HKPlayerLocalRateTool.h
//  Code
//
//  Created by Ivan li on 2018/4/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKSeekTimeModel;

@interface HKPlayerLocalRateTool : NSObject

/**
 记录播放进度 到本地数据库
 
 @return
 */
+ (void)savePlayerCurrentTime:(NSInteger)currentTime
                    totalTime:(NSInteger)totalTime
                      videoId:(NSString*)videoId
                    videoType:(int)videoType
               isFromDownload:(BOOL)isFromDownload
                  detailModel:(DetailModel*)detailModel;


/**
 查询 本地 播放进度
 
 @return
 */
+ (HKSeekTimeModel*)querySeekModel:(DetailModel*)model;


/**
 视频 总时长 (分钟)

 @param model
 @return
 */
+ (NSInteger)videoTotalTime:(DetailModel*)model;



//直播课回看记录播放进度
+ (void)saveLivePlayerCurrentTime:(NSInteger)currentTime
                    totalTime:(NSInteger)totalTime
                      videoId:(NSString*)videoId;
@end
