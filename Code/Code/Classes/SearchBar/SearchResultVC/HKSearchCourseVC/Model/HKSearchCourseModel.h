//
//  HKSearchCourseModel.h
//  Code
//
//  Created by Ivan li on 2017/11/29.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideoModel,TagModel,HKAlbumModel,SeriseCourseModel,HKFirstMatchModel,HKTeacherMatchModel,HKSerieslistModel,HKRecommendVideoListModel;


//搜索--筛选课程标签
@interface CourseTagModel : NSObject

@property(nonatomic,copy)NSString *tag_id; //讲师属性

@property(nonatomic,copy)NSString *tag;  //讲师属性

@property(nonatomic,copy)NSString *class_id; //课程属性

@property(nonatomic,copy)NSString *name;    //课程属性

@property(nonatomic,assign)BOOL isSelect;

@end




@interface SearchPageInfo : NSObject

@property(nonatomic,assign) NSInteger page_total;

@property(nonatomic,assign) NSInteger current_page;

@property(nonatomic,assign) NSInteger total_count;

@property(nonatomic,assign) NSInteger page_size;

@end




@interface HKSearchCourseModel : NSObject

@property(nonatomic,copy)NSString *keyword;

@property(nonatomic,copy)NSString *count;
/// 页数判断  V2.11 以前
@property(nonatomic,copy)NSString *page;

@property(nonatomic,copy)NSString *total_page;

/** 视频 */
@property (nonatomic, strong)NSMutableArray<VideoModel *> *list;
/** 筛选标签 */
@property (nonatomic, strong)NSMutableArray<TagModel*> *class_list;
/** 教师 */
@property (nonatomic, strong)NSMutableArray<HKUserModel *> *teacher_list;
/** 系列课 */
//@property (nonatomic, strong)NSMutableArray<VideoModel *> *series_list;
/** 名师机构 */
@property (nonatomic, strong)NSMutableArray<VideoModel *> *course_list;
/** 专辑 */
@property (nonatomic, strong)NSMutableArray<VideoModel *> *album_list;

/// 请注意 不要瞎鸡吧改  页数判断  V2.11
@property (nonatomic, strong)SearchPageInfo *page_info;

/** 筛选标签 */ //V2.11
@property (nonatomic, strong)NSMutableArray<TagModel*> *filter_list;
/** 排序标签 */
@property (nonatomic, strong)NSMutableArray<TagModel*> *order_list;
/** 排序标签 */
@property (nonatomic, strong)NSMutableArray<TagModel*> *classList;

/** 专辑 */
@property (nonatomic, strong)HKTeacherMatchModel *album_match;
/** 文章 */
@property (nonatomic, strong)HKTeacherMatchModel *article_match;
/** 讲师 */
@property (nonatomic, strong)HKTeacherMatchModel *teacher_match;
/** 软件 */
@property (nonatomic, strong)HKTeacherMatchModel *software_match;
/** 系列课 */
@property (nonatomic, strong)HKSerieslistModel *series_list;
/** 推荐的普通课*/
@property (nonatomic, strong)HKRecommendVideoListModel *video_list;

@property(nonatomic,copy)NSString *identify;

@end




@interface HKTeacherMatchModel : NSObject

@property(nonatomic,strong)NSMutableArray<HKFirstMatchModel*> *first_match;

@property(nonatomic,assign)NSInteger match_count;

@property(nonatomic,assign)NSInteger is_show;

@end



@interface HKFirstMatchModel : NSObject

// 讲师
@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *uid;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *follow;

@property(nonatomic,copy)NSString *curriculum_num;

@property(nonatomic,copy)NSString *avator;

@property(nonatomic,assign)BOOL is_follow;

//搜索页面
@property (nonatomic, assign)int is_live;
//is_live
@property (nonatomic, copy)NSString * live_catalog_small_id;




// 软件
@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *app_small_img_url;

@property(nonatomic,copy)NSString *study_num;

@property(nonatomic,copy)NSString *master_curriculum;

@property(nonatomic,copy)NSString *slave_curriculum;

@property(nonatomic,copy)NSString *video_id;

@property(nonatomic,copy)NSString * is_end;


// 专辑
@property(nonatomic,copy)NSString *cover;

@property(nonatomic,copy)NSString *collect_num;

@property(nonatomic,copy)NSString *video_num;

@property(nonatomic,copy)NSString *author;


// 文章
@property(nonatomic,copy)NSString *cover_pic;

@property(nonatomic,copy)NSString *teacher_uid;

@property(nonatomic,copy)NSString *show_num;

@property(nonatomic,copy)NSString *appreciate_num;

@property(nonatomic,assign)BOOL is_exclusive;


@end




@interface HKSerieslistModel : NSObject

@property(nonatomic,assign)BOOL is_show;

@property(nonatomic,assign)NSInteger total_count;

@property(nonatomic, strong)NSMutableArray<VideoModel *> *video_list;


@end



@interface HKRecommendVideoListModel : NSObject

@property(nonatomic, strong)NSMutableArray<VideoModel *> *list;

@property (nonatomic, strong)SearchPageInfo *page_info;

@end

