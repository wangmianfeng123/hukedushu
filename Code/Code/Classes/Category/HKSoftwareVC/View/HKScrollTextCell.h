//
//  HKScrollTextCell.h
//  Code
//
//  Created by ivan on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKAchievementModel;

@interface HKScrollTextCell : UICollectionViewCell

@property(nonatomic,strong)NSMutableArray <HKAchievementModel*>*titlesArray;

@end

NS_ASSUME_NONNULL_END
