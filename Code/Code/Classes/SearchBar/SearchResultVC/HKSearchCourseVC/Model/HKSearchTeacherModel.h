//
//  HKSearchTeacherModel.h
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKUserModel;

@class CourseTagModel;

//搜索--筛选教师标签
@interface TeacherTagModel : NSObject

@property(nonatomic,copy)NSString *tag_id;

@property(nonatomic,copy)NSString *tag;

@property(nonatomic,copy)NSString *class_id;

@property(nonatomic,copy)NSString *name;

@property(nonatomic)BOOL isSelect;



@end



@interface HKSearchTeacherModel : NSObject

@property(nonatomic,copy)NSString *count;

@property (nonatomic, strong)NSArray<HKUserModel *> *teacher_list;

@property (nonatomic, strong)NSMutableArray<TeacherTagModel *> *tag_list;

@end








