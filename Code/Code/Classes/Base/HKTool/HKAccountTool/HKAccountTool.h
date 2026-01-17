//
//  HKAccountTool.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKUserModel.h"

@interface HKAccountTool : NSObject {
    
}

@property (nonatomic,strong) HKUserModel *userAccount;


/**
 获取当前用户实例，可以用于判断是否登录状态
 
 @return 实例
 */

+ (instancetype)shareInstance;

+ (HKUserModel *)shareAccount;

/**
 保存实例
 
 @param user 实例
 */
+ (void)saveOrUpdateAccount:(HKUserModel *)account;



+ (void)saveAccountToken:(NSString *)access_token andRefresh_token:(NSString *)refresh_token andAccess_token_expire:(NSString *)expire_at;

/**
 删除实例（实例文档）
 */
+ (void)deleteAccount;

@end

