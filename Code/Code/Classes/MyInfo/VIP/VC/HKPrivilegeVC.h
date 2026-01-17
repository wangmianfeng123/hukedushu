//
//  HKPrivilegeVC.h
//  Code
//
//  Created by eon Z on 2021/11/9.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKVipPrivilegeModel;

@interface HKPrivilegeVC : HKBaseVC

//@property (nonatomic , strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *dataArray;// 会员权益说明

@end

NS_ASSUME_NONNULL_END
