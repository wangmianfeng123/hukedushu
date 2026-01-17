//
//  HKUserOtherInfoModel.h
//  Code
//
//  Created by Ivan li on 2018/5/29.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HKMallDataModel : NSObject

/** Yes - 显示 */
@property (nonatomic, assign)BOOL is_show;

@property (nonatomic, copy)NSString *url;

@end




/** 用户额外信息 无需登录访问 */
@interface HKUserOtherInfoModel : NSObject

/** 客服电话 */
@property (nonatomic, copy)NSString *phone;
/** 客服QQ */
@property (nonatomic, copy)NSString *qq;
/** VIP 类型 跳转VIP页使用 */
@property (nonatomic, copy)NSString *class_type;
/** 我的页面 VIP cell 显示 文案*/
@property (nonatomic, copy)NSString *vip_str;

@property (nonatomic, strong)HKMallDataModel *mall_data;


@end





