//
//  HKPgcTeacherInfoCell.h
//  Code
//
//  Created by Ivan li on 2017/12/21.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKPgcCourseInfoCell : UITableViewCell

@property(nonatomic,copy)NSString *coursrInfo;

@property(nonatomic,strong)DetailModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
