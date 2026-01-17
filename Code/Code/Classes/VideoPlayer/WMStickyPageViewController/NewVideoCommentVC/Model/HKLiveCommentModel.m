//
//  HKLiveCommentModel.m
//  Code
//
//  Created by Ivan li on 2020/12/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveCommentModel.h"

@implementation HKLiveCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"user":[HKCommentUser class],
        @"commentImages":[HKCommentImageModel class]
    };
}
@end

@implementation HKCommentUser

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end


@implementation HKCommentImageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end
