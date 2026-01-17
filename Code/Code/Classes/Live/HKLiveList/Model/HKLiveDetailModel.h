//
//  HKLiveDetailModel.h
//  Code
//
//  Created by Ivan li on 2018/10/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKPracticeModel.h"
#import "HKCourseModel.h"


@class VideoModel,HKLiveListModel,ShareModel,HKGroupModel,HKMapModel,HKLivedepositModel;


@interface HKLiveTeacherModel : NSObject

@property (nonatomic,copy) NSString *avator;

@property (nonatomic,copy) NSString *is_subscription;

@property (nonatomic,copy) NSString *name;

@property (nonatomic, copy)NSString *organization_name; // 机构组织

@property (nonatomic, copy)NSString *content; // 详细介绍

@property (nonatomic,copy) NSString *room_id;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *teacher_id;

@property (nonatomic, assign)CGFloat contentHeight;

@property (nonatomic, assign)CGFloat organization_name_height; // 教师介绍

@property (nonatomic, strong)HKGroupModel *im_group;


@end




@interface HKContentModel : NSObject

@property (nonatomic,copy) NSString *content_id;

@property (nonatomic,copy) NSString *live_course_id;

@property (nonatomic,copy) NSString *content;

@property (nonatomic, copy)NSString *h5_url;

@property (nonatomic, assign)CGFloat contentHeight; // 课程html高度

@property (nonatomic, copy)NSString *course_type; // 类型 直播 或 系列课;

@end





@class HKLiveCategoryModel;

@interface HKLiveDetailModel : NSObject

@property (nonatomic, strong)NSArray<HKLiveCategoryModel *> *series_courses; // 系列课
@property (nonatomic, strong)NSNumber * recently_play ;//是否是最近播放： 1是 0不是
@property (nonatomic, strong)NSNumber * can_download ;//是否可以下载 1.可以 0.不可以
@property (nonatomic, copy)NSString * can_download_text ;//点击下载按钮tips


/****************** 视频详情 标签 标题 *******************/
@property (nonatomic,assign) CGSize headSize;
/** 字体高度 */
@property (nonatomic,assign) CGFloat headHeight;

@property (nonatomic, copy)NSString *img_cover_url_big;
@property (nonatomic, copy)NSString *video_title;
/** 字体行数 */
@property (nonatomic,assign) NSInteger textLines;
/**********************************************/
/** 详情分享视频 */
@property (nonatomic, strong)ShareModel *share_data;

@property (nonatomic, strong)HKCourseModel  *course;

@property (nonatomic, copy)NSString *h5_url;

@property (nonatomic, strong)HKLiveTeacherModel *teacher;

@property (nonatomic, strong)HKLiveListModel *live;

@property (nonatomic, strong)HKContentModel *content;

@property (nonatomic,assign)BOOL isEnroll;

@property (nonatomic,assign)BOOL hasManageAuth;

@property (nonatomic,assign)BOOL isTeacherWatch;

@property (nonatomic,assign)BOOL hasWatchAuth;

@property (nonatomic,assign)BOOL is_in_live_time;

@property (nonatomic,assign)BOOL is_in_a_hour;

@property (nonatomic,assign)BOOL canTalkNow;

@property (nonatomic,copy)NSString *im_token;

@property (nonatomic,copy)NSString *uid;

@property (nonatomic,assign)NSInteger playback;

@property (nonatomic,assign)NSInteger course_type;

@property (nonatomic, assign)CGFloat courseNameHeight;

@property (nonatomic, assign)BOOL playerPlaying;// 播放器正在播放中

@property (nonatomic, assign)BOOL isCurrent; // 目录课程当前播放

// ****** 目录系列课******
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *live_course_id;
@property (nonatomic, copy)NSString *catalog_id;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *start_live_at;
/// 当前直播状态0:未开始，1:开始直播,2:直播结束
@property (nonatomic, assign)HKLiveStatus live_status;
/// 是否支持回放
@property (nonatomic, assign)BOOL can_replay;
@property (nonatomic, copy)NSString *start_live_at_str;
@property (nonatomic, assign)BOOL has_study;
// ****** 目录系列课******

/** 直播跳转 浏览器*/
@property (nonatomic,strong)HKMapModel *redirect_package;

/** 保力威 sdk*/
@property (nonatomic, copy)NSString *channel_id; // 频道ID

@property (nonatomic, copy)NSString *user_id; // 保力威用户ID

@property (nonatomic, copy)NSString *app_id; // 保力威ID

@property (nonatomic, copy)NSString *app_secret; // 保力威ID
/// 回放视频 0:未上传
@property (nonatomic, copy)NSString *video_id;
/// 是否免费试学 1:是0:否
@property (nonatomic, assign)NSInteger free_learn;


//预售新加字段
@property (nonatomic , assign) int priceStrategy ;//用来判断活动 0免费 1无活动支付模式 2拼团模式 3秒杀模式 4预售定金模式
@property (nonatomic , strong) HKLivedepositModel * deposit;
@end





@interface HKLiveCategoryModel : NSObject

@property (nonatomic, copy)NSString *title;

@property (nonatomic, strong)NSArray *child;

@end


@interface HKLivedepositModel : NSObject

@property (nonatomic , assign) int live_id ;
@property (nonatomic, copy)NSString * original_price;  //原价
@property (nonatomic, copy)NSString * pay_final_price_start_at;  //尾款支付开始时间
@property (nonatomic, copy)NSString * pay_final_price_end_at;  //尾款支付结束时间
@property (nonatomic, copy)NSString * price;  //支付价格（最终支付价格）
@property (nonatomic, copy)NSString * advance_start_at;  //定金支付开始时间
@property (nonatomic, copy)NSString * advance_end_at;  //定金支付结束时间
@property (nonatomic, copy)NSString * advance_deposit_price;  //定金价格
@property (nonatomic, copy)NSString * advance_final_price;  //尾款价格
@property (nonatomic , strong) NSNumber * depositDeduction ; //定金抵扣金额

@property (nonatomic , strong) NSNumber * finalDeduction ; //尾款立减金额

@property (nonatomic, copy)NSString * finalDeductionCh;  //尾款立减金额（中文）

/**
1未报名成功-预售模式-定金未支付；
2未报名成功-预售模式-定金已支付-不在尾款支付时间；
3未报名成功-预售模式-定金已支付-在尾款支付时间-非会员（或者有会员，但没有会员尾款优惠）；
4未报名成功-预售模式-定金已支付-在尾款支付时间-会员；
5若已报名成功
 */
@property (nonatomic , assign) int depositStage ;


@end
