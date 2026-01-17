//
//  HKTainItemDetailCell.h
//  Code
//
//  Created by hanchuangkeji on 2019/1/21.
//  Copyright © 2019年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKTrainItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HKPunchClockModel;

@interface HKTainItemDetailCell : UITableViewCell


@property (nonatomic, copy)void(^coverIVTapBlock)(HKPunchClockModel *model);

@property (nonatomic, copy)void(^userHeaderIVTapBlock)(HKPunchClockModel *model);

@property (weak, nonatomic) IBOutlet UIButton *deteBtn;
@property (weak, nonatomic) IBOutlet UILabel *resaonLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbsBtn;

@property (nonatomic, copy) void(^deleteBlock)(HKPunchClockModel * model);
@property (nonatomic, copy) void(^likeBlock)(HKPunchClockModel * model);
@property (nonatomic, strong) HKPunchClockModel * punchClockModel;
@property (nonatomic, copy) NSString * typeString;


@end

NS_ASSUME_NONNULL_END
