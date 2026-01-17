//
//  HKHomeFollowCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKRecCourseCell : UITableViewCell

@property (nonatomic, strong)NSArray<VideoModel *> *recommends;

@property (nonatomic, copy) void(^didSelectedRecBlock)(VideoModel *model);

@end
