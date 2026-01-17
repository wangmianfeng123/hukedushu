//
//  HKTaskDetailHeadCell.h
//  Code
//
//  Created by Ivan li on 2018/7/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseTaskCell.h"


@class HKTaskModel,HKTaskTeacCommentView,HKTaskDetailModel;

@protocol HKTaskDetailHeadCellDelegate <NSObject>

- (void)reloadTaskDetailHeadCell:(HKTaskDetailModel*)model indexPath:(NSIndexPath *)indexPath;;

- (void)userInfoClick:(HKTaskDetailModel*)model indexPath:(NSIndexPath *)indexPath;

- (void)didClickPraiseBtnInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end


@interface HKTaskDetailHeadCell : HKBaseTaskCell

@property(nonatomic,strong) HKTaskDetailModel *model;

@property(nonatomic,weak)id<HKTaskDetailHeadCellDelegate> delegate;
/** 作品图片 */
@property(nonatomic,strong)UILabel *scanImageLB;

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@property(nonatomic,assign)CGFloat *imageH;

@end
