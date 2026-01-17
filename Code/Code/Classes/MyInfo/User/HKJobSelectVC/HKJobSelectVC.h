//
//  HKJobSelectVC.h
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"


@class HKJobModel;

typedef NS_ENUM(NSInteger, SelectVCType) {

    SelectVCTypeJob =0,//职业选择
    SelectVCTypeSkill,//能力选择
};


@interface HKJobSelectVC : HKBaseVC

/** 职业选择 回调 */
@property(nonatomic,copy) void(^jobSelectBlock)(HKJobModel *jobModel);

/** 控制器类型 0--职业选择  1-- 能力选择*/
@property(nonatomic,assign)SelectVCType selectVCType;

@property(nonatomic,strong) HKJobModel *jobModel;

@end
