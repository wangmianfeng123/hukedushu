//
//  HomeServiceMediator.m
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HomeServiceMediator.h"
#import "AFNetworkTool.h"
#import "BaseUrl.h"
#import "RequestUrl.h"
#import "CommonFunction.h"
#import "UIDeviceHardware.h"

@implementation HomeServiceMediator


+ (HomeServiceMediator *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static HomeServiceMediator *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[HomeServiceMediator alloc] init];
    });
    return instance;
}





#pragma mark - 首页
- (void)homeData:(void (^)(FWServiceResponse *response))completion
       failBlock:(Failure)failBlock {
    
    //type：banner类型，1-H5页面 2-视频详情页 3-列表页 4-VIP页
    //NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/home/index"];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:nil success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg  = [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}



#pragma mark - 首页推荐教程换一批接口
- (void)homeRecommendeCourse:(NSString *)page
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,HOME_RECOMMENG_COURSE];
    
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



#pragma mark - n获取首页最新教程翻页数据列表
- (void)homeNewCourse:(NSString *)page
             video_ids:(NSString *)exclude_vide_ids
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock {
    
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",nil];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setSafeObject:exclude_vide_ids forKey:@"exclude_video_ids"];
    [parameters setSafeObject:page forKey:@"page"];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,HOME_NEW_COURSE];
    
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



#pragma mark - 统计banner点击次数
- (void)recordBannerClickCount:(NSString *)bannerId
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:bannerId,@"banner_id",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,HOME_BANNER_CLICK];
    
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




#pragma mark -  用于统计登录次数。 一天记录一次
- (void)recordLoginCount:(NSString *)token
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,LOGIN_STATS];
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

#pragma mark - 新增设备数和活跃设备数统计
- (void)newDeviceAndActiveUser:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock {
    
    NSString *device_num = [CommonFunction getUUIDFromKeychain]; //[CommonFunction getUUIDString];
    NSString *system_version = [[UIDevice currentDevice] systemVersion];//系统版本
    NSString *device_brand = [[UIDevice currentDevice] model];
    NSString *device_model = [[UIDeviceHardware new]platformString];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:device_num,@"device_num", system_version,@"system_version",device_brand,@"device_brand",device_model,@"device_model",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,STATS_DEVICE_STATS];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        completion([[FWServiceResponse alloc]initWithJsonData:responseObject]);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}



#pragma mark - 广告位 和 banner 点击次数 统计
- (void)advertisClickCount:(NSString*)adId {
    if (isEmpty(adId)) {
        return;
    }
    [HKHttpTool POST:ADVERTISING_STATIC_AD_CLICKS parameters:@{@"id":adId} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}



@end
