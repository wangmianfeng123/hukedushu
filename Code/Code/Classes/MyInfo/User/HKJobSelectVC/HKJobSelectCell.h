//
//  HKJobSelectCell.h
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKCellBottomView;

@interface HKJobSelectCell : UITableViewCell

@property(nonatomic,strong)HKCellBottomView *cellBottomView;

@property(nonatomic,strong)UIImageView *rightIV;

@property(nonatomic,assign)BOOL isSelectJob;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
