//
//  HKCouponModel.h
//  Code
//
//  Created by Ivan li on 2018/1/26.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKCouponModel : NSObject

//client_type：0-通用 1-PC端可用 2-APP端可用，commodity_type：商品类型，1-VIP 2-PGC课程，discount：优惠券面额，satisfy_amount：满多少可用，is_gray：1-置灰，优惠券ID

/** 过期时间 */
@property(nonatomic,copy)NSString *expire_time;
/** client_type：0-通用 1-PC端可用 2-APP端可用*/
@property(nonatomic,copy)NSString *client_type;
/** commodity_type：商品类型，1-VIP 2-PGC课程 */
@property(nonatomic,copy)NSString *commodity_type;

@property(nonatomic,copy)NSString *commodity_id;
/** discount：优惠券面额*/
@property(nonatomic,copy)NSString *discount;
/** satisfy_amount：满多少可用 */
@property(nonatomic,copy)NSString *satisfy_amount;
/** 优惠券ID*/
@property(nonatomic,copy)NSString *coupon_id;
/** 过期 背景 灰色*/
@property(nonatomic,copy)NSString *is_gray;
/** 标题 */
@property(nonatomic,copy)NSString *title;

/** 1-显示即将过期，要变颜色 2-多少张 */
@property(nonatomic,copy)NSString *show_type;
/** 优惠券数量 */
@property(nonatomic,copy)NSString *show_str;

@end



