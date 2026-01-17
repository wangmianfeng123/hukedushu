//
//  HKAchievementModel.m
//  Code
//
//  Created by ivan on 2020/8/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKAchievementModel.h"
#import "BannerModel.h"

@implementation HKAchievementModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"redirect" : [HKMapModel class]};
}

@end
