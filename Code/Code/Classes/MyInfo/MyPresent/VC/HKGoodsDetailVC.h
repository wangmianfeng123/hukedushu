//
//  HKGoodsDetailVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKGoodsModel;
@interface HKGoodsDetailVC : HKBaseVC

@property (nonatomic, strong)HKGoodsModel *model;

@property (nonatomic, copy)void(^refreshBlock)();


@end
