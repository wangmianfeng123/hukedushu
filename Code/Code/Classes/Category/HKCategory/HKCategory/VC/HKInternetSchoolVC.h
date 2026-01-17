//
//  HKInternetSchoolVC.h
//  Code
//
//  Created by ivan on 2020/5/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class HKcategoryOnlineSchoolListModel;

@interface HKInternetSchoolVC : HKBaseVC

- (instancetype)initWitFrame:(CGRect)rect;

//@property(nonatomic,strong)NSMutableArray <HKcategoryOnlineSchoolListModel*>*dataArr;

@property (nonatomic, assign) int ID;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
