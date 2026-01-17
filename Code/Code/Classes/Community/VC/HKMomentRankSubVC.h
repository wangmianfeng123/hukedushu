//
//  HKMomentRankSubVC.h
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKMonmentTabModel,HKMonmentTypeModel,HKMonmentTagModel;

@interface HKMomentRankSubVC : HKBaseVC
@property (nonatomic , strong) HKMonmentTabModel * tabModel; //分类，标签，排序model的总和
@property (nonatomic , strong) HKMonmentTypeModel * typeModel; //动态tab的Model
@property (nonatomic , strong) HKMonmentTagModel * model; //排序Model
- (void)refreshTableView;
@end

NS_ASSUME_NONNULL_END
