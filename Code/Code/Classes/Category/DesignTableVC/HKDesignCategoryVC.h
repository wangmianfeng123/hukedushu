//
//  HKDesignCategoryVC.h
//  Code
//
//  Created by Ivan li on 2020/12/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface HKDesignCategoryVC : WMStickyPageControllerTool

@property (nonatomic,copy)NSString *category;
/** 选中筛选tag */
@property(nonatomic,copy)NSString *defaultSelectedTag;

@end

NS_ASSUME_NONNULL_END
