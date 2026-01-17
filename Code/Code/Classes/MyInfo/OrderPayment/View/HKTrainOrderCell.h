//
//  HKTrainOrderCell.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKTrainModel.h"
#import "HKPgcCategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HKTrainOrderCell;
@protocol HKTrainOrderCellDelegate <NSObject>
@optional
- (void)trainOrderCellDidTeacherBtn:(HKTrainModel *)model;
- (void)trainOrderCell:(HKTrainOrderCell *)cell didGifBtn:(HKTrainModel *)model ;

@end

@interface HKTrainOrderCell : UITableViewCell

@property (nonatomic, strong)HKTrainModel *model; // 训练营
@property (weak, nonatomic) IBOutlet UIButton *gifButton;

@property (nonatomic, strong)HKPgcCourseModel *pgcModel; // PGC
@property(nonatomic,weak)id<HKTrainOrderCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
