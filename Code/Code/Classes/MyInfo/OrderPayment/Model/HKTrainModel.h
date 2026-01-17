//
//  HKTrainModel.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKSeriesCourseModel;
NS_ASSUME_NONNULL_BEGIN

@interface HKTrainModel : NSObject

@property (nonatomic, copy)NSString *ID;

@property (nonatomic, copy)NSString *order_number; // 订单编号

@property (nonatomic, copy)NSString *pay_order_number; // 支付流水号

@property (nonatomic, copy)NSString *price; // 订单价格

@property (nonatomic, copy)NSString *pay_time; // 支付时间

@property (nonatomic, copy)NSString *training_id; // 训练营id

@property (nonatomic, copy)NSString *img; // 训练营封面图

@property (nonatomic, copy)NSString *start; // 训练营开始时间

@property (nonatomic, copy)NSString *end; // 训练营开始时间

@property (nonatomic, copy)NSString *entry_fee; // 训练营开始时间

@property (nonatomic, copy)NSString *state_desc; // 训练营状态描述(用于列表展示,如:已结束)

@property (nonatomic, copy)NSString *training_cycle; // 训练营周期

@property (nonatomic, copy)NSString *name; // 训练名称

@property (nonatomic, assign)NSInteger pay_type;

@property (nonatomic, assign)NSInteger state;
/// 是否过期 1：过期 0：未过期
@property (nonatomic, assign)BOOL is_expire;

@property (nonatomic,copy)NSString *live_small_catalog_id;


/////  直播订单

@property (nonatomic, copy)NSString *uid;
/// 直播课程ID
@property (nonatomic, copy)NSString *live_course_id;
/// 订单号
@property (nonatomic, copy)NSString *order;
/// 实际支付金额
@property (nonatomic, copy)NSString *pay_money;

@property (nonatomic, copy)NSString *live_cover;
/// 直播小节ID
@property (nonatomic, copy)NSString *live_small_id;

@property (nonatomic, copy)NSString *live_name;
/// 开始时间
@property (nonatomic, copy)NSString *start_at;
/// 直播状态 0 未开始 1 直播中 2 直播结束
@property (nonatomic, assign)NSInteger status;
/// Yes - 直播订单
@property (nonatomic, assign)BOOL isLive;

/// 直播标题
@property (nonatomic, copy)NSString *title;
/// 直播封面
@property (nonatomic, copy)NSString *cover;
/// 直播报名人数
@property (nonatomic, copy)NSString *subscribe_num;
/// 直播课程数
@property (nonatomic, assign)NSInteger lesson_num;

@property (nonatomic, copy)NSString *teacher_qr;

@property (nonatomic, copy)NSString * teacher_name;  //
@property (nonatomic, copy)NSString * hasGive;  //是否有赠予权限0无 1有

@property (nonatomic , strong) NSMutableArray * giveVipList;//赠送的vip会员列表
@property (nonatomic , strong) NSMutableArray * giveLiveList;//赠送的直播列表



@property (nonatomic, copy)NSString * series_id;
@property (nonatomic, copy)NSString * payfored_at;
@property (nonatomic , strong) HKSeriesCourseModel * series;

@property (nonatomic , strong) NSString * video_id;
@property (nonatomic, copy)NSString * live_status;  //直播状态：0未开始 1直播中 2已结束
@end

@interface HKSeriesCourseModel : NSObject
@property (nonatomic , strong) HKLiveTeachModel * teacher;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *cover;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *category_id;
@property (nonatomic, copy)NSString *course_num;
@property (nonatomic, copy)NSString *teacher_id;

@end

NS_ASSUME_NONNULL_END

