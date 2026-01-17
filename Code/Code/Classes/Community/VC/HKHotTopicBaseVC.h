//
//  HKHotTopicBaseVC.h
//  Code
//
//  Created by Ivan li on 2021/1/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"

NS_ASSUME_NONNULL_BEGIN
@class HKMonmentTabModel,HKMonmentTagModel,HKMonmentTypeModel;

@interface HKHotTopicBaseVC : WMStickyPageControllerTool
//@property (nonatomic , strong) HKMonmentTagModel * tagModel;
@property (nonatomic, copy)NSString * subjectId;  //
@end

NS_ASSUME_NONNULL_END
