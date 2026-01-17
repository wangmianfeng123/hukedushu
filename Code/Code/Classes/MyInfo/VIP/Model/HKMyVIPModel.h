//
//  HKMyVIPModel.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKRenewalInfoModel;
/** vip_type：1-终身全站通VIP 2-全站通VIP 3-分类SVIP 4-分类限五VIP；state：1-显示即将过期和立即续费 2-显示立即升级；upgrade_type：要升级的类型，0-没有可升级的 999-可升级到全站通 9999-可升级终身全站通*/

@interface HKMyVIPModel : NSObject
@property (nonatomic, copy)NSString *avator;// 头像
@property (nonatomic, copy)NSString *name;// title
@property (nonatomic, copy)NSString *describe;// 详情

@property (nonatomic, copy)NSString *date;// 有效时间
@property (nonatomic, copy)NSString *backgroundUrl;// 背景

// 1-终身全站通VIP 2-全站通VIP 3-分类SVIP 4-分类限五VIP
//@property (nonatomic, copy)NSString *vip_type;

@property (nonatomic, copy)NSString *type;
/** state：1-显示即将过期和立即续费 2-显示立即升级 */
@property (nonatomic, copy)NSString *state;
/** 续费VIP 类型 */
@property (nonatomic, copy)NSString *class_type;

/** 2.1 版本 VIP 类型 */
@property (nonatomic, copy)NSString *vip_class;


@property (nonatomic, strong) HKRenewalInfoModel * renewalInfo; //是否续费订阅VIP 2.28

@end

@interface HKRenewalInfoModel : NSObject

@property (nonatomic, assign) int is_renewal;

@property (nonatomic, copy)NSString * next_renewal_time;
@property (nonatomic, copy)NSString * next_renewal_price;
@property (nonatomic, copy) NSString * original_price;

@end




