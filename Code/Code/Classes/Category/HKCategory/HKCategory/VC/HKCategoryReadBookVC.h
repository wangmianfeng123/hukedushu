//
//  HKCategoryReadBookVC.h
//  Code
//
//  Created by ivan on 2020/6/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKCategoryReadBookVC : HKBaseVC

- (instancetype)initWitFrame:(CGRect)rect;

@property(nonatomic,assign)HKCategoryType categoryType;
@property (nonatomic, assign) int ID;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
