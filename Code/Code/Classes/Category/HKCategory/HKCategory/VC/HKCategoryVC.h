//
//  HKCategoryVC.h
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@class HKLeftMenuModel;

@interface HKCategoryVC : HKBaseVC

/** 左边 表格 数据模型 */
@property(nonatomic,strong)NSMutableArray<HKLeftMenuModel*> *leftModelArr;

- (void)loadCatagoryData;

@end

