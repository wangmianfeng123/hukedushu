//
//  HKCourseModel.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCourseModel.h"
#import "HKPracticeModel.h"

@implementation HKCourseModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID" : @"id", @"videoType" : @"video_type"};
}

- (BOOL)is_study {
    return _is_study? _is_study : _is_studied;
}

- (BOOL)is_studied {
    return _is_studied? _is_studied : _is_study;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : [HKCourseModel class], @"praticesArray" : [HKPracticeModel class], @"recommends" : [VideoModel class],@"slaves" : [HKCourseModel class]};
}

- (NSString *)title {
    return _title.length? _title : _video_title.length? _video_title : _cource_title;
}

- (NSString *)video_title {
    return _video_title.length? _video_title : _title.length? _title : _cource_title;
}

- (NSString *)cource_title {
    return _cource_title.length? _cource_title : _title.length? _title : _video_title;
}

-(NSString *)video_duration{
    return _video_duration.length ? _video_duration : _videoDuration.length ? _videoDuration : _video_duration ;
}

- (NSString *)videoId {
    if (_videoId == nil) {
        return _video_id;
    }else {
        return _videoId;
    }
}

- (NSString *)video_id {
    if (_video_id == nil) {
        return _videoId;
    }else {
        return _video_id;
    }
}



- (NSMutableArray<HKCourseModel *>*)children {
    return _children ? _children :_slaves;
}


- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] allocWithZone:zone] init];
    
    Class class = [self class];
    unsigned int count = 0;
    //获取类中所有成员变量名
    Ivar *ivar = class_copyIvarList(class, &count);
    for (int i = 0; i < count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        //进行解档取值
        //            id value = [decoder decodeObjectForKey:strName];
        id value = [self valueForKey:strName];
        //利用KVC对属性赋值
        [obj setValue:value forKey:strName];
    }
    free(ivar);
    
    return obj;
}

@end
