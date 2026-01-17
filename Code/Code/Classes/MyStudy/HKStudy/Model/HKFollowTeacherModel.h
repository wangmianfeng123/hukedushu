//
//  HKFollowTeacherModel.h
//  Code
//
//  Created by yxma on 2020/10/9.
//  Copyright © 2020 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKFollowTeacherModel : NSObject
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString * live_catalog_small_id;
@property (nonatomic, copy) NSString * teacher_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * avator;

@property (nonatomic, copy) NSString * tags_id;
@property (nonatomic, copy) NSString * follow;
@property (nonatomic, copy) NSString * follow_count;
@property (nonatomic, copy) NSString * updated_at;
@property (nonatomic, copy) NSString * sort_at;

@end


@interface HKFollowVideoModel : NSObject
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString * img_cover_url;
@property (nonatomic, copy) NSString * gif_url;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * video_id;
@property (nonatomic, copy) NSString * opened_at;
@property (nonatomic, copy) NSString * img_cover_url_big;
@property (nonatomic, copy) NSString *  teacher_id;
@property (nonatomic, copy) NSString * teacher_avator;
@property (nonatomic, copy) NSString * teacher_name;

@end

NS_ASSUME_NONNULL_END
