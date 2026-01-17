//
//  HKSoftCycleVerticalCell.h
//  Code
//
//  Created by yxma on 2020/8/31.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKUserFetchCerModel;

@interface HKSoftCycleVerticalCell : UICollectionViewCell
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) void(^itemClickBlock)(HKUserFetchCerModel * model);

@end

NS_ASSUME_NONNULL_END
