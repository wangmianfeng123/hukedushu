//
//  HKDownloadDB.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JQFMDB.h"
#import "HKDownloadModel.h"
#import "HKSegmentModel.h"
#import "HKSeekTimeModel.h"


@interface HKDownloadDB : NSObject

+ (instancetype)shareInstance;


/**
 删除视频对象在数据库中的记录

 @param model 视频对象
 @param deletModelBlock 删除成功的回调
 */
- (void)didDeletedDownload:(HKDownloadModel *)model delete:(void (^)(BOOL, HKDownloadModel *))deletModelBlock;


/**
 删除总目录对象在数据库中的记录

 @param model 目录对象
 @param deletModelBlock 删除成功的回调
 */
- (void)didDeletedDirect:(HKDownloadModel *)model delete:(void (^)(BOOL, HKDownloadModel *))deletModelBlock;


/**
 某视频某个切片下载完成

 @param segment 切片对象
 @return 是否成功
 */
- (BOOL)segmentDownloadFinsh:(HKSegmentModel *)segment;


/**
 保存或者更新视频对象在数据库中的记录

 @param model 视频对象
 @param dicOrModel 更新的键值对
 @return 是否成功
 */
- (BOOL)savedownloadModel:(HKDownloadModel *)model dicOrModel:(id)dicOrModel;


/**
 保存更新切片信息

 @param model 切片信息
 @param dicOrModel 更新的键值
 @return 是否保存成功
 */
- (BOOL)saveSegmentModel:(HKSegmentModel *)model dicOrModel:(id)dicOrModel;


/**
 查询数据库表信息，比如全部视频记录的信息

 @param table 表名
 @param clazz 表对应的类名
 @param format 查询语句
 @return 封装表数据返回的对象数组
 */
- (NSArray *)query:(NSString *)table Clazz:(Class)clazz whereFormat:(NSString *)format;



/**
 批量保存视频对象到数据库中

 @param array 视频组数据
 @param saveBlock 保存成功回调
 */
- (void)saveModelArray:(NSArray<HKDownloadModel *> *)array block:(void(^)())saveBlock;


/**
 保存目录到数据库中

 @param model 目录对象
 @return 是否保存成功
 */
- (BOOL)saveDirectoryModel:(HKDownloadModel *)model;


/**
 更新目录

 @param model 目录对象
 @param dicOrModel 更新的键值对
 */
- (void)updateDirectoryModel:(HKDownloadModel *)model param:(id)dicOrModel;


/**
 保存或更新记忆播放

 @param model 视频对象
 @return 是否保存成功
 */
- (BOOL)saveOrUpdateSeekModel:(HKSeekTimeModel *)model;


/**
 查询记忆播放

 @param model 视频对象
 @return 记忆播放对象
 */
- (HKSeekTimeModel *)querySeekModel:(HKSeekTimeModel *)model;

@end
