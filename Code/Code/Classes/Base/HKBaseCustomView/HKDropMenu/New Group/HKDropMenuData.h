//
//  HKDropMenuData.h
//  Code
//
//  Created by Ivan li on 2019/12/2.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKDropMenuModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKDropMenuData : NSObject

@property (nonatomic,strong) HKDropMenuModel *dropMenuModel;

+ (instancetype)shareInstance;

+ (HKDropMenuModel *)shareAccount;

/**
 保存实例
 
 @param user 实例
 */
+ (void)saveOrUpdateDropMenuData:(HKDropMenuModel *)account;

/**
 删除实例（实例文档）
 */
+ (void)deleteAccount;

@end

NS_ASSUME_NONNULL_END

