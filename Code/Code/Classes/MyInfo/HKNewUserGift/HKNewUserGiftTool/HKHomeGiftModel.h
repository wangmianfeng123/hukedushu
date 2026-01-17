//
//  HKHomeGiftModel.h
//  Code
//
//  Created by Ivan li on 2018/8/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HKGiftInfoModel;


@interface HKHomeGiftModel : NSObject

@property(nonatomic,copy)NSString *reason;
/** 显示 yes 显示 */
@property(nonatomic,assign)BOOL show_pop;
/** 活动天数 */
@property(nonatomic,copy)NSString *day;
/** 优惠券 金额 */
@property(nonatomic,copy)NSString *gold;

/** YES 显示新手礼包  */
@property(nonatomic,assign)BOOL result;

@property(nonatomic,copy)NSString *share;
/** YES 已分享  */
@property(nonatomic,assign)BOOL is_shared;

@property(nonatomic,strong)HKGiftInfoModel *express_vip;

@property(nonatomic,strong)ShareModel *share_data;

@property(nonatomic,strong)HKGiftInfoModel *first_day_gift;


@end




@interface HKGiftInfoModel : NSObject

@property(nonatomic,assign)NSInteger days;

@property(nonatomic,copy)NSString *desc;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *type_name;
/** YES - 已经领取 */
@property(nonatomic,assign)BOOL has_get;

@property(nonatomic,strong)HKGiftInfoModel *express_vip;

@end





