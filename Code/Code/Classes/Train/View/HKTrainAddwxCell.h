//
//  HKTrainAddwxCell.h
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKTrainAddwxCell : UITableViewCell
@property (nonatomic, copy) void(^addWxBlock)(void);
@property (nonatomic, copy) void(^thumbsLikeBlock)(void);


@end

NS_ASSUME_NONNULL_END
