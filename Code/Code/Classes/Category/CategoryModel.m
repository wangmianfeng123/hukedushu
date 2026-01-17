//
//  CategoryModel.m
//  Code
//
//  Created by Ivan li on 2017/8/22.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

//+(JSONKeyMapper*)keyMapper {
//
//    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"class": @"className",}];
//}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"className" : @"class"};
}

@end


@implementation HomeCategoryModel

//+(JSONKeyMapper*)keyMapper {
//
//    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"class": @"className",}];
//}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"className" : @"class"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirect_package":[HomeAdvertModel class]};
}

@end



@implementation PageCategoryModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : [HomeCategoryModel class]};
}

@end

