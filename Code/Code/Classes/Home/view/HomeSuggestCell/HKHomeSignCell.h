//
//  HKHomeSignCell.h
//  Code
//
//  Created by eon Z on 2021/8/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKHomeSignModel;

@interface HKHomeSignCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (nonatomic , strong) HKHomeSignModel * signModel;

@end

NS_ASSUME_NONNULL_END
