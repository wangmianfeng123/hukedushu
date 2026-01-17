//
//  HKMyLiveModel.m
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKMyLiveModel.h"

@implementation HKMyLiveModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"teacher":[HKLiveTeachModel class]};
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"ID":@"id",
        @"className":@"class"
    };
}
@end

@implementation HKLiveTeachModel

@end


@implementation HKClassListModel
MJCodingImplementation
- (id)copyWithZone:(NSZone *)zone {
    HKClassListModel *p = [[HKClassListModel allocWithZone:zone] init];
    //属性也要拷贝赋值
    p.name = [self.name mutableCopy];
    p.classVal = [self.classVal copy];
    p.tagSeleted = self.tagSeleted;
    return p;
}

@end
