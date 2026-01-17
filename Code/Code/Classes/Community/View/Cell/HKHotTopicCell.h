//
//  HKHotTopicCell.h
//  Code
//
//  Created by Ivan li on 2021/1/19.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKMomentDetailModel,HKMonmentTagModel;

@interface HKHotTopicCell : UITableViewCell
@property (nonatomic , strong)  HKMomentDetailModel * model;
@property (nonatomic , strong) void(^didTagModelBlock)(HKMonmentTagModel * tagModel);

@end

NS_ASSUME_NONNULL_END
