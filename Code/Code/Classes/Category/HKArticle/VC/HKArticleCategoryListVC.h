//
//  HKArticleCategoryListVC.h
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKArticleCategoryModel.h"

@interface HKArticleCategoryListVC : HKBaseVC

@property (nonatomic, strong)NSMutableArray<HKArticleCategoryModel *> *dataSource;

@property (nonatomic, copy)void(^didSelectHKArticleCategoryModelBlock)(HKArticleCategoryModel *model, int index);

@end
