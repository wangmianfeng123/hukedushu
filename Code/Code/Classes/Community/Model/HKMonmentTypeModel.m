//
//  HKMonmentTypeModel.m
//  Code
//
//  Created by Ivan li on 2021/1/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMonmentTypeModel.h"
@implementation HKMonmentTypeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"order":[HKMonmentTagModel class],
             @"page_filter":[HKParameterModel class]
    };
}


@end


@implementation HKMonmentTabModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"tabs":[HKMonmentTypeModel class],
             @"subjects":[HKMonmentTagModel class],
             @"orderBy":[HKMonmentTagModel class],
             @"categories":[HKMonmentTagModel class],
             @"ad_data":[HKADdataModel class],
             @"carousel_message":[HKCarouselModel class]
    };
}
@end



@implementation HKMonmentTagModel
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id",@"classVal":@"id"};
}

- (id)copyWithZone:(NSZone *)zone {
    HKMonmentTagModel *p = [[HKMonmentTagModel allocWithZone:zone] init];
    //属性也要拷贝赋值
    p.name = [self.name mutableCopy];
    p.ID = self.ID;
    p.tagSeleted = self.tagSeleted;
    p.classVal = [self.classVal copy];
    return p;
}

@end


@implementation HKADdataModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirect_package" : [HomeAdvertModel class]};
}

@end


@implementation HKCarouselModel
        
@end

@implementation HKParameterModel

@end
