//
//  HKCategoryTreeModel.m
//  Code
//
//  Created by Ivan li on 2018/4/13.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategoryTreeModel.h"
#import "HKLiveListModel.h"

@implementation HKCategoryTreeModel

@end




@implementation TSModel

@end




@implementation HKcategoryChilderenModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"category_id": @"class"};
}


- (NSString*)category_id {
    return isEmpty(_category_id) ?_class_id :_category_id;
}

- (NSString*)class_id {
    return isEmpty(_class_id) ?_category_id :_class_id;
}

@end


@implementation HKcategoryListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HKcategoryChilderenModel class], @"bookList" : [HKBookModel class]};
    
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"class_id": @"class"};
}

@end



@implementation HKcategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"class_a" : [HKcategoryListModel class],
             @"class_b" : [HKcategoryListModel class],
             @"class_c" : [HKcategoryListModel class],
             @"class_0" : [HKcategoryListModel class],
             @"class_1" : [HKcategoryListModel class],
             @"class_2" : [HKcategoryListModel class],
             @"class_3" : [HKcategoryListModel class],
             @"class_5" : [HKcategoryListModel class],
             @"class_6" : [HKcategoryOnlineSchoolListModel class],
    };
}


@end



@implementation HKcategoryOnlineSchoolListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HKLiveListModel class]};
}

@end



@implementation HKcategoryOnlineSchoolModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [HKcategoryOnlineSchoolListModel class]};
}

@end



