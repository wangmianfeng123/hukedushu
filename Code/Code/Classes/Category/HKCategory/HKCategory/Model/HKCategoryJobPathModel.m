//
//  HKCategoryJobPathModel.m
//  Code
//
//  Created by ivan on 2020/6/28.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKCategoryJobPathModel.h"

@implementation HKCategoryJobPathModel

+(NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return @{@"descr":@"description"};
}

@end
