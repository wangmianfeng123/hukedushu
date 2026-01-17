//
//  VideoPlayCVC.m
//  Code
//
//  Created by Ivan li on 2017/7/20.222
//  Copyright © 2017年 pg. All rights reserved.

#import "VideoPlayVC.h"
#import "ZFNormalPlayer.h"
#import "UINavigationController+ZFNormalFullscreenPopGesture.h"

#import "DetailModel.h"
#import "DownloadManager.h"
#import "HKPermissionVideoModel.h"
#import "BaseVideoViewController.h"
#import "HomeServiceMediator.h"
//#import "ZFNormalPlayerControlView.h"
#import "HKCourseModel.h"
#import "HKVideoNewGuideView.h"
#import "HKDownloadManager.h"
#import "VideoPlayVC+Category.h"
#import "HKSoftwareRecommenVC.h"
#import "HKSoftwareAchieveVC.h"
#import "HtmlShowVC.h"
#import "UIViewController+ZFNormalPlayerRotation.h"
#import "FeedbackVC.h"
#import "HKContainerListVC.h"
#import "commentBottomView.h"
#import "VideoPlayEmptyView.h"

#import "ZFHKNormalPlayer.h"
#import "ZFHKNormalAVPlayerManager.h"
#import "TXLiteAVPlayerManager.h"

#import "ZFHKNormalPlayerControlView.h"
#import "ZFHKNormalPlayerControlView+Category.h"

#import "HKAirPlayGuideVC.h"
#import "UIAlertController+ZFNormalPlayerRotation.h"
#import "HKH5PushToNative.h"
#import "GKPlayer.h"
#import "LBLelinkKitManager.h"

#import "AppDelegate.h"
#import "HKNewTaskModel.h"
#import "HKHNewbieFatherView.h"
#import "HKObtainCampVC.h"
#import "HKAchieveTool.h"
#import "HKCourseListVC.h"
#import "TeacherInfoViewController.h"
#import "NewVideoCommentVC.h"
#import "iCommentView.h"
#import "HKEditNoteVC.h"
#import "HKBuyVipView.h"
#import "YHIAPpay.h"
#import "HKPushNoticeModel.h"
#import "HKInteractionVC.h"
#import "HKVideoEvaluationVC.h"

@interface VideoPlayVC ()<BaseVideoViewControllerDelegate,commentBottomViewDelegate,HKVideoEvaluationVCDelegate,ZFHKNormalPlayerControlViewDelegate,VideoPlayEmptyViewDelegate>

/** 播放器背景 */
@property (nonatomic, strong) UIView *playerBgView;

@property (nonatomic, copy) NSString *videoId;

@property (nonatomic, copy) NSString *fileUrl;

@property (nonatomic, copy) NSString *videoName;

@property (nonatomic, copy) NSString *placeholderImageUrl;

@property (nonatomic, assign) LookStatus lookStatus;


@property (nonatomic, strong) HKCourseModel *courseModel;

@property (nonatomic, strong) HKPermissionVideoModel *permissionVideoModel;

@property (nonatomic, strong)HKContainerListVC *containerVC;
/** 底部评价 */
@property(nonatomic,strong)commentBottomView  *commentView;
/** 显示在当前 window */
@property (nonatomic,assign)BOOL isShowWidonw;
/** 播放器 */
@property (nonatomic, strong) ZFHKNormalPlayerController *videoPlayer;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) ZFHKNormalPlayerControlView *controlView;

//@property (nonatomic, strong)ZFHKNormalAVPlayerManager  *playerManager;
@property (nonatomic, strong)TXLiteAVPlayerManager  *playerManager;


@property (nonatomic, strong)VideoPlayEmptyView *videoPlayEmptyView;

@property (nonatomic,assign)BOOL isNeedFullScreen;
/** 搜索关键词*/
@property(nonatomic,copy)NSString *searchkey;
/** 搜索关键字区分字段*/
@property(nonatomic,copy)NSString *searchIdentify;

@property (nonatomic,assign)CGFloat playerHeight;
/** post 回话 */
@property (nonatomic,strong)NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@property(nonatomic,copy)NSString * _Nonnull chapterId;

@property(nonatomic,copy)NSString * _Nonnull sectionId;

@property(nonatomic,copy)NSString * _Nonnull careerId;
/** 用于 后台统计 */
@property (nonatomic,copy) NSString *_Nonnull sourceId;
@property (nonatomic , strong) HKHNewbieFatherView * tipView;
@property (nonatomic , assign) BOOL hasPlayed;
@property (nonatomic , strong) iCommentView * commentIconV ; //评论悬浮按钮
@property (nonatomic , strong)  HKBuyVipView * vipView;
@property (nonatomic , assign)  BOOL isFlag;
@property (nonatomic , copy)  NSString * currentVideoID;


@property (nonatomic , assign) BOOL commentIconVHidden;//保存显隐性
@property (nonatomic , assign) BOOL commentViewHidden;//保存显隐性

@end




@implementation VideoPlayVC


- (instancetype _Nullable )initWithNibName:(nullable NSString *)nibNameOrNil
                                    bundle:(nullable NSBundle *)nibBundleOrNil
                                   fileUrl:(NSString*_Nullable)fileUrl
                                 videoName:(NSString*_Nullable)videoName
                          placeholderImage:(NSString*_Nullable)placeholderImage
                                lookStatus:(LookStatus)status
                                   videoId:(NSString * _Nullable)videoId
                                     model:(id _Nullable)model
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lookStatus = status;
        self.fileUrl = fileUrl;
        self.videoName = videoName;
        self.placeholderImageUrl = placeholderImage;
        self.videoId = videoId;
        
        if (model && [model isKindOfClass:[HKCourseModel class]]) {
            self.chapterId =  ((HKCourseModel*)model).chapter_id;
            self.sectionId =  ((HKCourseModel*)model).ID;
            self.careerId = ((HKCourseModel*)model).career_id;
            self.sourceId = ((HKCourseModel*)model).sourceId;
        }
    }
    return  self;
}


- (instancetype _Nullable )initWithNibName:(nullable NSString *)nibNameOrNil
                                    bundle:(nullable NSBundle *)nibBundleOrNil
                                   fileUrl:(NSString*_Nullable)fileUrl
                                 videoName:(NSString*_Nullable)videoName
                          placeholderImage:(NSString*_Nullable)placeholderImage
                                lookStatus:(LookStatus)status
                                   videoId:(NSString * _Nullable)videoId
                                     model:(id _Nullable )model
                                 searchkey:(NSString *)searchkey
                            searchIdentify:(NSString *)searchIdentify
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lookStatus = status;
        self.fileUrl = fileUrl;
        self.videoName = videoName;
        self.placeholderImageUrl = placeholderImage;
        self.videoId = videoId;
        self.searchkey = searchkey;
        self.searchIdentify = searchIdentify;
    }
    return  self;
}



- (instancetype _Nullable )initWithNibName:(nullable NSString *)nibNameOrNil
                                    bundle:(nullable NSBundle *)nibBundleOrNil
                          placeholderImage:(NSString*_Nullable)placeholderImage
                                lookStatus:(LookStatus)status
                                   videoId:(NSString * _Nullable)videoId
                           fromTrainCourse:(BOOL)fromTrainCourse
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lookStatus = status;
        self.placeholderImageUrl = placeholderImage;
        self.videoId = videoId;
        self.fromTrainCourse = fromTrainCourse;
    }
    return  self;
}






- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    //self.baseVideoVC.courseListVC.dataSource
    
    
    [self getVideoDetailInfoWithId:self.videoId type:self.videoType isChangeVideo:NO isNextAutoPlay:NO isScrollCourseList:NO];
    
    
    self.commentIconV = [iCommentView viewFromXib];
    self.commentIconV.hidden = YES;
    self.commentIconVHidden = YES;
    [self.view addSubview:self.commentIconV];
    @weakify(self);
    self.commentIconV.didTapBlock = ^{
        @strongify(self);
        [self commentBottomView:nil comment:nil];
    };
    self.commentIconV.frame = CGRectMake(SCREEN_W - 90,SCREEN_H - KTabBarHeight49 - 80 - 60, 80, 80);
    
    
    int vcCount = 0;
    NSArray * vcArray = [self.navigationController viewControllers];
    for (UIViewController *tempVC in vcArray) {
        if ([tempVC isKindOfClass:[VideoPlayVC class]]) {
            vcCount++;
        }
    }
    
    if (vcCount > 1) {
        NSArray * vcArray = [self.navigationController viewControllers];
        for (UIViewController *tempVC in vcArray) {
            if ([tempVC isKindOfClass:[VideoPlayVC class]]) {
                [tempVC removeFromParentViewController];
                return;
            }
        }
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.commentIconV.frame = CGRectMake(SCREEN_W - 90,SCREEN_H - KTabBarHeight49 - 80 - 60, 80, 80);
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //播放统计
    [self.controlView recordPlayTimeAndVideoProgress];
    [self.controlView resetProgressTimer];
    NSLog(@"isAirPlay : %d == isConnected : %d == isMirroring : %d == isLBlink : %d ",[LBLelinkKitManager sharedManager].isAirPlay,[LBLelinkKitManager sharedManager].isConnected,[LBLelinkKitManager sharedManager].isMirroring,[LBLelinkKitManager sharedManager].isLBlink);
    if ([LBLelinkKitManager sharedManager].isAirPlay &&
        ![LBLelinkKitManager sharedManager].isMirroring) return;
    self.videoPlayer.viewControllerDisappear = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    HKStatusBarStyleDefault;
    [MBProgressHUD hideHUD];
    self.isShowWidonw = NO;
    NSLog(@"isAirPlay : %d == isConnected : %d == isMirroring : %d == isLBlink : %d ",[LBLelinkKitManager sharedManager].isAirPlay,[LBLelinkKitManager sharedManager].isConnected,[LBLelinkKitManager sharedManager].isMirroring,[LBLelinkKitManager sharedManager].isLBlink);
    if ([LBLelinkKitManager sharedManager].isAirPlay &&
        ![LBLelinkKitManager sharedManager].isMirroring) return;
    self.videoPlayer.viewControllerDisappear = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isShowWidonw = YES;
    [self forceFullScreen];
    self.videoPlayer.viewControllerDisappear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:UM_RECORD_PLAYER];
    //APP status 查询
    [CommonFunction checkAPPStatus];
    //    HKStatusBarStyleLightContent;
}



- (void)createUI {
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    
    self.playerHeight = IS_IPAD ? floor(SCREEN_HEIGHT * 0.5) : floor(SCREEN_W*9/16);
    
    self.zf_prefersNavigationBarHidden = YES;
    [self setPlayerBlackBgView];
    [self.view addSubview:self.playerBgView];
    
    [self setAVPlayerManager];
    [self createObserver];
    HK_NOTIFICATION_ADD(@"shareNotice", removeShareView);
    
}

- (void)removeShareView{
    if (self.controlView) {
        //清除购买VIP view
        [self.controlView removeBuyVipShareView];
    }
}

#pragma mark - IPHONE_X 黑色背景
- (void)setPlayerBlackBgView {
    if (IS_IPHONE_X) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, self.playerHeight + 44)];
        view.backgroundColor = COLOR_000000;
        [self.view addSubview:view];
    }
}



- (UIView*)playerBgView {
    
    if (!_playerBgView) {
        _playerBgView = [[UIView alloc]init];
        _playerBgView.frame = CGRectMake(0, IS_IPHONE_X ?44 :0, SCREEN_W, self.playerHeight);
    }
    return _playerBgView;
}



- (BaseVideoViewController*)baseVideoVC {
    
    if (!_baseVideoVC) {
        _baseVideoVC = [BaseVideoViewController new];
        _baseVideoVC.baseVideoDelegate = self;
        WeakSelf
        _baseVideoVC.callBackSourceBlock = ^(NSMutableArray *dataArray,NSIndexPath *indexPath) {
            weakSelf.controlView.index = indexPath;
            weakSelf.controlView.courseDataArray = dataArray;
        };
        
        _baseVideoVC.categoryListShowBlock = ^(BOOL show) {
            
            if (show) {
                weakSelf.commentView.hidden = YES;
                weakSelf.commentIconV.hidden = YES;
            }else{
                weakSelf.commentView.hidden = weakSelf.commentViewHidden;
                weakSelf.commentIconV.hidden = weakSelf.commentIconVHidden;
            }
        };
        
    }
    _baseVideoVC.detailModel = self.detailModel;
    _baseVideoVC.courseModel = self.courseModel;
    
    return _baseVideoVC;
}


- (void)removeBaseVideoVC {
    if (_baseVideoVC) {
        [_baseVideoVC didMoveToParentViewController:nil];
        [_baseVideoVC.view removeFromSuperview];
        [_baseVideoVC removeFromParentViewController];
        _baseVideoVC = nil;
    }
}

-(NSMutableArray<HKCourseModel *> *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 更新frame   isScrollCourseList (课程目录是否滚动)
- (void)setBaseVideoVCFrame:(BaseVideoViewController*)vc isScrollCourseList:(BOOL)isScrollCourseList {
    [self.baseVideoVC layoutUI:isScrollCourseList];
    
    [self.view bringSubviewToFront:self.commentIconV];
}


#pragma mark - BaseVideoViewControllerDelegate
#pragma mark - 分享成功
- (void)baseVideoVC:(BaseVideoViewController *)baseVC shareVideoSucess:(id)sender {
    if (self.controlView) {
        //清除购买VIP view
        [self.controlView removeBuyVipShareView];
    }
}


- (void)baseVideoVC:(BaseVideoViewController*)baseVC didEnterCommentVC:(BOOL)enterCommentVC {
    if (enterCommentVC) {
        [self addBottomCommentView];
        [self hiddenOrShowCommentView:NO];
    }else{
        [self hiddenOrShowCommentView:YES];
    }
}


- (void)baseVideoVC:(BaseVideoViewController *)baseVC collectionAlbumWithModel:(DetailModel *)model {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    // 如果已经添加就直接返回
    if ([self.view viewWithTag:500]) return;
    
    HKContainerListVC *VC = self.containerVC;
    VC.view.frame = self.view.bounds;
    VC.detailModel  = model;
    VC.view.tag = 500;
    VC.view.y = SCREEN_H;
    
    VC.containerCloseBlock = ^(id sender) {
    };
    
    [self addChildViewController:VC];
    [self.view addSubview:VC.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        VC.view.y = 0;
    } completion:^(BOOL finished) {
        VC.view.backgroundColor = [COLOR_000000 colorWithAlphaComponent:0.3];
    }];
}


/** 切换课程 */
- (void)baseVideoVC:(BaseVideoViewController*)baseVC changeCourseVC:(BOOL)changeCourseVC
     changeCourseId:(NSString*)changeCourseId
          sectionId:(NSString*)sectionId
      frontCourseId:(NSString*)frontCourseId
       courseListVC:(HKCourseListVC*)courseListVC {
    if (!isEmpty(sectionId)) {
        self.sectionId = sectionId;
    }
    [self _removeBaseVideoVCFromParent:changeCourseId isNextAutoPlay:NO isScrollCourseList:NO frontCourseId:frontCourseId courseListVC:courseListVC];
}

- (void)baseVideoVCDidDownVideo:(BaseVideoViewController*)baseVC withMapModel:(HKMapModel *)mapModel{
    [self.vipView removeFromSuperview];
    
    if (self.detailModel.limited_playback_vip_list.count) {
        self.vipView = nil;
        self.vipView.vip_list = self.detailModel.limited_playback_vip_list;
        [self.view addSubview:self.vipView];
        [self.vipView showView];
    }else{
        //v2.17 职业路径  购买VIP 跳转
        [HKH5PushToNative runtimePush:mapModel.redirect_package.className arr:mapModel.redirect_package.list currectVC:self];
    }
}


/** 切换课程 */
- (void)changeCourseId:(NSString*)changeCourseId
             sectionId:(NSString*)sectionId
         frontCourseId:(NSString*)frontCourseId
{
    if (!isEmpty(sectionId)) {
        self.sectionId = sectionId;
    }
    [self _removeBaseVideoVCFromParent:changeCourseId isNextAutoPlay:YES isScrollCourseList:NO frontCourseId:frontCourseId courseListVC:self.baseVideoVC.courseListVC];
}



- (HKContainerListVC*)containerVC {
    if (!_containerVC) {
        _containerVC = [HKContainerListVC new];
    }
    return _containerVC;
}

#pragma mark - 添加切换视图
- (void)addSwitchBaseVideoVC:(BOOL)isScrollCourseList  removeFrontVC:(BOOL)removeFrontVC {
    
    if (self.videoPlayEmptyView) {
        self.videoPlayEmptyView.hidden = YES;
    }
    
    if (removeFrontVC) {
        [self removeBaseVideoVC];
    }
    
    if ( ![[self childViewControllers] containsObject:self.baseVideoVC]) {
        BaseVideoViewController *VC = _baseVideoVC;
        VC.alilogModel = self.alilogModel;
        [self addChildViewController:VC];
        if (removeFrontVC && self.videoPlayer.isFullScreen) {
            //解决全屏时 baseVideoVC view 显示在 0层
            [self.view insertSubview:VC.view atIndex:1];
        }else{
            [self.view addSubview:VC.view];
        }
        
        if (IS_IPAD) {
            VC.view.frame = CGRectMake(0, self.playerHeight, SCREEN_WIDTH, SCREEN_HEIGHT- self.playerHeight);
            
        }else{
            if (IS_IPHONE_X) {
                VC.view.frame = CGRectMake(0, self.playerHeight+44, SCREEN_W, SCREEN_H-self.playerHeight-44);
            }else{
                VC.view.frame = CGRectMake(0, self.playerHeight, SCREEN_W, SCREEN_H- self.playerHeight);
            }
        }
        
        [VC didMoveToParentViewController:self];
    }
    [self setBaseVideoVCFrame:nil isScrollCourseList:isScrollCourseList];
}

- (void)addBottomCommentView {
    // 1-播放后显示 2-进入已播放视频 显示
    if (!self.commentView.isLoaded) {
        [self.view addSubview:self.commentView];
        [self.view bringSubviewToFront:self.commentView];
        self.commentView.isLoaded = YES;
    }
}

/*** isNextAutoPlay (YES - 自动跳转的视频) **/
- (void)_removeBaseVideoVCFromParent:(NSString*)videoId
                      isNextAutoPlay:(BOOL)isNextAutoPlay
                  isScrollCourseList:(BOOL)isScrollCourseList
                       frontCourseId:(NSString*)frontCourseId
                        courseListVC:(HKCourseListVC*)courseListVC {
    self.videoId = videoId;
    self.placeholderImageUrl = nil;
    
    //播放统计
    [self.controlView recordPlayTimeAndVideoProgress];
    
    [self.playerManager stop];
    
    [self getVideoDetailInfoWithId:self.videoId type:self.videoType isChangeVideo:YES
                    isNextAutoPlay:isNextAutoPlay isScrollCourseList:isScrollCourseList];
}


#pragma mark - 隐藏 或 显示 评论框
- (void)hiddenOrShowCommentView:(BOOL)ishiddenOrShow {
    if (_commentView) {
        _commentView.hidden = ishiddenOrShow;
        _commentViewHidden = ishiddenOrShow;
    }
}


- (commentBottomView*)commentView {
    //播放后显示  并进入评论视图 显示评论框
    if (!_commentView) {
        CGRect rect;
        if (IS_IPAD) {
            rect = CGRectMake(0, SCREEN_HEIGHT- 50, SCREEN_WIDTH, 50);
        }else{
            rect = CGRectMake(0, SCREEN_H- (IS_IPHONE_X ?70 :50), SCREEN_W, (IS_IPHONE_X ?70 :50));
        }
        _commentView = [[commentBottomView alloc]initWithFrame:rect];
        _commentView.delegate = self;
    }
    return _commentView;
}


#pragma mark - commentBottomView 代理
- (void)commentBottomView:(commentBottomView*)view  comment:(id)comment {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    if ([self.detailModel.is_play isEqualToString:@"1"]) {
        //is_play：1-可以评论 0-不可以评论
        WeakSelf;
        [self checkBindPhone:^{
            StrongSelf;
            [strongSelf setEvaluationVC];
        } bindPhone:^{
            
        }];
        
    }else{
        showTipDialog(@"学习后才能评价哦～");
    }
}

- (void)setEvaluationVC {
    HKVideoEvaluationVC *VC = [[HKVideoEvaluationVC alloc]initWithNibName:nil bundle:nil videoId:self.detailModel.video_id];
    VC.delegate = self;
    [self pushToOtherController:VC];
}


#pragma mark - EvaluationVC  代理
- (DetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [DetailModel new];
    }
    return _detailModel;
}

- (VideoPlayEmptyView*)videoPlayEmptyView {
    if (!_videoPlayEmptyView) {
        _videoPlayEmptyView = [[VideoPlayEmptyView alloc]init];
        _videoPlayEmptyView.delegate = self;
        _videoPlayEmptyView.hidden = YES;
    }
    return _videoPlayEmptyView;
}

- (void)videoPlayEmptyView:(UIView*)view {
    [self getVideoDetailInfoWithId:self.videoId type:self.videoType isChangeVideo:NO isNextAutoPlay:NO isScrollCourseList:NO];
}

- (void)showPlayEmptyView {
    [self.view addSubview:self.videoPlayEmptyView];
    [self.videoPlayEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.videoPlayEmptyView.hidden = NO;
}

- (NSMutableArray <NSURLSessionDataTask *> *)sessionTaskArray{
    if (!_sessionTaskArray) {
        _sessionTaskArray = [NSMutableArray array];
    }
    return _sessionTaskArray;
}

/**
 视频详情
 
 @param videoId ID
 @param type 视频类型
 @param isChangeVideo <#isChangeVideo description#>
 @param isNextAutoPlay  跳转到下一节视频 是否自动播放
 @param isScrollCourseList 视频目录 是否滚动(选中的row滚到顶部)
 */
- (void)getVideoDetailInfoWithId:(NSString *)videoId
                            type:(HKVideoType)type
                   isChangeVideo:(BOOL)isChangeVideo
                  isNextAutoPlay:(BOOL)isNextAutoPlay
              isScrollCourseList:(BOOL)isScrollCourseList {
    
    if (isEmpty(videoId)) {
        return;
    }
    
    [self.sessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.state == NSURLSessionTaskStateRunning || obj.state == NSURLSessionTaskStateSuspended ) {
            [obj cancel];
        }
    }];
    
    if (!self.videoPlayer.isFullScreen) {
        [MBProgressHUD showActivityMessageInWindow:@"加载中.." timer:10];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }
    
    // 普通课程
    NSString *nomalUrl = (HKVideoType_PGC == self.videoType) ?PGC_DETAIL :VIDEO_DETAIL;
    
    NSString *url = (HKVideoType_JobPath == self.videoType || HKVideoType_JobPath_Practice == self.videoType)? JOBPATH_DETAIL :nomalUrl;
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:videoId forKey:@"video_id"];
    if (!isEmpty(self.searchkey)) {
        [parameters setValue:self.searchkey forKey:@"search_key"];
    }
    
    if (!isEmpty(self.searchIdentify)) {
        [parameters setValue:self.searchIdentify forKey:@"search_identify"];
    }
    
    // 职业路径
    if ([url isEqualToString:JOBPATH_DETAIL]) {
        if (!isEmpty(self.chapterId)) {
            [parameters setValue:self.chapterId forKey:@"chapter_id"];
        }
        if (!isEmpty(self.sectionId)) {
            [parameters setValue:self.sectionId forKey:@"section_id"];
        }
        
        if (!isEmpty(self.sourceId)) {
            [parameters setValue:self.sourceId forKey:@"source"];
        }
    }
    
    @weakify(self);
    NSURLSessionDataTask *sessionTask = [HKHttpTool hk_taskPost:url allUrl:nil isGet:NO parameters:parameters success:^(id responseObject) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if (HKReponseOK) {
            DetailModel *model = [DetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            model.isNextAutoPlay = isNextAutoPlay;
            model.is_home_recommend_video_play = self.fromHomeRecommandVideo ? YES :NO;
            
            model.video_down_status = (LookStatusLocalVideo == self.lookStatus)? @"0" :@"1"; //0 - 下载列表跳转来(已下载) 1 -- 未下载
            
            BOOL isChange ;
            
            if ([self.detailModel.video_type isEqualToString:model.video_type]) {
                isChange = NO;
            }else{
                // 视频类型 0-普通视频 1-软件入门 2-系列课视频  3-有上下集  4--PGC课 5-职业路径的练习题 6--职业路径
                if ([model.video_type intValue] == 1  ||
                    [model.video_type intValue] == 5) {
                    isChange = YES;
                }else{
                    isChange = NO;
                }
            }
            
            if (self.isFromTrainCourse) {
                model.fromTrainCourse = self.isFromTrainCourse;
            }
            
            // 职业路径
            if (self.videoType == HKVideoType_JobPath || self.videoType == HKVideoType_JobPath_Practice) {
                model.chapterId = self.chapterId;
                model.sectionId = self.sectionId;
                model.career_id = self.careerId;
            }
            
            
            self.detailModel = model;
            
            // 搜索统计关键词
            self.detailModel.searchkey = self.searchkey;
            self.detailModel.searchIdentify = self.searchIdentify;
            
            if ([self.detailModel.is_play isEqualToString:@"1"]) {
                self.commentIconV.hidden = NO;
                self.commentIconVHidden = NO;
                
                [self.commentIconV setShowCommentIcon];
                
            }else{
                self.commentIconV.hidden = YES;
                self.commentIconVHidden = YES;
            }
            // 教程资料
            HKCourseModel *courseModel = [HKCourseModel mj_objectWithKeyValues:responseObject[@"data"][@"lessons_data"]];
            self.courseModel = courseModel;
            
            
            //请求目录
            if ([self.detailModel.video_type intValue]== HKVideoType_Series ||
                [self.detailModel.video_type intValue] == HKVideoType_UpDownCourse ||
                [self.detailModel.video_type intValue] == HKVideoType_JobPath ||
                [self.detailModel.video_type intValue] == HKVideoType_JobPath_Practice ||
                [self.detailModel.video_type intValue] == HKVideoType_PGC ||
                (self.detailModel.is_series && (self.detailModel.is_buy_series == 1))) {
                //请求目录
                WeakSelf
                [self loadCatalogueList:[self.detailModel.video_type intValue] resultBlock:^(NSMutableArray *dataArray, NSIndexPath *index) {
                    weakSelf.detailModel.dataSource = dataArray;
                    [weakSelf addSwitchBaseVideoVC:isScrollCourseList removeFrontVC:isChange];
                    weakSelf.controlView.index = index;
                    weakSelf.controlView.courseDataArray = dataArray;
                }];
            }else{
                //暂不需请求目录
                [self addSwitchBaseVideoVC:isScrollCourseList removeFrontVC:isChange];
            }
            //重新对playerModel 赋值
            [self resetPlayModelWithModel:model];
        }
    } failure:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        self.detailModel.isNextAutoPlay = isNextAutoPlay;
        // 搜索统计关键词
        self.detailModel.searchkey = self.searchkey;
        self.detailModel.searchIdentify = self.searchIdentify;
        [self resetPlayModelWithModel:nil];
        
        if (NSURLErrorCancelled == error.code) {
            
        }else{
            [self showPlayEmptyView];
        }
    }];
    
    [self.sessionTaskArray removeAllObjects];
    [self.sessionTaskArray addObject:sessionTask];
}



#pragma mark - 通知
- (void)createObserver {
    
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSucessNotification:);
    HK_NOTIFICATION_ADD(HKBuyVIPSuccessNotification,buyVIPSuccessNotification:);
}


/** 登录 成功 */
- (void)loginSucessNotification:(NSNotification *)noti {
    [self getVideoDetailInfoWithId:self.videoId type:self.videoType isChangeVideo:NO isNextAutoPlay:NO isScrollCourseList:NO];
}


/** 购买VIP 成功 */
- (void)buyVIPSuccessNotification:(NSNotification *)noti {
    //if (nil != _playerView) {[_playerView zf_controlRemoveBuyVipView];}
    [self getVideoDetailInfoWithId:self.videoId type:self.videoType isChangeVideo:NO isNextAutoPlay:NO isScrollCourseList:NO];
}

- (void)resetPlayModelWithModel:(DetailModel*)model {
    
    if (model) {
        model.isFromDownload = self.isFromDownload;
        self.isFromDownload = NO;
        [self playVideo:model];
    }else{
        if (isEmpty(self.detailModel.video_id)) {
            self.detailModel.video_id = self.videoId;
            self.detailModel.video_type = [NSString stringWithFormat:@"%ld",(long)self.videoType];
        }
        self.detailModel.isFromDownload = self.isFromDownload;
        self.isFromDownload = NO;
        [self playVideo:self.detailModel];
    }
    // 清空搜索统计关键词 防止目录课程重复统计
    self.searchkey = nil;
    self.searchIdentify = nil;
    self.alilogModel = nil;
}



#pragma mark ---- 屏幕切换
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.videoPlayer.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    if(IS_IPAD){
        return 1;
    }
    return 0;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if (self.videoPlayer.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}


-(BOOL)prefersHomeIndicatorAutoHidden {
    // 自动隐藏 X系列手机横线
    return YES;
}


- (void)loadView {
    [super loadView];
    
    [self createUI];
}

#pragma mark ---- 播放器
- (void)setAVPlayerManager {
    
    [self.view addSubview:self.containerView];
    
    @weakify(self)
    self.videoPlayer.orientationWillChange = ^(ZFHKNormalPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
}



- (void)playVideo:(DetailModel*)model {
    
    NSString *picUrl = isEmpty(model.img_cover_url)  ?self.placeholderImageUrl :model.img_cover_url;
    self.controlView.alilogModel = self.alilogModel;
    [self.controlView showTitle:model.video_titel coverURLString:picUrl fullScreenMode: IS_IPAD ? ZFHKNormalFullScreenModePortrait : ZFHKNormalFullScreenModeLandscape];
    self.controlView.videoDetailModel = model;
}


- (ZFHKNormalPlayerController*)videoPlayer {
    if (nil == _videoPlayer) {
        _videoPlayer = [ZFHKNormalPlayerController playerWithPlayerManager:self.playerManager containerView:self.containerView];
        _videoPlayer.controlView = self.controlView;
        //屏幕旋转 转动控制器
        //        _videoPlayer.forceDeviceOrientation = YES;
    }
    return _videoPlayer;
}

- (TXLiteAVPlayerManager*)playerManager {
    if (!_playerManager) {
        _playerManager = [[TXLiteAVPlayerManager alloc] init];
        _playerManager.timeRefreshInterval = 1;
    }
    return _playerManager;
}

- (ZFHKNormalPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFHKNormalPlayerControlView new];
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.fastTimeInterval = 5;
        _controlView.hideControlViewWithAnimated = NO;
        _controlView.effectViewShow = NO;
        _controlView.delegate = self;
        _controlView.fromTrainCourse = self.fromTrainCourse;
        _controlView.notesSeekTime = self.seekTime;
        _controlView.isNeedAutoPlay = self.seekTime ? YES :NO;
        @weakify(self)
        _controlView.playerPrepareToPlayCallback = ^(NSString *videoId) {
            @strongify(self)
            [MobClick event:UM_RECORD_DETAIL_PAGE_PLAY];
            //1-可以评论 0-不可以评论
            self.detailModel.is_play = @"1";
            self.hasPlayed = YES;
            [self _updateFrontVideoPlayStatus:videoId];
            self.commentIconV.hidden = NO;
            self.commentIconVHidden = NO;
            [self.commentIconV setShowCommentIcon];
            if (self.fromHomeRecommand) {
                if (self.isFlag) {
                    NSLog(@"------");
                }else{
                    self.isFlag = YES;
                    if (videoId.length) {
                        [HKVideoPlayAliYunConfig videoPlayAliYunVideoID:videoId btn_type:18];
                    }
                }
            }
            
            self.currentVideoID = videoId;
        };
        
        _controlView.backBtnClickCallback = ^{
            @strongify(self)
            [self playerBackAction];
        };
        
        _controlView.portraitBackBtnClickCallback = ^{
            //@strongify(self)
            //[self playerBackAction];
        };
        _controlView.portraitGraphicBtnClickCallback = ^(UIButton *btn, BOOL isCenterBtnClick, NSString *webUrl) {
            @strongify(self)
            [self setHtmlVCWithPicUrl:webUrl];
            if (isCenterBtnClick) {
                [MobClick event:UM_RECORD_DETAILPAGE_PLAY_FINISHED_GRAPHIC1];
            }else{
                [MobClick event:UM_RECORD_DETAILPAGE_PLAY_FINISHED_GRAPHIC2];
            }
        };
        _controlView.landScapeGraphicBtnClickCallback = ^(UIButton *btn, NSString *webUrl) {
            @strongify(self)
            self.isNeedFullScreen = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setHtmlVCWithPicUrl:webUrl];
            });
            [MobClick event:UM_RECORD_DETAILPAGE_PLAY_FINISHED_GRAPHIC2];
        };
        _controlView.centerPlayBtnClick = ^{
            @strongify(self)
            [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:1];
            [self setLoginVC];
        };
        _controlView.landScapeFeedBackCallback = ^{
            @strongify(self)
            self.isNeedFullScreen = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pushToOtherController:[FeedbackVC new]];
            });
        };
        
        _controlView.portraitVipBtnClickCallback = ^(UIButton *btn, DetailModel *detailModel, HKPermissionVideoModel *permissionModel) {
            @strongify(self)
            [self pushVIPCategoryVCWithModel:detailModel permissionModel:permissionModel];
        };
        
        _controlView.landScapeVipBtnClickCallback = ^(UIButton *btn, DetailModel *detailModel, HKPermissionVideoModel *permissionModel) {
            @strongify(self)
            self.isNeedFullScreen = YES;
            //[MobClick event:UM_RECORD_VEDIO_BUY_VIP];
            //[self pushVIPCategoryVC:self.detailModel.categoryId];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pushVIPCategoryVCWithModel:detailModel permissionModel:permissionModel];
            });
        };
        _controlView.didCourseBlock = ^(NSString *changeCourseId, NSString *sectionId, NSString *frontCourseId) {
            @strongify(self)
            [self changeCourseId:changeCourseId sectionId:sectionId frontCourseId:frontCourseId];
        };
        _controlView.didNextBlock = ^(DetailModel *videoDetailModel) {
            @strongify(self)
            [self setNextVideoWithModel:videoDetailModel isNextAutoPlay:YES];
        };
    }
    return _controlView;
}


- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor blackColor];
        _containerView.frame = CGRectMake(0, (IS_IPHONE_X ?44 :0), IS_IPAD ? SCREEN_WIDTH : SCREEN_W,IS_IPAD ? floor(SCREEN_HEIGHT * 0.5) : floor(SCREEN_W*9/16));
    }
    return _containerView;
}


/** 设置html */
- (void)setHtmlVCWithPicUrl:(NSString*)picUrl {
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    @weakify(self);
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:picUrl];
    htmlShowVC.backActionCallBlock = ^(BOOL fullScreen) {
        if (NO == fullScreen) {
            @strongify(self);
            [self forcePlayerPortrait];
        }
    };
    [self pushToOtherController:htmlShowVC];
}


- (void)playerBackAction {
    [self showNewTaskView];
}

- (void)showNewTaskView{
    ///0:未注册 1:完成 (领了vip和训练营或者没有配训练营) 2:已注册 3:已播放 4:已领vip,未领训练营 5:老用户
    AppDelegate * delegate = [AppDelegate sharedAppDelegate];
    if (delegate.model.status == 2) {
        BOOL isHave = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasObtainVIP"];
        if (!isHave) {
            if (self.hasPlayed){
                HK_NOTIFICATION_POST(@"videoPlayed", nil);
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasObtainVIP"];
            }else{
                [self backClick];
            }
        }else{
            [self backClick];
        }
    }else{
        [self backClick];
    }
}

- (void)backClick{
    // 直接返回
    UIViewController *vcTemp = nil;
    for (NSInteger i = self.navigationController.viewControllers.count; i > 0; i-- ) {
        UIViewController *vc = self.navigationController.viewControllers[i - 1];
        
        if (![vc isKindOfClass:[VideoPlayVC class]]) {
            vcTemp = vc;
            break;
        }
    }
    
    if (self.videoIdBlock) {
        self.videoIdBlock(self.currentVideoID);
    }
    if (vcTemp && self.detailModel.video_type.integerValue != HKVideoType_Practice) {
        [self.navigationController popToViewController:vcTemp animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - ZFHKNormalPlayerControlView delegate

/** 点击分享 */
- (void)zfHKNormalPlayerControlView:(UIView*)view shareAction:(id )sender videoDetailModel:(DetailModel *)model permissionVideoModel:(HKPermissionVideoModel *)permissionModel{
    if (permissionModel.cannotPlayRedirect) {
        [HKH5PushToNative runtimePush:permissionModel.cannotPlayRedirect.class_name arr:permissionModel.cannotPlayRedirect.list currectVC:self];
    }
}


- (HKBuyVipView *)vipView{
    if (_vipView == nil) {
        _vipView = [HKBuyVipView viewFromXib];
        _vipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _vipView.alpha = 0.0;
        WeakSelf
        _vipView.didSureBtnBlock = ^(HKBuyVipModel * _Nonnull vipModel) {
            // 苹果支付
            if (isLogin()) {
                YHIAPpay *apPay = [YHIAPpay instance];
                [apPay buyProductionModel:vipModel];
            }
        };
        _vipView.didAgreeBlock = ^{
            NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_VIP_AGREEMENT];
            HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
            [weakSelf pushToOtherController:htmlShowVC];
        };
        
    }
    return _vipView;
}

/** 点击购买VIP */

- (void)zfHKNormalPlayerControlView:(UIView*)view  buyVipAction:(UIButton*)sender videoDetailModel:(DetailModel *)model permissionModel:(HKPermissionVideoModel *)permissionModel {
    //[self pushVIPCategoryVCWithModel:model permissionModel:permissionModel];
    [self.vipView removeFromSuperview];
    
    if (self.detailModel.limited_playback_vip_list.count) {
        self.vipView = nil;
        self.vipView.vip_list = self.detailModel.limited_playback_vip_list;
        [self.view addSubview:self.vipView];
        [self.vipView showView];
    }else{
        [self pushVIPCategoryVCWithModel:model permissionModel:permissionModel];
    }
}


#pragma mark - 跳转VIP
- (void)pushVIPCategoryVCWithModel:(DetailModel *)model permissionModel:(HKPermissionVideoModel *)permissionModel {
    //v2.17 职业路径  购买VIP 跳转
    [HKH5PushToNative runtimePush:permissionModel.vipRedirect.redirect_package.className arr:permissionModel.vipRedirect.redirect_package.list currectVC:self];
}


/** 进度提示 点击下一节视频 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  nextVideoModel:(DetailModel *)model {
    
    [self setNextVideoWithModel:model isNextAutoPlay:NO];
}


/** 播放完成倒计时 下一节视频 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  countDownNextVideoModel:(DetailModel *)model {
    [self setNextVideoWithModel:model isNextAutoPlay:(YES)];
}

/**
 下一节视频
 @param model
 @param isNextAutoPlay (YES - 自动跳转的视频)
 */
- (void)setNextVideoWithModel:(DetailModel*)model  isNextAutoPlay:(BOOL)isNextAutoPlay {
    if (isEmpty(model.video_id)) {
        return;
    }
    if (![model.video_id isEqualToString:self.detailModel.next_video_info.video_id]) {
        self.sectionId = model.next_video_info.section_id;
        [self _removeBaseVideoVCFromParent:model.next_video_info.video_id isNextAutoPlay:isNextAutoPlay isScrollCourseList:YES frontCourseId:model.video_id courseListVC:nil];
    }
}


#pragma mark - 推荐视频
/** 推荐视频 竖屏 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  portraitSimilarVideoView:(VideoModel *)model {
    [self setSimilarVideoWithModel:model];
}

/** 推荐视频 全屏*/
- (void)zfHKNormalPlayerControlView:(UIView*)view  landScapeSimilarVideoView:(VideoModel *)model {
    [self setSimilarVideoWithModel:model];
}


- (void)setSimilarVideoWithModel:(VideoModel*)model {
    if (isEmpty(model.video_id)) {
        return;
    }
    if (![model.video_id isEqualToString:self.detailModel.next_video_info.video_id]) {
        [self _removeBaseVideoVCFromParent:model.video_id isNextAutoPlay:NO isScrollCourseList:NO frontCourseId:nil courseListVC:nil];
    }
}


/** 播放完了 用于软件入门 证书弹框 */
- (void)zfHKNormalPlayerControlView:(UIView*)view  playEnd:(BOOL)playEnd videoModel:(DetailModel *)model {
    //[self setAchieveDialogWithModel:model];
}


/** 投屏 */
- (void)zfHKNormalPlayerControlView:(ZFHKNormalPlayerControlView *)view airPlayBtn:(UIButton*)airPlayBtn isFullScreen:(BOOL)isFullScreen {
    
    __block ZFHKNormalPlayerControlView *tempView = view;
    
    self.isNeedFullScreen = isFullScreen;
    HKAirPlayGuideVC *airPlayGuideVC = [HKAirPlayGuideVC new];
    //airPlayGuideVC.permissionModel = view.permissionModel;
    airPlayGuideVC.airPlayGuideVCCallBack = ^(NSString * _Nonnull deviceName, BOOL isAirPlay) {
        if (isAirPlay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tempView changeConnectAirPlay];
            });
        }
    };
    [self pushToOtherController:airPlayGuideVC];
}

//-(void)zfHKNormalPlayerControlView:(ZFHKNormalPlayerControlView *)view addTxtNote:(UIImage *)img isFullScreen:(BOOL)isFullScreen{
//    NSLog(@"跳转编辑页面");
//    self.isNeedFullScreen = isFullScreen;
//    HKEditNoteVC * vc = [[HKEditNoteVC alloc] init];
//    vc.img = img;
//    [self pushToOtherController:vc];
//}

- (void)zfHKNormalPlayerControlView:(ZFHKNormalPlayerControlView *)view addTxtNote:(UIImage *)img isFullScreen:(BOOL)isFullScreen currentTime:(NSInteger)currentTime videoModel:(DetailModel *)videoModel{
    self.isNeedFullScreen = isFullScreen;
    HKEditNoteVC * vc = [[HKEditNoteVC alloc] init];
    vc.videoModel = videoModel;
    vc.currentTime = currentTime;
    vc.img = img;
    [self pushToOtherController:vc];
}

/// 强制全屏
- (void)forceFullScreen {
    if (self.isNeedFullScreen) {
        self.isNeedFullScreen = NO;
        if (!self.controlView.player.isFullScreen && self.controlView.player){
            if(IS_IPAD){//竖屏模式的全屏状态
                [self.controlView.player enterPortraitFullScreen:YES animated:YES];
            }else{
                [self.controlView.player enterFullScreen:YES animated:NO];
            }
        }
    }
}



/** 强制设置竖屏 */
- (void)forcePlayerPortrait {
    if (self.controlView.player.orientationObserver.supportInterfaceOrientation && self.controlView.player.isFullScreen) {
        [self.controlView.player enterFullScreen:NO animated:NO];
    }
}


/// 更新 视频观看后 目录列表 的显示UI
- (void)_updateFrontVideoPlayStatus:(NSString*)videoId {
    if (_baseVideoVC) {
        [_baseVideoVC updateFrontVideoPlayStatus:videoId];
    }
}

/** 移除专辑 VC */
- (void)_removeContainerVC {
    if (self.containerVC) {
        [self.containerVC.view removeFromSuperview];
        [self.containerVC removeFromParentViewController];
        self.containerVC = nil;
    }
}

- (void)dealloc {
    [self removeBaseVideoVC];
    HK_NOTIFICATION_REMOVE();
    LOG_ME;
}

@end




