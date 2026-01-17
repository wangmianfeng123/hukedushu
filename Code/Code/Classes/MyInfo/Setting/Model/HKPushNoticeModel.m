//
//  HKPushNoticeModel.m
//  Code
//
//  Created by Ivan li on 2021/7/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPushNoticeModel.h"

@implementation HKPushNoticeModel
MJCodingImplementation

-(NSString *)pushFrequency{
    if (_pushFrequency == nil) {
        if ([self.j_push_type intValue] == 0) {
            _pushFrequency = @"每天";
        }else if ([self.j_push_type intValue] == 1){
            _pushFrequency = @"法定工作日";
        }else if ([self.j_push_type intValue] == 2){
            _pushFrequency = @"法定节假日";
        }else if ([self.j_push_type intValue] == 3){
            _pushFrequency = @"周一至周五";
        }else if ([self.j_push_type intValue] == 4){
            _pushFrequency = @"周六至周日";
        }else{
            _pushFrequency = @"";
        }
    }
    return _pushFrequency;
}

-(NSString *)j_push_hour_typeString{
    if (_j_push_hour_typeString == nil) {
        if ([self.j_push_hour_type intValue] == 2) {
            _j_push_hour_typeString = @"30";
        }else {
            _j_push_hour_typeString = @"00";
        }
    }
    return _j_push_hour_typeString;
}

@end
