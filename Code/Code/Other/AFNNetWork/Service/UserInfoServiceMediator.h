//
//  UserInfoServiceMediator.h
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWServiceResponse.h"
#import "HKBuyVipModel.h"

typedef void (^ Failure)(NSError *error);        // 失败Blcok

@interface UserInfoServiceMediator : NSObject


+ (UserInfoServiceMediator *)sharedInstance;

#pragma mark - 提交留言
//comment_id    如果用户是从评论的举报入口进来的，需要带上评论ID
- (void)submitMessageWithToken:(NSString *)token
                       content:(NSString *)content
                            qq:(NSString *)qq
                     commentId:(NSString *)commentId
                    completion:(void (^)(FWServiceResponse *response))completion
                     failBlock:(Failure)failBlock;



#pragma mark - 绑定手机号
- (void)bingPhoneNum:(NSString *)phone
               token:(NSString *)token
                code:(NSString *)code
          completion:(void (^)(FWServiceResponse *response))completion
           failBlock:(Failure)failBlock;



#pragma mark - 获取搜索结果
- (void)searchListByWord:(NSString *)keyword
                   token:(NSString *)token
                    page:(NSString *)page
              completion:(void (^)(FWServiceResponse *response))completion
               failBlock:(Failure)failBlock;


#pragma mark - 播放 下载    is_vip：0-非VIP（不可下载） 1-限5VIP（不可下载） 2-全站VIP或分类无限VIP（可下载），is_paly：0-不可观看 1-可观看


- (void)seeAndDownloadByVideoId:(NSString *)videoId
                    VideoDetail:(DetailModel *)detailModel
                      videoType:(HKVideoType)videoType
                          token:(NSString *)token
                      searchkey:(NSString *)searchkey
                 searchIdentify:(NSString *)searchIdentify
                     completion:(void (^)(FWServiceResponse *response))completion
                      failBlock:(Failure)failBlock;


#pragma mark - 获取用户VIP类型
- (void)checkUserVipType:(NSString *)token
              completion:(void (^)(FWServiceResponse *response))completion
               failBlock:(Failure)failBlock;

#pragma mark - 获取用户额外信息，比如签到
- (void)getUserExtInfoCompletion:(void (^)(FWServiceResponse *response))completion failBlock:(Failure)failBlock;


#pragma mark - 购买 VIP 订单生成接口
- (void)setVipOrderWithToken:(NSString *)token model:(HKBuyVipModel *)model
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock;


#pragma mark - 验证VIP 是否购买 成功
- (void)checkReceiptIsValid:(NSString *)token
                    receipt:(NSString *)receipt
                   orederNo:(NSString *)orderNo setp:(NSString *)step
                 completion:(void (^)(FWServiceResponse *response))completion
                  failBlock:(Failure)failBlock;

#pragma mark - 验证判断IOS APP状态接口
- (void)checkAppStatus:(void (^)(FWServiceResponse *response))completion
             failBlock:(Failure)failBlock;



///  下载视频 （V2.18 将下载 播放接口分开，原先下载和播放 同一接口）
- (void)downloadWithVideoId:(NSString *)videoId
                videoType:(HKVideoType)videoType
                searchkey:(NSString *)searchkey
           searchIdentify:(NSString *)searchIdentify
               completion:(void (^)(FWServiceResponse *response))completion
                  failBlock:(Failure)failBlock;

@end

