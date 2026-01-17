//
//  DownloadCacher.m
//  DownLoader
//
//  Created by bfec on 17/2/15.
//  Copyright © 2017年 com. All rights reserved.
//

#import "DownloadCacher.h"
#import "DownloadCacher+M3U8.h"
#import "VideoModel.h"

static DownloadCacher *instance;
#define DBName @"downloadCacher.db"
#define DownloadCacherTable @"downloadCacherTable"


#define  createTableSql    @"create table if not exists %@ (id integer primary key autoincrement,downloadStatus integer,videoName text,videoUrl text,downloadPercent real,resumeData text,videoSize integer,category text,hardLevel text,imageUrl text,videoDuration text,tsDownloadTSIndex integer,allTsAcount integer,userID text,videoId text)"



@interface DownloadCacher ()

@end

@implementation DownloadCacher

+ (id)shareInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[DownloadCacher alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
//#warning 创建数据库放到子线程
        
        //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@",kLibraryCache,DBName];
        //NSLog(@"数据库路径--%@",dbPath);
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([db open])
            {
                
                NSString *createSql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,downloadStatus integer,videoName text,videoUrl text,downloadPercent real,resumeData text,videoSize integer,category text,hardLevel text,imageUrl text,videoDuration text,userID text, videoId text)",DownloadCacherTable];
                BOOL createResult = [db executeUpdate:createSql];
                if (createResult)
                {
                    //NSLog(@"create downloadCacherTable successful...");
                }
                else
                {
                    NSLog(@"uncreate downloadCacherTable...");
                }
            }
            else
            {
                NSLog(@"unopen or uncreate db...");
            }
        }];
        
        [self createM3U8Table];
    }
    return self;
    
}


- (DownloadStatus)queryDownloadStatusByModel:(DownloadModel *)downloadModel
{
    NSString *querySql = [NSString stringWithFormat:@"select downloadStatus from %@ where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,downloadModel.url,downloadModel.userID];
    __block BOOL isExist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if ([result next])
        {
            isExist = YES;
        }
        [result close];
    }];
    
    __block DownloadStatus status;
    //__block DownloadModel *model = downloadModel;
    if (isExist)
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:querySql];
            while ([result next])
            {
                status = [result intForColumn:@"downloadStatus"];
                //model.url = downloadModel.url;
                //model.name = downloadModel.name;
                //model.status = [result intForColumn:@"downloadStatus"];
                break;
            }
            [result close];
        }];
    }
    else
        status = DownloadNotExist;
    
    return status;
}



#pragma mark - 查询视频状态
- (DownloadStatus)queryDownloadStatusByVideoModel:(VideoModel *)videoModel
{
    NSString *querySql = [NSString stringWithFormat:@"select downloadStatus from %@ where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,videoModel.video_url,[CommonFunction getUserId]];
    __block BOOL isExist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if ([result next])
        {
            isExist = YES;
        }
        [result close];
    }];
    __block DownloadStatus status;
    if (isExist)
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:querySql];
            while ([result next])
            {
                status = [result intForColumn:@"downloadStatus"];
                break;
            }
            [result close];
        }];
    }
    else
        status = DownloadNotExist;
    
    return status;
}


#pragma mark - 查询视频状态
- (DownloadStatus)queryDownloadStatusByVideoUrl:(NSString *)videoUrl
{
    NSString *querySql = [NSString stringWithFormat:@"select downloadStatus from %@ where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,videoUrl,[CommonFunction getUserId]];
    __block BOOL isExist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if ([result next])
        {
            isExist = YES;
        }
        [result close];
    }];
    __block DownloadStatus status;
    if (isExist)
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:querySql];
            while ([result next])
            {
                status = [result intForColumn:@"downloadStatus"];
                break;
            }
            [result close];
        }];
    }
    else
        status = DownloadNotExist;
    
    return status;
}




- (BOOL)insertDownloadModel:(DownloadModel *)downloadModel
{
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@(downloadStatus,videoName,videoUrl,downloadPercent,resumeData,videoSize,category,hardLevel,imageUrl,videoDuration,userID,videoId) values (%d,'%@','%@',%f,'%@',%lld,'%@','%@','%@','%@','%@','%@')",DownloadCacherTable,downloadModel.status,downloadModel.name,
                           downloadModel.url,
                           downloadModel.downloadPercent,
                           downloadModel.resumeData,
                           downloadModel.videoSize,
                           downloadModel.category,
                           downloadModel.hardLevel,
                           downloadModel.imageUrl,
                           downloadModel.videoDuration,
                           downloadModel.userID,
                           downloadModel.videoId];
    
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:insertSql];
        if (result)
        {
        }
        else
        {
            NSLog(@"insert downloadCacherTable failed...");
        }
    }];
    return result;
}


#pragma mark - 更新表中记录
- (void)updateDownloadModel:(DownloadModel *)downloadModel {
    
    NSString *updateSql;
    if (downloadModel.resumeData)
    {
        updateSql = [NSString stringWithFormat:@"update %@ set downloadStatus = %d,downloadPercent = %f,resumeData = '%@' where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,downloadModel.status,downloadModel.downloadPercent,downloadModel.resumeData,downloadModel.url,downloadModel.userID];
    }
    else{
        updateSql = [NSString stringWithFormat:@"update %@ set downloadStatus = %d,downloadPercent = %f where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,downloadModel.status,downloadModel.downloadPercent,downloadModel.url,downloadModel.userID];
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:updateSql];
        if (result)
        {
            //NSLog(@"update downloadCacherTable sucessful...");
        }else{
            NSLog(@"update downloadCacherTable failed...");
        }
    }];
    
    //modify  yang
    
//    NSString *querySql = [NSString stringWithFormat:@"select resumeData from %@ where videoUrl = '%@'",DownloadCacherTable,downloadModel.url];
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:querySql];
//        while ([rs next])
//        {
//            //double percent = [rs doubleForColumn:@"downloadPercent"];
//            //NSString *resumeData = [rs stringForColumn:@"resumeData"];
//        }
//        [rs close];
//    }];
}

- (void)deleteDownloadModel:(DownloadModel *)downloadModel
{
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,downloadModel.url,downloadModel.userID];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:deleteSql];
        if (result)
        {
            //NSLog(@"delete downloadCacherTable sucessful...");
        }
        else{
            NSLog(@"delete downloadCacherTable failed...");
        }
        NSLog(@"%@",downloadModel);
    }];
}


- (DownloadModel *)queryTopWaitingDownloadModel
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where downloadStatus = %d and userID = '%@'",DownloadCacherTable,0,[CommonFunction getUserId]];//等待的下载
    
    __block DownloadModel *downloadModel = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if (result == nil)
        {
            
        }
        else
        {
            while ([result next])
            {
                DownloadStatus status = [result intForColumn:@"downloadStatus"];
                NSString *videoName = [result stringForColumn:@"videoName"];
                NSString *videoUrl = [result stringForColumn:@"videoUrl"];
                double downloadPercent = [result doubleForColumn:@"downloadPercent"];
                NSString *resumeData = [result stringForColumn:@"resumeData"];
                long videoSize = [result longForColumn:@"videoSize"];
                
                //add
                NSString *category =   [result stringForColumn:@"category"];
                NSString *hardLevel =   [result stringForColumn:@"hardLevel"];
                NSString *imageUrl =   [result stringForColumn:@"imageUrl"];
                NSString *videoDuration =   [result stringForColumn:@"videoDuration"];
                //
                
                if ([resumeData isEqualToString:@"(null)"])
                {
                    resumeData = nil;
                }
                downloadModel = [[DownloadModel alloc] init];
                downloadModel.status = status;
                downloadModel.name = videoName;
                downloadModel.url = videoUrl;
                downloadModel.downloadPercent = downloadPercent;
                downloadModel.resumeData = resumeData;
                downloadModel.videoSize = videoSize;
                //add
                downloadModel.category = category;
                downloadModel.hardLevel = hardLevel;
                downloadModel.imageUrl = imageUrl;
                downloadModel.videoDuration = videoDuration;
                downloadModel.videoId = [result stringForColumn:@"videoId"];
                
                break;
            }
        }
        [result close];
    }];
    return downloadModel;
}



//downloadStatus,videoName,videoUrl,downloadPercent,resumeData



- (void)getNewFromCacherWithModel:(DownloadModel *)downloadModel
{
    NSString *querySql = [NSString stringWithFormat:@"select downloadStatus,downloadPercent,resumeData,videoSize from %@ where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,downloadModel.url,downloadModel.userID];
    __block BOOL isExist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if ([result next])
        {
            isExist = YES;
        }
    }];
    
    __block DownloadModel *model = downloadModel;
    if (isExist)
    {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:querySql];
            while ([result next])
            {
                model.url = downloadModel.url;
                model.name = downloadModel.name;
                model.status = [result intForColumn:@"downloadStatus"];
                model.resumeData = [result stringForColumn:@"resumeData"];
                model.videoSize = [result longForColumn:@"videoSize"];
                //add
                model.category = [result stringForColumn:@"category"];
                model.hardLevel = [result stringForColumn:@"hardLevel"];
                model.imageUrl = [result stringForColumn:@"imageUrl"];
                model.videoDuration = [result stringForColumn:@"videoDuration"];
                
                model.videoId = [result stringForColumn:@"videoId"];
                
                break;
            }
            [result close];
        }];
    }
}





- (NSArray *)pauseAllDownloadModels
{
    //NSString *updateSql = [NSString stringWithFormat:@"update %@ set downloadStatus = %d where downloadStatus = %d",DownloadCacherTable,1,0];
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set downloadStatus = %d where downloadStatus = %d or downloadStatus = %d  and userID = '%@' ",DownloadCacherTable,1,2,0,[CommonFunction getUserId]];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:updateSql];
        if (result)
        {
            //NSLog(@"pauseAllDownloadModels successful...");
        }
        else
        {
            NSLog(@"pauseAllDownloadModels failure...");
        }
    }];
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where downloadStatus = %d  and userID = '%@'",DownloadCacherTable,1,[CommonFunction getUserId]];//暂停的下载
    
    __block DownloadModel *downloadModel = nil;
    //__weak NSMutableArray *resultArray = [NSMutableArray array];
    __block NSMutableArray *resultArray = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if (result == nil)
        {
            
        }
        else
        {
            while ([result next])
            {
                DownloadStatus status = [result intForColumn:@"downloadStatus"];
                NSString *videoName = [result stringForColumn:@"videoName"];
                NSString *videoUrl = [result stringForColumn:@"videoUrl"];
                double downloadPercent = [result doubleForColumn:@"downloadPercent"];
                NSString *resumeData = [result stringForColumn:@"resumeData"];
                long videoSize = [result longForColumn:@"videoSize"];
                
                //add
                NSString *category =   [result stringForColumn:@"category"];
                NSString *hardLevel =   [result stringForColumn:@"hardLevel"];
                NSString *imageUrl =   [result stringForColumn:@"imageUrl"];
                NSString *videoDuration =   [result stringForColumn:@"videoDuration"];
                
                NSString *videoId =   [result stringForColumn:@"videoId"];
                
                if ([resumeData isEqualToString:@"(null)"])
                {
                    resumeData = nil;
                }
                downloadModel = [[DownloadModel alloc] init];
                downloadModel.status = status;
                downloadModel.name = videoName;
                downloadModel.url = videoUrl;
                downloadModel.downloadPercent = downloadPercent;
                downloadModel.resumeData = resumeData;
                downloadModel.videoSize = videoSize;
                
                //add
                downloadModel.category = category;
                downloadModel.hardLevel = hardLevel;
                downloadModel.imageUrl = imageUrl;
                downloadModel.videoDuration = videoDuration;
                downloadModel.videoId = videoId;
                
                [resultArray addObject:downloadModel];
            }
        }
        [result close];
    }];
    return resultArray;
}




- (void)deleteDownloadModels:(NSArray *)downloadModels
{
    for (DownloadModel *downloadModel in downloadModels)
    {
        [self deleteDownloadModel:downloadModel];
    }
}


- (void)initializeDownloadModelFromDBCahcher:(DownloadModel *)downloadModel
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where videoUrl = '%@'",DownloadCacherTable,downloadModel.url];
    __weak DownloadModel *weakModel = downloadModel;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if (result == nil)
        {
            }else{
                while ([result next])
                {
                    DownloadStatus status = [result intForColumn:@"downloadStatus"];
                    NSString *videoName = [result stringForColumn:@"videoName"];
                    NSString *videoUrl = [result stringForColumn:@"videoUrl"];
                    double downloadPercent = [result doubleForColumn:@"downloadPercent"];
                    NSString *resumeData = [result stringForColumn:@"resumeData"];
                    
                    //add
                    NSString *category =   [result stringForColumn:@"category"];
                    NSString *hardLevel =   [result stringForColumn:@"hardLevel"];
                    NSString *imageUrl =   [result stringForColumn:@"imageUrl"];
                    NSString *videoDuration =   [result stringForColumn:@"videoDuration"];
                    
                    NSString *videoId =   [result stringForColumn:@"videoId"];
                    
                    if ([resumeData isEqualToString:@"(null)"])
                    {
                        resumeData = nil;
                    }
                    weakModel.status = status;
                    weakModel.name = videoName;
                    weakModel.url = videoUrl;
                    weakModel.downloadPercent = downloadPercent;
                    weakModel.resumeData = resumeData;
                    //add
                    weakModel.category = category;
                    weakModel.hardLevel = hardLevel;
                    weakModel.imageUrl = imageUrl;
                    weakModel.videoDuration = videoDuration;
                    weakModel.videoId = videoId;
                    break;
                }
        }
        [result close];
    }];
    
}



- (BOOL)checkIsExistDownloading
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where downloadStatus = %d and userID = '%@'",DownloadCacherTable,2,[CommonFunction getUserId]];//正在下载
    __block BOOL exist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        
        while ([result next])
        {
            exist = YES;
        }
        [result close];
    }];
    return exist;
}


#pragma mark - 查询是否在下载列表中存在
- (BOOL)checkIsExistDownloadWithUrl:(NSString *)url
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where videoUrl = '%@' and userID = '%@' ",DownloadCacherTable,url,[CommonFunction getUserId]];//正在下载
    __block BOOL exist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        
        if (result == nil) {
            
        }else{
            while ([result next])
            {
                exist = YES;
                break;
            }
        }
        [result close];
    }];
    return exist;
}




- (NSArray *)startAllDownloadModels
{
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set downloadStatus = %d where downloadStatus = %d and userID = '%@'",DownloadCacherTable,0,1,[CommonFunction getUserId]];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:updateSql];
        if (result)
        {
            //NSLog(@"startAllDownloadModels successful...");
        }
        else
        {
            //NSLog(@"startAllDownloadModels failure...");
        }
    }];
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where downloadStatus = %d  and userID = '%@'",DownloadCacherTable,0,[CommonFunction getUserId]];//等待的下载
    __block DownloadModel *downloadModel = nil;
    //__weak NSMutableArray *resultArray = [NSMutableArray array];
    
    __block NSMutableArray *resultArray = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if (result == nil)
        {
            
        }
        else
        {
            while ([result next])
            {
                DownloadStatus status = [result intForColumn:@"downloadStatus"];
                NSString *videoName = [result stringForColumn:@"videoName"];
                NSString *videoUrl = [result stringForColumn:@"videoUrl"];
                double downloadPercent = [result doubleForColumn:@"downloadPercent"];
                NSString *resumeData = [result stringForColumn:@"resumeData"];
                long videoSize = [result longForColumn:@"videoSize"];
                
                //add
                NSString *category =   [result stringForColumn:@"category"];
                NSString *hardLevel =   [result stringForColumn:@"hardLevel"];
                NSString *imageUrl =   [result stringForColumn:@"imageUrl"];
                NSString *videoDuration =   [result stringForColumn:@"videoDuration"];
                
                NSString *videoId =   [result stringForColumn:@"videoId"];
                
                if ([resumeData isEqualToString:@"(null)"])
                {
                    resumeData = nil;
                }
                downloadModel = [[DownloadModel alloc] init];
                downloadModel.status = status;
                downloadModel.name = videoName;
                downloadModel.url = videoUrl;
                downloadModel.downloadPercent = downloadPercent;
                downloadModel.resumeData = resumeData;
                downloadModel.videoSize = videoSize;
                
                //add
                downloadModel.category = category;
                downloadModel.hardLevel = hardLevel;
                downloadModel.imageUrl = imageUrl;
                downloadModel.videoDuration = videoDuration;
                downloadModel.videoId = videoId;
                //
                
                [resultArray addObject:downloadModel];
            }
        }
        [result close];
    }];
    
    return resultArray;
}




#pragma mark - 查询全部的下载条目
- (NSMutableArray *)selectAllDownloadModels {
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@  where userID = '%@'",DownloadCacherTable,[CommonFunction getUserId]];
    return  [self selectDownloadModels:querySql];
}


#pragma mark - 查询全部 下载 完成的条目
- (NSMutableArray *)selectfinishedDownloadModels {
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where downloadStatus = %d  and userID = '%@'",DownloadCacherTable,3,[CommonFunction getUserId]];
    return  [self selectDownloadModels:querySql];
}


#pragma mark - 查询全部 未下载 完成的条目
- (NSMutableArray *)selectNoDownloadModels {
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where downloadStatus != %d  and userID = '%@' ",DownloadCacherTable,3,[CommonFunction getUserId]];
    return  [self selectDownloadModels:querySql];
}


#pragma mark - 查找表中 下载 记录
- (NSMutableArray *)selectDownloadModels:(NSString *)querySql {
        
    __block DownloadModel *downloadModel = nil;
    //__weak NSMutableArray *resultArray = [NSMutableArray array];  modify yang
    __block NSMutableArray *resultArray = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        if (result == nil)
        {
            
        }
        else
        {
            while ([result next])
            {
                DownloadStatus status = [result intForColumn:@"downloadStatus"];
                NSString *videoName = [result stringForColumn:@"videoName"];
                NSString *videoUrl = [result stringForColumn:@"videoUrl"];
                double downloadPercent = [result doubleForColumn:@"downloadPercent"];
                NSString *resumeData = [result stringForColumn:@"resumeData"];
                long videoSize = [result longForColumn:@"videoSize"];
                
                //add
                NSString *category =   [result stringForColumn:@"category"];
                NSString *hardLevel =   [result stringForColumn:@"hardLevel"];
                NSString *imageUrl =   [result stringForColumn:@"imageUrl"];
                NSString *videoDuration =   [result stringForColumn:@"videoDuration"];
                NSString *videoId =   [result stringForColumn:@"videoId"];
                
                if ([resumeData isEqualToString:@"(null)"])
                {
                    resumeData = nil;
                }
                downloadModel = [[DownloadModel alloc] init];
                downloadModel.status = status;
                downloadModel.name = videoName;
                downloadModel.url = videoUrl;
                downloadModel.downloadPercent = downloadPercent;
                downloadModel.resumeData = resumeData;
                downloadModel.videoSize = videoSize;
                
                //add
                downloadModel.category = category;
                downloadModel.hardLevel = hardLevel;
                downloadModel.imageUrl = imageUrl;
                downloadModel.videoDuration = videoDuration;
                downloadModel.videoId = videoId;
                //
                
                [resultArray addObject:downloadModel];
            }
        }
        [result close];
    }];
    return resultArray;
}



- (BOOL)checkIsExistFinishDownload
{
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where downloadStatus = %d",DownloadCacherTable,3];//正在下载
    __block BOOL exist = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        
        while ([result next])
        {
            exist = YES;
        }
        [result close];
    }];
    return exist;
}


- (void)tb_closeDB {
    [self.dbQueue close];
}








@end
