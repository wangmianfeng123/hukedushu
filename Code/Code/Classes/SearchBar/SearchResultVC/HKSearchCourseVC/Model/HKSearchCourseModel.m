//
//  HKSearchCourseModel.m
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSearchCourseModel.h"
#import "TagModel.h"
#import "HKContainerModel.h"



@implementation HKSearchCourseModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : [VideoModel class],@"class_list" : [TagModel class], @"series_list": [HKSerieslistModel class]  ,@"course_list": [VideoModel class] ,@"album_list": [VideoModel class],@"teacher_list": [HKUserModel class] , @"filter_list" : [TagModel class] , @"order_list" : [TagModel class]
             
             ,@"album_match": [HKTeacherMatchModel class] ,@"article_match": [HKTeacherMatchModel class] ,@"teacher_match": [HKTeacherMatchModel class] ,@"software_match": [HKTeacherMatchModel class], @"video_list": [HKRecommendVideoListModel class]
        };
}


- (NSMutableArray<TagModel*> *)class_list {
    return _class_list.count ? _class_list : _filter_list;
}

- (NSMutableArray<TagModel*> *)filter_list {
    return _filter_list.count ? _filter_list : _class_list;
}

@end



@implementation CourseTagModel

@end


@implementation SearchPageInfo

@end



@implementation HKTeacherMatchModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"first_match" : [HKFirstMatchModel class]};
}

@end



@implementation HKFirstMatchModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end



@implementation HKSerieslistModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"video_list" : [VideoModel class]};
}


@end



@implementation HKRecommendVideoListModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : [VideoModel class],@"page_info" : [SearchPageInfo class]};
}

@end





