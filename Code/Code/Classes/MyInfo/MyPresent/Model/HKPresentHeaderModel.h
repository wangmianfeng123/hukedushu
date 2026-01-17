//
//  HKPresentHeaderModel.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKLuckPriceVC.h"
#import "HKGoodsModel.h"
#import "BannerModel.h"
#import "HKArticleModel.h"


@class HKPresentHeaderMoreCoinModel;
@class HKCoinDayModel;
@class HKTaskClassObjectModel;
@class HKTasktModel;
@class HKPrensentRec;

@interface HKPresentHeaderModel : NSObject

@property (nonatomic, strong)HKPrensentRec *rec;

@property (nonatomic, copy)NSString *share_gold_str;

@property (nonatomic, strong)ShareModel *share_data;

@property (nonatomic, copy)NSString *sign_img_url;// 签到成功图片

@property (nonatomic, copy)NSString *gold_total;// 虎课币

@property (nonatomic, copy)NSString *continue_num;// 连续签到天数

@property (nonatomic, assign)BOOL is_price;// 抽奖

@property (nonatomic, assign)BOOL is_sign_notify; // 设置连续签到推送

@property (nonatomic, assign)int is_show;// 0-当天已签到 1-显示签到成功弹框 2-显示抽奖弹框

@property (nonatomic, strong)NSArray<HKPresentHeaderMoreCoinModel *> *moreCoinArray;

@property (nonatomic, strong)NSMutableArray<HKGoodsModel *> *goods_list;


@property (nonatomic, strong)NSArray<HKCoinDayModel *> *sign_list;

@property (nonatomic, strong)NSArray<HKLuckPriceModel *> *reward_list;


@property (nonatomic, strong)NSArray<HKTasktModel *> *task_list;

@property (nonatomic, copy)NSString *today_gold;// 虎课币


@property (nonatomic, strong)NSNumber * sign_notify_hour;
@property (nonatomic, strong)NSNumber * sign_notify_hour_type;
@property (nonatomic, strong)NSNumber * sign_notify_type;

@property (nonatomic, copy)NSString * pushFrequency;  //推送频率
@property (nonatomic, copy)NSString * j_push_hour_typeString; // 00或者30

@end

@interface HKPresentHeaderMoreCoinModel : NSObject

@property (nonatomic, copy)NSString *title;// 虎课币

@property (nonatomic, copy)NSString *coinCount;// 完成获取多少虎课币

@property (nonatomic, assign)BOOL is_finish;// 完成


@end

@interface HKCoinDayModel : NSObject

@property (nonatomic, copy)NSString *gold;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, assign)BOOL is_sign;

@end

@interface HKTaskCoinDayModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, assign)BOOL is_sign;

@end


// ********* 签到任务
@interface HKTasktModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *gold;
@property (nonatomic, copy)NSString *img_url;
@property (nonatomic, copy)NSString *descrip;
@property (nonatomic, assign)BOOL is_complete;
@property (nonatomic, strong)HomeAdvertModel* class_object;
@property (nonatomic, strong)NSArray<HKTasktModel *>* list;
@end

@interface HKTaskClassObjectModel : NSObject

@property (nonatomic, copy)NSString *class_name;

@end
// ********* 签到任务


@interface HKPrensentRec : NSObject

@property (nonatomic, copy)NSString *ID;

@property (nonatomic, assign)int type; // 推荐类型 1：课程 2：文章

@property (nonatomic, strong)VideoModel *video;

@property (nonatomic, strong)HKArticleModel *article;

@property (nonatomic, strong)HKBookModel *book;

@end
