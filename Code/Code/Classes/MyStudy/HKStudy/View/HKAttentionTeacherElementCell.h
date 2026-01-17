//
//  HKAttentionTeacherElementCell.h
//  Code
//
//  Created by yxma on 2020/9/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKFollowTeacherModel;

@interface HKAttentionTeacherElementCell : UICollectionViewCell
//@property (nonatomic, assign) BOOL isLiving;
@property (nonatomic, strong) HKFollowTeacherModel * teacherModel;
@property (nonatomic, assign) BOOL isShowMore;

@end

NS_ASSUME_NONNULL_END
