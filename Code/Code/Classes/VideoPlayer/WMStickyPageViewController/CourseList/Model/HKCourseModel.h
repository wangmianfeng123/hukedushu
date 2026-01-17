//
//  HKCourseModel.h
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HKPracticeModel.h"

@interface HKCourseModel : NSObject

@property (nonatomic, strong)NSArray<VideoModel *> *recommends; // 推荐课程
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *title;// 练习目录名字
@property (nonatomic, copy)NSString * cover;// 练习目录名字

@property (nonatomic, copy)NSString *enrolment_people;// 直播报名人数
@property (nonatomic, copy)NSString *salve_video_total;// 练习数量
@property (nonatomic, copy)NSString *slave_string;// 练习数量
@property (nonatomic, copy)NSString *img_cover_url;
@property (nonatomic, copy)NSString *parent_id;
@property (nonatomic, copy)NSString *video_id;// 视频ID
@property (nonatomic, copy)NSString *videoId;// 视频ID
@property (nonatomic, copy)NSString *watch_nums;// 观看人数
@property (nonatomic, copy)NSString *level_id;//
@property (nonatomic, assign)int videoType;// 视频类型
@property (nonatomic, copy)NSString *image_url;// 封面
@property (nonatomic, copy)NSString *video_url;// 资源文件
@property (nonatomic, copy)NSString *video_play;//
@property (nonatomic, copy)NSString *teacher_qr;//班主任微信

@property (nonatomic, assign)BOOL is_study;// 是否已经学习过
@property (nonatomic, assign)BOOL is_studied;// 是否已经学习过
@property (nonatomic, assign)BOOL needStudyLocal;// 是否本地已经学习过
@property (nonatomic, assign)BOOL currentWatching;// 当前正在观看的视频
@property (nonatomic, copy)NSString *surface_url; // 直播封面图
@property (nonatomic, copy)NSString *currentCover; // 直播封面图
@property (nonatomic, copy)NSString *videoDuration; // 视频时长

@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *children;// 二级目录

@property (nonatomic, strong)NSMutableArray<HKPracticeModel *> *praticesArray;// 练习题

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *praticeNO;// 序列
@property (nonatomic, copy)NSString *praticeName;// 名字

@property (nonatomic, copy)NSString *summary;// 教程概述
@property (nonatomic, copy)NSString *application_direction;// 应用方向
@property (nonatomic, copy)NSString *suitable_for_groups;// 适合群体
@property (nonatomic, assign)BOOL islocalCache;// 本地缓存完成

@property (nonatomic, assign)BOOL expandExcercises; // 是否展开练习题
@property (nonatomic, assign)BOOL isPlayingExpandExcercises; // 是否展开正在播放的练习题
@property (nonatomic, assign)BOOL isExcercises; // 是否是练习题

/********************** PGC **********************/

@property (nonatomic,copy)NSString *video_title;

@property (nonatomic,copy)NSString *is_free;
/** 是否加锁：1-加锁 0-不加 */
@property (nonatomic,copy)NSString *is_lock;

/********************** PGC 目录 **********************/
@property (nonatomic, copy)NSString *cource_title; //课程标题

@property (nonatomic, copy)NSString *cource_duration;//时长

@property (nonatomic, copy)NSString *pay_people;//付费人数

@property (nonatomic, copy)NSString *price; //原价
@property (nonatomic, copy)NSString *original_price; //原价
/** 1-已购买课程 0-未购买课程 用于显示购买栏 */
@property (nonatomic, copy)NSString *is_buy;
/** 特价，为空表示没有特价 */
@property (nonatomic, copy)NSString *tag_1;
/**VIP折扣价标识，为空表示没有折扣价*/
@property (nonatomic, copy)NSString *tag_2;

@property (nonatomic, copy)NSString *now_price; // 当前售卖价格
/** html 源码*/
@property (nonatomic, copy)NSString *content;

@property (nonatomic, copy)NSString *video_application;
@property (nonatomic, copy)NSString *viedeo_difficulty;
@property (nonatomic, copy)NSString *video_duration;

@property (nonatomic, assign)BOOL isSelectedForDownload;// 批量选中下载

//
@property (nonatomic, assign)BOOL canNotDown;//是否可以下载


@property (nonatomic, assign)BOOL isSelectedForDelete;// 批量选中删除


/********************** 职业路径 目录 **********************/

@property (nonatomic, assign)NSInteger course_count;

@property (nonatomic, copy)NSString *chapter_id;
/// 职业路径 ID
@property (nonatomic, copy)NSString *career_id;

@property (nonatomic, assign)BOOL isJobPath; // 是否职业路径的课程
/** 练习题数量 */
@property (nonatomic, assign)NSInteger slave_count;
/*** 练习题 */
@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *slaves;
/** 用于 职业路径 后台统计 */
@property (nonatomic, copy)NSString *sourceId;
/// 职业路径 练习题 章节ID
@property (nonatomic, copy)NSString *section_id;


/********************** 直播课 **********************/
@property (nonatomic, copy)NSString * live_course_id;   //课程ID
@property (nonatomic, copy)NSString * live_id;   //课程ID
@property (nonatomic, strong) NSNumber * can_download;  //1代表有视频  0代表没有视频
@property (nonatomic, strong) NSNumber * video_size ;  //视频大小，单位mb

@end

