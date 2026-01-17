////
////  AFNetworkTool.h
////  AFNetText2.5
////
////  Created by pg on 15/1/27.
////  Copyright (c) 2015年 pg. All rights reserved.
////
//
///**
// 要使用常规的AFN网络访问
//
// 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
// 所有的网络请求,均有manager发起
//
// 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
//
// 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
// 2> 如果返回格式不是JSON的,
//
// 3. 请求格式
//
// AFHTTPRequestSerializer            二进制格式
// AFJSONRequestSerializer            JSON
// AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
//
// 4. 返回格式
//
// AFHTTPResponseSerializer           二进制格式
// AFJSONResponseSerializer           JSON
// AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
// AFXMLDocumentResponseSerializer (Mac OS X)
// AFPropertyListResponseSerializer   PList
// AFImageResponseSerializer          Image
// AFCompoundResponseSerializer       组合
// */
//
//#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
//
//
//
//typedef void (^ Success)(id responseObject);     // 成功Block
//typedef void (^ Failure)(NSError *error);        // 失败Blcok
//typedef void (^ Progress)(NSProgress *progress); // 上传或者下载进度Block
//
//@interface AFNetworkTool : NSObject
//@property (nonatomic,retain) NSString *content;
//
//
//
//
///**
// *  封装的get请求
// *
// *  @param URLString  请求的链接
// *  @param parameters 请求的参数
// *  @param success    请求成功回调
// *  @param failure    请求失败回调
// */
//+ (void)GET:(NSString *)URLString
// parameters:(NSDictionary *)parameters
//    success:(Success)success
//    failure:(Failure)failure;
//
//
///**
// *  封装的post请求
// *
// *  @param urlStr  请求的链接
// *  @param parameters 请求的参数
// *  @param success    请求成功回调
// *  @param fail       请求失败回调
// */
//+ (void)postWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters
//            success:(Success)success failure:(Failure)failure;
//
//
///**
// *  封装的post请求  请求头 中带有用户 token
// *
// *  @param URLString  请求的链接
// *  @param parameters 请求的参数
// *  @param success    请求成功回调
// *  @param fail       请求失败回调
// */
//+ (void)postWithHeader:(NSString *)header url:(NSString*)url parameters:(NSDictionary *)parameters
//               success:(Success)success failure:(Failure)failure;
//
//+ (void)tb_postWithHeader:(NSString *)header url:(NSString*)url parameters:(NSDictionary *)parameters
//               success:(Success)success failure:(Failure)failure;
//
///**
// *  封装POST图片上传(单张图片)
// *
// *  @param url      请求的链接
// *  @param params   请求的参数
// *  @param success  发送成功的回调
// *  @param fail     发送失败的回调
// */
//+ (void)upload:(NSString *)url
//        params:(NSDictionary *)params
//    arrayFiles:(NSArray *)fileArr
//       success:(void (^)(id responseObject))success
//          fail:(void (^)())fail;
//
//
///**
// *  封装POST上传url资源
// *
// *  @param URLString  请求的链接
// *  @param parameters 请求的参数
// *  @param picModle   上传的图片模型(资源的url地址)
// *  @param progress   进度的回调
// *  @param success    发送成功的回调
// *  @param failure    发送失败的回调
// */
//+ (void)POST:(NSString *)URLString
//  parameters:(NSDictionary *)parameters
//     fileURL:(NSURL *)fileURL
//    progress:(Progress)progress
//     success:(Success)success
//     failure:(Failure)failure;
//
//
//
///**
// POST
//
// @param header
// @param url URL
// @param parameters 参数
// @param success 成功的回调
// @param failure 失败的回调
// @return  post回话
// */
//+ (NSURLSessionDataTask*)sessionPostWithHeader:(NSString *)header
//                                           url:(NSString*)url
//                                         isGet:(BOOL)isGet
//                                    parameters:(NSDictionary *)parameters
//                                       success:(Success)success
//                                       failure:(Failure)failure;
//
//
//@end












//
//  AFNetworkTool.h
//  AFNetText2.5
//
//  Created by pg on 15/1/27.
//  Copyright (c) 2015年 pg. All rights reserved.
//

/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"



typedef void (^ Success)(id responseObject);     // 成功Block
typedef void (^ Failure)(NSError *error);        // 失败Blcok
typedef void (^ Progress)(NSProgress *progress); // 上传或者下载进度Block

@interface AFNetworkTool : NSObject
@property (nonatomic,retain) NSString *content;





/**
 *  封装的post请求  请求头 中带有用户 token
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param fail       请求失败回调
 */
+ (void)postWithHeader:(NSString *)header url:(NSString*)url parameters:(NSDictionary *)parameters
               success:(Success)success failure:(Failure)failure;

+ (void)tb_postWithHeader:(NSString *)header url:(NSString*)url parameters:(NSDictionary *)parameters
               success:(Success)success failure:(Failure)failure;


+ (void)customSessionPostWithSession:(AFHTTPSessionManager *)session
                              header:(NSString *)header
                                 url:(NSString*)url
                          parameters:(NSDictionary *)parameters
                             success:(Success)success
                             failure:(Failure)failure;


/**
 POST

 @param header
 @param url URL
 @param parameters 参数
 @param success 成功的回调
 @param failure 失败的回调
 @return  post回话
 */
+ (NSURLSessionDataTask*)sessionPostWithHeader:(NSString *)header
                                           url:(NSString*)url
                                         isGet:(BOOL)isGet
                                    parameters:(NSDictionary *)parameters
                                       success:(Success)success
                                       failure:(Failure)failure;
    

@end












