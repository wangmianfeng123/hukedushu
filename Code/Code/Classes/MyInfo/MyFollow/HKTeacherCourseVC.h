//
//  HKMyCollectionVC.h
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "WMStickyPageControllerTool.h"

@interface HKTeacherCourseVC : WMStickyPageControllerTool


@property (nonatomic, copy)NSString *teacher_id;

@property (nonatomic, copy)void(^followBlock)(BOOL is_follow, NSString *teacher_id);

@property (nonatomic, copy)void(^userVCDeallocBlock)();

@end

