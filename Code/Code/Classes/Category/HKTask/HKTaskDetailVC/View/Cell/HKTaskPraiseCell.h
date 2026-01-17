//
//  HKTaskPraiseCell.h
//  Code
//
//  Created by Ivan li on 2018/7/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKTaskPraiseBtn,HKTaskDetailModel,HKTaskPraiseCell;


@protocol HKTaskPraiseCellDelegate <NSObject>

- (void)hkTaskPraiseAction:(HKTaskDetailModel*)model cell:(HKTaskPraiseCell*)cell indexPath:(NSIndexPath *)indexPath;

@end


@interface HKTaskPraiseCell : UITableViewCell

@property(nonatomic,weak)id <HKTaskPraiseCellDelegate> delegate;

@property(nonatomic,strong)HKTaskPraiseBtn *hkPraiseBtn;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)HKTaskDetailModel *model;

+ (instancetype)initCellWithTableView:(UITableView *)tableview;

@end
