//
//  HKTrainModel.m
//  Code
//
//  Created by hanchuangkeji on 2019/1/15.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKTrainModel.h"

@implementation HKTrainModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"giveVipList":[HKTrainModel class],
        @"giveLiveList":[HKTrainModel class],
        @"series":[HKSeriesCourseModel class]
    };
}

- (NSString *)start {
    if (_start.length) {
        return [self timestampSwitchTime:_start andFormatter:@"YYYY/MM/dd"];
    }
    return _start;
}

- (NSString *)end {
    
    if (_end.length) {
        return [self timestampSwitchTime:_end andFormatter:@"YYYY/MM/dd"];
    }
    return _end;
}


- (NSString *)timestampSwitchTime:(NSString *)timestamp andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp.integerValue];
    
    NSLog(@"1296035591  = %@",confromTimesp);
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

@end

@implementation HKSeriesCourseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"teacher":[HKLiveTeachModel class],
    };
}


@end
