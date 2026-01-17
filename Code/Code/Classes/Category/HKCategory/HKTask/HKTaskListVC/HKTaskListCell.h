//
//  HKTaskListCell.h
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "HKBaseTaskCell.h"

@class HKTaskModel;

@protocol HKTaskListCellDelegate <NSObject>

- (void)userInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath;

- (void)didClickPraiseBtnInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end



@interface HKTaskListCell : HKBaseTaskCell

@property (nonatomic,weak) id<HKTaskListCellDelegate> delegate;

@property(nonatomic,strong) HKTaskModel *model;

@property(nonatomic,strong)UILabel *commentCountLB;

@property(nonatomic,strong)UILabel *scanCountLB;

@property(nonatomic,strong)UIButton *praiseBtn;// 点赞

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@end
