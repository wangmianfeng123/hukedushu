////
////  HKHttpTool.h
////  Code
////
////  Created by hanchuangkeji on 2017/11/8.
////  Copyright © 2017年 pg. All rights reserved..
////
//
//#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
//
//#define  HKneedNoLoginCallBack  @"HKneedNoLoginCallBack"
//
//@interface HKHttpTool : NSObject
//
///**
// *  发送post请求
// *
// *  @param URLString  请求的基本的url
// *  @param parameters 请求的参数字典
// *  @param success    请求成功的回调
// *  @param failure    请求失败的回调
// */
//+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//
//
//
///**
//  发送post请求  手动传入 主域名 url
//
// @param URLString 请求的基本的url
// @param baseUrl  主域名 url
// @param parameters
// @param success
// @param failure
// */
//+ (void)POST:(NSString *)URLString  baseUrl:(NSString *)baseUrl parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//
///**
// 校验返回数据正确性
//
// @param responseObject 网络字典数组
// @return 是否需要登录
// */
//+ (BOOL)checkServerState:(id)responseObject;
//
//
//
///**
// post请求
//
// allUrl 完整请求路径 （不为空 则不使用URLString ）
//
// @param URLString url
// @param allUrl allUrl
// @param parameters 参数字典
// @param success 成功的回调
// @param failure 失败的回调
// @return post会话
// */
//+ (NSURLSessionDataTask *)hk_taskPost:(NSString *)URLString
//                               allUrl:(NSString *)allUrl
//                                isGet:(BOOL)isGet
//                           parameters:(id)parameters
//                              success:(void (^)(id responseObject))success
//                              failure:(void (^)(NSError *error))failure;
//
//@end



//
//  HKHttpTool.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved..
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define  HKneedNoLoginCallBack  @"HKneedNoLoginCallBack"

@interface HKHttpTool : NSObject

/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;



/**
  发送post请求  手动传入 主域名 url

 @param URLString 请求的基本的url
 @param baseUrl  主域名 url
 @param parameters
 @param success
 @param failure
 */
+ (void)POST:(NSString *)URLString  baseUrl:(NSString *)baseUrl parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 校验返回数据正确性

 @param responseObject 网络字典数组
 @return 是否需要登录
 */
+ (BOOL)checkServerState:(id)responseObject;

//检查code是否为40001
+ (BOOL)checkNeedTermination:(id)responseObject;

/**
 post请求
 
 allUrl 完整请求路径 （不为空 则不使用URLString ）

 @param URLString url
 @param allUrl allUrl
 @param parameters 参数字典
 @param success 成功的回调
 @param failure 失败的回调
 @return post会话
 */
+ (NSURLSessionDataTask *)hk_taskPost:(NSString *)URLString
                               allUrl:(NSString *)allUrl
                                isGet:(BOOL)isGet
                           parameters:(id)parameters
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;


/**
 GET请求
 @param URLString url
 @param allUrl allUrl
 @param parameters 参数字典
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (NSURLSessionDataTask *)hk_taskGetUrl:(NSString *)URLString
                           parameters:(id)parameters
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

/**
post请求

 session 不为空 则使用传入的 session (返回结果在session 设置的队列中)
 
 session 为空 则使用传入的 默认的session (返回结果在主线程)
 
*/
+ (void)POSTWithSession:(AFHTTPSessionManager *)session
              URLString:(NSString *)URLString
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

// 字典转json字符串方法

+ (NSString *)jsonStringWithDict:(NSDictionary *)dict;

//跟新token
//+ (void)needsRefreshAccess_token:(id)responseObject  resultBlock:(void(^)(BOOL needRefresh))resultBlock;
@end
