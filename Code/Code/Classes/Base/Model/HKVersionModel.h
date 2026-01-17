//
//  HKVersionModel.h
//  Code
//
//  Created by Ivan li on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKVersionModel : NSObject

@property (copy, nonatomic)NSString  *type;

@property (copy, nonatomic)NSString  *force_update;// 1--普通更新   2--强制更新

@property (copy, nonatomic)NSString  *version_code;

@property (copy, nonatomic)NSString  *version;

@property (copy, nonatomic)NSString  *url;

@property (copy, nonatomic)NSString  *update_info; // 更新说明

//"force_update": "2",
//"version_code": "1.6",
//"version": "9",

@end





/// 登录配置 （极验 和 礼包）
@interface HKInitConfigModel : NSObject

// registerGift 注册礼包
@property(nonatomic,assign)NSInteger registerGift;
// 极验登录 （1-开启 0-关闭）
@property(nonatomic,assign)NSInteger oneLoginStatus;

////----  登录礼包
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *desc;
/// 渠道名
@property(nonatomic,copy)NSString *channel;

@property(nonatomic,copy)NSString *caid;
///
@property(nonatomic,copy)NSString *click_id;

@property(nonatomic,copy)NSString *caid_md5;
@property(nonatomic,copy)NSString *paid;

@property(nonatomic,copy)NSString * iosPayCancelRedirectUrl;


@end



@interface HKInitConfigManger : NSObject

@property (nonatomic,strong) HKInitConfigModel *configModel;
/// 渠道
@property (nonatomic,copy) NSString *channel;
/// 渠道
@property (nonatomic,copy) NSString *caid;
/// 渠道
@property (nonatomic,copy) NSString *click_id;
@property (nonatomic,copy) NSString *caid_md5;
@property (nonatomic,copy) NSString *paid;

+ (instancetype)sharedInstance;

@end



