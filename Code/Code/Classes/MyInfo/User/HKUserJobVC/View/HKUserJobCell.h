//
//  HKUserJobCell.h
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKCellBottomView;

@interface HKUserJobCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,strong)HKCellBottomView *cellBottomView;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
