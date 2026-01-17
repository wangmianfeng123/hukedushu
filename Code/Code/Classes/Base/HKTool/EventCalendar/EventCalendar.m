//
//  EventCalendar.m
//  app添加到手机日历提醒事件
//
//  Created by 刘燕鲁 on 16/12/27.
//  Copyright © 2016年 刘燕鲁. All rights reserved.
//

#import "EventCalendar.h"
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>


@interface EventCalendar ()
@property (nonatomic, strong) NSDateFormatter *tempFormatter;

@end

@implementation EventCalendar


static EventCalendar *calendar;

+ (instancetype)sharedEventCalendar{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[EventCalendar alloc] init];
    });
    
    return calendar;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [super allocWithZone:zone];
    });
    return calendar;
}

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray{
    __weak typeof(self) weakSelf = self;
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error)
                {
                    [strongSelf showAlert:@"添加失败，请稍后重试"];
                    
                }else if (!granted){
                    [strongSelf showAlert:@"暂未授权使用日历,请在设置中允许此App使用日历"];
                    
                }else{
                    
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    self.tempFormatter = [[NSDateFormatter alloc]init];
                    [self.tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = allDay;
                    EKRecurrenceRule * rule = [self repeatRule:0 currentDate:startDate];
                    if (rule != nil) {
                        event.recurrenceRules = @[rule];
                    }else{
                        event.recurrenceRules = nil;
                    }
                    
                    
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        
                        for (NSString *timeString in alarmArray) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    //[strongSelf showAlert:@"已添加到系统日历中"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HKCanlendarWitch];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            });
        }];
    }
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//重复规则
- (EKRecurrenceRule *)repeatRule:(NSInteger)repeatIndex currentDate:(NSDate*)date{
    NSDate *currentDate = date;
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:currentDate];
    components.year += 1;
    NSDate *recurrenceEndDate = [gregorian dateFromComponents:components];//高频率：每天、每两天、工作日
    NSDateComponents *components2 = [gregorian components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:currentDate];
    components2.year += 3;
    NSDate *recurrenceEndDate2 = [gregorian dateFromComponents:components2];//低频率：每周、每月、每年

    EKRecurrenceRule * rule;
    switch (repeatIndex) {
        case 0://每天
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:[EKRecurrenceEnd recurrenceEndWithEndDate:recurrenceEndDate]];
            break;
        case 1://每两天
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:2 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:[EKRecurrenceEnd recurrenceEndWithEndDate:recurrenceEndDate]];
            break;
        case 2://每周
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:[EKRecurrenceEnd recurrenceEndWithEndDate:recurrenceEndDate2]];
            break;
        case 3://每月
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:[EKRecurrenceEnd recurrenceEndWithEndDate:recurrenceEndDate2]];
            break;
        case 4://每年
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 daysOfTheWeek:nil daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:[EKRecurrenceEnd recurrenceEndWithEndDate:recurrenceEndDate2]];
            break;
        case 5://工作日
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 daysOfTheWeek:[NSArray arrayWithObjects:[EKRecurrenceDayOfWeek dayOfWeek:2],[EKRecurrenceDayOfWeek dayOfWeek:3],[EKRecurrenceDayOfWeek dayOfWeek:4],[EKRecurrenceDayOfWeek dayOfWeek:5],[EKRecurrenceDayOfWeek dayOfWeek:6],nil] daysOfTheMonth:nil monthsOfTheYear:nil weeksOfTheYear:nil daysOfTheYear:nil setPositions:nil end:[EKRecurrenceEnd recurrenceEndWithEndDate:recurrenceEndDate]];
            break;
        case 6:
            rule = nil;
            break;
        default:
            rule = nil;
            break;
    }
    return rule;
}

@end
