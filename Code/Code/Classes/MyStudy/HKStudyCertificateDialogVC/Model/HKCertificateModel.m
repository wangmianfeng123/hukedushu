//
//  HKCertificateModel.m
//  Code
//
//  Created by Ivan li on 2018/12/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCertificateModel.h"


@implementation HKCertificateAchieveInfoModel

@end




@implementation HKCertificateModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"achieve_info" : [HKCertificateAchieveInfoModel class],@"button_info" : [HKMapModel class]};
}


@end
