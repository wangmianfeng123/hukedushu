//
//  HKHotTopicModel.m
//  Code
//
//  Created by Ivan li on 2021/1/29.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKHotTopicModel.h"
#import "HKMonmentTypeModel.h"

@implementation HKHotTopicModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [HKMonmentTagModel class]};
}

@end
