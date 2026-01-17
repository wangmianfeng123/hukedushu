//
//  UserInfoServiceMediator.m
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "UserInfoServiceMediator.h"
#import "AFNetworkTool.h"
#import "BaseUrl.h"
#import "RequestUrl.h"
#import "CommonFunction.h"
#import "UIDeviceHardware.h"

/*
从API的v1.3版本开始，每次接口请求都得在header上带上下面两个参数
app_type：1-安卓  2-IOS   api_version：api版本号
 */


@implementation UserInfoServiceMediator

+ (UserInfoServiceMediator *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static UserInfoServiceMediator *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[UserInfoServiceMediator alloc] init];
    });
    return instance;
}



#pragma mark - 提交留言
//comment_id    如果用户是从评论的举报入口进来的，需要带上评论ID
- (void)submitMessageWithToken:(NSString *)token
                       content:(NSString *)content
                            qq:(NSString *)qq
                    commentId:(NSString *)commentId
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock {
    
    NSString *system_version = [[UIDevice currentDevice] systemVersion];//系统版本
    NSString *device_brand = [[UIDevice currentDevice] model];
    NSString *device_model = [[UIDeviceHardware new]platformString];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content", qq,@"qq",system_version,@"system_version",device_brand,@"device_brand",device_model,@"device_model",(commentId.length? commentId :nil),@"comment_id",nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,USER_SUGGEST];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        serviceResponse.code = [numberFormatter stringFromNumber:[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}


#pragma mark - 绑定手机号
- (void)bingPhoneNum:(NSString *)phone
               token:(NSString *)token
                code:(NSString *)code
          completion:(void (^)(FWServiceResponse *response))completion
           failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone", code,@"code",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,USER_BIND_PHONE];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        serviceResponse.code = [numberFormatter stringFromNumber:[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}







#pragma mark - //获取搜索结果
- (void)searchListByWord:(NSString *)keyword
               token:(NSString *)token
                page:(NSString *)page
          completion:(void (^)(FWServiceResponse *response))completion
           failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword", page,@"page",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,SEARCH_INDEX];
    NSString *headerToken = nil;
    //    if (!isEmpty(token)) {
    //        headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    //    }
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        //NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        serviceResponse.code = [responseObject objectForKey:@"code"];//[numberFormatter stringFromNumber:[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}




#pragma mark - 播放 下载    is_vip：0-非VIP（不可下载） 1-限5VIP（不可下载） 2-全站VIP或分类无限VIP（可下载），is_paly：0-不可观看 1-可观看
- (void)seeAndDownloadByVideoId:(NSString *)videoId
                    VideoDetail:(DetailModel *)detailModel
                          videoType:(HKVideoType)videoType
                          token:(NSString *)token
                      searchkey:(NSString *)searchkey
                 searchIdentify:(NSString *)searchIdentify
                     completion:(void (^)(FWServiceResponse *response))completion
                      failBlock:(Failure)failBlock {
    
    NSString *deviceNum = [CommonFunction getUUIDFromKeychain];// add 0130 增加设备ID
    //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:videoId,@"video_id",deviceNum,@"device_num",nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:videoId forKey:@"video_id"];
    [parameters setValue:deviceNum forKey:@"device_num"];
    
    if (!isEmpty(searchkey)) {
        [parameters setValue:searchkey forKey:@"search_key"];
    }
    
    if (!isEmpty(searchIdentify)) {
        [parameters setValue:searchIdentify forKey:@"search_identify"];
    }
    
    
    NSString *url = nil;    NSString *headerToken = nil;
    
    if (APPSTATUS && !isLogin() && TOURIST_VIP_STATUS) {
        
        // 去除V5获取服务器url
        NSString *urlTemp = BaseUrl;
        NSRange range = [urlTemp rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *newURL = [[urlTemp substringToIndex:range.location] stringByAppendingString:@"/video/play-for-review"];
        url = newURL;
    }else{
        
        if (detailModel.video_id.length && detailModel.is_series) {
            url = [NSString stringWithFormat:@"%@%@",BaseUrl, @"/series/play"];
        }else{
            url = [NSString stringWithFormat:@"%@%@",(videoType == HKVideoType_PGC) ?BaseUrl :BaseUrl, (videoType == HKVideoType_PGC) ?PGC_PLAY :VIDEO_PLAY];
            if (videoType != HKVideoType_PGC && detailModel.is_home_recommend_video_play == YES) {
                [parameters setValue:@"1" forKey:@"is_home_recommend_video_play"];
            }
        }
        
        headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    }
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg  = [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}



#pragma mark - 获取用户VIP类型  0-非VIP 1-分类VIP 2-全站通VIP
- (void)getUserExtInfoCompletion:(void (^)(FWServiceResponse *response))completion
                      failBlock:(Failure)failBlock {
    NSString *token = [CommonFunction getUserToken];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/user/get-user-info"];
    NSString *headerToken = token.length? [NSString stringWithFormat:@"Bearer-%@",token] : nil;
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:nil success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        //NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        //serviceResponse.code = [numberFormatter stringFromNumber:[responseObject objectForKey:@"code"]];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg  = [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

#pragma mark - 获取用户VIP类型  0-非VIP 1-分类VIP 2-全站通VIP
- (void)checkUserVipType:(NSString *)token
              completion:(void (^)(FWServiceResponse *response))completion
               failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,GET_VIP_TYPE];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:nil success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg  = [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}




#pragma mark - 购买 VIP 订单生成接口2222
- (void)setVipOrderWithToken:(NSString *)token model:(HKBuyVipModel *)model
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,BULID_ORDER_NO];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (model.vip_type.length) {
        parameters[@"vip_type"] = model.vip_type;
    }
    if (model.button_type.length) {
        parameters[@"button_type"] = model.button_type;
    }
    
    if (model.prize_type.length) {
        parameters[@"prize_type"] = model.prize_type;
    }
    
    if (model.canAutoRenewal == 1) {
        parameters[@"is_renewal"] = @(1);
    }
    
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg  = [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}




#pragma mark - 验证VIP 是否购买 成功
- (void)checkReceiptIsValid:(NSString *)token
                    receipt:(NSString *)receipt
                   orederNo:(NSString *)orderNo setp:(NSString *)step
                 completion:(void (^)(FWServiceResponse *response))completion
                  failBlock:(Failure)failBlock {
    
    
    // 测试环境和正式环境
    NSString *url = nil;
//    if ([BaseUrl containsString:@"app-test"]) {
//        url = @"http://app-test.huke88.com/pay/verify-receipt";
//    } else {
//        url = @"https://api.huke88.com/pay/verify-receipt";
//    }
    
    if ([BaseUrl containsString:@"app-test"]) {
        url = @"http://app-test.huke88.com/pay/verify-receipt";
    } else if ([BaseUrl containsString:@"app-release"]){
        //预发布
        url = @"http://app-release.huke88.com/pay/verify-receipt";
    }else{
        url = @"https://api.huke88.com/pay/verify-receipt";
    }
    
    

    
    NSString *headerToken = nil;//[NSString stringWithFormat:@"Bearer-%@",token];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:receipt,@"receipt_data",orderNo,@"out_trade_no", step, @"pay_step_signal", nil];
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
    
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg  = [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}




#pragma mark - 验证判断IOS APP状态接口
- (void)checkAppStatus:(void (^)(FWServiceResponse *response))completion failBlock:(Failure)failBlock {
    
    // 去除V5获取服务器url
    NSString *url = BaseUrl;
    NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *newURL = [[url substringToIndex:range.location] stringByAppendingString:@"/site/get-status"];
    
    [AFNetworkTool postWithHeader:nil url:newURL parameters:nil success:^(id responseObject) {

        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.msg  =  [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        serviceResponse.password  =  [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"password"]];
        completion(serviceResponse);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}



#pragma mark - 下载视频
- (void)downloadWithVideoId:(NSString *)videoId
                videoType:(HKVideoType)videoType
                searchkey:(NSString *)searchkey
           searchIdentify:(NSString *)searchIdentify
               completion:(void (^)(FWServiceResponse *response))completion
                failBlock:(Failure)failBlock {
    
    NSString *deviceNum = [CommonFunction getUUIDFromKeychain];// add 0130 增加设备ID
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:videoId forKey:@"video_id"];
    [parameters setValue:deviceNum forKey:@"device_num"];
    
    if (!isEmpty(searchkey)) {
        [parameters setValue:searchkey forKey:@"search_key"];
    }
    if (!isEmpty(searchIdentify)) {
        [parameters setValue:searchIdentify forKey:@"search_identify"];
    }
    
    NSString *url = nil;
    if (APPSTATUS && !isLogin() && TOURIST_VIP_STATUS) {
        // 去除V5获取服务器url
        NSString *urlTemp = BaseUrl;
        NSRange range = [urlTemp rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *newURL = [[urlTemp substringToIndex:range.location] stringByAppendingString:@"/video/play-for-review"];
        url = newURL;
    }else{
        url = [NSString stringWithFormat:@"%@%@",(videoType == HKVideoType_PGC) ?BaseUrl :BaseUrl, (videoType == HKVideoType_PGC) ?PGC_PLAY :VIDEO_DOWNLOAD];
    }
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg  = [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}


@end
