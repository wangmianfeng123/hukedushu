//
//  HKDropMenuData.m
//  Code
//
//  Created by Ivan li on 2019/12/2.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKDropMenuData.h"

#define HKDropMenuFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"HKDropMenuData.data"]


@implementation HKDropMenuData

@synthesize dropMenuModel = _dropMenuModel;

MJCodingImplementation

static HKDropMenuModel *_account;


+ (instancetype)shareInstance {
    
    static HKDropMenuData *accountTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountTool = [[HKDropMenuData alloc] init];
    });
    return accountTool;
}



- (void)setUserAccount:(HKDropMenuModel *)userAccount {
    _dropMenuModel = userAccount;
}



+ (HKDropMenuModel *)shareAccount {
    //if (_account == nil) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:HKDropMenuFileName];
        [[self shareInstance]setUserAccount:_account];
    //}
    return _account;
}



+ (void)saveOrUpdateDropMenuData:(HKDropMenuModel *)account {
    _account = account;// 最新更新
    [[self shareInstance]setUserAccount:account];
    [NSKeyedArchiver archiveRootObject:account toFile:HKDropMenuFileName];
}


/**
 删除文档
 */
+ (void)deleteAccount {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL blHave =[fileManager fileExistsAtPath:HKDropMenuFileName];
        if (blHave) {
            BOOL isOK = [fileManager removeItemAtPath:HKDropMenuFileName error:nil];
            if (NO == isOK) {
                NSLog(@"本地账号文档删除失败");
            }
        }
    });
}


@end




