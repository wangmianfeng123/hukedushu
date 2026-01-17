//
//  HKShortVideoModel.m
//  Code
//
//  Created by Ivan li on 2019/3/29.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoModel.h"
#import "HKUserModel.h"

@implementation HKShortVideoModel

+(NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"video_id" : @"id"};
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"teacher" : [HKUserModel class],@"video_tag" : [HKShortVideoTagModel class]};
    
}

@end




@implementation HKShortVideoTagModel

@end
