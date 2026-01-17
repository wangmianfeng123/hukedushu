//
//  TagModel.m
//  Code
//
//  Created by Ivan li on 2017/10/17.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "TagModel.h"
#import <MJExtension/MJExtension.h>




@implementation ChildrenModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : [ChildrenModel class]};
}

- (NSString*)ID {
    return _ID.length? _ID : _class_id;
}

- (NSString*)class_id {
    return _class_id.length? _class_id : _ID;
}

//- (NSString *)name{
//    return _name.length ? _name : _tag;
//}

@end



@implementation TagModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : [ChildrenModel class]};
    
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id",@"keyWord": @"key"};
}

@end

@implementation preciseWordsModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirect_package":[preciseWordsModel class]};
}

@end


