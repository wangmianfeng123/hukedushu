//
//  HKDownloadDB.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/18.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "HKDownloadDB.h"


static JQFMDB *_db;

static HKDownloadDB *_instance;

@implementation HKDownloadDB

+ (instancetype)shareInstance
{
    // 保证只有一条线程获取实例对象
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HKDownloadDB alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        // 这里执行创建数据库,以后的shareDatabase系列都属于获取当前的数据库引用
        JQFMDB *db = [JQFMDB shareDatabase:@"HKDownload.sqlite" path:path];
        
        // 创建表格
        if (![db jq_isExistTable:NSStringFromClass([HKDownloadModel class])]) {
            [db jq_createTable:NSStringFromClass([HKDownloadModel class]) dicOrModel:[HKDownloadModel class]];
        }
        
        if (![db jq_isExistTable:NSStringFromClass([HKSegmentModel class])]) {
            [db jq_createTable:NSStringFromClass([HKSegmentModel class]) dicOrModel:[HKSegmentModel class]];
        }
        
        // 记忆播放表格
        if (![db jq_isExistTable:NSStringFromClass([HKSeekTimeModel class])]) {
            [db jq_createTable:NSStringFromClass([HKSeekTimeModel class]) dicOrModel:[HKSeekTimeModel class]];
        }
        
        // 更新数据库的字段
        [db jq_alterTable:NSStringFromClass([HKDownloadModel class]) dicOrModel:[HKDownloadModel class]];
        [db jq_alterTable:NSStringFromClass([HKSegmentModel class]) dicOrModel:[HKSegmentModel class]];
        [db jq_alterTable:NSStringFromClass([HKSeekTimeModel class]) dicOrModel:[HKSeekTimeModel class]];
        
        // 获取更新后的新字段(置空即可)
        db.tableDic[@"HKDownloadModel"] = nil;
        db.tableDic[@"HKSegmentModel"] = nil;
        db.tableDic[@"HKSeekTimeModel"] = nil;
        
        _db = db;
    }
    return self;
}


#pragma 删除model
- (void)didDeletedDownload:(HKDownloadModel *)model delete:(void (^)(BOOL, HKDownloadModel *))deletModelBlock {
    
    [_db jq_inDatabase:^{
        [_db jq_deleteTable:@"HKDownloadModel" whereFormat:@"WHERE userID = '%@' and videoId = '%@' and videoType = %d", [HKAccountTool shareAccount].ID, model.videoId, model.videoType];
        
        // 1.6 segements不同路径
        if (!model.saveInCache) {
            [_db jq_deleteTable:@"HKSegmentModel" whereFormat:@"WHERE videoId = '%@' and videoType = %d", model.videoId, model.videoType];
        }
        deletModelBlock(YES, model);
    }];
}

- (void)didDeletedDirect:(HKDownloadModel *)model delete:(void (^)(BOOL, HKDownloadModel *))deletModelBlock {
    
    [_db jq_inDatabase:^{
        [_db jq_deleteTable:@"HKDownloadModel" whereFormat:@"WHERE userID = '%@' and dir_id = '%@' and videoType = %d", [HKAccountTool shareAccount].ID, model.dir_id, model.videoType];
        
        // 发通知
//        deletModelBlock(YES, model);
    }];
}


- (BOOL)savedownloadModel:(HKDownloadModel *)model dicOrModel:(id)dicOrModel{
    
    // 先查询
    if (model.videoId.length) {
        
        [_db jq_inDatabase:^{
            HKDownloadModel *tempModel = [[_db jq_lookupTable:@"HKDownloadModel" dicOrModel:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and videoId = '%@' and videoType = %d", model.userID.length? model.userID : [HKAccountTool shareAccount].ID,  model.videoId, model.videoType]] lastObject];
            
            
            NSArray *segments = [_db jq_lookupTable:@"HKSegmentModel" dicOrModel:[HKSegmentModel class] whereFormat:[NSString stringWithFormat:@"WHERE videoId = '%@' and videoType = %d",  model.videoId, model.videoType]];
            
            // 新增
            if (!tempModel) { //数据库中未存储该视频
                //插入一条数据
                [_db jq_insertTable:@"HKDownloadModel" dicOrModel:model];
                [_db jq_insertTable:@"HKSegmentModel" dicOrModelArray:model.segments];
                
            } else if (tempModel && !segments.count && dicOrModel == nil) {
                
                //数据库中已经存在该视频 但是没有segments
                [_db jq_insertTable:@"HKSegmentModel" dicOrModelArray:model.segments];
                //更新数据
                [_db jq_updateTable:@"HKDownloadModel" dicOrModel:@{@"totalDurations" : @(model.totalDurations)} whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and videoId = '%@' and videoType = %d", model.userID.length? model.userID : [HKAccountTool shareAccount].ID, model.videoId, model.videoType]];
            }else if (dicOrModel && tempModel) {
                
                //更新数据
                [_db jq_updateTable:@"HKDownloadModel" dicOrModel:dicOrModel whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and videoId = '%@' and videoType = %d", model.userID.length? model.userID : [HKAccountTool shareAccount].ID, model.videoId, model.videoType]];
            }
        }];
    }
    return YES;
}

- (void)saveModelArray:(NSArray<HKDownloadModel *> *)array block:(void(^)())saveBlock {
    [_db jq_inDatabase:^{
        [_db jq_insertTable:@"HKDownloadModel" dicOrModelArray:array];
        !saveBlock? : saveBlock();
    }];
}

- (void)updateDirectoryModel:(HKDownloadModel *)model param:(id)dicOrModel {
    
    if (!model.dir_id.length) return;
    
    [_db jq_inDatabase:^{
        //更新数据
        [_db jq_updateTable:@"HKDownloadModel" dicOrModel:dicOrModel whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and dir_id = '%@' and videoType = %d", model.userID.length? model.userID : [HKAccountTool shareAccount].ID, model.dir_id, model.videoType]];
    }];
    
    
}


- (BOOL)saveDirectoryModel:(HKDownloadModel *)model {
    
    __block BOOL success = NO;
    
    // 先查询
    if (model.dir_id.length) {
        
        [_db jq_inDatabase:^{
            
            HKDownloadModel *tempModel = [[_db jq_lookupTable:@"HKDownloadModel" dicOrModel:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and dir_id = '%@' and videoType = %d", model.userID.length? model.userID : [HKAccountTool shareAccount].ID,  model.dir_id, model.videoType]] lastObject];
            
            success = YES;
            // 新增
            if (!tempModel) {
                //插入一条数据
                success = [_db jq_insertTable:@"HKDownloadModel" dicOrModel:model];
            } else if (tempModel && ![tempModel.responseDicData isEqualToData:model.responseDicData] ) {
                
                // 更新data
                [_db jq_updateTable:@"HKDownloadModel" dicOrModel:model whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and dir_id = '%@' and videoType = %d", model.userID.length? model.userID : [HKAccountTool shareAccount].ID,  model.dir_id, model.videoType]];
            }
        }];
    } else {
        success = NO;
    }
    return success;
}

- (BOOL)saveOrUpdateSeekModel:(HKSeekTimeModel *)model{
    
    __block BOOL success = NO;
    
    // 先查询
    if (model.videoId.length) {
        
        [_db jq_inDatabase:^{
            
            HKSeekTimeModel *tempModel = [[_db jq_lookupTable:@"HKSeekTimeModel" dicOrModel:[HKSeekTimeModel class] whereFormat:[NSString stringWithFormat:@"WHERE userId = '%@' and videoId = '%@' and videoType = %d", model.userId.length? model.userId : [HKAccountTool shareAccount].ID,  model.videoId, model.videoType]] lastObject];
            
            success = YES;
            // 新增
            if (!tempModel) {
                //插入一条数据
                model.userId = model.userId.length? model.userId : [HKAccountTool shareAccount].ID;
                success = [_db jq_insertTable:@"HKSeekTimeModel" dicOrModel:model];
            } else {
                // 更新data
                [_db jq_updateTable:@"HKSeekTimeModel" dicOrModel:model whereFormat:[NSString stringWithFormat:@"WHERE userId = '%@' and videoId = '%@' and videoType = %d", model.userId.length? model.userId : [HKAccountTool shareAccount].ID,  model.videoId, model.videoType]];
            }
        }];
    } else {
        success = NO;
    }
    return success;
}

- (NSArray *)query:(NSString *)table Clazz:(Class)clazz whereFormat:(NSString *)format {
    
    __block NSArray *tempArray = nil;
    __block BOOL isExcuteCorrect = NO;
    
    // 没有登录状态直接返回nil
    if (![HKAccountTool shareAccount]) {
        return nil;
    }
    
    // 添加用户id
    if (format == nil) {
        format = [NSString stringWithFormat:@"where userID = '%@'", [HKAccountTool shareAccount].ID];
    }
    
    [_db jq_inDatabase:^{
        tempArray = [_db jq_lookupTable:table dicOrModel:clazz whereFormat:format];
        isExcuteCorrect = YES;
    }];
    
    if (!isExcuteCorrect) {
        NSLog(@"11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
        showTipDialog(@"执行不正常");
    }
    
    return tempArray;
}


- (HKSeekTimeModel *)querySeekModel:(HKSeekTimeModel *)model {
    HKSeekTimeModel *tempModel = [[_db jq_lookupTable:@"HKSeekTimeModel" dicOrModel:[HKSeekTimeModel class] whereFormat:[NSString stringWithFormat:@"WHERE userId = '%@' and videoId = '%@' and videoType = %d", model.userId.length? model.userId : [HKAccountTool shareAccount].ID,  model.videoId, model.videoType]] lastObject];
    return tempModel;
}


- (BOOL)saveSegmentModel:(HKSegmentModel *)model dicOrModel:(id)dicOrModel {
    
    [_db jq_inDatabase:^{
        // 新增数据
        if (!dicOrModel) {
            [_db jq_insertTable:@"HKSegmentModel" dicOrModel:model];
        } else {
            
            // 先查询
            HKDownloadModel *tempModel = [[_db jq_lookupTable:@"HKSegmentModel" dicOrModel:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE indexSegment = '%d' and videoId = '%@' and videoType = %d", model.indexSegment, model.videoId, model.videoType]] lastObject];
            
            // 新增
            if (!tempModel) {
                //插入一条数据
                [_db jq_insertTable:@"HKSegmentModel" dicOrModel:model];
            } else {
                //更新数据
                [_db jq_updateTable:@"HKSegmentModel" dicOrModel:dicOrModel whereFormat:[NSString stringWithFormat:@"WHERE indexSegment = '%d' and videoId = '%@' and videoType = %d", model.indexSegment, model.videoId, model.videoType]];
            }
        }
    }];
    return YES;
}

- (BOOL)segmentDownloadFinsh:(HKSegmentModel *)segment {
    
    [_db jq_inDatabase:^{
        
        // 更新百分比
        HKDownloadModel *downloadModel = [[_db jq_lookupTable:@"HKDownloadModel" dicOrModel:[HKDownloadModel class] whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and videoId = '%@' and videoType = %d", [HKAccountTool shareAccount].ID, segment.videoId, segment.videoType]] lastObject];
        
        float currentPersent = downloadModel.downloadPercent + segment.duration / (downloadModel.totalDurations * 1.0);
        downloadModel.downloadPercent = currentPersent;
        
        if (downloadModel.downloadPercent >= 0.9999) {
            downloadModel.downloadPercent = 0.999;
        }
        
        [_db jq_updateTable:@"HKDownloadModel" dicOrModel:@{@"downloadPercent" : @(downloadModel.downloadPercent), @"isFinish" : @(downloadModel.isFinish)} whereFormat:[NSString stringWithFormat:@"WHERE userID = '%@' and videoId = '%@'  and videoType = %d", [HKAccountTool shareAccount].ID, downloadModel.videoId, downloadModel.videoType]];
        
        [_db jq_updateTable:@"HKSegmentModel" dicOrModel:@{@"isFinish" : @YES} whereFormat:[NSString stringWithFormat:@"WHERE indexSegment = '%d' and videoId = '%@'  and videoType = %d",  segment.indexSegment, segment.videoId, segment.videoType]];
    }];
    
    return YES;
}

@end

