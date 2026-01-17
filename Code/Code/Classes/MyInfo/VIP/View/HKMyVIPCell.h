//
//  HKMyVIPCell.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyVIPModel.h"

typedef void(^MyVIPCellBlock)(HKMyVIPModel *model);

@interface HKMyVIPCell : UITableViewCell

@property (nonatomic, strong)HKMyVIPModel *model;

@property (nonatomic, copy)MyVIPCellBlock myVIPCellBlock;
@property (nonatomic, copy) void(^autoBuyBlock)(void);

@end
