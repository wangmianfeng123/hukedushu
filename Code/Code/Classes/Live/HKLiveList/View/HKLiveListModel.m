
//
//  HKLiveListModel.m
//  Code
//
//  Created by Ivan li on 2018/10/15.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveListModel.h"

@implementation HKLiveListModel


+(NSDictionary*)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (NSInteger)coutDownForLive {

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:_start_live_at.integerValue];
    NSDate* nowDate = [NSDate date];
    NSTimeInterval time = [startDate timeIntervalSinceDate:nowDate];
    NSInteger timeTemp = time;
//
    // 只有倒计时1秒到一个小时才返回大于0
    if (timeTemp > 0 && (timeTemp / 60.0 / 60.0) < 1.0) {
        return timeTemp + 2; // 多加2秒 初始化控件和请求延时
    } else if (timeTemp < 0) {
        return timeTemp;
    }  else {
        return 0;
    }
}

- (BOOL)coutDownMoreThanOneHourForLive {
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[_start_live_at floatValue]];
    NSDate* nowDate = [NSDate date];
    NSTimeInterval time = [startDate timeIntervalSinceDate:nowDate];
    if (time > 0 && (time / 60 / 60) > 1) {
        return YES;
    } else {
        return NO;
    }
}

@end
