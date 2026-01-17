
//
//  HKHttpTool.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKHttpTool.h"
#import "AFNetworkTool.h"
#import "SVProgressHUD.h"
#import "HKLoginTool.h"
#import "LoginVC.h"
#import "HKEmptyRootVC.h"

/**
 后台 状态码:
 
 code
 1：正常返回
 
 -1： token过期，重新登录
 
 1001：提示“您的账号已在别处登录，如非本人操作请立即修改密码哦~”，点击“确定”跳转到登录页
 
 40001:服务器维护
 
 401:未登录,-1:登录失效,1:请求成功,
 1001:登录被顶掉,
 40001:服务器维护，
 40002:弹出msg，停止后续操作
 -2 无VIP 弹框
 
 //out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录 5-强制绑定手机号
 */




@implementation HKHttpTool


+ (void)POST:(NSString *)URLString parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure
{
    
    // 设置token
    NSString *headerToken = nil;
    if ([CommonFunction getUserToken].length) {
        headerToken = [NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]];
    }
    
    // 拼接url
    if (![URLString hasPrefix:@"/"]) {
        URLString = [NSString stringWithFormat:@"/%@", URLString];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, URLString];
    //[SVProgressHUD showWithStatus:@"加载中..."];
    [AFNetworkTool tb_postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        // 检查状态
        BOOL needLogin = [self checkServerState:responseObject];
        
        BOOL needNoLoginCallBack = [self needNoLoginCallBack:parameters];
        
        if (needNoLoginCallBack && needLogin) {
            success(responseObject);
            return;
        }
        
        if (success && !needLogin) {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        //服务器报错信息
            NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        //服务器报错响应头
               NSHTTPURLResponse * reoponseData = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
        //服务器返回500
            if(reoponseData.statusCode == 500) {
                showTipDialog(@"服务器异常");
        }
        
        if (failure) {
            failure(error);
        }
        
        //        //格式化服务器报错信息
        //
        //            NSDictionary*serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        //        if([serializedData isKindOfClass:[NSDictionary class]]&&[reoponseData isKindOfClass:[NSHTTPURLResponse class]]) {
        //            NSString*data = [serializedData objectForKey:@"data"];
        //            NSString*errStr = [NSString stringWithFormat:@"---请求失败----\n code：%ld \nInfo:%@",reoponseData.statusCode,data];
        //            NSLog(@"---请求失败--- code：%ld ---Info:%@",reoponseData.statusCode,data);
        //        }
    }];
}



+ (void)POSTWithSession:(AFHTTPSessionManager *)session URLString:(NSString *)URLString parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {
    
    // 设置token
    NSString *headerToken = nil;
    if ([CommonFunction getUserToken].length) {
        headerToken = [NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]];
    }
    
    // 拼接url
    if (![URLString hasPrefix:@"/"]) {
        URLString = [NSString stringWithFormat:@"/%@", URLString];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, URLString];
    
    if (session) {
        [AFNetworkTool customSessionPostWithSession:session header:headerToken url:url parameters:parameters success:^(id responseObject) {
            // 检查状态
            BOOL needLogin = [self checkServerState:responseObject];
            
            BOOL needNoLoginCallBack = [self needNoLoginCallBack:parameters];
            if (needNoLoginCallBack && needLogin) {
                success(responseObject);
                return;
            }
            
            if (success && !needLogin) {
                success(responseObject);
            }
            
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }else{
        [AFNetworkTool tb_postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
            
            // 检查状态
            BOOL needLogin = [self checkServerState:responseObject];
            
            BOOL needNoLoginCallBack = [self needNoLoginCallBack:parameters];
            if (needNoLoginCallBack && needLogin) {
                success(responseObject);
                return;
            }
            
            if (success && !needLogin) {
                success(responseObject);
            }
            
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}




+ (void)POST:(NSString *)URLString  baseUrl:(NSString *)baseUrl parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 设置token
    NSString *headerToken = nil;
    if ([CommonFunction getUserToken].length) {
        headerToken = [NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]];
    }
    // 拼接url
    if (![URLString hasPrefix:@"/"]) {
        URLString = [NSString stringWithFormat:@"/%@", URLString];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl, URLString];
    
    [AFNetworkTool tb_postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        // 检查状态
        BOOL needLogin = [self checkServerState:responseObject];
        
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        if (success && !needLogin) {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        //showTipDialog(error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}


/**
 检查状态
 
 @param responseObject 回馈对象
 */
+ (BOOL)checkServerState:(id)responseObject {
    
    BOOL needLogin = NO;
    NSString *statusCode = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
    
#warning TODO
    //    if (HKIsDebug) {
    //        if ([statusCode isEqualToString:@"0"]) {
    //            NSString *desc = [responseObject description];
    //            NSLog(@"%@", [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);
    //            showTipDialog(desc);
    //        }
    //    }
    
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        // 非json数据
    }
    
    // 输出错误信息 -1为重新登录
    if (responseObject[@"msg"] && ![statusCode isEqualToString:@"1"] && ![statusCode isEqualToString:@"-1"] && ![statusCode isEqualToString:@"1001"]
        &&  ![statusCode isEqualToString:@"-2"]&& ![statusCode isEqualToString:@"(null)"] && ![statusCode isEqualToString:@"0"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            showTipDialog([NSString stringWithFormat:@"%@", responseObject[@"msg"]]);
        });
    }
    
    // 需要登录 登录过期
    if (responseObject[@"code"] && ([statusCode isEqualToString:@"-1"] ||  [statusCode isEqualToString:@"401"])){
        if (isLogin()) {
            signOut();//退出
            dispatch_async(dispatch_get_main_queue(), ^{
                [HKLoginTool setResetLoginAlertWithContent:TIME_OUT_LOGIN];
            });
            needLogin = YES;
        }else{
            needLogin = YES;
            //            [HKLoginTool pushLoginVC];
        }
    }
    
    if (responseObject[@"code"] && [statusCode isEqualToString:@"1001"]) {
        [HKLoginTool setResetLoginAlertWithContent:REMOTE_LOGIN];
        needLogin = YES;
    }
    
    if (responseObject[@"code"] && [statusCode isEqualToString:@"40001"]) {
        //服务器维护
        dispatch_async(dispatch_get_main_queue(), ^{
            showTipDialog([NSString stringWithFormat:@"%@", responseObject[@"msg"]]);
        });
    }
    
    if ([statusCode isEqualToString:@"-2"]) {
        // vip 受限
        [HKLoginTool vipRestrictDialog];
    }
    
    return needLogin;
}


/**
 检查状态
 
 @param responseObject 回馈对象
 */
+ (BOOL)checkNeedTermination:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSString *statusCode = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
        if ([statusCode isEqualToString:@"40002"]) {
            showTipDialog(responseObject[@"msg"]);
            [HKProgressHUD hideHUD];
            return YES;
        }
    }
    return NO;
}


+ (NSURLSessionDataTask *)hk_taskPost:(NSString *)URLString
                               allUrl:(NSString *)allUrl
                                isGet:(BOOL)isGet
                           parameters:(id)parameters
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    
    // 设置token
    NSString *headerToken = nil;
    if ([CommonFunction getUserToken].length) {
        headerToken = [NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]];
    }
    // 拼接url
    if (![URLString hasPrefix:@"/"]) {
        URLString = [NSString stringWithFormat:@"/%@", URLString];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, URLString];
    
    if (!isEmpty(allUrl)) {
        url = allUrl;
    }
    
    NSURLSessionDataTask *sessionTask =  [AFNetworkTool sessionPostWithHeader:headerToken url:url isGet:isGet parameters:parameters success:^(id responseObject) {
        // 检查状态
        BOOL needLogin = NO;
        
        if (isGet) {
            // get 请求不去验证有效行，由于搜索联想词接口 是PC程序员写的 code = 200 (与APP 接口的Code = 1 的判读逻辑不一样)
            needLogin = NO;
        }else{
            needLogin = [self checkServerState:responseObject];
        }
        
        BOOL needNoLoginCallBack = [self needNoLoginCallBack:parameters];
        
        
        
        if (needNoLoginCallBack && needLogin) {
            success(responseObject);
            return ;
        }
        
        if (success && !needLogin) {
            success(responseObject);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    return sessionTask;
}







/**
 未登录状态 回调 到 VC
 
 @param parameters  字典  (key : needNoLoginCallBack)
 @return
 */

+ (BOOL)needNoLoginCallBack:(id)parameters {
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        if([[parameters allKeys] containsObject:HKneedNoLoginCallBack]) {
            return YES;
        }
    }
    return NO;
}

//+ (void)needsRefreshAccess_token:(id)responseObject  resultBlock:(void(^)(BOOL needRefresh))resultBlock{
//    NSString *statusCode = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
//    if (responseObject[@"code"] && [statusCode isEqualToString:@"-1"]) {
//        if ([HKAccountTool shareAccount].refresh_token.length) {
//            NSLog(@"USERR_TOKEN=====");
//            [HKHttpTool POST:@"user/refresh-access-token" parameters:@{@"refresh_token":[HKAccountTool shareAccount].refresh_token} success:^(id responseObject) {
//                if ([CommonFunction detalResponse:responseObject]) {
//                    NSString * access_token = responseObject[@"data"][@"access_token"];
//                    NSString * refresh_token = responseObject[@"data"][@"refresh_token"];
//                    if (access_token.length && refresh_token.length) {
//                        [HKAccountTool saveAccountToken:access_token andRefresh_token:refresh_token];
//                        if (resultBlock) {
//                            resultBlock(YES);
//                        }
//                    }else{
//                        signOut();//退出
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [HKLoginTool setResetLoginAlertWithContent:TIME_OUT_LOGIN];
//                        });
//                        if (resultBlock) {
//                            resultBlock(NO);
//                        }
//                    }
//                }else{
//                    signOut();//退出
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [HKLoginTool setResetLoginAlertWithContent:TIME_OUT_LOGIN];
//                    });
//                    if (resultBlock) {
//                        resultBlock(NO);
//                    }
//                }
//            } failure:^(NSError *error) {
//                if (resultBlock) {
//                    resultBlock(NO);
//                }
//            }];
//        }else{//老用户升级过来可能存在
//            signOut();//退出
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [HKLoginTool setResetLoginAlertWithContent:TIME_OUT_LOGIN];
//            });
//            if (resultBlock) {
//                resultBlock(NO);
//            }
//        }
//    }else{
//        if (resultBlock) {
//            resultBlock(NO);
//        }
//    }
//}


// 字典转json字符串方法

+ (NSString *)jsonStringWithDict:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSURLSessionDataTask *)hk_taskGetUrl:(NSString *)URLString
                           parameters:(id)parameters
                              success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure{
    // 设置token
    NSString *headerToken = nil;
    if ([CommonFunction getUserToken].length) {
        headerToken = [NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]];
    }
//    [AFNetworkTool httpSessionManager].responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *sessionTask =  [AFNetworkTool sessionPostWithHeader:headerToken url:URLString isGet:YES parameters:parameters success:^(id responseObject) {
        // 检查状态 get 请求不去验证有效行，由于搜索联想词接口 是PC程序员写的 code = 200 (与APP 接口的Code = 1 的判读逻辑不一样)
        if (success) {
            success(responseObject);
        }
                
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    return sessionTask;
    
}



@end
