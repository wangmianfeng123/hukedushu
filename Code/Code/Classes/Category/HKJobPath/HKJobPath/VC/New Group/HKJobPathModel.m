

//
//  HKJobPathModel.m
//  Code
//
//  Created by Ivan li on 2019/6/24.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKJobPathModel.h"

@implementation HKJobPathModel

+(NSDictionary*)mj_replacedKeyFromPropertyName {
    
    return  @{@"desc" : @"description"};
}

@end



@implementation HKJobPathChapterInfoModel

@end


@implementation HKJobPathPageInfoModel

@end




@implementation HKJobPathStudyedModel

@end


@implementation HKJobPathHeadGuideModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirect_package" : [HKMapModel class]};
}

@end





