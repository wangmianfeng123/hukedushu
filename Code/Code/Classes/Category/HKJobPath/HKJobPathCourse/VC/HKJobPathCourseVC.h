//
//  HKJobPathCourseVC.h
//  Code
//
//  Created by Ivan li on 2019/6/5.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "WMStickyPageControllerTool.h"

NS_ASSUME_NONNULL_BEGIN

@class HKJobPathModel;


@interface HKJobPathCourseVC : WMStickyPageControllerTool

@property (nonatomic,copy) NSString *courseId;

@property (nonatomic,strong) HKJobPathModel *jobPathModel;

@end

NS_ASSUME_NONNULL_END

