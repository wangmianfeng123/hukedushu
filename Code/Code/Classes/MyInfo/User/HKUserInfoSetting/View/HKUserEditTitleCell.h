//
//  HKUserEditTitleCell.h
//  Code
//
//  Created by Ivan li on 2018/3/15.
//  Copyright © 2018年 pg. All rights reserved.
//


#import <UIKit/UIKit.h>


@class HKCellBottomView;

@interface HKUserEditTitleCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,copy)NSString *title;
/** yes-绑定*/
@property(nonatomic,assign)BOOL isBind;

@property(nonatomic,strong)HKCellBottomView *cellBottomView;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
