//
//  HKDropMenuTypeCell.h
//  Code
//
//  Created by Ivan li on 2020/12/15.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKDropMenuModel;

@interface HKDropMenuTypeCell : UICollectionViewCell
@property (nonatomic , strong) HKDropMenuModel *dropMenuModel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic , assign) BOOL needAdjusted;

@end

NS_ASSUME_NONNULL_END
