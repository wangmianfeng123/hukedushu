
//
//  HKLiveRecommendCourseModel.m
//  Code
//
//  Created by ivan on 2020/8/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveRecommendCourseModel.h"

@implementation HKLiveRecommendCourseModel


+(NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return  @{@"courseId":@"id"};
}


+(NSDictionary *)mj_objectClassInArray {
    return @{@"teachers":[HKUserModel class]};
}

@end
