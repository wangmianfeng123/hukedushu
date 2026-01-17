//
//  HKVipInfoExModel.h
//  Code
//
//  Created by hanchuangkeji on 2018/7/16.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKVipInfoExModel : NSObject

@property (nonatomic, strong)NSArray<NSString *> *coming_class;

@property (nonatomic, copy)NSString *class_total;

// 6大权益+3大专属权益
@property (nonatomic, copy)NSString *privilegeString;

// 特权说明
@property (nonatomic, copy)NSString *privilegeTitle;

// 1、VIP账号可在网页、APP客户端、ipad客户端通用，享受同等权益...
@property (nonatomic, copy)NSString *privilegeContent;

@end
