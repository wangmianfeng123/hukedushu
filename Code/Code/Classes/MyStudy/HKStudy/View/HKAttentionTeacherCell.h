//
//  HKAttentionTeacherCell.h
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKFollowTeacherModel;

@interface HKAttentionTeacherCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray * followTeacherArray;
@property (nonatomic, copy) void(^didCellBlock)(HKFollowTeacherModel * model ,NSInteger row);

@end

NS_ASSUME_NONNULL_END
