//
//  WMTableViewController.h
//  Demo
//
//  Created by Mark on 16/7/25.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//

#import "HKBaseVC.h"
#import "HKCourseModel.h"

@interface TeacherInfoViewController : HKBaseVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                          model:(DetailModel*)model
                         course:(HKCourseModel *)course;

- (void)layoutUI;


- (void)setTeacherInfoWithModel:(DetailModel*)model;

@end

