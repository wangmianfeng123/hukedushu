//
//  HKHomeFollowCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKHomeFollowCell : TBCollectionHighLightedCell

@property (nonatomic, strong)HKUserModel *teacher_info;
@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, copy)void(^homeMyFollowVideoSelectedBlock)(NSIndexPath *indexPath, VideoModel *videoNodel);

@property (nonatomic, copy)void(^followTeacherSelectedBlock)(NSIndexPath *indexPath, HKUserModel *teacherModel);

- (void)setTeacher_info:(HKUserModel *)teacher_info hiddenSeparator:(BOOL)hiddenSeparator index:(NSIndexPath *)index;

@end
