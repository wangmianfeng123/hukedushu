//
//  CategoryServiceMediator.m
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "CategoryServiceMediator.h"
#import "AFNetworkTool.h"
#import "BaseUrl.h"
#import "RequestUrl.h"
#import "CommonFunction.h"

@implementation CategoryServiceMediator

+ (CategoryServiceMediator *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static CategoryServiceMediator *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[CategoryServiceMediator alloc] init];
    });
    return instance;
}



#pragma mark -  //软件入门(学习路径)列表页
- (void)softwareList:(void (^)(FWServiceResponse *response))completion failBlock:(Failure)failBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,VIDEO_STUDY_TOUTE];
    
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


#pragma mark - //系列课列表页
- (void)seriseCourseListWithClassId:(NSString*)classId  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,VIDEO_SERIES_LESSON];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:classId,@"class_id",nil];
    
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
