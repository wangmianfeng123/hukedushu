//
//  SeriseCourseCell.h
//  Code
//
//  Created by Ivan li on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeriseCourseModel;

@interface SeriseCourseCell : UITableViewCell

@property(nonatomic,copy)SeriseCourseModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;
@end
