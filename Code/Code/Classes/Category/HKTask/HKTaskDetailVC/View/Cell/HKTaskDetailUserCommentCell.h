//
//  HKTaskDetailUserCommentCell.h
//  Code
//
//  Created by Ivan li on 2018/7/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HKTaskCommentModel,HKTaskModel;


@interface HKTaskDetailUserCommentCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableView  row:(NSInteger)row;

@property (nonatomic,strong) HKTaskCommentModel *commentM;

@end
