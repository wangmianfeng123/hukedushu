//  SCDateUtil.m
//  Core
//
//  Created by pg on 13-12-4.
//  Copyright (c) 2013年 code. All rights reserved.
//

#import "DateChange.h"

@implementation DateChange


+ (NSString *)getCurrentTime_day {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}


 + (NSString *)getCurrentTime {
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     //[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"]; //SSS 毫秒
     NSString *dateTime = [formatter stringFromDate:[NSDate date]];
     return dateTime;
 }

+(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}


+ (NSString *)stringFromDate24:(NSDate *)date
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFromatter stringFromDate:date];
    return strDate;
}

+ (NSDate *)dateFromString24:(NSString *)dateString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFromatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate12:(NSDate *)date
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *strDate = [dateFromatter stringFromDate:date];
    return strDate;
}

+ (NSDate *)dateFromString12:(NSString *)dateString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFromatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDay:(NSDate *)date
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFromatter stringFromDate:date];
    return strDate;
}

+ (NSDate *)dayFromString:(NSString *)dateString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFromatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromTime24:(NSDate *)time
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"HH:mm:ss"];
    NSString *strTime = [dateFromatter stringFromDate:time];
    return strTime;
}

+ (NSDate *)timeFromString24:(NSString *)timeString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"HH:mm:ss"];
    NSDate *time = [dateFromatter dateFromString:timeString];
    return time;
}

+ (NSString *)stringFromTime12:(NSDate *)time
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"hh:mm:ss"];
    NSString *strTime = [dateFromatter stringFromDate:time];
    return strTime;
}

+ (NSDate *)timeFromString12:(NSString *)timeString
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:@"hh:mm:ss"];
    NSDate *time = [dateFromatter dateFromString:timeString];
    return time;
}
+ (NSString *)stringFromTime:(NSDate *)time format:(NSString*)format
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:format];
    NSString *strTime = [dateFromatter stringFromDate:time];
    return strTime;
}

+ (NSDate *)timeFromString:(NSString *)timeString format:(NSString*)format
{
    NSDateFormatter *dateFromatter=[[NSDateFormatter alloc] init];
    [dateFromatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFromatter setDateFormat:format];
    NSDate *time = [dateFromatter dateFromString:timeString];
    return time;
}


+ (NSString *)DateFromNetWorkString:(NSString *)NetWorkString {
    
    NSString *time = [NSString stringWithFormat:@"%@",NetWorkString];
    
    NSInteger num = [time integerValue];
    if (NetWorkString.length == 13) {
        //13位时间戳
        num = num/1000;
    }
    if (NetWorkString.length == 10) {
        //10位时间戳
        num = num;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"时间---->>>>>= %@",confromTimesp);
    return  confromTimespStr;
}



+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay
                                             fromDate:fromDate
                                               toDate:toDate
                                              options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}


/**
  比较时间 先后 日期格式请传入：2017-01-01 12:12:12
    （如果修改日期格式，比如：2017-01-01）则将[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"] 修改为[df setDateFormat:@"yyyy-MM-dd"];
 */
+ (int)compareDate:(NSString*)date1 withDate:(NSString*)date2 {
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate *dt1 = [[NSDate alloc]init];
    //NSDate *dt2 = [[NSDate alloc]init];
    
    NSDate *dt1 = [df dateFromString:date1];
    NSDate *dt2 = [df dateFromString:date2];
    NSComparisonResult result = [dt1 compare:dt2];

    if (result == NSOrderedDescending) {
        //date02比date01小
        return 1;
    }else if (result == NSOrderedAscending){
        //date02比date01大
        return -1;
    }
    //时间相同
    return 0;
}



+ (NSString *)DateFromNetWorkString:(NSString *)NetWorkString  dateFormat:(NSString*)dateFormat {
    
    NSString *time = [NSString stringWithFormat:@"%@",NetWorkString];
    
    NSInteger num = [time integerValue];
    if (NetWorkString.length == 13) {
        //13位时间戳
        num = num/1000;
    }
    if (NetWorkString.length == 10) {
        //10位时间戳
        num = num;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (isEmpty(dateFormat)) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [formatter setDateFormat:dateFormat];
    }
    // hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"时间---->>>>>= %@",confromTimesp);
    return  confromTimespStr;
}



+ (NSString *)getCurrentTime_Min {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString *)getCurrentTime_Hour{
    NSString * time = [self getCurrentTime_Min];
    NSArray * array = [time componentsSeparatedByString:@":"];
    return array[0];
}



/** 两个时间 相差多少秒 */
+ (NSTimeInterval)secondWithStarDate:(NSDate *)starDate endDate:(NSDate *)endDate {
    NSTimeInterval time = [endDate timeIntervalSinceDate:starDate];
    return time;
}

+ (NSDate *)getTimeDateFromString:(NSString *)timeHourMin{
    //NSString * h = [self getCurrentTime_Hour];
    NSArray * array = [timeHourMin componentsSeparatedByString:@":"];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    [greCalendar setTimeZone: timeZone];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay  fromDate:[NSDate date]];

    //  定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:dateComponents.day];
    [dateComponentsForDate setMonth:dateComponents.month];
    [dateComponentsForDate setYear:dateComponents.year];
    [dateComponentsForDate setHour:[array[0] integerValue]];
    [dateComponentsForDate setMinute:[array[1] integerValue]];
    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    return dateFromDateComponentsForDate;
}

// 字符串时间—>时间戳
+ (NSString *)cTimestampFromString:(NSString *)theTime {
    // theTime __@"%04d-%02d-%02d %02d:%02d:00"
    // 转换为时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    // [formatter setTimeZone:timeZone];
    NSDate* dateTodo = [formatter dateFromString:theTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    return timeSp;
}



@end

