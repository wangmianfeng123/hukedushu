//
//  HKChooseTopicCell.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKMonmentTagModel;

@interface HKChooseTopicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic , strong) HKMonmentTagModel * model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desTopMargin;
@end

NS_ASSUME_NONNULL_END
