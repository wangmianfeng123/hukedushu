//
//  HKLiveRecommendCourseModel.h
//  Code
//
//  Created by ivan on 2020/8/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class HKUserModel;


@interface HKLiveRecommendCourseModel : NSObject

/// 封面
@property(nonatomic,copy)NSString *detail_cover;

@property(nonatomic,assign)NSInteger group_buy;

@property(nonatomic,assign)NSInteger group_buy_limit;


@property(nonatomic,copy)NSString *group_buy_price;

@property(nonatomic,copy)NSString *group_invite_pic;


@property(nonatomic,copy)NSString *courseId;


@property(nonatomic,assign)BOOL is_charge;

@property(nonatomic,assign)NSInteger left_seckill;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,assign)NSInteger open_seckill;



@property(nonatomic,assign)NSInteger rec_live;
/// 头像
@property(nonatomic,copy)NSString *surface_url;

@property(nonatomic,copy)NSString *teacher_qr;


@property(nonatomic,assign)NSInteger tid;

@property(nonatomic,assign)NSInteger tid_two;

@property(nonatomic,strong)NSMutableArray <HKUserModel*>*teachers;

@property(nonatomic,copy)NSString *start_live_at_cn;
///感兴趣人数或者报名人数
@property(nonatomic,copy)NSString *checkin_num;

@property(nonatomic,assign)NSInteger enrolment_people;
///小节课ID
@property(nonatomic,assign)NSInteger next_small_catalog_id;

@end




NS_ASSUME_NONNULL_END
