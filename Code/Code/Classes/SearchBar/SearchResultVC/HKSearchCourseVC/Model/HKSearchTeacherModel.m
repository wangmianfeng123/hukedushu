//
//  HKSearchTeacherModel.m
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSearchTeacherModel.h"
#import "HKSearchCourseModel.h"




@implementation HKSearchTeacherModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"teacher_list" : [HKUserModel class],@"tag_list" : [TeacherTagModel class]};
}

@end



@implementation TeacherTagModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"class_id" : @"tag_id", @"name":@"tag"};
}

@end


