//
//  HKTeacherDetailVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface HKTeacherDetailVC : HKBaseVC

@property (nonatomic, copy)NSString *teacher_id;

@property (nonatomic, copy)void(^followBlock)(BOOL is_follow, NSString *teacher_id);

@end
