//
//  UserInfoRecord.m
//  Code
//
//  Created by Ivan li on 2017/8/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "UserInfoRecord.h"
#import "HKUserModel.h"

#define DBName @"downloadCacher.db"

#define T_user @"t_user"

/*
@property(nonatomic,copy)NSString <Optional>*access_token;
@property(nonatomic,copy)NSString <Optional>*ID;
@property(nonatomic,copy)NSString <Optional>*username;
@property(nonatomic,copy)NSString <Optional>*avator;
*/


#define  createStudyVideoTableSql    @"create table if not exists %@ (id integer primary key autoincrement,userID text,username text,avator text,access_token text)"

static UserInfoRecord *instance;

@implementation UserInfoRecord


+ (id)shareInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[UserInfoRecord alloc] init];
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

                NSString *createSql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,userID text,username text,avator text,access_token text)",T_user];
                BOOL createResult = [db executeUpdate:createSql];
                if (createResult)
                {
                    //NSLog(@"create T_user successful...");
                }
                else
                {
                    //NSLog(@"uncreate T_user...");
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



#pragma mark - 插入用户信息记录
- (BOOL)insertUserModel:(HKUserModel *)userInfoModel
{
    __block BOOL btrue = NO;
    NSString *querySql = [NSString stringWithFormat:@"select count(userID) as userCount from %@ where userID = '%@' ",T_user,userInfoModel.ID];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:querySql];
        int count = 0;
        while ([result next]) {
            count = [result intForColumn:@"userCount"];
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

        NSString *insertSql = [NSString stringWithFormat:@"insert or ignore into %@(userID,username,avator,access_token) values ('%@','%@','%@','%@')",T_user,userInfoModel.ID,userInfoModel.username,userInfoModel.avator,userInfoModel.access_token];
        
        __block BOOL tempResult = NO;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            tempResult = [db executeUpdate:insertSql];
            if (tempResult)
            {
                //NSLog(@"insert T_user sucessful...");
            }
            else{
                NSLog(@"insert T_user failed...");
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
    
    NSString *querySql = [NSString stringWithFormat:@"select * from %@",T_user];
    return  [self selectDownloadModels:querySql];
}

#pragma mark - 查找表中 下载 记录
- (NSMutableArray *)selectDownloadModels:(NSString *)querySql {
    
    __block HKUserModel *downloadModel = nil;
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
                NSString *userID = [result stringForColumn:@"userID"];
                NSString *username = [result stringForColumn:@"username"];
                NSString *avator =   [result stringForColumn:@"avator"];
                NSString *access_token =   [result stringForColumn:@"access_token"];
                
                downloadModel = [[HKUserModel alloc] init];
                downloadModel.ID = userID;
                downloadModel.username = username;
                //add
                downloadModel.avator = avator;
                downloadModel.access_token = access_token;
                [resultArray addObject:downloadModel];
            }
        }
        [result close];
    }];
    return resultArray;
}






@end
