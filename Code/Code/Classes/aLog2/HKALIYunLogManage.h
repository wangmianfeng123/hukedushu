//
//  HKALIYunLog.h
//  Code
//
//  Created by Ivan li on 2019/3/30.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN



@class HKALIYunLogModel;



@interface HKALIYunLogManage : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,strong)HKALIYunLogModel *logModel;
@property (nonatomic, copy)NSString * button_id;  //

- (void)setBaseConfig;

- (void)removeBaseConfig;

/** 统计短视频播放次数 */
- (void)shortVideoPlayCountLogWithVideoId:(NSString *)videoId;


/**
  统计点击数

 @param identify  点击按钮的标识
 1:底部短视频TAB按钮
 2:短视频播放页关注讲师
 3:取消 短视频点赞
 4:短视频点赞
 5:短视频评论
 6:短视频分享
 */
- (void)shortVideoClickLogWithIdentify:(NSString *)identify;



/**
 统计短视频播放时长

 @param videoId
 @param second 单位 秒
 */
- (void)shortVideoPlayTimeLogWithVideoId:(NSString *)videoId second:(NSInteger )second;



/**
 虎课读书 统计点击数

 @param flag flag 1:列表访问, 2:列表项点击, 3:详情页访问, 4:图书课程播放, 5:分享图书, 6:收藏图书, 7:添加评论
 @param bookId 书ID
 @param courseId  课程ID
 */
- (void)hkBookClickLogWithFlag:(NSString*)flag bookId:(NSString*)bookId  courseId:(NSString*)courseId;


/**
 短视频 统计点击数

 @param flag flag
 1:来源视频按钮点击
 2:推荐视频按钮点击
 3.通过短视频推荐视频跳转视频详情页的视频收藏
 4.通过短视频推荐视频跳转视频详情页的视频播放
 5.通过短视频来源视频跳转视频详情页的视频收藏
 6.通过短视频来源视频跳转视频详情页的视频播放

 */
- (void)hkShortVideoClickLogWithFlag:(NSString*)flag;





/**

 视频播放 统计
 @param btn_id  1 视频播放 2 视频详情页收藏 3 视频详情页下载 4 虎课读书播放 5 个人中心去登陆 6 个人中心头像 14首页底部登录
 @param show_type 1 弹窗触发 2 登录成功
 */
- (void)hkVideoPlayWithBtnId:(NSString*)btnId  showType:(NSString*)showType;




/**

 推送点击
 @param btnId   13 - 推送点击
 @param showType  3 - 推送点击
 */
- (void)hkNotificationWithBtnId:(NSString*)btnId  showType:(NSString*)showType  pushType:(NSString*)pushType;


/// 统计支付流程
/// @param vip_type VIP类别
/// @param step 支付步骤
/// @param step_desc 支付方法名
/// @param pay_info 购买凭证
- (void)applePayWithStep:(NSString *)step stepDesc:(NSString *)step_desc payInfo:(NSString *)pay_info vipType:(NSString *)vip_type;


- (void)applePayWithOrder_id:(NSString *)order_id payPrice:(NSString *)price;


/**
 统计极验回调

 @param flag flag 1:列表访问, 2:列表项点击, 3:详情页访问, 4:图书课程播放, 5:分享图书, 6:收藏图书, 7:添加评论
 @param bookId 书ID
 @param courseId  课程ID
 */
- (void)hkErrorLogWithCode:(NSString*)code message:(NSString*)message;


@end


@interface HKALIYunLogModel : NSObject

@property(nonatomic,copy)NSString *AccessKeyId;

@property(nonatomic,copy)NSString *AccessKeySecret;

@property(nonatomic,copy)NSString *Expiration;

@property(nonatomic,copy)NSString *SecurityToken;

@end

NS_ASSUME_NONNULL_END




