//
//  UserInfoRecord.h
//  Code
//
//  Created by Ivan li on 2017/8/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModel.h"
#import "FMDB.h"



@class HKUserModel;

@interface UserInfoRecord : NSObject

@property (nonatomic,strong) FMDatabaseQueue *dbQueue;

+ (id)shareInstance;

- (BOOL)insertUserModel:(HKUserModel *)userInfoModel;

- (NSMutableArray *)selectAllDownloadModels;

@end
