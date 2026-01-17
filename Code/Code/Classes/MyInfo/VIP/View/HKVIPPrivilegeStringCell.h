//
//  HKVIPPrivilegeStringCell.h
//  Code
//
//  Created by hanchuangkeji on 2018/7/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKVipInfoExModel.h"

@interface HKVIPPrivilegeStringCell : UITableViewCell

@property (nonatomic, strong)HKVipInfoExModel *vipInfoExModel;
@property (nonatomic, copy) NSString * txt;
@property (nonatomic, copy) NSString * privilegeContent;
@end
