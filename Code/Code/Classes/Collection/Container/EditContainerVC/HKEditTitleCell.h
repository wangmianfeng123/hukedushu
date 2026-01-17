//
//  HKEditTitleCell.h
//  Code
//
//  Created by Ivan li on 2017/12/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKEditTitleCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,strong)UIImageView *rightIV;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
