//
//  HKStudyTagModel.m
//  Code
//
//  Created by Ivan li on 2018/5/17.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyTagModel.h"

@implementation HKStudyTagModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"classId" : @"class"};
}

+(NSDictionary*)mj_objectClassInArray {
    return @{@"children" : [self class]};
}

- (NSString*)classId {
    return _classId.length ?  _classId :_class_id;
}


- (NSString*)class_id {
    return _class_id.length ? _class_id :_classId;
}


@end
