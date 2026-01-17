//
//  VideoServiceMediator.h
//  Code
//
//  Created by Ivan li on 2017/10/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWServiceResponse.h"

typedef void (^ Failure)(NSError *error);        // 失败Blcok

@interface VideoServiceMediator : NSObject

+ (VideoServiceMediator *)sharedInstance;

#pragma mark - 获取视频评论接口
- (void)getVideoComment:(NSString *)token
                videoId:(NSString *)videoId
                   page:(NSString *)page
              only_type:(NSString *)typeString
             completion:(void (^)(FWServiceResponse *response))completion
              failBlock:(Failure)failBlock;




#pragma mark - 提交评论     score * 星级评价，数值即星级数，数值区间为1-5  难易程度：1太简单，2简单，3难度适中，4有点难，5太难了,数值区间为1-5
- (void)submitVideoComment:(NSString *)token
                   videoId:(NSString *)videoId
                     score:(NSString *)score
                 difficult:(NSString *)difficult
                   content:(NSString *)content
                completion:(void (^)(FWServiceResponse *response))completion
                 failBlock:(Failure)failBlock;


#pragma mark - 视频评论点赞接口
- (void)VideoPraise:(NSString *)token
          commentId:(NSString *)commentId
         completion:(void (^)(FWServiceResponse *response))completion
          failBlock:(Failure)failBlock;


#pragma mark - 获取列表页标签
- (void)getVideoTagList:(NSString *)className
            completion:(void (^)(FWServiceResponse *response))completion
            failBlock:(Failure)failBlock;


/**
 筛选  分类 视频列表
 
 排序：0-默认 1-最新 2-热度 3-最简单 4-最难
 
 @param className 分类ID
 @param sort  0-默认 1-最新 2-热度 3-最简单 4-最难
 @param page   
 @param tags  选中标签 数组 json
 @param completion
 @param failBlock
 */
- (void)filterVideoListWithClass:(NSString *)className
                            sort:(NSString *)sort
                            page:(NSString *)page
                            tags:(NSDictionary *)tags
                      completion:(void (^)(FWServiceResponse *response))completion
                       failBlock:(Failure)failBlock;

#pragma mark - 回复评论
- (void)replayComment:(NSString *)commentId
              content:(NSString *)content
                 type:(NSString *)type
           completion:(void (^)(FWServiceResponse *response))completion
            failBlock:(Failure)failBlock;

#pragma mark - 获取单条评论和当前评论的回复内容接口
- (void)getSingleCommentInfo:(NSString *)commentId
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock;

#pragma mark - 删除评论
- (void)deleteVideoCommentInfo:(NSString *)commentId
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock;


#pragma mark -  合集列表 排序 筛选  排序：0-默认 1-收藏人数 2-教程数量 3-创建时间
- (void)filterAlbumListWithSort:(NSString *)sort
                            page:(NSString *)page
                            tag1:(NSString *)tag1
                            tag2:(NSString *)tag2
                            tag3:(NSString *)tag3
                            tag4:(NSString *)tag4
                      completion:(void (^)(FWServiceResponse *response))completion
                       failBlock:(Failure)failBlock;

@end
