//
//  HKUserModel.h
//  FamousWine
//
//  Created by Administrator on 15/12/18.
//  Copyright © 2015年 pg. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import "VideoModel.h"
#import "DetailModel.h"
#import "HKTeacherTagsModel.h"

@class HKCouponModel;

@interface HKUserModel : NSObject<NSCoding>

//vip_type:0-非VIP 1-分类VIP 2-全站通VIP，3- 终身VIP     值为1或2时文案显示VIP中心，值为0时显示成为VIP；sign_continue_num：持续签到天数；

//vip_class：5-分类限五vip 4-套餐vip 3-终身全站通 2-全站通VIP 1-分类无限VIP 0-非VIP  （-1 过期），

//sign_type：1-当天已签到 0-未签；show_type：1-显示即将过期，要变颜色 2-多少张

//out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录  5-强制绑定手机号


/** 是否有作品   YES -有作品  NO */
@property(nonatomic,assign)BOOL has_task;

/** 是否有点赞短视频   YES -有  NO */
@property(nonatomic,assign)BOOL has_short_video;

/**用来区分登录状态，进行跳转*/
@property(nonatomic,copy)NSString *out_line;

@property(nonatomic,copy)NSString *access_token;


@property(nonatomic,copy)NSString *refresh_token;

@property(nonatomic,copy)NSString *access_token_expire_at;

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *username;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *avator;
/** 头像大图 */
@property(nonatomic,copy)NSString *big_avator;

@property(nonatomic,copy)NSString *phone;
/** 2.1 版本 弃用 */
//@property(nonatomic,copy)NSString *vip_type;
/** vip 类型 */
@property(nonatomic,copy)NSString *vip_class;

@property(nonatomic,copy)NSString *content;// 自我介绍

@property(nonatomic,copy)NSString *teacher_id;// 教师ID

@property(nonatomic,assign)BOOL is_follow;// 是否被关注

@property(nonatomic,copy)NSString *courseCount;// 教程数量

@property(nonatomic,copy)NSString *follow_count;// 粉丝数量

@property(nonatomic,copy)NSString *follow;// 粉丝数量

@property(nonatomic,copy)NSString *video_count;

@property(nonatomic,copy)NSString *tags;// 专业，擅长

@property(nonatomic,strong)NSArray<VideoModel *> *video_list;// 拥有的视频

@property(nonatomic,assign)int unread_msg_total;// 未读消息总数

@property(nonatomic,copy)NSString *curriculum_num;//视频数量

@property(nonatomic,copy)NSString *sign_type; //签到

@property(nonatomic,copy)NSString *sign_continue_num;//连续签到天数
/** 优惠券 */
@property(nonatomic,strong)HKCouponModel *coupon_data;

@property(nonatomic,strong)ShareModel *share_data; // 分享

@property(nonatomic,copy)NSString *teacher_type;// 1-只有VIP课程 2-只有pgc课程 3-两种都有

@property(nonatomic,assign)BOOL teacherInfoExpand; // 教师主页简介是否展开

@property(nonatomic,copy)NSString *vip_tips_msg;// 续费
/** 教师头衔*/
@property(nonatomic,copy)NSString *title;


/****************** 个人主页 ******************/
/** 课程数 */
@property(nonatomic,copy)NSString *count;
/** 虎课币数 */
@property(nonatomic,copy)NSString *gold;
/** 1-自己 2-非 */
@property(nonatomic,copy)NSString *is_self;
/** 学习视频数 */
@property(nonatomic,copy)NSString *study_video_total;


/****************** 编辑资料 ******************/

@property(nonatomic,copy)NSString *job;

@property(nonatomic,assign)BOOL is_bind_wechat;

@property(nonatomic,assign)BOOL is_bind_qq;

@property(nonatomic,assign)BOOL is_bind_weibo;

@property (nonatomic, strong)NSArray<HKTeacherTagsModel *> *teacherTags; // 教师类型，比如VIP课程，PGC，文章

@property (nonatomic, assign)BOOL is_subscription; // 文章关注教师

/****************** IM token ******************/
@property(nonatomic,copy)NSString *im_token;

/****************** 绑定手机号 ******************/
@property (nonatomic, assign)BOOL islogin;

@property (nonatomic, assign)BOOL bindedPhone;
/** 注销账号 */
@property(nonatomic,copy)NSString *contact_phone;


/****************** 短视频 ******************/
/** flower 是否关注 0:未关注 1:已关注 */
@property (nonatomic, assign)BOOL flower;

@property (nonatomic, strong)VideoModel * video;//首页教师的列表的视频

@property (nonatomic , strong) HKMapModel * kf_url;

@property(nonatomic,copy)NSString *regd;//注册时间

@end




//@interface HKTeacherCourseModel : NSObject
//@property (nonatomic, copy)NSString * video_id;
//@property (nonatomic, copy)NSString * video_title;
//@property (nonatomic, copy)NSString * img_cover_url;
//@property (nonatomic, copy)NSString * img_cover_url_big;
//@end


/**
 设备信息
 */
@interface HKKeychainModel : NSObject

+ (instancetype)sharedInstance;

/// 存放在 钥匙串中 设备ID
@property (nonatomic, copy)NSString *keychainAccess;

@end









