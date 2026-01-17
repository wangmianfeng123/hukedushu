//
//  HKBuyVipModel.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerModel.h"
#import "HKVipPrivilegeModel.h"
#import "HKVipInfoExModel.h"

@interface HKBuyVipModel : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *class_name;
@property (nonatomic, copy)NSString *vip_type;
@property (nonatomic, copy)NSString *button_type;
@property (nonatomic, copy)NSString *class_type;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, copy)NSString *per_day;
@property (nonatomic, copy)NSString *motto;

@property (nonatomic, assign)BOOL isFlag;//标记滑动是tab选中

@property (nonatomic, assign)BOOL is_selected;
@property (nonatomic, assign)BOOL is_just_watch; // 刚刚观看
@property (nonatomic, assign)BOOL is_show;
@property (nonatomic, copy)NSString *highPrice; // 高价
@property (nonatomic, assign)BOOL is_lastBtn; // 更新中，不可点击
@property (nonatomic, copy)NSString *class_total; // 多少分类vip数量

@property (nonatomic, copy)NSString *orderNo; // 订单号

@property (nonatomic, copy)NSString *pc_price;
@property (nonatomic, copy)NSString *price_tips;
@property (nonatomic, copy)NSString *price_title;

@property (nonatomic, copy)NSString *tips;

//@property (nonatomic, copy)NSString *vip_class;

@property (nonatomic, copy)NSString *apple_product_id;// 苹果商品的id

@property(nonatomic,strong)HKMapModel *ad; // 广告
/// 用于 活动价格标记
@property (nonatomic, copy)NSString *prize_type;
/// 订单号
@property(nonatomic,copy)NSString *out_trade_no;
/// 订单支付 字符串
@property(nonatomic,copy)NSString *order_string;


/// 微信支付
@property(nonatomic,copy)NSString *appid;

@property(nonatomic,copy)NSString *noncestr;

@property(nonatomic,copy)NSString *packageValue;

@property(nonatomic,copy)NSString *partnerid;

@property(nonatomic,copy)NSString *prepayid;

@property(nonatomic,copy)NSString *sign;

@property(nonatomic,assign)UInt32 timestamp;
/// 支付结果查询 Url
@property(nonatomic,copy)NSString *order_query_url;
/// yes - 已绑定手机
@property (nonatomic, assign)BOOL isBindPhone;

@property(nonatomic,copy)NSString *categoryVipName;//当前VIP中包含的分类会员的名称
//@property(nonatomic,copy)NSString *categoryVipprice;//当前VIP中包含的分类会员的价格

//自动续费
@property (nonatomic, assign)int canAutoRenewal; //是否开启自动续费
@property(nonatomic,copy)NSString *auto_renewal_try_out_tips; //自动续费试用价格
/// 支付结果查询 Url
@property(nonatomic,copy)NSString *auto_renewal_close_tips; //自动续关闭文案

@property (nonatomic, strong) NSArray * agreements;
@property (nonatomic, copy) NSString * buy_button_title;

@property (nonatomic, copy)NSString * try_out_price_title;//红色背景的底部文案
//@property (nonatomic, copy)NSString * price_title; //¥ 388
@property (nonatomic, copy)NSString * price_title_suffix;//年/自动续费

@property (nonatomic, copy)NSString * check_box_title;  //
@property (nonatomic, copy)NSString * check_box_desc;  //
@property (nonatomic, copy)NSString * desc;  //
@property (nonatomic , strong) NSString * button_string;//视频详情页vip购买页按钮文字
@property (nonatomic, copy)NSString * tag;  //
@property (nonatomic, copy)NSString *abbr;

@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *all_vip_privilege;// 会员权益说明
@property (nonatomic, strong)HKVipInfoExModel * vipInfoExModel;//特权说明


@end




@interface HKVipTabModel : NSObject
///
@property (nonatomic, copy)NSString *index;
/// VIP 名字
@property (nonatomic, copy)NSString *name;

@end
