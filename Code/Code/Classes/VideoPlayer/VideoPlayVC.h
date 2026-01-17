//
//  VideoPlayCVC.h
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"


/**
 
 1- 进入视频详情需传入 （videoId 和videoType） 不传入videoType 默认是普通类型视频，不同类型的课程，详情获取的接口不同
    根据videoId 请求视频基本信息。
 
 2- 根据视频详情信息的视频type (视频type 详见 HKVideoType 枚举 ) 添加tab（1-目录 2-详情 3-评论), 如果是普通的课程 则没有(tab 目录).
    其他 tab 要有。
 
 3- 根据 videoId和videoType 查询该视频 是否下载(1-已经下载的视频 则直接播放，无需用户点击播放)，
    未下载的视频( 1- wifi连接 如果用户设置wifi自动，则直接播放，没有设置则需用户点击播放。 2- 手机流量时，需用户点击播放)。
 
 4- 目录课程，点击目录 在当前控制器VC切换课程，重复上面 1-3 步骤。 普通课程 点击详情tab 的推荐课程，跳转新的控制器VC。
 
 
 */



/**

 视频播放时开启 播放时长和播放进度 统计， 暂停播放则 暂停相应的统计， 切换课程,控制器VC消失时，则上报统计。
 
*/


typedef enum {
    LookStatusLocalVideo = 0,// 本地视频(已经下载视频页面 跳转过来)
    LookStatusInternetVideo = 1, // 在线视频
}LookStatus;




@class VideoModel,HKPermissionVideoModel,BaseVideoViewController,HKPushNoticeModel;


@interface VideoPlayVC : HKBaseVC

/**
 初始化 视频播放器  (fileUrl  本地视频 传值非空值  在线视频-> nil)  (placeholderImage 播放器背景图)
 HKVideoType -- PGC课程 必须指定视频类型
 
 @param nibNameOrNil
 @param nibBundleOrNil
 @param fileUrl  本地视频-> 传值(非空值)  在线视频 -> (有值就传 无->nil)
 @param videoName 视频标题
 @param placeholderImage 播放器背景图
 @param status 视频状态(0->本地,1->在线)
 @param videoId 视频ID
 @param model  -> nil
 @return
 */
- (instancetype _Nullable )initWithNibName:(nullable NSString *)nibNameOrNil
                                    bundle:(nullable NSBundle *)nibBundleOrNil
                                   fileUrl:(NSString*_Nullable)fileUrl
                                 videoName:(NSString*_Nullable)videoName
                          placeholderImage:(NSString*_Nullable)placeholderImage
                                lookStatus:(LookStatus)status
                                   videoId:(NSString * _Nullable)videoId
                                     model:(id _Nullable )model;



/**
 
 初始化 视频播放器  (fileUrl  本地视频 传值非空值  在线视频-> nil)  (placeholderImage 播放器背景图)
 HKVideoType -- PGC课程 必须指定视频类型
 
 @param nibNameOrNil
 @param nibBundleOrNil
 @param fileUrl  本地视频-> 传值(非空值)  在线视频 -> (有值就传 无->nil)
 @param videoName 视频标题
 @param placeholderImage 播放器背景图
 @param status 视频状态(0->本地,1->在线)
 @param videoId 视频ID
 @param model  -> nil
 @param searchkey 搜索关键词
 
 @param searchIdentify 搜索关键字区分字段
 @return
 */
- (instancetype _Nullable )initWithNibName:(nullable NSString *)nibNameOrNil
                                    bundle:(nullable NSBundle *)nibBundleOrNil
                                   fileUrl:(NSString*_Nullable)fileUrl
                                 videoName:(NSString*_Nullable)videoName
                          placeholderImage:(NSString*_Nullable)placeholderImage
                                lookStatus:(LookStatus)status
                                   videoId:(NSString * _Nullable)videoId
                                     model:(id _Nullable )model
                                 searchkey:(NSString *_Nullable)searchkey
                            searchIdentify:(NSString *_Nullable)searchIdentify;



///  初始化 视频播放器 (训练营跳转专用)
/// @param nibNameOrNil
/// @param nibBundleOrNil
/// @param placeholderImage 播放器背景图
/// @param status 视频状态(0->本地,1->在线)
/// @param videoId 视频ID
/// @param fromTrainCourse YES - 从训练营跳转过来
- (instancetype _Nullable )initWithNibName:(nullable NSString *)nibNameOrNil
                                    bundle:(nullable NSBundle *)nibBundleOrNil
                          placeholderImage:(NSString*_Nullable)placeholderImage
                                lookStatus:(LookStatus)status
                                   videoId:(NSString * _Nullable)videoId
                           fromTrainCourse:(BOOL)fromTrainCourse;


@property(nonatomic,assign)HKVideoType videoType;
/** YES - 从下载完成视频进入到详情  NO-默认   */
@property(nonatomic,assign)BOOL isFromDownload;

/** 阿里云 统计 */
@property (nonatomic,strong) HKAlilogModel * _Nullable alilogModel;

/** YES - 标记从训练营跳转过来，强制去除课程目录。(不按视频类型来判断)  NO-默认  */
@property(nonatomic,assign,getter=isFromTrainCourse)BOOL fromTrainCourse;

@property (nonatomic, strong) UIButton * markTimeLabel;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) BaseVideoViewController *baseVideoVC;
//@property (nonatomic, assign) BOOL showedTimeChooseView;
@property (nonatomic ,assign) NSInteger seekTime;
@property (nonatomic ,strong) HKPushNoticeModel * noticeModel ;
@property (nonatomic ,assign) BOOL fromHomeRecommand;

@property (nonatomic ,assign) BOOL fromHomeRecommandVideo; //首页推荐模块，登录和未登录都要

@property (nonatomic, strong) DetailModel *detailModel;


@property (nonatomic , strong) void(^videoIdBlock)(NSString * video_id);
//@property (nonatomic, copy) NSString *video_id;
@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;//目录数组

/** 强制设置竖屏 */
- (void)forcePlayerPortrait;

@end
