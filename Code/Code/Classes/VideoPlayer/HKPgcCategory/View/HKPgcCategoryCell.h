//
//  HKPgcCategoryCell.h
//  Code
//
//  Created by Ivan li on 2017/12/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  HKPgcCourseModel;

@interface HKPgcCategoryCell : UITableViewCell

@property(nonatomic,strong)HKPgcCourseModel  *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
