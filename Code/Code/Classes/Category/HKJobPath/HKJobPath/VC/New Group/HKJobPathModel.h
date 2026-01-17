//
//  HKJobPathModel.h
//  Code
//
//  Created by Ivan li on 2019/6/24.
//  Copyright © 2019 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HKJobPathChapterInfoModel;


@interface HKJobPathModel : NSObject

@property(nonatomic,copy)NSString *career_id;

@property(nonatomic,copy)NSString *first_chapter_id;

@property(nonatomic,copy)NSString *first_section_id;

@property(nonatomic,copy)NSString *first_video_id;

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *desc;

@property(nonatomic,copy)NSString *cover;

@property(nonatomic,assign)NSInteger chapter_number;

@property(nonatomic,assign)NSInteger course_number;

@property(nonatomic,copy)NSString *study_number;
/** 章节*/
@property(nonatomic,copy)NSString *chapter_sort;



@property(nonatomic,copy)NSString *chapter_id;

@property(nonatomic,copy)NSString *section_id;

@property(nonatomic,copy)NSString *video_id;

@property(nonatomic,assign)NSInteger studied_total;




@property(nonatomic,assign)NSInteger chapter_count;

@property(nonatomic,assign)NSInteger course_count;

@property(nonatomic,copy)NSString *total_time;

@property(nonatomic,strong)HKJobPathChapterInfoModel *first_chapter_info;


// C4D  课程数
@property(nonatomic,copy)NSString *master_video_total;
// 练习数
@property(nonatomic,copy)NSString *slave_video_total;
// c4d 类型
@property(nonatomic,copy)NSString  *career_type;


@property(nonatomic,copy)NSString *video_title;

@property(nonatomic,copy)NSString *chapter_title;
/** 用于 后台统计 */
@property(nonatomic,copy)NSString *source;

@end






@interface HKJobPathChapterInfoModel : NSObject

@property(nonatomic,copy)NSString *chapter_id;

@property(nonatomic,copy)NSString *first_section_id;

@property(nonatomic,copy)NSString *first_video_id;

@property(nonatomic,copy)NSString *cover;

@end







@interface HKJobPathStudyedModel : NSObject

@property(nonatomic,assign)NSInteger total_count;

@property(nonatomic,assign)NSInteger studiedCount;

@property(nonatomic,strong)HKJobPathModel *lastStudied;

@end






@interface HKJobPathPageInfoModel : NSObject

@property(nonatomic,assign)NSInteger current_page;

@property(nonatomic,assign)NSInteger page_size;

@property(nonatomic,assign)NSInteger page_total;

@property(nonatomic,assign)NSInteger total_count;

@end


@interface HKJobPathHeadGuideModel : NSObject

@property (nonatomic,assign) BOOL is_show;
@property (nonatomic, copy)NSString * string;
@property (nonatomic , strong) HKMapModel * redirect_package;
@end



NS_ASSUME_NONNULL_END
