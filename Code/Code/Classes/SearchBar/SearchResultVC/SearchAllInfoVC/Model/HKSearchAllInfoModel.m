//
//  HKSearchAllInfoModel.m
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSearchAllInfoModel.h"


@implementation HKSearchAllInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [VideoModel class], @"teacher_list":[HKUserModel class], @"class_list":[TagModel class]};
}



@end
