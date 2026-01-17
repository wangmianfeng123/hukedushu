//
//  HKDropMenuTagCell.h
//  Code
//
//  Created by eon Z on 2022/4/29.
//  Copyright © 2022 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKDropMenuModel;

@interface HKDropMenuTagCell : UICollectionViewCell

@property (nonatomic , strong) HKDropMenuModel *dropMenuModel;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

NS_ASSUME_NONNULL_END
