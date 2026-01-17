//
//  HKTaskListCell.h
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "HKBaseTaskCell.h"

@class HKTaskModel,HKTaskListCell;

@protocol HKTaskListCellDelegate <NSObject>
/** 头像 昵称点击 */
- (void)userInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath;
/** 点赞 */
- (void)didClickPraiseBtnInCell:(HKTaskListCell*)cell indexPath:(NSIndexPath *)indexPath;
/** 封面点击 */
- (void)didClickCoverImageInCell:(HKTaskListCell*)cell indexPath:(NSIndexPath *)indexPath;

@end



@interface HKTaskListCell : HKBaseTaskCell

@property (nonatomic,weak) id<HKTaskListCellDelegate> delegate;

@property(nonatomic,strong) HKTaskModel *model;

@property(nonatomic,strong)UILabel *commentCountLB;

@property(nonatomic,strong)UILabel *scanCountLB;

@property(nonatomic,strong)UIButton *praiseBtn;// 点赞

+ (instancetype)initCellWithTableView:(UITableView *)tableview indexPath:(NSIndexPath*)indexPath identif:(NSString*)identif;

@end
