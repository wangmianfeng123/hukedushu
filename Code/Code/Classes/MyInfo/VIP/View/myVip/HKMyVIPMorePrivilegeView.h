//
//  HKMyVIPMorePrivilegeView.h
//  Code
//
//  Created by hanchuangkeji on 2018/10/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKVipPrivilegeModel;

NS_ASSUME_NONNULL_BEGIN

@interface HKMyVIPMorePrivilegeView : UITableViewCell

- (void)setDataSource:(NSMutableArray<HKVipPrivilegeModel *> *)dataSource title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
