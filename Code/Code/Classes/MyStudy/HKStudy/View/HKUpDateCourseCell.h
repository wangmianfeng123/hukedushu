//
//  HKUpDateCourseCell.h
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKFollowVideoModel;

@interface HKUpDateCourseCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray * followVideoArray;
@property (nonatomic, copy) void(^lookBlock)(HKFollowVideoModel * model);

@end

NS_ASSUME_NONNULL_END
