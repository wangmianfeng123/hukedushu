

//
//  AFNetworkTool.m
//  AFNetText2.5
//
//  Created by wxxu on 15/1/27.
//  Copyright (c) 2015年 wxxu. All rights reserved.
//

#import "AFNetworkTool.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "AppDelegate.h"
#import "HKVersionModel.h"
#import "HkChannelData.h"
#import "AES128Helper.h"

@implementation AFNetworkTool
@synthesize content;


#define APP_defalut_channel   @"hukeAPP"

#define APP_channel   @"channel"

#define APP_channel_xhs   @"xhs"

#define APP_idfa   @"app-idfa"
#define APP_caid   @"app-caid"
#define APP_clickid  @"app-clickid"

#define APP_caid_md5  @"app-caid_md5"
#define APP_paid  @"app-paid"

#define APP_night   @"is-night"





static AFHTTPSessionManager * _manager;



+ (AFHTTPSessionManager*)httpSessionManager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [[self class]setRequestSerializer:manager];
    return manager;
}



+ (void)setRequestSerializer:(AFHTTPSessionManager *)sessionManager {
    // 设置请求的超时时间
    
    sessionManager.requestSerializer.timeoutInterval = 10;
    //app_type：1-安卓  2-IOS   api_version：api版本号
    [sessionManager.requestSerializer setValue:APP_TYPE forHTTPHeaderField:@"app-type"];
    [sessionManager.requestSerializer setValue:API_VERSION forHTTPHeaderField:@"api-version"];
    
    //manager.requestSerializer.HTTPShouldHandleCookies = YES;
    
    // 是否为 
    [sessionManager.requestSerializer setValue:STRING_TABLET forHTTPHeaderField:@"is-tablet"];
    
    
    NSMutableDictionary * headerDic = [NSMutableDictionary dictionary];
    NSString *idfa = [CommonFunction getIDFAString];
    [headerDic setSafeObject:idfa forKey:APP_idfa];
    
    NSString *caid = [CommonFunction getCAIDString];
    [headerDic setSafeObject:caid forKey:APP_caid];
    
    NSString * device_id = [CommonFunction getUUIDFromKeychain];
    [headerDic setSafeObject:device_id forKey:DEVICE_NUM];
    

    if ([headerDic allKeys].count > 0) {
        
        NSError *error;
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:headerDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        
        NSData *data = [[NSData alloc]initWithBase64EncodedString:@"aHVrZTIwMjEwNzIyMjE0Nw==" options:NSDataBase64DecodingIgnoreUnknownCharacters];
        if(data == nil) return;
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        NSString *decrStr = [AES128Helper aesEncrypt:jsonString key:string];
        
        if (!isEmpty(decrStr)) {
            [sessionManager.requestSerializer setValue:decrStr forHTTPHeaderField:@"sign-info"];
        }
    }
    NSString * paid = [CommonFunction getXHSpaid];
    [sessionManager.requestSerializer setValue:[CommonFunction getXHSpaid] forHTTPHeaderField:APP_paid];
    
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
}


/** 加密字符串 */
+ (void)setSessionSecurityWithParam:(NSDictionary *)param path:(NSString *)path  sessionManager:(AFHTTPSessionManager *)sessionManager {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setSafeObject:@"device-num" forKey:@"device-num"];
    [dic addEntriesFromDictionary:param];
    //按字母顺序排序
    NSArray *keys = [dic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 8];
    for (NSInteger i = 0; i < 8; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    NSString * privateKey = @"o71orZ8cb8Y7STSa";
    
    
    NSString * md5Key =@"";
    for (NSString * key in sortedArray) {
        md5Key = [NSString stringWithFormat:@"%@%@=%@&",md5Key,key,randomString];
    }
    
    NSString *stringMD5 = [NSString md5:md5Key];
    NSString * nwStr = [NSString stringWithFormat:@"%@%@",stringMD5,privateKey];
    NSString * sign = [NSString md5:nwStr];
    
    
    
    [sessionManager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
    [sessionManager.requestSerializer setValue:randomString forHTTPHeaderField:@"nonce-str"];
    
    // 是否为黑暗模式
    //is_night  1为夜间模式 0为非夜间模式
    if (@available(iOS 13.0, *)) {
        DMUserInterfaceStyle mode = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
        BOOL isHKNight = (DMUserInterfaceStyleDark == mode) ? YES :NO;
        [sessionManager.requestSerializer setValue:isHKNight ?@"1" :@"0" forHTTPHeaderField:APP_night];
    }
}




/** 配置https */
+ (AFSecurityPolicy *)setSecurityPolicy {
    /** https */
    NSString*cerPath = [[NSBundle mainBundle] pathForResource:@"huke88.cer" ofType:nil];
    NSData*cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet*set = [[NSSet alloc] initWithObjects:cerData,nil];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone withPinnedCertificates:set];
    [policy setValidatesDomainName:NO]; //是否需要验证域名，默认为YES；
    [policy setAllowInvalidCertificates:YES]; //允许无效证书
    return policy;
}




/** 设置token 和安全协议*/
+ (void)setSessionToken:(NSString*)token sessionManager:(AFHTTPSessionManager *)sessionManager {
    // 设置安全协议
    if ([BaseUrl hasPrefix:@"https"]) {
        /*************** https *******************/
        sessionManager.securityPolicy = [self setSecurityPolicy];
    }else {
        sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    
    // 设置token
    if ([CommonFunction getUserToken].length) {
        [sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]] forHTTPHeaderField:USERR_TOKEN];
    }else {
        [sessionManager.requestSerializer setValue:token forHTTPHeaderField:USERR_TOKEN];
    }
    NSLog(@"USERR_TOKEN=====%@",[NSString stringWithFormat:@"Bearer-%@",[CommonFunction getUserToken]]);
}



/** 设置渠道 （广告推广渠道 用于后台统计）*/
+ (void)setSessionChannel:(AFHTTPSessionManager *)sessionManager {
    if (!isEmpty([HKInitConfigManger sharedInstance].channel)) {
        
        if ([[HKInitConfigManger sharedInstance].channel isEqualToString:APP_defalut_channel]) {
            /// 默认渠道 不统计
            NSString *nullStr = @" ";
            [sessionManager.requestSerializer setValue:nullStr forHTTPHeaderField:APP_channel];
        }else{
            [sessionManager.requestSerializer setValue:[HKInitConfigManger sharedInstance].channel forHTTPHeaderField:APP_channel];
        }
        [sessionManager.requestSerializer setValue:[CommonFunction getCAIDString]  forHTTPHeaderField:APP_caid];
        
        [sessionManager.requestSerializer setValue:[CommonFunction getIDFAString] forHTTPHeaderField:APP_idfa];
        
        if(!isEmpty([CommonFunction getXHSClickid])){
            [sessionManager.requestSerializer setValue:[CommonFunction getXHSClickid] forHTTPHeaderField:APP_clickid];
        }
        
        if(!isEmpty([CommonFunction getXHScaid_md5])){
            [sessionManager.requestSerializer setValue:[CommonFunction getXHScaid_md5] forHTTPHeaderField:APP_caid_md5];
        }
    }
}



+ (AFHTTPSessionManager *)tb_shareManager:(NSString*)token param:(NSDictionary *)param path:(NSString *)path {
    
    if (nil== _manager) {
        _manager = [[self class]httpSessionManager];
    }
    BOOL isloadMiddleIconData = [[NSUserDefaults standardUserDefaults] boolForKey:@"loadMiddleIconData"];
    if (isloadMiddleIconData) {
        _manager.requestSerializer.timeoutInterval = 2;
    }else{
        _manager.requestSerializer.timeoutInterval = 10;
    }
    
    [[self class]setSessionChannel:_manager];
    [[self class]setSessionToken:token sessionManager:_manager];
    [[self class]setSessionSecurityWithParam:param path:path sessionManager:_manager];
    return _manager;
}



+ (AFHTTPSessionManager *)customSessionManager:(NSString*)token param:(NSDictionary *)param path:(NSString *)path session:(AFHTTPSessionManager *)session {
    
    if (session) {
        [[self class]setRequestSerializer:session];
        [[self class]setSessionChannel:session];
        [[self class]setSessionToken:token sessionManager:session];
        [[self class]setSessionSecurityWithParam:param path:path sessionManager:session];
    }
    
    return session;
}




+ (void)customSessionPostWithSession:(AFHTTPSessionManager *)session
                              header:(NSString *)header
                                 url:(NSString*)url
                          parameters:(NSDictionary *)parameters
                             success:(Success)success
                             failure:(Failure)failure  {
    [[[self class ] customSessionManager:header param:parameters path:url session:nil] POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}





/**
 *  封装的post请求  请求头 中带有用户 token
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param fail       请求失败回调
 */
+ (void)postWithHeader:(NSString *)header url:(NSString*)url parameters:(NSDictionary *)parameters
               success:(Success)success failure:(Failure)failure {
    
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];// 打开状态栏的等待菊花
        });
    }else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];// 打开状态栏的等待菊花
    }
    
    [[self tb_shareManager:header param:parameters path:url] POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //关闭状态栏动画
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        // 检查状态
        BOOL needLogin = [HKHttpTool checkServerState:responseObject];
        //success && !needLogin ? success(responseObject) : nil;
        
        if ([HKHttpTool checkNeedTermination:responseObject] == NO) {
            
            if (success) {
                success(responseObject);
            }
            //success && !needLogin ? success(responseObject) : nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];  //关闭状态栏动画
        failure ? failure(error) : nil;
    }];
}







+ (void)tb_postWithHeader:(NSString *)header url:(NSString*)url parameters:(NSDictionary *)parameters
                  success:(Success)success failure:(Failure)failure {
    [[self tb_shareManager:header param:parameters path:url] POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([HKHttpTool checkNeedTermination:responseObject] == NO) {
            success ? success(responseObject) : nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    
}



+ (NSURLSessionDataTask*)sessionPostWithHeader:(NSString *)header
                                           url:(NSString*)url
                                         isGet:(BOOL)isGet
                                    parameters:(NSDictionary *)parameters
                                       success:(Success)success
                                       failure:(Failure)failure {
    
    
    NSURLSessionDataTask *sessionDataTask = nil;
    if (isGet) {
        
        sessionDataTask  =  [[self tb_shareManager:header param:parameters path:url] GET:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([HKHttpTool checkNeedTermination:responseObject] == NO) {
                success ? success(responseObject) : nil;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure ? failure(error) : nil;
        }];
        
    }else{
        sessionDataTask  =  [[self tb_shareManager:header param:parameters path:url] POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([HKHttpTool checkNeedTermination:responseObject] == NO) {
                success ? success(responseObject) : nil;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure ? failure(error) : nil;
        }];
    }
    
    
    
    [sessionDataTask resume];
    return sessionDataTask;
}



@end











