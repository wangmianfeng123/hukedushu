//
//  HKTaskCommentCell.h
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKTaskCommentModel,HKTaskModel;


@interface HKTaskCommentCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableView  row:(NSInteger)row;

@property (nonatomic,strong) HKTaskCommentModel *commentM;

@property(nonatomic,strong)UILabel *attrLabel;

@end
