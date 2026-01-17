//
//  HKOtherVipTopCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBuyVipModel.h"

@interface HKOtherVipTopCell : UITableViewCell


@property (nonatomic, copy)void(^adImageViewTapBlock)(HKMapModel *model);

@property (nonatomic, strong)HKBuyVipModel *model;
@property (nonatomic , assign) BOOL isAutoBuy ;
@end
