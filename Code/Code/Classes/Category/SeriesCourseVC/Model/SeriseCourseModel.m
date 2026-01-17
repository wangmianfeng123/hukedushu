

//
//  SeriseCourseModel.m
//  Code
//
//  Created by Ivan li on 2017/10/25.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "SeriseCourseModel.h"

@implementation SeriseCourseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end


@implementation SeriseTagModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}



@end


@implementation SeriseListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"lesson_class" : [SeriseTagModel class],@"lesson_list" : [SeriseCourseModel class]};
}

@end
