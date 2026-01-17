//
//  HKC4dHeadCell.h
//  Code
//
//  Created by Ivan li on 2017/11/14.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKC4dHeadCell : TBHighLightedCell

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@property(nonatomic,strong)C4DHeadModel  *model;

@end
