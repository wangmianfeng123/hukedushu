//
//  HKAccountTool.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/30.
//  Copyright © 2017年 pg. All rights reserved.
//


#import "HKAccountTool.h"


#define HKAccountFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"HKAccount.data"]


#define    HK_TOKEN         @"userAccount.access_token"

#define    HK_VIP_TYPE      @"userAccount.vip_class"


@implementation HKAccountTool

@synthesize userAccount = _userAccount;

MJCodingImplementation

static HKUserModel *_account;


+ (instancetype)shareInstance {
    
    static HKAccountTool *accountTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountTool = [[HKAccountTool alloc] init];
    });
    return accountTool;
}


- (instancetype)init {
    if (self = [super init]) {
        [self userInfoObserver];
    }
    return self;
}


- (void)setUserAccount:(HKUserModel *)userAccount {
    _userAccount = userAccount;
}



+ (HKUserModel *)shareAccount {
    
    if (_account == nil) {
        
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:HKAccountFileName];
        [[self shareInstance]setUserAccount:_account];
        
    }
    return _account;
}



+ (void)saveOrUpdateAccount:(HKUserModel *)account {
    _account = account;// 最新更新
    [[self shareInstance]setUserAccount:account];
    [NSKeyedArchiver archiveRootObject:account toFile:HKAccountFileName];
}


+ (void)saveAccountToken:(NSString *)access_token andRefresh_token:(NSString *)refresh_token andAccess_token_expire:(NSString *)expire_at{
    if (_account) {
        _account.access_token = access_token;
        _account.refresh_token = refresh_token;
        _account.access_token_expire_at = expire_at;
        [self saveOrUpdateAccount:_account];
    }
}




///**
// 删除文档
// */
//+ (void)deleteAccount {
//
//    // 置空账号
//    _account = nil;
//    // 删除文件
//    NSFileManager* fileManager = [NSFileManager defaultManager];
//    BOOL blHave =[[NSFileManager defaultManager] fileExistsAtPath:HKAccountFileName];
//    if (!blHave) {
//        NSLog(@"没有账号文档保存在本地");
//        return;
//    } else {
//        BOOL blDele = [fileManager removeItemAtPath:HKAccountFileName error:nil];
//        if (blDele) {
//            NSLog(@"本地账号文档删除成功");
//        }else {
//            NSLog(@"本地账号文档删除失败");
//        }
//    }
//    [[self shareInstance]setUserAccount:_account];
//}



/**
 删除文档
 */
+ (void)deleteAccount {
    
    // 置空账号
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 删除文件
        NSFileManager* fileManager = [NSFileManager defaultManager];
        BOOL blHave =[fileManager fileExistsAtPath:HKAccountFileName];
        if (!blHave) {
            NSLog(@"没有账号文档保存在本地");
            return;
        } else {
            BOOL blDele = [fileManager removeItemAtPath:HKAccountFileName error:nil];
            if (blDele) {
                NSLog(@"本地账号文档删除成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    _account = nil;
                    [[self shareInstance]setUserAccount:_account];
                    
                    [self deleteHttpCookie];
                    // 发出注销通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:HKLogoutSuccessNotification object:nil];
                });
                
            }else {
                NSLog(@"本地账号文档删除失败");
            }
        }
    });
}



/**
 *
 *清除http cookie
 *
 */
+ (void) deleteHttpCookie {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *arr = [NSArray arrayWithArray:[cookieStorage cookies]];
    for (id obj in arr) {
        [cookieStorage deleteCookie:obj];
    }
}


/*******************  ***********************/

#pragma mark - 观察用户VIP 登录状态变化
- (void)userInfoObserver {
    
    [self addObserver:self forKeyPath:HK_VIP_TYPE options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:HK_TOKEN options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}



/** 回调方法    */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    [self changeForKeyPath:keyPath targetKeyPath:HK_TOKEN change:change notiName:HKUserInfoChangeNotification];
    [self changeForKeyPath:keyPath targetKeyPath:HK_VIP_TYPE change:change notiName:HKUserInfoChangeNotification];
}




- (BOOL)changeForKeyPath:(NSString *)keyPath  targetKeyPath:(NSString *)targetKeyPath
                  change:(NSDictionary<NSString *,id> *)change
                notiName:(NSString*)notiName {
    
    if ([keyPath isEqualToString:targetKeyPath]) {
        
        id new = [change valueForKey:NSKeyValueChangeNewKey];
        id old = [change valueForKey:NSKeyValueChangeOldKey];
        
        if (isEmpty(new) && isEmpty(old)) {
            //NSLog(@"%@ null ",targetKeyPath);
            return NO;
        }else{
            
            NSString *newToken = [NSString stringWithFormat:@"%@",new];
            NSString *oldToken = [NSString stringWithFormat:@"%@",old];
            if ([newToken isEqual: oldToken]) {
                //NSLog(@"%@  相同 ",targetKeyPath);
                return NO;
            }else{
                //NSLog(@"%@  不等",targetKeyPath);
                NSLog(@"changed %@ ---- old = %@",[change valueForKey:NSKeyValueChangeNewKey],[change valueForKey:NSKeyValueChangeOldKey]);
                NSLog(@"%@",[DateChange getCurrentTime]);
                if (!isEmpty(notiName)) {
                    [self postChangeNotiWithName:notiName targetKeyPath:targetKeyPath change:change];
                    //[self postChangeNotiWithName:HKUserInfoChangeNotification targetKeyPath:targetKeyPath change:change];
                }
                return YES;
            }
        }
    }
    return NO;
}



#pragma mark - 信息改变通知
- (void)postChangeNotiWithName:(NSString*)notiName targetKeyPath:(NSString *)targetKeyPath
                        change:(NSDictionary<NSString *,id> *)change  {
    
    NSString *newStr = [NSString stringWithFormat:@"%@",[change valueForKey:NSKeyValueChangeNewKey]];
    NSDictionary *dict = isEmpty(newStr)? @{@"new":newStr} : nil;
    HK_NOTIFICATION_POST_DICT(notiName, nil, dict);
}



@end




