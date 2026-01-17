//
//  HKInterestCell.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKrecommendUserModel;

@protocol HKInterestCellDelegate <NSObject>

- (void)interestCellDidAttentionBtn:(HKrecommendUserModel *)model;
- (void)interestCellDidHeaderBtn:(HKrecommendUserModel *)model;

@end

@interface HKInterestCell : UICollectionViewCell
@property (nonatomic , strong) HKrecommendUserModel * model;
@property (nonatomic , weak) id<HKInterestCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
