//
//  HKLiveListModel.h
//  Code
//
//  Created by Ivan li on 2018/10/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKLiveListModel : NSObject

@property (nonatomic, assign)BOOL can_replay;

@property(nonatomic,copy)NSString *course_id;
/**  直播结束后显示 */
@property(nonatomic,copy)NSString *end_desc;
///小结直播结束时间戳
@property(nonatomic,assign)NSNumber* end_live_at;
/// 课程直播节数，公开课节数为1;
@property (nonatomic, copy)NSString *lession_num;
///小结直播结束时间转文字
@property(nonatomic,copy)NSString *end_live_at_str;

@property(nonatomic,copy)NSString *ID;
/**  是否报名 （1 是，0否） */
@property(nonatomic,assign)BOOL isEnroll;
/** 是否收费 */
@property(nonatomic,assign)BOOL is_charge;
/** 是否在开播前的一小时内 0 否 1 是 */
@property(nonatomic,assign)BOOL is_in_a_hour;
/** 是否在开播设置的时间段内 0 否 1 是 */
@property(nonatomic,assign)BOOL is_in_live_time;

/** 当前直播状态0:未开始，1:开始直播,2:直播结束 */
@property(nonatomic,assign)NSInteger live_status;
/** 标题 */
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *source;
/// 小结直播开始时间戳
@property(nonatomic,assign)NSNumber *start_live_at;

@property(nonatomic,copy)NSString *start_live_at_str;
/**  封面图 */
@property(nonatomic,copy)NSString *surface_url;

@property(nonatomic,copy)NSString *teacher_avator;

@property(nonatomic,copy)NSString *teacher_id;

@property(nonatomic,copy)NSString *teacher_name;

@property(nonatomic,copy)NSString *teacher_organization_name;
 /**录制的直播课程id */
@property(nonatomic,copy)NSString *video_id;

@property (nonatomic, assign)NSInteger coutDownForLive; // 倒计时，如果不为零既须显示倒计时

/// 直播流地址
@property (nonatomic, copy)NSString *rtmpPullUrl;

/// 回放地址
@property (nonatomic, copy)NSString *url;

@property (nonatomic, copy)NSString *onLineCount;// 在线观看人数

@property (nonatomic, assign)BOOL coutDownMoreThanOneHourForLive;

/// 感兴趣的文本
@property (nonatomic, copy)NSString *view;
/// 第二位老师头像
@property (nonatomic, copy)NSString *teacher_two_avator;
/// 第二位老师名字
@property (nonatomic, copy)NSString *teacher_two_name;
//是否免费试学 1:是0:否
@property (nonatomic, assign)NSInteger free_learn;

@property (nonatomic, copy)NSString *price_desc;
@property (nonatomic, copy)NSString * tag_left_up;  //分类页，直播课角标


@property(nonatomic,strong)HKMapModel *redirect;

@end







