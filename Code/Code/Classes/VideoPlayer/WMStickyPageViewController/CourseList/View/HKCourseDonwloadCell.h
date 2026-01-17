//
//  HKCourseListCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCourseModel.h"

@interface HKCourseDonwloadCell : UITableViewCell

@property (nonatomic, assign)BOOL isHKDownloadCourseVC;

// 预下载的时候
- (void)setModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden videoType:(HKVideoType)videoType;

// 完成展示的时候
- (void)showCompeletModel:(HKCourseModel *)model hiddenSpeparator:(BOOL)hidden videoType:(HKVideoType)videoType edit:(BOOL)edit block:(void(^)(HKCourseModel *model))deleteBtnClickBlock;

@end
