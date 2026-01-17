//
//  HKM3U8Parse.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HKDownloadModel.h"
#import "HKSegmentModel.h"

@class HKM3U8Parse;
@protocol HKM3U8ParseDelegate <NSObject>


/**
 解析M3U8连接失败

 @param Parser 解析失败后的对象
 */
-(void)praseM3U8Finished:(HKM3U8Parse *)Parser;


/**
 解析M3U8成功

 @param Parser 解析成功的对象
 @param list 解析完成的视频对象
 */
-(void)praseM3U8Failed:(HKM3U8Parse *)Parser segmentList:(HKDownloadModel *)list;


@end



@interface HKM3U8Parse : NSObject


/**
 根据videoUrl获取m3u8文件并且解析

 @param videoUrl 视频的videoUrl
 @param error 出错
 @param videoID videoID
 @param videoType videoType
 
 @param chapter_id 职业路径
 @param section_id
 @param career_id
 
 @return 视频对象
 */
//- (HKDownloadModel *)analyseVideoUrl:(NSString *)videoUrl error:(NSError **)error videoID:(NSString *)videoID videoType:(int)videoType;
- (HKDownloadModel *)analyseVideoUrl:(NSString *)videoUrl
                               error:(NSError **)error
                             videoID:(NSString *)videoID
                           videoType:(int)videoType
                          chapter_id:(NSString *)chapter_id
                          section_id:(NSString *)section_id
                           career_id:(NSString *)career_id;


/**
 下载完成后生成对应的m3u8文件，用于离线播放

 @param videoUrl videoUrl
 @param videoType videoType
 @param segmentList 下载视频的切片对象
 @param createM3U8FileBlock 生成文件之后的block
 */
+ (void)createM3U8File:(NSString*)videoUrl videoType:(int)videoType  segmentList:(HKDownloadModel *)segmentList finish:(void(^)(BOOL))createM3U8FileBlock;

@end

