

#import <Foundation/Foundation.h>
#import "FWServiceResponse.h"
#import "HKEnumerate.h"
typedef void (^ Failure)(NSError *error);        // 失败Blcok

typedef void (^ Success)(id responseObject);     // 成功Block

@interface FWNetWorkServiceMediator : NSObject


+ (FWNetWorkServiceMediator *)sharedInstance;

#pragma mark - 三方登陆  注册方式 [1:QQ,2:微信,3:微博]
- (void)loginWithUserId:(NSString*)username
                 avator:(NSString*)avator
                 openid:(NSString*)openid
                unionid:(NSString*)unionid
                 client:(NSString*)client
           registerType:(NSString*)registerType
             jsonString:(NSString*)string
             completion:(void (^)(FWServiceResponse *response))completion
              failBlock:(Failure)failBlock;


#pragma mark - 获取收藏视频列表
- (void)getCOllectionVideoListWithToken:(NSString *)token
                                pageNum:(NSString *)pageNum
                            collectType:(NSString*)collectType
                             completion:(void (^)(FWServiceResponse *response))completion
                              failBlock:(Failure)failBlock;

- (void)getStudyVideoListWithToken:(NSString *)token
                           pageNum:(NSString *)pageNum
                         videoType:(NSString*)videoType
                        completion:(void (^)(FWServiceResponse *response))completion
                         failBlock:(Failure)failBlock;

#pragma mark - 查询系统版本
- (void)getSystemVersion:(void (^)(FWServiceResponse *response))completion
               failBlock:(Failure)failBlock;


#pragma mark - 分类首页列表
- (void)getCategoryListWithToken:(NSString *)token
                      completion:(void (^)(FWServiceResponse *response))completion
                       failBlock:(Failure)failBlock;

#pragma mark - 收藏 取消 收藏视频  type-- 收藏状态  videoType --  视频类型
- (void)collectOrQuitVideoWithToken:(NSString *)token
                            videoId:(NSString *)videoId
                               type:(NSString *)type
                          videoType:(HKVideoType)videoType
                   postNotification:(BOOL)postNotification
                         completion:(void (^)(FWServiceResponse *response))completion
                          failBlock:(Failure)failBlock;

#pragma mark - 发送验证码

- (void)getAuthCodeWithPhone:(NSString *)phone
                        type:(NSString *)type //短信类型：1-绑定手机号 2-注册
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock;

#pragma mark - 手机验证码方式注册&登录
- (void)loginWithAuthCode:(NSString *)authCode
                    phone:(NSString *)phone
               completion:(void (^)(FWServiceResponse *response))completion
                failBlock:(Failure)failBlock;

#pragma mark - 用户主页的评论，消息列表
- (void)userInfoNotificationWithToken:(NSString *)token
                            page:(NSString *)page
                         completion:(void (^)(FWServiceResponse *response))completion
                          failBlock:(Failure)failBlock;

#pragma mark - 用户关注列表列表
- (void)userFollowsWithToken:(NSString *)token
                        page:(NSString *)page
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock;


#pragma mark - 关注或取消 教师
- (void)followTeacherVideoWithToken:(NSString *)token
                          teacherId:(NSString *)teacherId
                               type:(NSString *)type
                         completion:(void (^)(FWServiceResponse *response))completion
                          failBlock:(Failure)failBlock;



#pragma mark - 教师主页
- (void)teacherHomeWithToken:(NSString *)token
                   teacherId:(NSString *)teacherId page:(NSString *)page
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock;

#pragma mark - 软件入门
- (void)solfwareStartToken:(NSString *)token
                   videoId:(NSString *)videoId
                 is_Series:(BOOL)isSeries
                  completion:(void (^)(FWServiceResponse *response))completion
                   failBlock:(Failure)failBlock;

#pragma mark - 系列课  2，系列课 3，上中下的课
- (void)seriesCourseToken:(NSString *)token
                  videoId:(NSString *)videoId videoType:(NSString *)type
                completion:(void (^)(FWServiceResponse *response))completion
                 failBlock:(Failure)failBlock;

#pragma mark - 用户获取抽奖信息
- (void)userLuckyNotificationWithToken:(NSString *)token
                            completion:(void (^)(FWServiceResponse *response))completion
                             failBlock:(Failure)failBlock;

#pragma mark - 用户完成抽奖信息
- (void)userFinishLuckyNotificationWithToken:(NSString *)token gold:(NSString *)gold
                                  completion:(void (^)(FWServiceResponse *response))completion
                                   failBlock:(Failure)failBlock;


@end
