//
//  StudyVedioRecord.h
//  Code
//
//  Created by Ivan li on 2017/8/14.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


@class DownloadModel;
@class DetailModel;
@class VideoModel;

@interface StudyVedioRecord : NSObject

@property (nonatomic,strong) FMDatabaseQueue *dbQueue;

+ (id)shareInstance;

#pragma mark - 插入观看记录
- (BOOL)insertDownloadModel:(DownloadModel *)downloadModel;
- (BOOL)insertHistoryByDetailModel:(DetailModel *)detailModel;
- (BOOL)insertHistoryByVideoModel:(VideoModel *)detailModel;

- (NSMutableArray *)selectAllDownloadModels;

@end
