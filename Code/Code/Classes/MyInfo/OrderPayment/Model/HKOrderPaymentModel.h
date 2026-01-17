//
//  HKOrderPaymentModel.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKOrderPaymentModel : NSObject

@property (nonatomic, copy)NSString *orderNO;// 订单编号

@property (nonatomic, copy)NSString *orderAvator;// 订单图片

@property (nonatomic, copy)NSString *title;// 订单名称

@property (nonatomic, copy)NSString *userAvator;// 用户头像

@property (nonatomic, copy)NSString *userName;// 用户名

@property (nonatomic, copy)NSString *price;// 订单价格

@property (nonatomic, copy)NSString *valid;// 有效期限

@property (nonatomic, copy)NSString *realPrice;// 实付金额

@end
