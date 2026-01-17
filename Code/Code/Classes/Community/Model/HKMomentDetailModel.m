//
//  HKMomentDetailModel.m
//  Code
//
//  Created by Ivan li on 2021/1/25.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKMomentDetailModel.h"
#import "HKMonmentTypeModel.h"

@implementation HKMomentDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"user":[HKMonmentUserModel class],
        @"topic":[HKMonmentTopicModel class],
        @"recentlyReplies":[HKMonmentReplyModel class],
        @"subjects":[HKMonmentTagModel class],
        @"video":[HKMonmentVideoModel class],
        @"dynamic":[HKMonmentDynamicModel class],
    };
}

@end

@implementation HKMonmentUserModel

@end

@implementation HKMonmentTopicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

@implementation HKMonmentReplyModel

@end

//@implementation HKMonmentSubjectModel
//
//@end


@implementation HKMonmentVideoModel

@end

@implementation HKMonmentDynamicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"descriptions":@"description"};
}

@end

@implementation HKSubjectInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"share_data" : [ShareModel class]};
}

@end


@implementation HKrecommendUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end




       
