//
//  DownloadCacher.h
//  DownLoader
//
//  Created by bfec on 17/2/15.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModel.h"
#import "FMDB.h"





@interface DownloadCacher : NSObject

@property (nonatomic,strong) FMDatabaseQueue *dbQueue;

+ (id)shareInstance;
- (DownloadStatus)queryDownloadStatusByModel:(DownloadModel *)downloadModel;
- (BOOL)insertDownloadModel:(DownloadModel *)downloadModel;
- (void)updateDownloadModel:(DownloadModel *)downloadModel;
- (void)deleteDownloadModel:(DownloadModel *)downloadModel;
- (void)deleteDownloadModels:(NSArray *)downloadModels;
- (DownloadModel *)queryTopWaitingDownloadModel;
- (void)getNewFromCacherWithModel:(DownloadModel *)downloadModel;
- (NSArray *)startAllDownloadModels;
- (NSArray *)pauseAllDownloadModels;
- (void)initializeDownloadModelFromDBCahcher:(DownloadModel *)downloadModel;
- (BOOL)checkIsExistDownloading;

//add yang
#pragma mark - 查询全部的下载条目
- (NSMutableArray *)selectAllDownloadModels;

#pragma mark - 查询全部的下载完成条目
- (NSMutableArray *)selectfinishedDownloadModels;

#pragma mark - 查询全部 未下载 完成的条目
- (NSMutableArray *)selectNoDownloadModels;

#pragma mark - 查询是否在下载列表中存在
- (BOOL)checkIsExistDownloadWithUrl:(NSString *)url;

#pragma mark - 查询视频状态
- (DownloadStatus)queryDownloadStatusByVideoModel:(VideoModel *)videoModel;

#pragma mark - 查询视频状态
- (DownloadStatus)queryDownloadStatusByVideoUrl:(NSString *)videoUrl;

- (void)tb_closeDB;


@end

