
//
//  HKMyInfoUserModel.m
//  Code
//
//  Created by Ivan li on 2018/9/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyInfoUserModel.h"

@implementation HKMyInfoUserModel

@end



@implementation HKMyInfoVipModel

+(NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"vip_class" : @"vip_type"};
}

@end



@implementation HKMyInfoMapPushModel


@end

@implementation HKMyInfoGuideLearnModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"id" : @"ID"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirect_package":[HKMapModel class]};
}
@end

@implementation UnreadMessageModel

@end

