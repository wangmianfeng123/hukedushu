//
//  HKPresentHeaderModel.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/9.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPresentHeaderModel.h"
#import "HKBookModel.h"


@implementation HKPresentHeaderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"moreCoinArray" : [HKPresentHeaderMoreCoinModel class], @"reward_list" : [HKLuckPriceModel class], @"sign_list" : [HKCoinDayModel class], @"task_list" : [HKTasktModel class]};
}

-(NSString *)pushFrequency{
    if (_pushFrequency == nil) {
        if ([self.sign_notify_type intValue] == 0) {
            _pushFrequency = @"每天";
        }else if ([self.sign_notify_type intValue] == 1){
            _pushFrequency = @"法定工作日";
        }else if ([self.sign_notify_type intValue] == 2){
            _pushFrequency = @"法定节假日";
        }else if ([self.sign_notify_type intValue] == 3){
            _pushFrequency = @"周一至周五";
        }else if ([self.sign_notify_type intValue] == 4){
            _pushFrequency = @"周六至周日";
        }else{
            _pushFrequency = @"";
        }
    }
    return _pushFrequency;
}

-(NSString *)j_push_hour_typeString{
    if (_j_push_hour_typeString == nil) {
        if ([self.sign_notify_hour_type intValue] == 2) {
            _j_push_hour_typeString = @"30";
        }else {
            _j_push_hour_typeString = @"00";
        }
    }
    return _j_push_hour_typeString;
}


@end

@implementation HKPresentHeaderMoreCoinModel


@end

@implementation HKCoinDayModel

@end

@implementation HKTasktModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"descrip": @"description",@"ID": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HKTasktModel class]};
}

@end

@implementation HKTaskClassObjectModel

@end

@implementation HKPrensentRec

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"book" : [HKBookModel class]};
}


@end



