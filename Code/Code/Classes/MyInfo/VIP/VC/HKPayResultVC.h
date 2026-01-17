//
//  HKPayResultVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKBuyVipModel.h"

@interface HKPayResultVC : HKBaseVC

@property (nonatomic, assign)BOOL success;
@property (nonatomic, strong)HKBuyVipModel *model;

@end
