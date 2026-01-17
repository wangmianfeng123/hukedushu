//
//  HKVipPrivilegeModel.h
//  Code
//
//  Created by hanchuangkeji on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKVipPrivilegeModel : NSObject

@property (nonatomic, copy)NSString *header;

@property (nonatomic, copy)NSString *name;
/// vip 特权 描述
@property (nonatomic, copy)NSString *des;
/// vip 特权 URL
@property (nonatomic, copy)NSString *icon;

@end
