//  SCDateUtil.h
//  Core
//
//  Created by pg on 13-12-4.
//  Copyright (c) 2013年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateChange : NSObject

/**
 获取当前时间 精确到 day
 
 @return 日期
 */

+ (NSString *)getCurrentTime_day;


/**
 获取当前时间

 @return 日期
 */
+ (NSString *)getCurrentTime;

//获取当前时间戳
+(NSString *)getNowTimeTimestamp;
/**
 *  24小时制 日期转字符串 转换的格式yyyy-MM-dd HH:mm:ss
 *
 *  @param date 日期
 *
 *  @return 格式化字符串
 */
+ (NSString *)stringFromDate24:(NSDate *)date;

/**
 *  24小时制 字符串转日期 转换的格式yyyy-MM-dd HH:mm:ss
 *
 *  @param dateString 日期字符串
 *
 *  @return date
 */
+ (NSDate *)dateFromString24:(NSString *)dateString;

/**
 *  12小时制 日期转字符串 转换的格式yyyy-MM-dd hh:mm:ss
 *
 *  @param date 日期
 *
 *  @return 格式化字符串
 */
+ (NSString *)stringFromDate12:(NSDate *)date;

/**
 *  12小时制 字符串转日期 转换的格式yyyy-MM-dd hh:mm:ss
 *
 *  @param dateString 日期字符串
 *
 *  @return date
 */
+ (NSDate *)dateFromString12:(NSString *)dateString;

/**
 *  日期转字符串 转换的格式yyyy-MM-dd
 *
 *  @param date 日期
 *
 *  @return 格式化字符串
 */
+ (NSString *)stringFromDay:(NSDate *)date;

/**
 *  字符串转日期 转换的格式yyyy-MM-dd
 *
 *  @param dateString 日期字符串
 *
 *  @return date
 */
+ (NSDate *)dayFromString:(NSString *)dateString;

/**
 *  24小时制 时间转字符串 转换的格式HH:mm:ss
 *
 *  @param time 时间
 *
 *  @return 格式化字符串
 */
+ (NSString *)stringFromTime24:(NSDate *)time;

/**
 *  24小时制 字符串转时间 转换的格式HH:mm:ss
 *
 *  @param timeString 时间字符串
 *
 *  @return time
 */
+ (NSDate *)timeFromString24:(NSString *)timeString;

/**
 *  12小时制 时间转字符串 转换的格式hh:mm:ss
 *
 *  @param time 时间
 *
 *  @return 格式化字符串
 */
+ (NSString *)stringFromTime12:(NSDate *)time;

/**
 *  12小时制 字符串转时间 转换的格式hh:mm:ss
 *
 *  @param timeString 时间字符串
 *
 *  @return time
 */
+ (NSDate *)timeFromString12:(NSString *)timeString;

/**
 *  时间转字符串 转换的格式format
 *
 *  @param time 时间
 *  @param format 自定义日期时间格式
 *
 *  @return 格式化字符串
 */
+ (NSString *)stringFromTime:(NSDate *)time format:(NSString*)format;

/**
 *  字符串转时间 转换的格式format
 *
 *  @param timeString 时间字符串
 *  @param format 自定义日期时间格式
 *
 *  @return time
 */
+ (NSDate *)timeFromString:(NSString *)timeString format:(NSString*)format;


/**
 网络字符串转时间

 @param NetWorkString 网络字符串
 @return 日期
 */
+ (NSString *)DateFromNetWorkString:(NSString *)NetWorkString;


/**
 获取两个日期之间的天数
 
 * @param fromDate       起始日期
 * @param toDate         终止日期
 * @return    总天数
 */
+ (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;


/**
 比较时间 先后 日期格式请传入：2017-01-01 12:12:12
 （如果修改日期格式，比如：2017-01-01）则将[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"] 修改为[df setDateFormat:@"yyyy-MM-dd"];
 */
+ (int)compareDate:(NSString*)date1 withDate:(NSString*)date2;


/**
 网络字符串转时间
 
 @param NetWorkString 网络字符串
 
 @param dateFormat 转换格式

 @return 日期
 */
+ (NSString *)DateFromNetWorkString:(NSString *)NetWorkString  dateFormat:(NSString*)dateFormat;



/**
 获取当前时间 小时  分钟
 
 @return

 @return HH:mm
 */
+ (NSString *)getCurrentTime_Min;

/**
 获取当前时间 小时
 
 @return

 @return HH:mm
 */
+ (NSString *)getCurrentTime_Hour;


/** 两个时间 相差多少秒 */
+ (NSTimeInterval)secondWithStarDate:(NSDate *)starDate endDate:(NSDate *)endDate;


+ (NSDate *)getTimeDateFromString:(NSString *)timeHourMin;
+ (NSString *)cTimestampFromString:(NSString *)theTime;
@end

