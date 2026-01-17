//
//  HKTaskDetailCommentCell.h
//  Code
//
//  Created by Ivan li on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseTaskCell.h"
#import "HKTaskCommentView.h"


@class HKTaskModel;

@protocol HKTaskDetailCommentCellDelegate <NSObject>

- (void)userInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath;

- (void)didClickPraiseBtnInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end



@interface HKTaskDetailCommentCell : HKBaseTaskCell<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) id<HKTaskDetailCommentCellDelegate> delegate;

@property(nonatomic,strong) HKTaskModel *model;

@property(nonatomic,strong) HKTaskModel *heightModel;

@property(nonatomic,strong)HKTaskCommentView *taskCommentView;

@property(nonatomic,strong)UIView *lineView;

//+ (instancetype)initCellWithTableView:(UITableView *)tableview;
+ (instancetype)initCellWithTableView:(UITableView *)tableview model:(HKTaskModel *)model;

@end
