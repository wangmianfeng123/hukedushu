//
//  StudyVedioRecord.m
//  Code
//
//  Created by Ivan li on 2017/8/14.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "StudyVedioRecord.h"
#import "DownloadModel.h"
#import "DetailModel.h"
#import "VideoModel.h"


#define DBName @"downloadCacher.db"

#define T_studyVideo @"t_study_video"


#define  createStudyVideoTableSql    @"create table if not exists %@ (id integer primary key autoincrement,videoName text,videoUrl text,category text,hardLevel text,imageUrl text,videoDuration text,userID text)"

static StudyVedioRecord *instance;

@implementation StudyVedioRecord



+ (id)shareInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[StudyVedioRecord alloc] init];
    });
    return instance;
}


- (id)init
{
    if (self = [super init])
    {
    
        NSString *dbPath = [NSString stringWithFormat:@"%@/%@",kLibraryCache,DBName];
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            if ([db open])
            {
                NSString *createSql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,videoName text,videoUrl text,category text,hardLevel text,imageUrl text,videoDuration text,userID text,videoId text)",T_studyVideo];
                BOOL createResult = [db executeUpdate:createSql];
                if (createResult)
                {
                    //NSLog(@"create T_studyVideo successful...");
                }
                else
                {
                    //NSLog(@"uncreate T_studyVideo...");
                }
            }
            else
            {
                //NSLog(@"unopen or uncreate db...");
            }
        }];
    }
    return self;
}



#pragma mark - 插入观看记录
- (BOOL)insertDownloadModel:(DownloadModel *)downloadModel
{
    __block BOOL btrue = NO;
    NSString *querySql = [NSString stringWithFormat:@"select count(videoUrl) as urlCount from %@ where videoUrl = '%@' and userID = '%@' ",T_studyVideo,downloadModel.url, downloadModel.userID];//等待的下载
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        int count = 0;
        while ([result next]) {
            count = [result intForColumn:@"urlCount"];
        }
        if (count == 0)
        {
            btrue = YES;
        }else{
            btrue = NO;
        }
        [result close];
    }];
    
    if (btrue) {
        NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(videoName,videoUrl,category,hardLevel,imageUrl,videoDuration,userID,videoId ) values ('%@','%@','%@','%@','%@','%@','%@','%@')",T_studyVideo,downloadModel.name,downloadModel.url,downloadModel.category,downloadModel.hardLevel,downloadModel.imageUrl,downloadModel.videoDuration,downloadModel.userID,downloadModel.videoId];
        
        __block BOOL tempResult = NO;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            tempResult = [db executeUpdate:insertSql];
            if (tempResult)
            {  //NSLog(@"insert studyTable sucessful...");
            }
            else{
                //NSLog(@"insert studyTable failed...");
            }
        }];
        return tempResult;
    }
    else{
        return YES;
    }
}










#pragma mark - 插入观看记录
- (BOOL)insertHistoryByDetailModel:(DetailModel *)detailModel
{
    __block BOOL btrue = NO;
    NSString *querySql = [NSString stringWithFormat:@"select count(videoUrl) as urlCount from %@ where videoUrl = '%@' and userID = '%@' ",T_studyVideo,detailModel.video_url, [CommonFunction getUserId]];//等待的下载
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        int count = 0;
        while ([result next]) {
            count = [result intForColumn:@"urlCount"];
        }
        if (count == 0)
        {
            btrue = YES;
        }else{
            btrue = NO;
        }
        [result close];
    }];
    
    if (btrue) {
        NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(videoName,videoUrl,category,hardLevel,imageUrl,videoDuration,userID,videoId ) values ('%@','%@','%@','%@','%@','%@','%@','%@')",T_studyVideo,detailModel.video_titel,detailModel.video_url,detailModel.video_application,detailModel.viedeo_difficulty,detailModel.img_cover_url,detailModel.video_duration,[CommonFunction getUserId],detailModel.video_id];
        
        __block BOOL tempResult = NO;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            tempResult = [db executeUpdate:insertSql];
            if (tempResult)
            {  //NSLog(@"insert studyTable sucessful...");
            }
            else{
                //NSLog(@"insert studyTable failed...");
            }
        }];
        return tempResult;
    }
    else{
        return YES;
    }
}





#pragma mark - 插入观看记录
- (BOOL)insertHistoryByVideoModel:(VideoModel *)detailModel
{
    __block BOOL btrue = NO;
    NSString *querySql = [NSString stringWithFormat:@"select count(videoUrl) as urlCount from %@ where videoUrl = '%@' and userID = '%@' ",T_studyVideo,detailModel.video_url, [CommonFunction getUserId]];//等待的下载
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        int count = 0;
        while ([result next]) {
            count = [result intForColumn:@"urlCount"];
        }
        if (count == 0)
        {
            btrue = YES;
        }else{
            btrue = NO;
        }
        [result close];
    }];
    
    if (btrue) {
        NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(videoName,videoUrl,category,hardLevel,imageUrl,videoDuration,userID,videoId ) values ('%@','%@','%@','%@','%@','%@','%@','%@')",T_studyVideo,detailModel.video_titel,detailModel.video_url,detailModel.video_application,detailModel.viedeo_difficulty,detailModel.img_cover_url,detailModel.video_duration,[CommonFunction getUserId],detailModel.video_id];
        
        __block BOOL tempResult = NO;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            tempResult = [db executeUpdate:insertSql];
            if (tempResult)
            {  //NSLog(@"insert studyTable sucessful...");
            }
            else{
                //NSLog(@"insert studyTable failed...");
            }
        }];
        return tempResult;
    }
    else{
        return YES;
    }
}







#pragma mark - 查询全部的下载条目
- (NSMutableArray *)selectAllDownloadModels {
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where userID = '%@'",T_studyVideo,[CommonFunction getUserId]];
    return  [self selectDownloadModels:querySql];
}

#pragma mark - 查找表中 下载 记录
- (NSMutableArray *)selectDownloadModels:(NSString *)querySql {
    
    __block DownloadModel *downloadModel = nil;
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
                NSString *videoName = [result stringForColumn:@"videoName"];
                NSString *videoUrl = [result stringForColumn:@"videoUrl"];
                //add
                NSString *category =   [result stringForColumn:@"category"];
                NSString *hardLevel =   [result stringForColumn:@"hardLevel"];
                NSString *imageUrl =   [result stringForColumn:@"imageUrl"];
                NSString *videoDuration =   [result stringForColumn:@"videoDuration"];
                NSString *videoId =   [result stringForColumn:@"videoId"];
                
                downloadModel = [[DownloadModel alloc] init];
                downloadModel.name = videoName;
                downloadModel.url = videoUrl;
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






@end
