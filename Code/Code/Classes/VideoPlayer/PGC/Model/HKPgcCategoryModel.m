

//
//  HKPgcCategoryModel.m
//  Code
//
//  Created by Ivan li on 2017/12/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPgcCategoryModel.h"


@implementation HKPgcCourseModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end


@implementation PgcTagListModel

@end


@implementation HKPgcCategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"course_list" : [HKPgcCourseModel class],@"tag_list":[PgcTagListModel class] };
}

@end


