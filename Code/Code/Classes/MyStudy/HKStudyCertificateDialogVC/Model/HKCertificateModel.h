//
//  HKCertificateModel.h
//  Code
//
//  Created by Ivan li on 2018/12/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerModel.h"



NS_ASSUME_NONNULL_BEGIN

/** 成就信息 */
@interface HKCertificateAchieveInfoModel : NSObject

/** 成就名称 */
@property(nonatomic,copy)NSString *name;
/** 成就类型 */  //枚举备注: 1 等级勋章 2 特殊勋章 3 证书
@property(nonatomic,copy)NSString *type;
/** 成就等级 */
@property(nonatomic,copy)NSString *level;
/** 成就完成条件描述 */
@property(nonatomic,copy)NSString *condition_description;
/** 成就完成图标 */
@property(nonatomic,copy)NSString *completed_icon;
/** 等级图标 */
@property(nonatomic,copy)NSString *level_icon;
/** 虎课证书 */
@property (nonatomic, copy)NSString *cert_desc;

@end



@interface HKCertificateModel : NSObject
/** 标题文案 */
@property (nonatomic,copy)NSString *title;

@property (nonatomic,strong)HKCertificateAchieveInfoModel *achieve_info;

@property (nonatomic,strong) HKMapModel *button_info;

@end



NS_ASSUME_NONNULL_END
