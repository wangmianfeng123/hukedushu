//
//  WMHomeViewController.h
//  Demo
//
//  Created by Mark on 16/7/25.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//



/**

1-  视频下载， 1-普通视频 (视频type 详见 HKVideoType 枚举 )， 下载时，已经下载的视频点击下载不响应， 未下载的视频，则请求接口
 
    获取用户的下载权限，根据接口数据，进行相应操作(有下载权限，则下载，无权限则根据接口数据，做相应控制器跳转 或者 提示)
 
    2- 目录课程，则进入目录列表页面。
 
 
*/



#import "WMStickyPageControllerTool.h"
#import "HKCourseModel.h"

@class BaseVideoViewController,HKCourseListVC,TeacherInfoViewController,NewVideoCommentVC,HKInteractionVC,HKImageTextVC;


@protocol BaseVideoViewControllerDelegate <NSObject>

@optional

/** 分享成功 */
- (void)baseVideoVC:(BaseVideoViewController*)baseVC shareVideoSucess:(id)sender;

/** 收藏专辑 */
- (void)baseVideoVC:(BaseVideoViewController*)baseVC collectionAlbumWithModel:(DetailModel *)model;

/** 进入评论VC */
- (void)baseVideoVC:(BaseVideoViewController*)baseVC didEnterCommentVC:(BOOL)enterCommentVC;

/** 点击下载视频*/
- (void)baseVideoVCDidDownVideo:(BaseVideoViewController*)baseVC withMapModel:(HKMapModel*)mapModel;;

/** 切换课程 （sectionId 职业路径）  */
- (void)baseVideoVC:(BaseVideoViewController*)baseVC
     changeCourseVC:(BOOL)changeCourseVC
     changeCourseId:(NSString*)changeCourseId
          sectionId:(NSString*)sectionId
      frontCourseId:(NSString*)frontCourseId
       courseListVC:(HKCourseListVC*)courseListVC;

@end



@interface BaseVideoViewController : WMStickyPageControllerTool
//@property (nonatomic, strong)NSMutableArray<HKCourseModel *> *dataSource;//目录数组

@property(nonatomic,strong)DetailModel *detailModel;

@property(nonatomic,strong)HKCourseModel *courseModel;

@property(nonatomic,weak) id <BaseVideoViewControllerDelegate>  baseVideoDelegate;

@property (nonatomic,strong) HKAlilogModel *alilogModel;
@property (nonatomic, strong) HKCourseListVC *courseListVC;
@property (nonatomic, strong) TeacherInfoViewController *teacherInfoVC;
@property (nonatomic, strong) HKInteractionVC * interactionVC;
@property (nonatomic, strong) HKImageTextVC * imageTextVC;
@property (nonatomic , strong) void(^callBackSourceBlock)(NSMutableArray * dataArray,NSIndexPath *indexPath);


@property (nonatomic , strong) void(^categoryListShowBlock)(BOOL show);


//- (instancetype)initWithModel:(DetailModel*)model course:(HKCourseModel *)course;

/**
 建立 分享 UI
 
 @param model
 @param isCurrentVC isCurrentVC (YES: 当前Base 控制器 NO:视频播放页 分享解锁)
 */
- (void)initShareUIWithModel:(DetailModel*)model isCurrentVC:(BOOL)isCurrentVC;

/** 屏幕方向切换 */
//- (void)screenOrientationChange:(id)sender  isFullscreen:(BOOL)isFullscreen;



/**
 刷新布局
 @param scrollCourseList  视频目录 是否滚动(选中的row滚到顶部)
 */
- (void)layoutUI:(BOOL)scrollCourseList;

- (void)updateFrontVideoPlayStatus:(NSString*)courseId;

@end



