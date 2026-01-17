//
//  FWNetWorkServiceMediator.m
//  FamousWine
//
//  Created by pg on 15/12/4.
//  Copyright © 2015年 pg. All rights reserved.
//

#import "FWNetWorkServiceMediator.h"
#import "AFNetworkTool.h"
#import "BaseUrl.h"
#import "RequestUrl.h"
#import "CommonFunction.h"

@implementation FWNetWorkServiceMediator


+ (FWNetWorkServiceMediator *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static FWNetWorkServiceMediator *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[FWNetWorkServiceMediator alloc] init];
    });
    return instance;
}

#pragma mark - 三方登陆   RegisterForm[client]  注册方式 [1:QQ,2:微信,3:微博]
- (void)loginWithUserId:(NSString*)username
                 avator:(NSString*)avator
                 openid:(NSString*)openid
                unionid:(NSString*)unionid
                 client:(NSString*)client
           registerType:(NSString*)registerType
             jsonString:(NSString*)string
             completion:(void (^)(FWServiceResponse *response))completion
              failBlock:(Failure)failBlock {
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setSafeObject:(username.length? username : @"") forKey:@"username"];
    [parameter setSafeObject:avator forKey:@"avator"];
    [parameter setSafeObject:(openid.length ?openid: unionid) forKey:@"openid"];
    [parameter setSafeObject:unionid forKey:@"unionid"];
    [parameter setSafeObject:client forKey:@"client"];
    [parameter setSafeObject:@"2" forKey:@"register_type"];
    [parameter setSafeObject:string forKey:@"userJson"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,USER_REGISTER];
    [AFNetworkTool postWithHeader:nil url:url parameters:parameter success:^(id responseObject) {
        
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



#pragma mark - 获取收藏视频列表
- (void)getCOllectionVideoListWithToken:(NSString *)token
                                pageNum:(NSString *)pageNum
                            collectType:(NSString*)collectType
                             completion:(void (^)(FWServiceResponse *response))completion
                              failBlock:(Failure)failBlock {
    
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:pageNum,@"page",collectType,@"type",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,USER_COLLECTION_VIDEO];
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

#pragma mark - 用户主页的评论，消息列表
- (void)userInfoNotificationWithToken:(NSString *)token
                                 page:(NSString *)page
                           completion:(void (^)(FWServiceResponse *response))completion
                            failBlock:(Failure)failBlock {
    
    NSDictionary *param = @{@"page" : page};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, USER_INFO_Comment];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    [AFNetworkTool postWithHeader:headerToken url:url parameters:param success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

#pragma mark - 用户获取抽奖信息
- (void)userLuckyNotificationWithToken:(NSString *)token
                            completion:(void (^)(FWServiceResponse *response))completion
                             failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, @"/activity/sign"];
    NSString *headerToken = token.length? [NSString stringWithFormat:@"Bearer-%@",token] : nil;
    [AFNetworkTool postWithHeader:headerToken url:url parameters:nil success:^(id responseObject) {
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

#pragma mark - 用户完成抽奖信息
- (void)userFinishLuckyNotificationWithToken:(NSString *)token gold:(NSString *)gold
                                  completion:(void (^)(FWServiceResponse *response))completion
                                   failBlock:(Failure)failBlock {
    NSDictionary *dic = @{@"gold" : gold};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, @"/activity/prize-draw"];
    NSString *headerToken = token.length? [NSString stringWithFormat:@"Bearer-%@",token] : nil;
    [AFNetworkTool postWithHeader:headerToken url:url parameters:dic success:^(id responseObject) {
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

- (void)userFollowsWithToken:(NSString *)token
                        page:(NSString *)page
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock {
    
    NSDictionary *param = @{@"page" : page};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, USER_INFO_FOLLOWS];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    [AFNetworkTool postWithHeader:headerToken url:url parameters:param success:^(id responseObject) {
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



#pragma mark - 获取已经学习视频列表
- (void)getStudyVideoListWithToken:(NSString *)token
                           pageNum:(NSString *)pageNum
                         videoType:(NSString*)videoType
                        completion:(void (^)(FWServiceResponse *response))completion
                         failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:pageNum,@"page",videoType,@"type",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,USER_ALREADY_STUDY];
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




/**
 查询系统版本
 
 @return
 */
- (void)getSystemVersion:(void (^)(FWServiceResponse *response))completion
               failBlock:(Failure)failBlock {
    
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"type",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,SYSTEM_VERSION];
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        
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



#pragma mark - 分类列表  1-普通分类 2-软件入门 3-系列课
- (void)getCategoryListWithToken:(NSString *)token
                      completion:(void (^)(FWServiceResponse *response))completion
                       failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,CATEGORY_INDEX];
    NSString *headerToken = nil;
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:nil success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}





#pragma mark - 收藏 取消 收藏视频  type-- 收藏状态  videoType --  视频类型  PGC 课必须传视频类型
- (void)collectOrQuitVideoWithToken:(NSString *)token
                            videoId:(NSString *)videoId
                               type:(NSString *)type
                          videoType:(HKVideoType)videoType
                   postNotification:(BOOL)postNotification
                         completion:(void (^)(FWServiceResponse *response))completion
                          failBlock:(Failure)failBlock {
    
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:videoId,@"video_id", type,@"type",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,(videoType == HKVideoType_PGC) ?PGC_COLLECT :COLLECT_VIDEO];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
        // 发通知刷新收藏页面
        if (postNotification) {
            [[NSNotificationCenter defaultCenter] postNotificationName:HKCollectionVCRefreshNotification object:nil];
        }
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

#pragma mark - 关注或取消 教师  1已关注，0未关注

- (void)followTeacherVideoWithToken:(NSString *)token
                          teacherId:(NSString *)teacherId
                               type:(NSString *)type
                         completion:(void (^)(FWServiceResponse *response))completion
                          failBlock:(Failure)failBlock {
    
    //type- 当前的关注状态
    if (!teacherId.length) return;
    NSDictionary *param = @{@"teacher_id": teacherId,@"type": type};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, FOLLOW_TEACHER];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:param success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
    
}

#pragma mark - 发送验证码
- (void)getAuthCodeWithPhone:(NSString *)phone
                        type:(NSString *)type //短信类型：type:@"1" 1-绑定手机号 2-(1-注册 2-验证手机号)
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock {
    
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",type,@"type",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseUrl,SEND_MESSAGE];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        serviceResponse.code = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[responseObject objectForKey:@"code"]]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}




#pragma mark - 手机验证码方式注册&登录
- (void)loginWithAuthCode:(NSString *)authCode
                    phone:(NSString *)phone
               completion:(void (^)(FWServiceResponse *response))completion
                failBlock:(Failure)failBlock {
    
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:authCode,@"code",phone,@"phone",@"2",@"register_type",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,PHONE_MESSAGE_LOGIN];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        
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

#pragma mark - 教师主页
- (void)teacherHomeWithToken:(NSString *)token
                   teacherId:(NSString *)teacherId page:(NSString *)page
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock {
    if (!teacherId.length) return;
    NSDictionary *parameters= @{@"teacher_id" : teacherId, @"page" : page};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, TEACHER_HOME];
    NSString *headerToken = token.length? [NSString stringWithFormat:@"Bearer-%@",token] : nil;
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

#pragma mark - 软件入门
- (void)solfwareStartToken:(NSString *)token
                   videoId:(NSString *)videoId
                 is_Series:(BOOL)isSeries
                completion:(void (^)(FWServiceResponse *response))completion
                 failBlock:(Failure)failBlock {
    
    NSDictionary *parameters= @{@"video_id" : videoId};
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, isSeries ? @"/series/get-dir":@"/video/get-route-dir"];
    NSString *headerToken = token.length? [NSString stringWithFormat:@"Bearer-%@",token] : nil;
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}


#pragma mark - 系列课
- (void)seriesCourseToken:(NSString *)token
                  videoId:(NSString *)videoId videoType:(NSString *)type
               completion:(void (^)(FWServiceResponse *response))completion
                failBlock:(Failure)failBlock {
    
    NSDictionary *parameters= @{@"video_id" : videoId, @"video_type" : @(type.intValue)};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl, @"/video/get-series-dir"];
    NSString *headerToken = token.length? [NSString stringWithFormat:@"Bearer-%@",token] : nil;
    
    [AFNetworkTool postWithHeader:headerToken url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
    
    
}





@end
