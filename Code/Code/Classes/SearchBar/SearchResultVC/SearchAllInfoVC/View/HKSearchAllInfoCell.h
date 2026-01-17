//
//  HKSearchAllInfoCell.h
//  Code
//
//  Created by Ivan li on 2017/11/28.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBaseSearchTeacCell.h"



@class HKUserModel,HKFirstMatchModel,HKTeacherMatchModel;


@interface HKSearchAllInfoCell : HKBaseSearchTeacCell

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, copy)void(^homeMyFollowVideoSelectedBlock)(NSIndexPath *indexPath, VideoModel *videoNodel);

@property (nonatomic, copy)void(^followTeacherSelectedBlock)(NSIndexPath *indexPath, HKUserModel *teacherModel);
/** 更多 按钮 点击回调 */
@property(nonatomic,copy)void (^moreBtnClickBackCall)();

//- (void)setTeacher_info:(HKUserModel *)teacher_info hiddenSeparator:(BOOL)hiddenSeparator index:(NSIndexPath *)index;

@property(nonatomic,strong)HKFirstMatchModel *matchModel;

@property(nonatomic,strong)HKTeacherMatchModel *teacherMatchModel;


@end










