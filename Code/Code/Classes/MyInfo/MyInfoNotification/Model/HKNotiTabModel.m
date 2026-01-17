//
//  HKNotiTabModel.m
//  Code
//
//  Created by Ivan li on 2021/1/27.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKNotiTabModel.h"

@implementation HKNotiTabModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

@implementation HKNotiMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end


@implementation HKOriginalUserModel

@end



@implementation HKOriginalModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirectPackage":[HomeAdvertModel class]};
}

@end

@implementation HKSystemNotiMsgModel

@end

