//
//  BaseVideoViewController.m
//  Demo
//
//  Created by Mark on 16/7/25.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//

#import "BaseVideoViewController.h"
#import "TeacherInfoViewController.h"
#import "DetailHeadView.h"
#import "DetailActionView.h"
#import "DetailModel.h"
#import "DetailGapView.h"

#import "HKDownloadModel.h"
#import "HKPermissionVideoModel.h"

#import "HKCourseListVC.h"
#import "HKCoursePracticeVC.h"
#import "NewVideoCommentVC.h"
#import <UMShare/UMShare.h>
#import "UMpopView.h"


#import "HKBulidContainerVC.h"
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"
#import "HKTestDownloadVC.h"
#import "HKVideoDetailBuyPgcView.h"
#import "HKDownloadCourseVC.h"
#import "HKUMpopViewController.h"
#import "WMPageController+Category.h"
#import "HKStudyMedalVC.h"
#import "HKStudyCertificateDialogVC.h"
#import "HKH5PushToNative.h"
#import "HKPlaytipByWWANTool.h"
#import "HKDetailRecommandView.h"
#import "VideoPlayVC.h"
#import "HKDetailAlbumView.h"
#import "CategoryModel.h"
#import "HKInteractionVC.h"
#import "HKImageTextVC.h"
#import "HKCatalogueListVC.h"

static CGFloat const kDetailActionViewHeight = 70;
static CGFloat const kDetailRcommandHeight = 197;
static CGFloat const kDetailAlbumHeight = 40;


@interface BaseVideoViewController ()<DetailActionViewDelegate, HKDownloadManagerDelegate,HKVideoDetailBuyPgcViewDelegate,UMpopViewDelegate,HKCourseListVCDelegate>

@property (nonatomic, strong) NSMutableArray <NSString*> *musicCategories;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *myViewcontrollers;
/** 标题视图 */
@property (nonatomic, strong) DetailHeadView *detailHeadView;
/** 按钮视图 */
@property (nonatomic, strong) DetailActionView *detailActionView;
/** 间隔 */
@property (nonatomic, strong) DetailGapView *detailGapView;

@property (nonatomic, strong) HKPermissionVideoModel *permissionVideoModel;
@property (nonatomic, strong) HKDownloadModel *downloadModel;
@property (nonatomic, strong) HKDownloadModel *HKmodelDownload;
@property (nonatomic, strong) HKVideoDetailBuyPgcView  *buyPgcView;
/** 头部标题视图高度 */
@property (nonatomic,assign) CGFloat detailHeadViewHeight;
/** 头部高度 */
@property (nonatomic,assign) CGFloat headViewHeight;
//推荐视频高度
//@property (nonatomic,assign) CGFloat headViewHeight;

@property (nonatomic , strong) HKDetailRecommandView * recommandView;
//专辑
@property (nonatomic , strong) HKDetailAlbumView * albumView;
@property (nonatomic , strong) HKCatalogueListVC * listVC;
@property (nonatomic , strong) HKDownloadCourseVC * downLoadVC;
@property (nonatomic , assign) BOOL showCatalogueList;

@end



@implementation BaseVideoViewController


#pragma mark <HKDownloadManagerDelegate>
- (void)beginDownload:(HKDownloadModel *)model {
    [self sendNotificationUpdateDownloadBtnStatus:YES];
    NSLog(@"%s", __func__);
}

- (void)waitingDownload:(HKDownloadModel *)model {
    [self sendNotificationUpdateDownloadBtnStatus:NO];
    NSLog(@"%s", __func__);
}

- (void)download:(HKDownloadModel *)model progress:(NSProgress *)progress index:(NSString *)index{
    //NSLog(@"%s %lld", __func__, progress.completedUnitCount);// 222
}
- (void)didFailedDownload:(HKDownloadModel *)model {
    [self sendNotificationUpdateDownloadBtnStatus:NO];
    NSLog(@"%s", __func__);
}
- (void)didFinishedDownload:(HKDownloadModel *)model {
    [self sendNotificationUpdateDownloadBtnStatus:NO];
    NSLog(@"%s", __func__);
}
- (void)didPausedDownload:(HKDownloadModel *)model {
    [self sendNotificationUpdateDownloadBtnStatus:NO];
    NSLog(@"%s", __func__);
}
- (void)didDeletedDownload:(HKDownloadModel *)model {
    [self sendNotificationUpdateDownloadBtnStatus:NO];
    NSLog(@"%s", __func__);
}

- (void)sendNotificationUpdateDownloadBtnStatus:(BOOL)notRealBegin {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:HKSingleModelChangeNotification object:self userInfo:@{@"notRealBegin" : @(notRealBegin)}];
    });
}



- (instancetype)initWithModel:(DetailModel*)model course:(HKCourseModel *)course {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
    }
    return self;
}



- (void)menuTabProgressUI {
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
}



- (void)viewDidLoad {
    [self menuTabProgressUI];
    [super viewDidLoad];
    [self.view addSubview:self.detailHeadView];
    [self.view addSubview:self.detailActionView];
    [self.view addSubview:self.albumView];

    [self.view addSubview:self.recommandView];

    //增加推荐的课程
    
    [self.view addSubview:self.detailGapView];
    [self createObserver];
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
//    UIScreenEdgePanGestureRecognizer * scre = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
//    scre.edges = UIRectEdgeLeft;
//    [self.view addGestureRecognizer:scre];
    
    
}

//- (void)panClick:(UIScreenEdgePanGestureRecognizer *)sender{
//
//    if (sender.edges == UIRectEdgeLeft) {
//        NSLog(@"------------");
//    }
//}


- (void)layoutUI:(BOOL)scrollCourseList {
    
    self.detailHeadViewHeight = ((self.detailModel.textLines == 2) ? 93 : 70)+3;
//    // 兼容iPhone5s尺寸一下的练习题的按钮
//    if ([self.detailModel.video_type isEqualToString:@"1"] && self.detailModel.salve_video_list.count > 0 && SCREEN_W <= Iphone_40Inch_Width) {
//        self.detailHeadViewHeight += 25.0;
//    }
        
    //self.headViewHeight = kDetailActionViewHeight + self.detailHeadViewHeight + 7.0 + kDetailRcommandHeight;
//    self.headViewHeight = CGRectGetMaxY(self.recommandView.frame);
    
    if (self.detailModel.dataSource.count) {
        self.recommandView.hidden = NO;
    }else{
        self.recommandView.hidden = YES;
    }
    self.detailActionView.frame = CGRectMake(0, self.detailHeadView.height + self.albumView.height,IS_IPAD ? SCREEN_WIDTH: SCREEN_W, [self.detailModel.is_show_tips isEqualToString:@"1"] ? kDetailActionViewHeight + 20 : kDetailActionViewHeight);
    self.headViewHeight = CGRectGetMaxY(self.recommandView.frame);
    [self prepareSetup];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.detailHeadView layoutIfNeeded];
    [self.detailActionView layoutIfNeeded];
    [self.detailGapView layoutIfNeeded];
    [self.recommandView layoutIfNeeded];
    [self.albumView layoutIfNeeded];
    [self refreshTabVC:scrollCourseList];
    if (self.showCatalogueList) {
        _listVC.view.frame = CGRectMake(0, (self.detailHeadViewHeight + self.detailActionView.height + 7), IS_IPAD ? SCREEN_WIDTH:SCREEN_W, self.view.height);
        self.maximumHeaderViewHeight = self.detailHeadViewHeight + self.detailActionView.height + 7;
        [self.view bringSubviewToFront:self.listVC.view];
    }
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self setBottomPgcBuyView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setBottomPgcBuyView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeBottomCommentView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}



- (DetailHeadView*)detailHeadView {
    
    @weakify(self);
    if (!_detailHeadView) {
        _detailHeadView = [[DetailHeadView alloc]initWithFrame:CGRectMake(0, 0, IS_IPAD ? SCREEN_WIDTH:SCREEN_W, self.detailHeadViewHeight)];
        //_detailHeadView.detaiModel = self.detailModel;
        // 设置点击练习block
        _detailHeadView.praticeBtnClickBlock = ^{
            @strongify(self);
            // 如果已经添加就直接返回
            if ([self.view viewWithTag:88]) return;
            
            __block HKCoursePracticeVC *vc = [[HKCoursePracticeVC alloc] init];
            vc.videoDetailModel = self.detailModel;
            vc.view.frame = self.view.bounds;
            [self addChildViewController:vc];
            vc.view.y = IS_IPAD ? SCREEN_HEIGHT:SCREEN_H;
            [self.view addSubview:vc.view];
            vc.view.tag = 88;
            [UIView animateWithDuration:0.5 animations:^{
                vc.view.y = 0;
            } completion:^(BOOL finished) {
                
            }];
        };
    }
    _detailHeadView.detaiModel = self.detailModel;
    _detailHeadView.height  = self.detailHeadViewHeight;
    WeakSelf
    _detailHeadView.certificateBgViewClickBlock = ^(DetailModel *detaiModel) {
        if (detaiModel.obtain_info.is_completed) {
            if (isLogin()) {
                    if (!isEmpty(detaiModel.obtain_info.redirect_package.class_name)) {
                        [HKH5PushToNative runtimePush:detaiModel.obtain_info.redirect_package.class_name arr:detaiModel.obtain_info.redirect_package.list currectVC:weakSelf];
                    }
            }else{
                [weakSelf setLoginVC];
            }
        }else{
            @strongify(self);
            if (self.myViewcontrollers.count >2) {
                //选中详情 tab
                self.selectIndex = 1;
                [self didEnterController:self.myViewcontrollers[1] atIndex:1];
            }
        }
    };
    return _detailHeadView;
}

-(HKCatalogueListVC *)listVC{
    if (_listVC == nil) {
        _listVC = [[HKCatalogueListVC alloc] init];
        _listVC.view.frame = CGRectMake(0, (self.detailHeadViewHeight + self.detailActionView.height + 7), IS_IPAD ? SCREEN_WIDTH:SCREEN_W, self.view.height);
        WeakSelf
        _listVC.closeBtnBlock = ^{
            weakSelf.showCatalogueList = NO;

//            CATransition* transition = [CATransition animation];
//            transition.duration =0.25;
//            transition.type = kCATransitionReveal;
//            transition.subtype = kCATransitionFromBottom;
//            [weakSelf.listVC.view.layer addAnimation:transition forKey:kCATransition];
//            [weakSelf.listVC.view removeFromSuperview];
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf removeBaseVideoVC];
                weakSelf.maximumHeaderViewHeight = weakSelf.headViewHeight;
//            });
            
            if (weakSelf.categoryListShowBlock) {
                weakSelf.categoryListShowBlock(NO);
            }
        };
        _listVC.didItemBlock = ^(HKCourseModel * _Nonnull model) {
            if (model.video_id.length == 0) {
                showTipDialog(@"当前视频id为nil");
            }else{
                if (![model.video_id isEqualToString:weakSelf.detailModel.video_id]) {
                    if ([weakSelf.baseVideoDelegate respondsToSelector:@selector(baseVideoVC:changeCourseVC:changeCourseId:sectionId:frontCourseId:courseListVC:)]) {
                        [weakSelf.baseVideoDelegate baseVideoVC:weakSelf changeCourseVC:YES changeCourseId:model.videoId sectionId:model.section_id frontCourseId:weakSelf.detailModel.video_id courseListVC:nil];
                    }
                }else{
                    NSLog(@"正在播放当前视频");
                }
            }
        };
    }
    return _listVC;
}

-(HKDetailRecommandView *)recommandView{//kDetailActionViewHeight + self.detailHeadViewHeight + 7.0
    if (_recommandView == nil) {
        _recommandView = [[HKDetailRecommandView alloc] initWithFrame:CGRectMake(0,self.detailHeadView.height + self.detailActionView.height + 7 + self.albumView.height, IS_IPAD ? SCREEN_WIDTH:SCREEN_W, kDetailRcommandHeight)];
        WeakSelf
        _recommandView.moreClickBlock = ^{
            weakSelf.showCatalogueList = YES;
            if (![[weakSelf childViewControllers] containsObject:weakSelf.listVC]) {
                [weakSelf addChildViewController:weakSelf.listVC];
                [weakSelf.view addSubview:weakSelf.listVC.view];
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.25;
                transition.type = kCATransitionMoveIn;
                transition.subtype = kCATransitionFromTop;
                [weakSelf.listVC.view.layer addAnimation:transition forKey:kCATransition];


                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.maximumHeaderViewHeight = weakSelf.detailHeadViewHeight + weakSelf.detailActionView.height + 7;
                });
                
                weakSelf.listVC.detaiModel = weakSelf.detailModel;
                weakSelf.listVC.videoCount = (int)weakSelf.recommandView.dataArray.count;
                if (weakSelf.categoryListShowBlock) {
                    weakSelf.categoryListShowBlock(YES);
                }
            }
        };

        _recommandView.cellClickBlock = ^(HKCourseModel * _Nonnull model) {
            [MobClick event: detailpage_catalog_recommend_video];
            if (model.video_id.length == 0) {
                showTipDialog(@"当前视频id为nil");
            }else{
                if (![model.video_id isEqualToString:weakSelf.detailModel.video_id]) {
                    if ([weakSelf.baseVideoDelegate respondsToSelector:@selector(baseVideoVC:changeCourseVC:changeCourseId:sectionId:frontCourseId:courseListVC:)]) {
                        [weakSelf.baseVideoDelegate baseVideoVC:weakSelf changeCourseVC:YES changeCourseId:model.videoId sectionId:model.section_id frontCourseId:weakSelf.detailModel.video_id courseListVC:nil];
                    }
                }else{
                    NSLog(@"正在播放当前视频");
                }
            }
        };

    }
    _recommandView.y = CGRectGetMaxY(self.detailActionView.frame) + 7.0;
    _recommandView.height = self.detailModel.dataSource.count? kDetailRcommandHeight : 0.0;
    _recommandView.detaiModel = self.detailModel;
    return _recommandView;
}


- (void)removeBaseVideoVC {
    if (_listVC) {
        [_listVC didMoveToParentViewController:nil];
        [_listVC.view removeFromSuperview];
        [_listVC removeFromParentViewController];
        _listVC = nil;
    }
}

-(HKDetailAlbumView *)albumView{
    if (_albumView == nil) {
        _albumView = [HKDetailAlbumView viewFromXib];
        _albumView.frame = CGRectMake(0, self.detailHeadView.height, IS_IPAD ? SCREEN_WIDTH:SCREEN_W, 0);
        _albumView.didTapBlock = ^(DetailModel * _Nonnull detaiModel) {
            [HKH5PushToNative runtimePush:detaiModel.album.redirect_package.class_name arr:detaiModel.album.redirect_package.list currectVC:nil];
        };
    }
    _albumView.y = CGRectGetMaxY(self.detailHeadView.frame);
    
    
    
    if (self.detailModel.album) {
        _albumView.hidden =  NO;
        _albumView.height = kDetailAlbumHeight;
    }else{
        if (self.detailModel.is_series && (self.detailModel.is_buy_series == NO)) {
            _albumView.hidden = NO;
            _albumView.height = kDetailAlbumHeight;
        }else{
            _albumView.hidden = YES;
            _albumView.height = 0.0;
        }
    }
    _albumView.detaiModel = self.detailModel;
    return _albumView;
}

- (DetailActionView*)detailActionView {
    if (!_detailActionView) {
        _detailActionView = [[DetailActionView alloc]initWithFrame:CGRectMake(0, self.detailHeadView.height + self.albumView.height, IS_IPAD ? SCREEN_WIDTH:SCREEN_W, [self.detailModel.is_show_tips isEqualToString:@"1"] ? kDetailActionViewHeight + 20 : kDetailActionViewHeight)];
        _detailActionView.delegate = self;
        //_detailActionView.detailModel = self.detailModel;
        
        WeakSelf;
        _detailActionView.collectVideoBlock = ^(DetailModel *model){
            
            //通过短视频跳转 收藏点击统计
            if (!isEmpty(weakSelf.alilogModel.shortVideoToVideoCollectFlag)) {
                [[HKALIYunLogManage sharedInstance] hkShortVideoClickLogWithFlag:weakSelf.alilogModel.shortVideoToVideoCollectFlag];
            }
            
            if (!isLogin()) {
                [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:2];
                [weakSelf setLoginVC];
            }else{
                NSInteger status = [HkNetworkManageCenter shareInstance].networkStatus;
                if (status == AFNetworkReachabilityStatusNotReachable){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        showTipDialog(NETWORK_NOT_POWER_TRY);
                    });
                    return;
                }
            }
        };
        _detailActionView.loadVideoBlock = ^(HKDownloadModel *downloadModel, DetailModel *detailModel, HKDownloadStatus dowloadStatus) {
            
           NSInteger type = detailModel.video_type.integerValue;
            if (!isLogin()) {
                [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:3];
                [weakSelf setLoginVC];
                return;
            }
            // 普通视频没有下载过的
            //if (HKVideoType_Ordinary == type || HKVideoType_UpDownCourse == type) {
            if (HKVideoType_Ordinary == type) {
                
                if (dowloadStatus == HKDownloadFinished) return;
                
                if (dowloadStatus == HKDownloadNotExist) {
                    weakSelf.downloadModel = downloadModel;
                }
            }
            // 获取权限
            [weakSelf getPermission:detailModel];
        };
    }
    _detailActionView.y = CGRectGetMaxY(self.albumView.frame);
    
    _detailActionView.detailModel = self.detailModel;
    return _detailActionView;
}

-(void)setDetailModel:(DetailModel *)detailModel{
    _detailModel = detailModel;
    NSLog(@"*******====*****===");
    if (self.downLoadVC) {
        self.downLoadVC.videlDetailModel = detailModel;
        NSLog(@"*******====*****");
    }
}

- (DetailGapView*)detailGapView {
    if (!_detailGapView) {
        _detailGapView = [[DetailGapView alloc]initWithFrame:CGRectMake(0,self.detailHeadView.height + self.albumView.height + self.detailActionView.height, IS_IPAD ? SCREEN_WIDTH:SCREEN_W, PADDING_15/2)];
    }
    _detailGapView.frame = CGRectMake(0, CGRectGetMaxY(self.recommandView.frame), IS_IPAD ? SCREEN_WIDTH:SCREEN_W, PADDING_15/2);
    return _detailGapView;
}


#pragma mark - DetailActionView 分享 代理
- (void)shareVideo:(DetailModel *)detailModel {
    
    [self initShareUIWithModel:detailModel isCurrentVC:YES];
}



- (void)collectionAlbum:(DetailModel *)detailModel {
    
    if ([self.baseVideoDelegate respondsToSelector:@selector(baseVideoVC:collectionAlbumWithModel:)]) {
        [self.baseVideoDelegate baseVideoVC:self collectionAlbumWithModel:detailModel];
    }
}



/**
 建立 分享 UI
 
 @param model
 @param isCurrentVC (YES: 当前Base 控制器 NO:视频播放页 分享解锁)
 */
- (void)initShareUIWithModel:(DetailModel*)model isCurrentVC:(BOOL)isCurrentVC {
    
    
    ShareModel *shareM = isCurrentVC ? model.share_data :model.share_data_unlock;
    shareM.video_id = model.video_id;
    
    UMpopView *popView = [UMpopView sharedInstance];
    [popView createUIWithModel:shareM];
    popView.delegate = self;
}


#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareVideoWithModel:model];
    }
}


- (void)uMShareWebFail:(id)sender {
    NSLog(@"分享失败");
}


- (void)uMShareImageSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareVideoWithModel:model];
    }
}

- (void)uMShareImageFail:(id)sender {
    
}



#pragma mark - 分享视频成功 统计分享结果 解锁视频
- (void)shareVideoWithModel:(ShareModel*)model {
    
    // 未登录 不能解锁视频
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }
    WeakSelf;
    
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        StrongSelf;
        [strongSelf shareSucessCallback:model];
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)shareSucessCallback:(id)sender {
    if ([self.baseVideoDelegate respondsToSelector:@selector(baseVideoVC:shareVideoSucess:)]) {
        [self.baseVideoDelegate baseVideoVC:self shareVideoSucess:sender];
    }
}


#pragma mark - 下载 观看 权限判断
- (void)getPermission:(DetailModel *)detailModel {
    
//    NSString *type = detailModel.video_type;
    
//    if (type.intValue == HKVideoType_JobPath || type.intValue == HKVideoType_JobPath_Practice) {
//
//        //[self jobPathDownPermission:detailModel];
//        [self detailVidelDownloadNotification:nil];
//    }else{
        [self detailVidelDownloadNotification:nil];
//    }
}




// 职业路径下载权限
//- (void)jobPathDownPermission:(DetailModel *)detailModel {
//    __block NSString *type = detailModel.video_type;
//    @weakify(self);
//    NSDictionary *param = @{@"chapter_id" : detailModel.chapterId, @"section_id" : detailModel.sectionId, @"video_id" : detailModel.video_id, @"career_id" : detailModel.career_id};
//    //url = CAREER_VIDEO_PLAY;
//    //v2.21
//    [HKHttpTool POST:VIDEO_DOWNLOAD parameters:param success:^(id responseObject) {
//        closeWaitingDialog();
//        if (HKReponseOK) {
//            @strongify(self)
//            //is_paly：0-不可观看 1-可观看
//            HKPermissionVideoModel *model = [HKPermissionVideoModel mj_objectWithKeyValues:responseObject[@"data"]];
//            self.permissionVideoModel = model;
//            NSDictionary *dict =  @{@"loginStatus":model,@"videoType":isEmpty(type) ?@"" :type};
//            [MyNotification postNotificationName:KLoginStatusNotification object:self userInfo:dict];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}




#pragma mark - 通知
- (void)createObserver {
    
    //下载 权限
    HK_NOTIFICATION_ADD_OBJ(KLoginStatusNotification, (detailVidelDownloadNotification:), self);
    //全屏 切换
    HK_NOTIFICATION_ADD(KPlayVideoScreenRotationNotification, (playVideoScreenRotationNotification:));
}


- (void)playVideoScreenRotationNotification:(NSNotification *)noti {
    //NSDictionary *dict = @{@"videoId":videoId,@"direction":@"0"};
    // 0--竖屏  1-- 全屏
    NSDictionary *dict = noti.userInfo;
    NSString *videoId = dict[@"videoId"];
    NSString *direction = dict[@"direction"];
    if ([videoId isEqualToString:self.detailModel.video_id]) {
        if ([direction isEqualToString:@"1"]) {
            [self hiddenOrShowBuyPgcView:YES];
        }else{
            [self hiddenOrShowBuyPgcView:NO];
        }
    }
}


- (void)detailVidelDownloadNotification:(NSNotification *)noti {
    
    @weakify(self);
    NSString *videoType = self.detailModel.video_type;
    if ([videoType integerValue] == HKVideoType_PGC) {
        showTipDialog(GO_TO_PC_BUY_PGC);
        return ;
    }
//    else{
//        if (NO == self.detailModel.can_download) {
//            [HKALIYunLogManage sharedInstance].button_id = @"8";
//            //没有下载权限
//            [self pushToVipVC:self.detailModel.vipRedirect];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                showTipDialog(@"仅付费vip可下载视频");
//            });
//            return ;
//        }
//    }
    
    // 进入目录的下载列表
     NSInteger type = [self.detailModel.video_type integerValue];
    if (type == HKVideoType_LearnPath || type == HKVideoType_Series || type == HKVideoType_PGC || type == HKVideoType_Practice ||
        type == HKVideoType_JobPath_Practice || type == HKVideoType_JobPath || type == HKVideoType_UpDownCourse || type == HKVideoType_Series)
    {
        // 非普通视频没有下载列表
        HKDownloadCourseVC *courseVC = [[HKDownloadCourseVC alloc]initWithNibName:nil bundle:nil videoId:self.detailModel.video_id detailModel:self.detailModel];
        // 传递更新的block
        courseVC.selectedBlock = ^(NSArray *array) {
            @strongify(self);
            for (UIViewController *vc in self.myViewcontrollers) {
                if ([vc isKindOfClass:[HKCourseListVC class]]) {
                    [((HKCourseListVC *)vc) loadNewCacheStatus:array];
                    break;
                }
            }
        };
        courseVC.hidesBottomBarWhenPushed = YES;
        self.downLoadVC = courseVC;
        [self.navigationController pushViewController:courseVC animated:YES];
        return;
    }
    
    
    
    
    if (NO == self.detailModel.can_download) {
        [HKALIYunLogManage sharedInstance].button_id = @"8";
        //没有下载权限
        [self pushToVipVC:self.detailModel.vipRedirect];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            showTipDialog(@"仅付费vip可下载视频");
        });
        return ;
    }
    
    //self.downloadModel.url = tempModel.video_url;
    self.downloadModel.videoType = [videoType intValue];
    HKDownloadModel *model = self.downloadModel;
    NSInteger status = [HkNetworkManageCenter shareInstance].networkStatus;
    if (status == AFNetworkReachabilityStatusNotReachable){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            showTipDialog(NETWORK_NOT_POWER_TRY);
        });
        return;
    }
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        // 尚未下载过
        HKDownloadStatus downloadStatus = [[HKDownloadManager shareInstance] queryStatus:model];
        if (downloadStatus == HKDownloadNotExist) {
            
            // 直接执行代理开始（假象，因为子线程需要解析，初始化数据库等操作耗时）
            !self.detailActionView.beginBlock? : self.detailActionView.beginBlock
            ();
            showTipDialog(DownLoading_Tip);
            if (model != nil) {
                [[HKDownloadManager shareInstance] downloadModel:model withDelegate:self];
            }
        }else{
            showTipDialog(In_DownLoad_Queue);
            return;
        }
    }else if(status == AFNetworkReachabilityStatusReachableViaWWAN){
        
            [HKPlaytipByWWANTool nomarlVideoDownloadtipByWWAN:^{
                @strongify(self);
               // 尚未下载过
               HKDownloadStatus downloadStatus = [[HKDownloadManager shareInstance] queryStatus:model];
               if (downloadStatus == HKDownloadNotExist) {
                   showTipDialog(DownLoading_Tip);
                   if (model != nil) {
                       [[HKDownloadManager shareInstance] downloadModel:model withDelegate:self];
                       
                   }
               }else{
                   showTipDialog(In_DownLoad_Queue);
                   return;
               }
            } cancelAction:^{
                
            }];
    }
}



- (void)prepareSetup {
    
    self.controllerType = WMStickyPageControllerType_videoDetail;
    self.menuItemWidth = (IS_IPAD ? SCREEN_WIDTH:SCREEN_W) /3;
    
    self.menuViewHeight = 44;//标题栏高度
    self.maximumHeaderViewHeight = self.headViewHeight;
    self.minimumHeaderViewHeight = 0;
}



#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.myViewcontrollers.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    if(index < self.myViewcontrollers.count){
        return self.myViewcontrollers[index];
    }
    return nil;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if(index < self.myViewcontrollers.count){
        return self.musicCategories[index];
    }
    return @"";
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController
              withInfo:(NSDictionary *)info {
    
    if ([self.baseVideoDelegate respondsToSelector:@selector(baseVideoVC:didEnterCommentVC:)]) {
        
        BOOL isNewVideoCommentVC = NO;
//        if ([viewController isKindOfClass:[NewVideoCommentVC class]]) {
//            isNewVideoCommentVC = YES;
//        }
        
        if ([viewController isKindOfClass:[HKInteractionVC class]]) {
            isNewVideoCommentVC = YES;
        }
        
        [self.baseVideoDelegate baseVideoVC:self didEnterCommentVC:isNewVideoCommentVC];
    }
}

#pragma mark - 刷新 tab
- (void)refreshTabVC:(BOOL)scrollCourseList {
    
    [self.myViewcontrollers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[HKInteractionVC class]]) {
            [((HKInteractionVC *)obj) setCommentWithModel: self.detailModel];
            
        }
        if ([obj isKindOfClass:[HKImageTextVC class]]) {
            [((HKImageTextVC *)obj) setVideoInfoWithModel: self.detailModel];

        }
        else if ([obj isKindOfClass:[TeacherInfoViewController class]]) {
            
            [((TeacherInfoViewController *)obj) setTeacherInfoWithModel:self.detailModel];
            
        }else if ([obj isKindOfClass:[HKCourseListVC class]]) {
            if (scrollCourseList) {
                [((HKCourseListVC *)obj) selectClickVideo:self.detailModel.video_id isScroll:YES];
            }
        }
    }];
}



#pragma mark - lazy
- (NSMutableArray <NSString*> *)musicCategories {
    if (!_musicCategories) {
        _musicCategories = [NSMutableArray array];
    }
    // 视频类型 0-普通视频 1-软件入门 2-系列课视频  3-有上下集  4-PGC 5-练习题 6-职业路径
    switch ([self.detailModel.video_type integerValue]) {
            
        case HKVideoType_Ordinary:{
//            if (self.detailModel.is_series && (self.detailModel.is_buy_series == 1)) {
            if(self.detailModel.pictext_url.length == 0){
                _musicCategories = @[@"相关",[self connectionString]].mutableCopy;
            }else{
                _musicCategories = @[@"图文",@"相关",[self connectionString]].mutableCopy;
            }
                
//            }else{
//                _musicCategories = @[@"详情",[self connectionString]].mutableCopy;
//            }
        }
            break;
            
        case HKVideoType_LearnPath: case HKVideoType_Practice://软件入门
            _musicCategories = @[@"目录", @"详情",[self connectionString]].mutableCopy;
            break;
            
        case HKVideoType_Series: case HKVideoType_UpDownCourse:
        case HKVideoType_JobPath: case HKVideoType_JobPath_Practice:
            if(self.detailModel.pictext_url.length == 0){
                _musicCategories = @[@"相关",[self connectionString]].mutableCopy;
            }else{
                _musicCategories = @[@"图文",@"相关",[self connectionString]].mutableCopy;
            }
            
            break;
            
        case HKVideoType_PGC:
            if(self.detailModel.pictext_url.length == 0){
                _musicCategories = @[@"相关",[self connectionString]].mutableCopy;
            }else{
                _musicCategories = @[@"图文",@"相关",[self connectionString]].mutableCopy;
            }
            
            break;
        default:
            if(self.detailModel.pictext_url.length == 0){
                _musicCategories = @[@"相关",[self connectionString]].mutableCopy;
            }else{
                _musicCategories = @[@"图文",@"相关",[self connectionString]].mutableCopy;
            }
            
            break;
    }
    
//    if (self.detailModel.fromTrainCourse) {
//        //训练营跳转过来，去除目录
//
//        if(self.detailModel.pictext_url.length == 0){
//            _musicCategories = @[@"相关",[self connectionString]].mutableCopy;
//        }else{
//            _musicCategories = @[@"图文",@"相关",[self connectionString]].mutableCopy;
//        }
//    }
    return _musicCategories;
}


/** 拼接 评论数量 */
- (NSString*)connectionString {
    
    NSString *total = self.detailModel.comment_total;
    NSString *comment = @"评价";
    if ([total intValue] >0) {
        comment = [NSString stringWithFormat:@"评论(%@)",([total intValue] >1000) ?@"999+" :total];
    }
    return comment;
}




- (NSMutableArray<UIViewController *> *)myViewcontrollers {
    
    if (_myViewcontrollers == nil) {
        _myViewcontrollers = [NSMutableArray array];
    }
    
    
    if ([self.detailModel.video_type integerValue] == HKVideoType_LearnPath || [self.detailModel.video_type integerValue] == HKVideoType_Practice) {
        _myViewcontrollers = @[self.courseListVC, self.teacherInfoVC,self.interactionVC].mutableCopy;
    }else{
        if(self.detailModel.pictext_url.length == 0){
            _myViewcontrollers = @[self.teacherInfoVC,self.interactionVC].mutableCopy;
        }else{
            _myViewcontrollers = @[self.imageTextVC, self.teacherInfoVC,self.interactionVC].mutableCopy;
        }
        
    }
    
//    if ([self.detailModel.video_type integerValue] == HKVideoType_Ordinary) {
//        if (self.detailModel.is_series && (self.detailModel.is_buy_series == 1)) {
//            _myViewcontrollers = @[self.courseListVC, self.teacherInfoVC,self.interactionVC].mutableCopy;
//        }else{
//            // 普通的视频 练习题
//            _myViewcontrollers = @[self.teacherInfoVC, self.interactionVC].mutableCopy;
//        }
//        
//    }else if ([self.detailModel.video_type integerValue] == HKVideoType_PGC) {
//        //PGC
//        _myViewcontrollers = @[self.courseListVC, self.teacherInfoVC].mutableCopy;
//    }else{
//        _myViewcontrollers = @[self.courseListVC, self.teacherInfoVC,self.interactionVC].mutableCopy;
//    }
//    
//    if (self.detailModel.fromTrainCourse) {
//        //训练营跳转过来，去除目录
//        _myViewcontrollers = @[self.teacherInfoVC, self.interactionVC].mutableCopy;
//    }
    
    
    return _myViewcontrollers;
}



/// 更新 视频观看后 目录列表 的显示UI
/// @param courseId 视频ID
- (void)updateFrontVideoPlayStatus:(NSString*)courseId {
    
    if (_myViewcontrollers.count) {
        [_myViewcontrollers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BOOL isContain = [obj isKindOfClass:[HKCourseListVC class]];
            
                if (isContain && _courseListVC) {
                    [_courseListVC setFrontCourseId:courseId];
                    *stop = YES;
                }
        }];
    }
}


- (void)courseListVC:(HKCourseListVC*)VC changeCourseId:(NSString*)changeCourseId
           sectionId:(NSString*)sectionId
       frontCourseId:(NSString*)frontCourseId {
    if ([self.baseVideoDelegate respondsToSelector:@selector(baseVideoVC:changeCourseVC:changeCourseId:sectionId:frontCourseId:courseListVC:)]) {
        [self.baseVideoDelegate baseVideoVC:self changeCourseVC:YES changeCourseId:changeCourseId sectionId:sectionId frontCourseId:frontCourseId courseListVC:nil];
    }
}



#pragma mark - 跳转购买VIP
- (void)pushToVipVC:(HKMapModel*)mapModel {
    
    // 跳转到 vip购买页 选中相应分类
    [MobClick event:UM_RECORD_VEDIO_DWONLIMIT_BUY];
//    // v2.17 购买VIP 跳转
//    [HKH5PushToNative runtimePush:mapModel.redirect_package.className arr:mapModel.redirect_package.list currectVC:self];
    
//    if (!isEmpty(self.detailModel.categoryId)) {
//        HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
//        VC.class_type = self.detailModel.categoryId;
//        VC.isShowDialg = YES;
//        VC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:VC animated:YES];
//    }
    if ([self.baseVideoDelegate respondsToSelector:@selector(baseVideoVCDidDownVideo: withMapModel:)]) {
        [self.baseVideoDelegate baseVideoVCDidDownVideo:self withMapModel:mapModel];
    }
}




/**************************** 购买PGC ****************************/
- (void)setBottomPgcBuyView {
    NSInteger type = [self.detailModel.video_type integerValue];
    BOOL isBuy = [self.detailModel.course_data.is_buy isEqualToString:@"0"]; // 1-已购买课程 0-未购买课程
    if (type == HKVideoType_PGC && isBuy) {
        [[[[UIApplication sharedApplication] delegate]window] addSubview:self.buyPgcView];
        //[self.view addSubview:self.buyPgcView];
    }
}

- (HKVideoDetailBuyPgcView*)buyPgcView {
    if (!_buyPgcView) {
        _buyPgcView = [[HKVideoDetailBuyPgcView alloc]initWithFrame:CGRectMake(0, IS_IPAD ? (SCREEN_HEIGHT-55):(SCREEN_H-55), IS_IPAD ? SCREEN_WIDTH:SCREEN_W, 55)];
        //CGRectMake(0, SCREEN_H*2/3-55, SCREEN_W, 55)];
        _buyPgcView.delegate = self;
        _buyPgcView.model = self.detailModel;
        _buyPgcView.backgroundColor = [UIColor redColor];
    }
    return _buyPgcView;
}

#pragma mark - 隐藏 或 显示 购买PGC视图
- (void)hiddenOrShowBuyPgcView:(BOOL)ishiddenOrShow {
    if (_buyPgcView) {
        _buyPgcView.hidden = ishiddenOrShow;
    }
}

- (void)buyPgcCourse:(id)sender {
    showTipDialog(GO_TO_PC_BUY_PGC);
    //[HKAccountTool shareAccount] ? nil : [self setLoginVC];
}

#pragma mark - 移除评价输入框
- (void)removeBottomCommentView {
    TTVIEW_RELEASE_SAFELY(_buyPgcView);
}




- (HKCourseListVC*)courseListVC {
    if (!_courseListVC) {
        // 软件入门（练习题），系列课
        _courseListVC = [[HKCourseListVC alloc]initWithNibName:nil bundle:nil videoId:self.detailModel.video_id detailModel:self.detailModel];
        _courseListVC.courseListDelegate = self;
        WeakSelf
        _courseListVC.callBackSourceBlock = ^(NSMutableArray *dataArray,NSIndexPath *indexPath) {
            if (weakSelf.callBackSourceBlock) {
                weakSelf.callBackSourceBlock(dataArray,indexPath);
            }
        };
    }
    return _courseListVC;
}

- (HKImageTextVC *)imageTextVC{
    if (_imageTextVC == nil) {
        _imageTextVC = [[HKImageTextVC alloc] initWithNibName:nil bundle:nil videoId:self.detailModel.video_id detailModel:self.detailModel];
    }
    return _imageTextVC;
}



- (TeacherInfoViewController*)teacherInfoVC {
    if (!_teacherInfoVC) {
        _teacherInfoVC = [[TeacherInfoViewController alloc]initWithNibName:nil bundle:nil model:self.detailModel  course:self.courseModel];
    }
    return _teacherInfoVC;
}

- (HKInteractionVC *)interactionVC{
    if (!_interactionVC) {
        WeakSelf
        _interactionVC = [[HKInteractionVC alloc] initWithDetailModel:self.detailModel];
        _interactionVC.CommentCountChangeBlock = ^(NSString * _Nonnull count) {
            if (!isEmpty(count) && ![count isEqualToString:@"0"]) {
                NSInteger index = (weakSelf.myViewcontrollers.count == 3) ?2 :1;
                [weakSelf updateTitle:[NSString stringWithFormat:@"评论(%@)",count] atIndex:index];
            }
        };
    }
    return _interactionVC;
}

@end











