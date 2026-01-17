//
//  HKBookModel.m
//  Code
//
//  Created by hanchuangkeji on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookModel.h"

@implementation HKBookModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return  @{@"book_course_id":@"id"};
}

@end




@implementation HKBookPlayInfoModel

@end





@implementation HKTagModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName {
    return  @{@"tagId":@"id"};
}

@end




@implementation HKLastBookModel

@end



@implementation HKRelateBookModel

+(NSDictionary*)mj_objectClassInArray {
    return @{@"last_book" : [HKLastBookModel class],@"next_book" : [HKLastBookModel class]};
}

@end

@implementation HKUserFetchCerModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"redirect":[HKCerRedirectModel class]};
}
@end

@implementation HKCerRedirectModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list":[HKCerRedirectListModel class]};
}
@end

@implementation HKCerRedirectListModel

@end

