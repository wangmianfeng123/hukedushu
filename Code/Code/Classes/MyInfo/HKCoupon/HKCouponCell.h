//
//  HKCouponCell.h
//  Code
//
//  Created by Ivan li on 2018/1/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCouponModel;

@interface HKCouponCell : TBHighLightedCell

@property(nonatomic,strong)HKCouponModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@end
