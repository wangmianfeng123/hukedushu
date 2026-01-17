//
//  HKMomentRankVC.h
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"
#import "WMPageControllerTool.h"

NS_ASSUME_NONNULL_BEGIN
@class HKMonmentTabModel,HKMonmentTypeModel;

@interface HKMomentRankVC : WMPageControllerTool
@property (nonatomic , strong) HKMonmentTabModel * tabModel;
@property (nonatomic , strong) HKMonmentTypeModel * typeModel;//每个模块对应的tabModel
- (void)refreshTableView;

@end

NS_ASSUME_NONNULL_END
