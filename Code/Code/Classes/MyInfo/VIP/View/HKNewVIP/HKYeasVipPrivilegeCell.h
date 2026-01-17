//
//  HKYeasVipPrivilegeCell.h
//  Code
//
//  Created by eon Z on 2021/11/9.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HKVipPrivilegeModel;

@interface HKYeasVipPrivilegeCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *dataSource;
@property (nonatomic, strong) void(^didMoreBlock)(void);
@end

NS_ASSUME_NONNULL_END
