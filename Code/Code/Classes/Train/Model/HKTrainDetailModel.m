//
//  HKTrainDetailModel.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTrainDetailModel.h"

@implementation HKTrainDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"date_list" : [HKTrainDetailTaskCalendarModel class],
        @"rankInfo" : [HKTrainRankInfoModel class],
        @"task_list" : [HKAllTrainTaskModel class],
        @"video" : [HKTrainTaskVideoModel class],
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end

@implementation HKAllTrainTaskModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"list" : [HKTrainTaskModel class],
    };
}

@end

@implementation HKTrainTaskModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"live_params" : [HKTrainTaskLiveParamModel class],
    };
}
@end

@implementation HKTrainTaskLiveParamModel

@end


@implementation HKTrainRankInfoModel

@end

@implementation HKDayTaskModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end

@implementation HKDayTaskGifModel

@end


@implementation HKTrainDetailInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id", @"clazz" : @"class"};
}

@end

@implementation HKTrainDetailTaskProgressModel



@end

@implementation HKTrainDetailTodayCourseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"clazz" : @"class"};
}

@end


@implementation HKTrainDetailTaskCalendarModel

@end

@implementation HKTrainTaskVideoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end

