//
//  HKDownloadCore.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//




/**
    1- 通过接口数据 获取到视频m3u8文件数据，解析m3u8文件数据，解析出ts 文件URL和 解密key, (m3u8解析 HKM3U8Parse.m)

    2- 获取到的ts URL 数组，开始ts 文件下，下载ts可能失败，失败了，则去下载下一个ts文件，记录下载失败的ts （ts 下载 HKDownloadCore.m）

    3- ts 数组遍历完后，再去下载 下载失败的ts. 如果重新下载 仍然失败，则重新请求 更新ts URL, 重新下载失败ts 文件 （ts URL 有过期时间           4小时，过期后则下载失败）

    4- ts全部下载完成，则 生成本地M3u8文件(createM3U8File) 和 生成 解密key文件，用于本地播放。
    
    5- 开启下一个正在等待下载的视频，
*/




#import <Foundation/Foundation.h>
#import "HKDownloadModel.h"
#import "HKDownloadDB.h"
#import "HKM3U8DownloadConfig.h"


@protocol HKDownloadCoreDelegate <NSObject>

@optional

/**
 开启某个视频下载

 @param model 视频下载对象
 */
- (void)beginDownload:(HKDownloadModel *)model;


/**
 某个视频的下载详情进展

 @param model 视频下载对象
 @param progress 进度
 */
- (void)download:(HKDownloadModel *)model progress:(NSProgress *)progress;


/**
 某个视频下载失败

 @param model 失败的视频下载对象
 */
- (void)didFailedDownload:(HKDownloadModel *)model;


/**
 某个视频下载完成

 @param model 完成的视频对象
 */
- (void)didFinishedDownload:(HKDownloadModel *)model;


/**
 完成了某个切片下载

 @param downloadModel 下载的视频
 @param segmentModel 完成的切片
 */
- (void)didFinishModel:(HKDownloadModel *)downloadModel Segment:(HKSegmentModel *)segmentModel;

@end


typedef void(^BNM3U8DownloadOperationResultBlock)( NSError * _Nullable error, NSString * _Nullable relativeUrl);
typedef void(^BNM3U8DownloadOperationProgressBlock)(CGFloat progress);


@interface HKDownloadCore : NSOperation


@property (nonatomic, weak)id<HKDownloadCoreDelegate> delegate;

@property (nonatomic, assign) BOOL suspend;

- (instancetype)initWithConfig:(HKM3U8DownloadConfig *)config downloadDstRootPath:(NSString *)path sessionManager:(AFURLSessionManager *)sessionManager progressBlock:(BNM3U8DownloadOperationProgressBlock)progressBlock resultBlock:(BNM3U8DownloadOperationResultBlock)resultBlock downloadModel:(HKDownloadModel *)downloadModel;

@end


