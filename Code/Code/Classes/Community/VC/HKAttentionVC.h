//
//  HKAttentionVC.h
//  Code
//
//  Created by Ivan li on 2021/1/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKMonmentTabModel,HKMonmentTypeModel;

@interface HKAttentionVC : HKBaseVC
@property (nonatomic , strong) HKMonmentTabModel * tabModel;
@property (nonatomic , strong) HKMonmentTypeModel * typeModel;
@property (nonatomic , strong) void(^didTagBtnBlock)(int index);
- (void)refreshTableView;

@end

NS_ASSUME_NONNULL_END
