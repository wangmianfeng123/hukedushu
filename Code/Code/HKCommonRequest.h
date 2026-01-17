//
//  HKCommonRequest.h
//  Code
//
//  Created by Ivan li on 2018/6/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 通用的请求 */
@interface HKCommonRequest : NSObject

/**
 分享成功回调
 
 @param model 分享model
 @param success （成功后 执行回调）
 */
+ (void)shareDataSucess:(ShareModel*)model  success:(void (^)(id responseObject))success  failure:(void (^)(NSError *error))failure;

@end
