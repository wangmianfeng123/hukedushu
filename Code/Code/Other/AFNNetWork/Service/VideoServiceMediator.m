//
//  VideoServiceMediator.m
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "VideoServiceMediator.h"
#import "AFNetworkTool.h"
#import "BaseUrl.h"
#import "RequestUrl.h"
#import "CommonFunction.h"

/*
 从API的v1.3版本开始，每次接口请求都得在header上带上下面两个参数
 app_type：1-安卓  2-IOS   api_version：api版本号
 */


@implementation VideoServiceMediator

+ (VideoServiceMediator *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static VideoServiceMediator *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[VideoServiceMediator alloc] init];
    });
    return instance;
}



#pragma mark - 获取视频评论接口  score-星级评价，数值即星级数 difficult：教程难度，1太简单，2简单，3难度适中，4有点难，5太难了
- (void)getVideoComment:(NSString *)token
                videoId:(NSString *)videoId
                   page:(NSString *)page
              only_type:(NSString *)typeString
             completion:(void (^)(FWServiceResponse *response))completion
              failBlock:(Failure)failBlock {
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setSafeObject:videoId forKey:@"video_id"];
    [parameters setSafeObject:page forKey:@"page"];
    [parameters setSafeObject:typeString forKey:@"type"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,GET_VIDEO_COMMENT];
    NSString *headerToken = nil;
    if (!isEmpty(token)) {
        headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    }
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






#pragma mark - 提交评论     score * 星级评价，数值即星级数，数值区间为1-5  难易程度：1太简单，2简单，3难度适中，4有点难，5太难了,数值区间为1-5
- (void)submitVideoComment:(NSString *)token
                   videoId:(NSString *)videoId
                     score:(NSString *)score
                 difficult:(NSString *)difficult
                   content:(NSString *)content
                completion:(void (^)(FWServiceResponse *response))completion
                 failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:videoId,@"video_id", score,@"score",difficult,@"difficult",content,@"content",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,SUBMIT_COMMENT];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    
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





#pragma mark - 视频评论点赞接口  

- (void)VideoPraise:(NSString *)token
          commentId:(NSString *)commentId
         completion:(void (^)(FWServiceResponse *response))completion
          failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:commentId,@"comment_id",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,VIDEO_PRAISE];
    NSString *headerToken = [NSString stringWithFormat:@"Bearer-%@",token];
    
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







#pragma mark - 获取列表页标签
- (void)getVideoTagList:(NSString *)className
             completion:(void (^)(FWServiceResponse *response))completion
              failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:className,@"class_id",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,VIDEO_TAG_LIST];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}





#pragma mark -  分类 视频列表  筛选 视频  排序：0-默认 1-最新 2-热度 3-最简单 4-最难  has_pictext 1-只看图文 0-都看

- (void)filterVideoListWithClass:(NSString *)className
                            sort:(NSString *)sort
                            page:(NSString *)page
                            tags:(NSDictionary *)tagDic
                      completion:(void (^)(FWServiceResponse *response))completion
                       failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,CLASS_VIDEO_LIST];
    NSMutableDictionary  *parameters = [NSMutableDictionary new];
    [parameters setValue:className forKey:@"class_id"];
    [parameters setValue:sort forKey:@"sort"];
    [parameters setValue:page forKey:@"page"];
    
    if (tagDic.count) {
        
        NSArray * keyArray = [tagDic allKeys];
        for (NSString * key in keyArray) {
            NSString * value = [tagDic objectForKey:key];
            if (key.length) {
                
                [parameters setValue:value forKey:key];
            }
        }
    }
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}



#pragma mark - 回复评论
- (void)replayComment:(NSString *)commentId
              content:(NSString *)content
                 type:(NSString *)type
           completion:(void (^)(FWServiceResponse *response))completion
            failBlock:(Failure)failBlock {
    
    //type 1-回复一级评论 2-回复二级评论
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:commentId,@"comment_id",content,@"content",type,@"type",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,VIDEO_COMMENT_REPLAY];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}



#pragma mark - 获取单条评论和当前评论的回复内容接口
- (void)getSingleCommentInfo:(NSString *)commentId
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:commentId,@"comment_id",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,GET_SIGLE_COMENT_REPLY];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        FWServiceResponse *serviceResponse = [[FWServiceResponse alloc]init];
        serviceResponse.code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        serviceResponse.msg =  [responseObject objectForKey:@"msg"];
        serviceResponse.data = [responseObject objectForKey:@"data"];
        completion(serviceResponse);
        
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}


#pragma mark - 删除评论
- (void)deleteVideoCommentInfo:(NSString *)commentId
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:commentId,@"comment_id",nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,VIDEO_DELETE_COMMENT];
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        completion([[FWServiceResponse alloc]initWithJsonData:responseObject]);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}




#pragma mark -  合集列表 排序 筛选  排序：0-默认 1-收藏人数 2-教程数量 3-创建时间
- (void)filterAlbumListWithSort:(NSString *)sort
                           page:(NSString *)page
                           tag1:(NSString *)tag1
                           tag2:(NSString *)tag2
                           tag3:(NSString *)tag3
                           tag4:(NSString *)tag4
                     completion:(void (^)(FWServiceResponse *response))completion
                      failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,ALBUM_INDEX];
    NSMutableDictionary  *parameters = [NSMutableDictionary new];
    
    [parameters setValue:sort forKey:@"sort"];
    [parameters setValue:page forKey:@"page"];
    
    if (!isEmpty(tag1)) {//class_id
        [parameters setValue:tag1 forKey:@"class_id"];
    }
    
    if (!isEmpty(tag2)) {
        [parameters setValue: tag2 forKey:@"class_id"];
    }
    
    if (!isEmpty(tag3)) {
        [parameters setValue:tag3 forKey:@"class_id"];
    }
    
    if (!isEmpty(tag4)) {
        [parameters setValue:tag4 forKey:@"class_id"];
    }
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        completion([[FWServiceResponse alloc]initWithJsonData:responseObject]);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

+ (void)test:(NSString *)url
  parameters:(NSDictionary *)parameters
  completion:(void (^)(FWServiceResponse *response))completion
   failBlock:(Failure)failBlock {
    
    [AFNetworkTool postWithHeader:nil url:url parameters:parameters success:^(id responseObject) {
        completion([[FWServiceResponse alloc]initWithJsonData:responseObject]);
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

@end
