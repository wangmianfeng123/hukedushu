//
//  HomeServiceMediator.h
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWServiceResponse.h"

typedef void (^ Failure)(NSError *error);        // 失败Blcok

@interface HomeServiceMediator : NSObject

+ (HomeServiceMediator *)sharedInstance;

#pragma mark - 首页
- (void)homeData:(void (^)(FWServiceResponse *response))completion
       failBlock:(Failure)failBlock;

#pragma mark - 首页推荐教程换一批接口
- (void)homeRecommendeCourse:(NSString *)page
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock;

#pragma mark - n获取首页最新教程翻页数据列表
- (void)homeNewCourse:(NSString *)page
            video_ids:(NSString *)exclude_vide_ids
           completion:(void (^)(FWServiceResponse *response))completion
            failBlock:(Failure)failBlock;


#pragma mark - 统计banner点击次数
- (void)recordBannerClickCount:(NSString *)page
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock;

#pragma mark -  用于统计登录次数。 一天记录一次
- (void)recordLoginCount:(NSString *)token
              completion:(void (^)(FWServiceResponse *response))completion
               failBlock:(Failure)failBlock;


#pragma mark - 新增设备数和活跃设备数统计
- (void)newDeviceAndActiveUser:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock;


/**
 广告位 和 banner 点击次数 统计

 @param adId 广告位 和 banner ID
 */
- (void)advertisClickCount:(NSString*)adId;

@end
