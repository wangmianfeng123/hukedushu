//
//  HKCarouselCell.h
//  Code
//
//  Created by Ivan li on 2021/6/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKCarouselModel;

@interface HKCarouselCell : UITableViewCell

@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , strong) void(^didItemBlock)(HKCarouselModel * model);

@end

NS_ASSUME_NONNULL_END
