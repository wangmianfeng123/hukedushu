//
//  HKUserModel.m
//  FamousWine
//
//  Created by Administrator on 15/12/18.
//  Copyright © 2015年 pg. All rights reserved.
//

#import "HKUserModel.h"

@implementation HKUserModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"video_list" : [VideoModel class], @"share_data" : [ShareModel class],@"video":[VideoModel class],@"kf_url":[HKMapModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"follow"])
        return YES;
    return NO;
}

//- (NSString *)phone{
//    return @"";
//}

@end


//@implementation HKTeacherCourseModel
//
//
//@end


@implementation HKKeychainModel

+ (instancetype)sharedInstance {
    static HKKeychainModel *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

@end
