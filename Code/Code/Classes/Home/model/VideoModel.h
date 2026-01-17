//
//  VideoModel.h
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKMyLiveModel.h"

#define  HomeToken   @"Bearer-994C2B0E3A595A4FBE6002CA3FBA5A39"


@class HKMapModel;


@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *video_id;

@property (nonatomic, copy)NSString *root_id;

@property (nonatomic, copy)NSString *root_type;

@property (nonatomic, copy)NSString *doc_count; // 普通视频已学

@property (nonatomic, copy)NSString *master_count; // 普通视频非单个的数量

@property (nonatomic, copy)NSString *slave_count; // 普通视频非单个的l练习题数量

@property (nonatomic, copy)NSString *lesson_num;

@property (nonatomic, copy)NSString *studied_count;

@property (nonatomic, copy) NSString *video_titel;

@property (nonatomic, copy) NSString *video_title;
//视频页默认图
@property (nonatomic, copy) NSString *img_cover_url;
//视频页默认图
@property (nonatomic, copy) NSString *img_cover_url_big;
//视频时长
@property (nonatomic, copy) NSString *video_duration;
//难度级别
@property (nonatomic, copy) NSString *viedeo_difficulty;
@property (nonatomic, copy) NSString *difficulty;

@property (nonatomic , assign) BOOL is_series ; //是否是系列课
@property (nonatomic, assign)BOOL isOldAccess; // 已学旧接口

@property (nonatomic , assign) BOOL is_normal_video ;//是否普通视频 非普通视频展示是否完结 视频数
//@property (nonatomic , assign) BOOL is_end ;//是否完结
@property (nonatomic , copy) NSString * video_total ;//视频数

@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, copy)NSString *live_course_id;
@property (nonatomic, copy)NSString *live_small_id;
@property (nonatomic, copy)NSString *start_live_at;

@property (nonatomic, assign)BOOL isMoreModel; // 更多的按钮

// 图文教程
@property (nonatomic, assign)BOOL has_pictext;

@property (nonatomic, copy) NSString *video_application;

@property (nonatomic, copy) NSString *is_show_deadline; //is_show_deadline:是否显示7天有效 1-显示 0-不显示
@property (nonatomic, assign) BOOL is_collect;// 是否已经收藏

/*********系列课*********/
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *cover;

@property (nonatomic, assign)NSInteger courseCount;
@property (nonatomic, copy)NSString *watch_nums;

@property (nonatomic, copy)NSString *update_status;
//@property (nonatomic, assign)NSInteger update_status;
@property (nonatomic, assign)NSInteger videoType;
/** 总课时*/
@property (nonatomic, assign)NSInteger total_course;
/** 已更新课时*/
@property (nonatomic, assign)NSInteger update_course;

/*********系列课*********/

/********* PGC *********/
@property (nonatomic,copy)NSString *cover_url;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *avator;

@property (nonatomic,copy)NSString *now_price;

@property (nonatomic,copy)NSString *old_price;

@property (nonatomic,copy)NSString *discount_price;

@property (nonatomic,copy)NSString *price;

@property (nonatomic,copy)NSString *ID;
/** 视频类型   1- VIP课  2-PGC*/
@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *curriculum_total;

//@property (nonatomic,copy)NSString *img_cover_url;

@property (nonatomic,copy)NSString *pgc_id;

//@property (nonatomic,copy)NSString *study_info;

//@property (nonatomic,copy)NSString *study_num;

//@property (nonatomic,copy)NSString *title;



/********** 音频 ************/
@property (nonatomic,copy)NSString *audio_id;

//@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *duration;

@property (nonatomic,copy)NSString *play_num;

/** 播放次数 */
@property (nonatomic,copy)NSString *video_play;
/** 图片 */
//@property (nonatomic,copy)NSString *cover_url;
/** 音频地址 */
@property (nonatomic,copy)NSString *audio_url;

@property (nonatomic,copy)NSString *teacher_id;

/** 是否正在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 是否喜欢 */
@property (nonatomic, assign) BOOL isLike;


/******************** 搜索系列课 ************************/
@property (nonatomic,copy)NSString *tag_id;

@property (nonatomic,copy)NSString *summary;

@property (nonatomic,copy)NSString *lesson_total;

/******************** 搜索系专辑 ************************/
/** 专辑ID */
@property (nonatomic,copy)NSString *album_id;
/** 收藏数 */
@property (nonatomic,copy)NSString *collect_num;
/** 教程数 */
@property (nonatomic,copy)NSString *video_num;
/** 专辑名 */
@property (nonatomic,copy)NSString *username;
/** 专辑高斯模糊图片 */
@property (nonatomic,copy)NSString *gaussian_blur_url;


/******************** 软件入门 ************************/
//is_vip:1-是VIP 0-非VIP，video_id：点击后要跳转的视频ID，is_end：1-已完结 0-更新中

/// 是否显示 证书标签1：显示 0：不显示
@property (nonatomic,assign)BOOL app_cert_show;
/// 证书是否完成 1：完成 0：未完成
@property (nonatomic,assign)BOOL is_completed;
/** 学习进度*/
@property (nonatomic,copy)NSString *study_progress;
@property (nonatomic ,assign)BOOL icon_show;
/** 标题*/
@property (nonatomic,copy)NSString *abbr;
/** is_end：1-已完结 0-更新中*/
@property (nonatomic,copy)NSString *is_end;
/** 课程总数*/
@property (nonatomic,copy)NSString *master_video_total;

//@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *route_id;
/** 购买课程人数*/
@property (nonatomic,copy)NSString *slave_video_total;
/** 小图标 */
@property (nonatomic,copy)NSString *small_img_url;
/** 已经学课程数*/
@property (nonatomic,copy)NSString *study_num;
/** 已经学课程 百分比*/
@property (nonatomic,copy)NSString *study_num_sort;
/** */
//@property (nonatomic,copy)NSString *tag_id;

//@property (nonatomic,copy)NSString *video_id;

/** 最近在学 封面*/
@property (nonatomic,copy)NSString *cover_img_url;
/** 软件入门 ID*/
@property (nonatomic,copy)NSString *anchorVideoId;
/** 最近在学课程 百分比*/
@property (nonatomic,copy)NSString *study_info;
/** 软件入门 ID*/
@property (nonatomic,copy)NSString *anchor_video_id;
/** 左侧 标签图片  */
@property (nonatomic,copy)NSString *tagImageName;
/** 软件 介绍*/
@property (nonatomic,copy)NSString *simple_introduce;

@property (nonatomic,copy)NSString *avatar;

@property (nonatomic,assign)NSInteger index;
//@property (nonatomic, assign) NSInteger is_completed;


#pragma mark - 用于全选 删除 视频
@property (nonatomic, assign) BOOL isCellSelected;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger section;



//**************** 短视频  **************/
@property (nonatomic,copy)NSString * desc;

@property (nonatomic,assign)NSInteger playCount;

@property (nonatomic,copy)NSString *tid;

@property (nonatomic,copy)NSString *video_time;


//**************** 搜索页软件  **************/
@property (nonatomic,copy)NSString *app_small_img_url;
/** 课程数 */
@property (nonatomic,assign)NSInteger master_curriculum;
/** 练习数 */
@property (nonatomic,assign)NSInteger slave_curriculum;

@property (nonatomic,copy)NSString *cover_image_url;

@property (nonatomic,assign)BOOL is_collected;

@property (nonatomic,copy)NSString *study_total;

//@property (nonatomic,copy)NSString *video_total;

@property (nonatomic,copy)NSString *time;

@property (nonatomic,copy)NSString *video_view;

//**************** 职业路径  **************/

@property (nonatomic,copy)NSString *section_id;
/// 观看进度
@property (nonatomic,copy)NSString *rate;


/******************** 搜索直播课 ************************/
@property (nonatomic,copy)NSString *klass;
@property (nonatomic,copy)NSString *live_small_catalog_id;
//@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *surface_url;
//@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *is_charge;
@property (nonatomic,copy)NSString *price_all;
//@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *lession_num;
@property (nonatomic,copy)NSString *show_num;
@property (nonatomic,copy)NSString *filter_class;
@property (nonatomic,copy)NSString *view;
@property (nonatomic,copy)NSString *teacherName;
//@property (nonatomic,copy)NSString *avator;
@property (nonatomic,copy)NSString *live_status;
//@property (nonatomic,copy)NSString *start_live_at;
//@property (nonatomic,copy)NSString *video_id;
@property (nonatomic,copy)NSString *teacherUid;
@property (nonatomic,copy)NSString *descript;
@property (nonatomic,copy)NSString *level;
@property (nonatomic,copy)NSString *enrolment_people;
//@property (nonatomic,copy)NSString *ID;
@property (nonatomic , strong) NSMutableArray * teacher;
@property (nonatomic, copy)NSString * label;
@property (nonatomic, copy)NSString * liveTime;
@property (nonatomic, copy)NSString * lessionAndLike;
@property (nonatomic, copy)NSString * recentStudy;  //
@property (nonatomic, copy)NSString * studyNum;  //已学课时
//@property (nonatomic, copy)NSString * lession_num;  //总课时

@property (nonatomic , assign) BOOL isHomeSign;//标记是否是猜你喜欢标签


@property (nonatomic,strong) HKMapModel *redirect_package;
@end



















//收藏列表
@interface CollectionListModel : NSObject

/** type --1普通视频 ， 2-PGC */
@property (nonatomic,copy)NSString *type;
/** PGC*/
@property (nonatomic,strong)VideoModel *class_1;
/** 普通视频*/
@property (nonatomic,strong)VideoModel *class_2;

@end




@interface C4DHeadModel : NSObject

@property (nonatomic, copy) NSString *master_video_total;

@property (nonatomic, copy) NSString *slave_video_total;

@property (nonatomic, copy) NSString *video_id;

@end

















