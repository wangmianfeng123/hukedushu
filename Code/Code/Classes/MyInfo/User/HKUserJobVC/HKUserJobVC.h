//
//  HKUserJobVC.h
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKJobModel;

@interface HKUserJobVC : HKBaseVC

/** 职业选择 回调 */
@property(nonatomic,copy) void(^userJobSelectBlock)(HKJobModel *jobModel);


@end
