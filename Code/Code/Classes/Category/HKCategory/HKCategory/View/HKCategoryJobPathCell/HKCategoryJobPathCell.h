//
//  HKCategoryJobPathCell.h
//  Code
//
//  Created by ivan on 2020/6/18.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKCategoryJobPathModel;

@interface HKCategoryJobPathCell : UICollectionViewCell

@property (nonatomic, strong)HKCategoryJobPathModel *model;

/** 阴影背景 */
@property (strong, nonatomic)  UIImageView *bgIV;

@end

NS_ASSUME_NONNULL_END



