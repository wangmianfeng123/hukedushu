//
//  HKPrecentCell21.h
//  Code
//
//  Created by hanchuangkeji on 2018/6/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPresentHeaderModel.h"
#import "HKPresentHeaderModel.h"

@interface HKPrecentCell21 : UITableViewCell


@property (nonatomic, strong)HKTasktModel *model;

@property (nonatomic, copy)void(^btnClickBlock)(HKTasktModel *);

@end
