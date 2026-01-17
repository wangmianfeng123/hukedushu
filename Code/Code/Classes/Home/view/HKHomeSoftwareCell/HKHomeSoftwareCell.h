//
//  HKHomeSoftwareCell.h
//  Code
//
//  Created by ivan on 2020/6/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SoftwareModel;

@interface HKHomeSoftwareCell : UICollectionViewCell

@property (strong, nonatomic)  UIImageView *iconIV;

@property (strong, nonatomic)  UILabel *nameLB;

@property (nonatomic, strong)SoftwareModel *model;

@end

NS_ASSUME_NONNULL_END
