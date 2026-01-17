//
//  HKMyInfoLearnCell.h
//  Code
//
//  Created by yxma on 2020/11/12.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKMyInfoGuideLearnModel;

@interface HKMyInfoLearnCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic , strong) HKMyInfoGuideLearnModel * model;
@end

NS_ASSUME_NONNULL_END
