//
//  HKArticleModel.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleCategoryModel.h"

@implementation HKArticleCategoryModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return @{@"tagId":@"id"};
}

@end

