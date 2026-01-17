//
//  DetailModel.h
//  Code
//
//  Created by Ivan li on 2017/8/23.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKPracticeModel.h"
#import "HKCourseModel.h"


@class VideoModel,HKMapModel,ShareModel,HkCertificateModel,HomeCategoryModel,HKBuyVipModel;

@class HKPgcCourseModel,SoftwareInfoModel;

@interface DetailModel : NSObject

/****************** 视频详情 标签 标题 *******************/
@property (nonatomic,assign) CGSize headSize;
/** 字体高度 */
@property (nonatomic,assign) CGFloat headHeight;
/** 字体行数 */
@property (nonatomic,assign) NSInteger textLines;
/**********************************************/

//1-自动播放 0-不自动播放
@property (nonatomic,assign) BOOL is_auto_play;
/** 获得 虎课币 文案 提示 */
@property (nonatomic,copy) NSString *obtain_gold;

/**  0 - 下载列表跳转来(已下载)   1 -- 未下载*/
@property (nonatomic,copy) NSString *video_down_status;

@property (nonatomic,copy) NSString *video_id;

@property (nonatomic,copy) NSString *class_name; //课程类型 eg: c4d

@property (nonatomic,copy) NSString *teacher_id;

@property (nonatomic,copy) NSString *video_titel;

@property (nonatomic,copy) NSString *img_cover_url;

@property (nonatomic,copy) NSString *video_duration;

@property (nonatomic,copy) NSString *viedeo_difficulty;

@property (nonatomic,copy) NSString *video_url;

@property (nonatomic,copy) NSString *video_application;

@property (nonatomic,copy) NSString *img_cover_url_big;

@property (nonatomic,copy) NSString *ID;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *avator;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,assign) BOOL is_collect;

@property (nonatomic,copy) NSString *follow;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *updated_at;

@property (nonatomic,copy) NSString *is_play; //1-可以评论 0-不可以评论

@property (nonatomic,copy) NSString *categoryId; //分类ID

@property (nonatomic,copy) NSString *video_play; //播放次数

@property (nonatomic,copy) NSString *opened_at;


@property (nonatomic,copy) NSString *video_type;// 视频类型 0-普通视频 1-软件入门 2-系列课视频  3-有上下集  4--PGC课 5-职业路径的练习题 6--职业路径

@property (nonatomic, strong)HKUserModel *teacher_info;

@property (nonatomic, strong)HKCourseModel *lessons_data;

@property (nonatomic, strong)NSMutableArray<HKPracticeModel *> *salve_video_list;// 练习题
/** 详情分享视频 */
@property (nonatomic, strong)ShareModel *share_data;
/** 播放器分享解锁视频 */
@property (nonatomic, strong)ShareModel *share_data_unlock;

@property (nonatomic, strong)NSMutableArray<VideoModel *> *recommend_video_list;// 详情推荐
@property (nonatomic, strong)NSMutableArray<VideoModel *> *dir_recommend_video_list;// 目录推荐
//@property (nonatomic,copy) NSString *next_video_id; //下一个视频ID

@property (nonatomic, strong)VideoModel *next_video_info;

/** 视频评论数量 */
@property (nonatomic,copy) NSString *comment_total;

/************************* PGC *************************/
/** PGC 目录 */
@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dir_list;
/** PGC 详情 */
@property (nonatomic, strong)HKCourseModel  *course_data;
/** PGC 标题 */
//@property (nonatomic,copy) NSString *video_title; //PGC

/** 提示有素材 网站下载 1-显示去网站下载源文件的提示框 0-不显示 */
@property (nonatomic,copy) NSString *is_show_tips;

/************************* 软件入门 *************************/
@property (nonatomic,copy) NSString *is_last_video; //is_last_video：1-软件入门的最后一个视频，学完后显示证书 0-不显示证书；
/** 软件介绍 */
@property (nonatomic, strong) NSMutableArray<SoftwareInfoModel *> *software_info;
/** 图文链接 */
@property (nonatomic,copy) NSString *pictext_url;

//vip_class：5-分类限五vip 4-套餐vip 3-终身全站通 2-全站通VIP 1-分类无限VIP 0-非VIP
@property (nonatomic,copy) NSString *vip_class;
/** 0 - 可以分享 1-不能分享 */
//@property (nonatomic,assign)NSInteger is_video_share_over_num;

/**  自动跳转的 上一视频 是否为全屏 */
@property(nonatomic, assign)BOOL isFullScreen;
/** YES - 从下载完成视频进入到详情  NO-默认   */
@property(nonatomic,assign)BOOL isFromDownload;

/** yes 播放完目录课程 自动跳转的下一节课 */
@property(nonatomic,assign)BOOL isNextAutoPlay;


/************************* 搜索统计 *************************/
@property (nonatomic,copy) NSString *searchkey;

@property (nonatomic,copy) NSString *searchIdentify;

// 职业路径
@property(nonatomic,copy)NSString *chapterId;

@property(nonatomic,copy)NSString *sectionId;

@property(nonatomic, copy)NSString *career_id;
/** 视频详情封面 */
@property(nonatomic, strong)UIImage *cover_image;

@property(nonatomic,strong)HKMapModel *vipRedirect;

/** YES - 标记从训练营跳转过来，强制去除课程目录。(不按视频类型来判断)  NO-默认  */
@property(nonatomic,assign)BOOL fromTrainCourse;

/** yes - 可下载 */
@property(nonatomic,assign)BOOL  can_download;
/// 证书
@property(nonatomic,strong)HkCertificateModel *obtain_info;


@property (nonatomic , assign) int has_feature_notes ;
@property (nonatomic , strong) NSMutableArray * tags;
@property (nonatomic , strong) HomeCategoryModel * album;
@property (nonatomic , assign) BOOL is_series ; //是否是套课
@property (nonatomic , assign) BOOL is_buy_series; //是否购买套课
@property (nonatomic, copy)NSString * series_url;  //套课url
@property (nonatomic, copy)NSString * pc_url;  //
@property (nonatomic , strong) NSArray * limited_playback_vip_list;


@property (nonatomic , assign) BOOL is_home_recommend_video_play; //是否来自首页推荐模块数据


@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;//目录数组

//
//@property (nonatomic , strong) NSMutableArray * work_pictures;
//@property (nonatomic , strong) NSNumber * exercise_count;
//@property (nonatomic , strong) NSNumber * question_count;
//@property (nonatomic , strong) NSNumber * score;
//@property (nonatomic , copy) NSString * diff;


@end




@interface SoftwareInfoModel : NSObject

@property (nonatomic,copy) NSString *info;

@property (nonatomic,copy) NSString *name;

@end






/****************** 分享 ******************/

/** 分享的平台 */
@interface SocialChannelModel : NSObject

/** 1-- QQ  2--QQ空间  3-- 微信  4 -- 朋友圈 5 -- 微博*/
@property (nonatomic,copy)NSString *channel;

@end





@interface ShareModel : NSObject

// 7-截图分享
@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *info;

@property (nonatomic,copy)NSString *img_url;

@property (nonatomic,copy)NSString *image_url;

@property (nonatomic,copy)NSString *web_url;

@property (nonatomic,copy)NSString *video_id;
/** 1-web  2-图片 */
@property (nonatomic,copy)NSString *share_type;

@property (nonatomic,strong)NSMutableArray<SocialChannelModel *>*channel_list;

@property (nonatomic,strong)UIImage *share_image;


/******************** 新手礼包 **********************/
@property (nonatomic,copy)NSString *desc_up;

@property (nonatomic,copy)NSString *desc_down;

@property (nonatomic,copy)NSString *url;
// 1 显示 0隐藏 分享按钮
@property(nonatomic,assign)BOOL status;
///调用 JS 分享方法名
@property(nonatomic,copy)NSString *triggerName;

@end





/// 证书model
@interface HkCertificateModel : NSObject

/// 是否显示 证书标签1：显示 0：不显示
@property (nonatomic,assign)BOOL app_cert_show;
/// 证书是否完成 1：完成 0：未完成
@property (nonatomic,assign)BOOL is_completed;
/// 证书信息条目
@property (nonatomic,strong)NSMutableArray<NSString *>*app_obtain;
@property (nonatomic,strong) HKMapModel * redirect_package;

@end

