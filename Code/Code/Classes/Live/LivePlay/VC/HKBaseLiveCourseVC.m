//
//  HKBaseLiveCourseVC.m
//  Code
//
//  Created by hanchuangkeji on 2018/12/6.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKBaseLiveCourseVC.h"
#import "WMPageController+Category.h"

#import "HKLiveDetailVC.h"
#import "HKLiveCalculateData.h"
#import "HKLiveCourseInfoCell.h"
#import "HKLiveCourseListVC.h"
#import "HKAdvanceSaleView.h"
#import "HKSaleRuleContentView.h"
#import "HKLiveDetailModel.h"

#import "HKLiveCoursePlayer.h"
#import "HKShowEntrollSuccessVC.h"
#import "HKLiveCourseVC.h"
#import "HKAirPlayGuideVC.h"
#import "UMpopView.h"
#import "HKLiveCourseBottomView.h"
#import "commentBottomView.h"
#import "HKVersionModel.h"
#import "HKSaveQrCodeView.h"
#import "HKLiveCommentVC.h"
#import "UIViewController+ZFNormalPlayerRotation.h"
#import "HKPermissionVideoModel.h"
#import "LBLelinkKitManager.h"
#import "HKDownloadLiveVC.h"
#import "VideoPlayEmptyView.h"
#import "WMMagicScrollView.h"
#import "HKPlayBackPlayerControlView+Category.h"


@interface HKBaseLiveCourseVC ()<VideoPlayEmptyViewDelegate,UMpopViewDelegate>

@property (nonatomic, strong)NSArray<UIViewController *> *myViewcontrollers;

@property (nonatomic, strong)NSMutableArray<NSString *> *myTitles;

/** 头部高度 */
@property (nonatomic,assign) CGFloat headViewHeight;

@property (nonatomic, strong)HKLiveCourseInfoCell *liveCourseInfoCell;
@property (nonatomic, strong)HKAdvanceSaleView * advanceSaleView;


@property (nonatomic, assign)CGFloat heigthTop;
// 顶部播放器
@property (nonatomic, assign)ZFPlayerPlaybackState playState; // 播放状态
@property (nonatomic, assign)BOOL isPauseByUs; // 进入别的页面暂停开始直播
@property (nonatomic, assign)NSInteger internetStatus;
// 底部购买
//@property (nonatomic, weak)HKLiveCourseBottomView *bottomView;
@property (nonatomic) HKPermissionVideoModel * permissionModel;//视频信息
@property (nonatomic, strong)VideoPlayEmptyView *videoPlayEmptyView;

@end

@implementation HKBaseLiveCourseVC

- (VideoPlayEmptyView*)videoPlayEmptyView {
    if (!_videoPlayEmptyView) {
        _videoPlayEmptyView = [[VideoPlayEmptyView alloc]init];
        _videoPlayEmptyView.delegate = self;
        _videoPlayEmptyView.hidden = YES;
    }
    return _videoPlayEmptyView;
}

- (void)viewDidLoad {
    [self menuTabProgressUI];
    [super viewDidLoad];
    self.internetStatus = [HkNetworkManageCenter shareInstance].networkStatus;

    // 模拟器的测试数据，无需理会
    if (SIMULATOR) {
        [[HKLiveCalculateData shareInstance] eachHourLiveData];
    }
    
//    [MyNotification addObserver:self
//                       selector:@selector(networkNotification:)
//                           name:KNetworkStatusNotification
//                         object:nil];
    [MyNotification addObserver:self selector:@selector(setItemTitle:) name:@"pageControllerTitle" object:nil];
}

- (void)setItemTitle:(NSNotification *)noti{
    int count = [noti.userInfo[@"count"] intValue];
    if (count > 0) {
        NSInteger row = 0 ;
        for (int i = 0; i < self.myTitles.count; i ++) {
            NSString * title = self.myTitles[i];
            if ([title containsString:@"评价"]) {
                row = i;
                //title = [NSString stringWithFormat:@"评价(%d)",count];
                //NSLog(@"----");
            }
        }
        if (count > 999) {
            [self.myTitles replaceObjectAtIndex:row withObject:@"评价(999+)"];
        }else{
            [self.myTitles replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"评价(%d)",count]];
        }
        
        [self reloadData];
    }
    
}

//- (void)networkNotification:(NSNotification *)noti {
//
//    NSDictionary *dict = noti.userInfo;
//    NSInteger  status  = [dict[@"status"] integerValue];
//    self.internetStatus = status;
//
//    // 如果正在播放4g
//    if (self.playState == ZFPlayerPlayStatePaused && status == AFNetworkReachabilityStatusReachableViaWWAN) {
//        showTipDialog(@"当前没有Wifi，回放会消耗流量哦~");
//    }
//}

// 暂停直播
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 虎课读书
    [HKBookPlayer hiddenWindowBooKView:NO];
    // 暂停播放
    if (self.playState == ZFPlayerPlayStatePlaying) {
        NSLog(@"isAirPlay : %d == isConnected : %d == isMirroring : %d == isLBlink : %d ",[LBLelinkKitManager sharedManager].isAirPlay,[LBLelinkKitManager sharedManager].isConnected,[LBLelinkKitManager sharedManager].isMirroring,[LBLelinkKitManager sharedManager].isLBlink);
        if ([LBLelinkKitManager sharedManager].isAirPlay &&
            ![LBLelinkKitManager sharedManager].isMirroring) return;
        
        self.isPauseByUs = YES;
        [self.topPlayerView.controlView hk_pauseOrStart];
    }
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 开始播放
    if (self.playState == ZFPlayerPlayStatePaused && self.isPauseByUs) {
        self.isPauseByUs = NO;
        [self.topPlayerView.controlView hk_pauseOrStart];
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self reloadData];
//}

- (void)setModel:(HKLiveDetailModel *)model {
    
    _model = model;
    [self prepareSetup];
    [self addTopView];

    self.liveCourseInfoCell.model = model;
    CGFloat height = (96 - 25) + self.model.courseNameHeight;
    /// height 取整，带有小数点 的高度 有的机型 无法向上滑动
    self.liveCourseInfoCell.height = (int) height; // 更新高度
    
    if (model.priceStrategy == 4) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addAdvanceSaleView];
        });
        
        //重新设置高度
        self.maximumHeaderViewHeight = self.headViewHeight =  (int) height + 218+ self.heigthTop;
    }else{
        //重新设置高度
        self.maximumHeaderViewHeight = self.headViewHeight =  (int) height + self.heigthTop;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self directGoLiveRoom];
    });
    if (model) {
        [self.videoPlayEmptyView removeFromSuperview];
        self.videoPlayEmptyView = nil;
        WMMagicScrollView * bgView = (WMMagicScrollView *)self.view;
        bgView.scrollEnabled = YES;

    }else{
        [self showPlayEmptyView];
    }
}

- (void)showPlayEmptyView {
    self.videoPlayEmptyView.frame = CGRectMake(0, self.heigthTop, SCREEN_WIDTH, SCREEN_HEIGHT - self.heigthTop);
    [self.view addSubview:self.videoPlayEmptyView];
    self.videoPlayEmptyView.hidden = NO;
    self.scrollEnable = NO;
    WMMagicScrollView * bgView = (WMMagicScrollView *)self.view;
    bgView.scrollEnabled = NO;
}

- (void)videoPlayEmptyView:(UIView*)view {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

- (void)directGoLiveRoom{
    if (!isLogin()) return;
    if (self.model.live.live_status != HKLiveStatusLiving) return;
    if (self.model.live.isEnroll) {//报名
        // 1 wifi 直接进入直播间
        // 2 非WIFI 弹框
        //        [self loadNetWorkTip];
        HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
        vc.live_id = self.model.live.ID;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else{//没有报名
        if (self.model.live.price.doubleValue == 0) {//免费
            //去报名
            // 免费的直接报名 并且
            WeakSelf
            [self userEnrollToServer:NO complete:^{
                HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                vc.live_id = weakSelf.model.live.ID;
                [self.navigationController pushViewController:vc animated:YES];
                //[weakSelf pushToOtherController:vc];
            }];
        }
    }
}

- (void)addTopView {
    HKLiveCourseInfoCell *liveCourseInfoCell = [[HKLiveCourseInfoCell alloc] init];
    liveCourseInfoCell.frame = CGRectMake(0, self.heigthTop, self.view.width, 0);
    self.liveCourseInfoCell = liveCourseInfoCell;
    [self.view addSubview:liveCourseInfoCell];
    WeakSelf
    self.liveCourseInfoCell.downBtnBlock = ^{
        //付费直播课详情页_下载按钮
        [MobClick event:@"C4406001"];
        if (weakSelf.model.live.isEnroll) {
            if ([weakSelf.model.can_download intValue] == 1) {
                HKDownloadLiveVC * downLiveVC = [HKDownloadLiveVC new];
                downLiveVC.ID = weakSelf.model.live.ID;
                downLiveVC.currentVideoID = weakSelf.model.live.video_id;
                [weakSelf.navigationController pushViewController:downLiveVC animated:YES];
            }else{
                showTipDialog(weakSelf.model.can_download_text);
            }
        }else{
            showTipDialog(@"报名后才能下载哦~");
        }
    };
    self.topPlayerView.model = _model;
//    self.bottomView.model = _model;
}

- (void)initMySettingView {
    
    // 顶部的播放器区域
    WeakSelf;
    HKLiveCoursePlayer *topPlayerView = [[HKLiveCoursePlayer alloc] init];
    self.topPlayerView = topPlayerView;
    CGFloat heigthTop = SCREEN_WIDTH*9/16;
        
    topPlayerView.frame = CGRectMake(0, 0, kScreenWidth, heigthTop);
    self.heigthTop = heigthTop;
    
    // 全屏时 VC旋转
//    topPlayerView.player.forceDeviceOrientation = YES;
    
    [self.view addSubview:topPlayerView];
    topPlayerView.backBtnClickBlock = ^{
        // 一次性返回
        NSArray *array = weakSelf.navigationController.viewControllers;
        UIViewController *vcTemp = nil;
        for (NSInteger i = array.count; i > 0; i--) {
            UIViewController *vc = array[i - 1];
            if (![vc isKindOfClass:[HKLiveCourseVC class]]) {
                vcTemp = vc;
                break;
            }
        }

        if (!vcTemp) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.navigationController popToViewController:vcTemp animated:YES];
        }

    };
    
    topPlayerView.shareBtnClickBlock = ^{
        [weakSelf shareWithUI:weakSelf.model.share_data];
    };
    topPlayerView.middleBtnClickBlock = ^{

        // 尚未开始直播 或者回放
        [weakSelf gotoLivingVCOrPlayBack];
    };
    topPlayerView.livingBtnClickBlock = ^{
        [weakSelf enterLivingVC];
    };
    topPlayerView.countdownEndDataBlock = ^{
        //[weakSelf loadNewData];
        if (weakSelf.refreshBlock) {
            weakSelf.refreshBlock();
        }
    };

    // 倍数
    topPlayerView.resolutionActionBlock = ^(CGFloat rate) {
        weakSelf.topPlayerView.player.currentPlayerManager.rate = rate;
    };

    // 播放状态
    topPlayerView.playerPlayStateChanged = ^(ZFPlayerPlaybackState playState) {
        weakSelf.playState = playState;
    };

    ///投屏
    topPlayerView.airPlayGuideVCBlock = ^(BOOL fullScreen) {

        HKAirPlayGuideVC *airPlayGuideVC = [HKAirPlayGuideVC new];
        airPlayGuideVC.airPlayGuideVCCallBack = ^(NSString * _Nonnull deviceName, BOOL isAirPlay) {
            if (isAirPlay) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //投屏
                    [weakSelf.topPlayerView.controlView changeConnectAirPlay];
                });
            }
        };
        [weakSelf.navigationController pushViewController:airPlayGuideVC animated:YES];
        //[weakSelf pushToOtherController:airPlayGuideVC];
        [MobClick event:DETAILPAGE_SCREENING];
    };
    if (self.isLocalVideo) {
        //本地已经下载的视频，直接播放
        [self playLookbackServer];
    }
}


- (void)addAdvanceSaleView{
    HKAdvanceSaleView * advanceV = [HKAdvanceSaleView viewFromXib];
    advanceV.frame = CGRectMake(0, CGRectGetMaxY(self.liveCourseInfoCell.frame), SCREEN_WIDTH, 218);
    advanceV.model = _model;
    advanceV.didLookBlock = ^{
        HKSaleRuleContentView * ruleV = [[HKSaleRuleContentView alloc] initWithFrame:CGRectMake(0, 0, 290, 210)];
        ruleV.didKnowBlock = ^{
            [LEEAlert closeWithCompletionBlock:nil];
        };
        [LEEAlert alert].config
        .LeeCustomView(ruleV)
        .LeeQueue(YES)
        .LeePriority(1)
        .LeeCornerRadius(0)
        .LeeHeaderColor([UIColor clearColor])
        .LeeHeaderInsets(UIEdgeInsetsZero)
        .LeeMaxWidth(320)
        .LeeClickBackgroundClose(YES)
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    };
    self.advanceSaleView = advanceV;
    [self.view addSubview:advanceV];
    
}


- (NSArray<UIViewController *> *)myViewcontrollers {
    if (_myViewcontrollers == nil) {
        
        WeakSelf;
        HKLiveDetailVC *vc1 = [[HKLiveDetailVC alloc] init];
        vc1.model = self.model;
        vc1.didSelectedRecBlock = ^(VideoModel * _Nonnull model) {
            !weakSelf.didSelectedRecBlock? : weakSelf.didSelectedRecBlock(model);
        };
        HKLiveCommentVC * commentV = [[HKLiveCommentVC alloc] init];
        commentV.videoId = _model.content.live_course_id;
        if (self.model.series_courses.count > 0) {
            HKLiveCourseListVC *vc2 = [[HKLiveCourseListVC alloc] init];
            vc2.didselectCourse = ^(HKLiveDetailModel *model) {
                !weakSelf.didselectCourse? : weakSelf.didselectCourse(model);
            };
            vc2.model = self.model;
            _myViewcontrollers = @[vc1, vc2,commentV];
        } else {
            _myViewcontrollers = @[vc1,commentV];
        }
    }
    return _myViewcontrollers;
}

- (NSMutableArray<NSString *> *)myTitles {
    if (_myTitles == nil) {
        
        if (self.model.series_courses.count > 0) {
            _myTitles = [NSMutableArray arrayWithObjects:@"详情", @"目录" ,@"评价", nil];
            //_myTitles = @[@"详情", @"目录" ,@"评价"];
        } else {
            _myTitles = [NSMutableArray arrayWithObjects:@"详情", @"评价", nil];

            //_myTitles = @[@"详情", @"评价"];
        }
    }
    return _myTitles;
}

- (void)prepareSetup {
    [self initMySettingView];
    self.headViewHeight = 200;
    self.controllerType = WMStickyPageControllerType_videoDetail;
    self.menuItemWidth = [UIScreen mainScreen].bounds.size.width / 3.0;
    self.menuViewHeight = self.model.series_courses.count? 40 : 0.0;//标题栏高度
//    self.progressColor = [UIColor redColor];
//    self.progressWidth = 30;
//    self.progressHeight = 4;
//    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    self.maximumHeaderViewHeight = self.headViewHeight;
    self.minimumHeaderViewHeight = STATUS_BAR_EH;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    if (self.myTitles.count > 1) {
        self.selectIndex = _model.live.isEnroll ? 1 : 0;
        HKLiveCourseVC * vc = (HKLiveCourseVC *)self.parentViewController;
        if (self.selectIndex == 1) {
            vc.recentlyView.hidden = vc.showRecentlyView ? NO : YES;
            if (vc.recentlyView.hidden == NO) {
                vc.recentlyView.y =  CGRectGetMinY(vc.bottomView.frame) - 44;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        vc.recentlyView.y =  CGRectGetMaxY(vc.bottomView.frame);
                    } completion:^(BOOL finished) {
                        vc.recentlyView.hidden = YES;
                    }];
                });
            }
        }else{
            vc.recentlyView.hidden = YES;
        }
    }
}

- (void)menuTabProgressUI {
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
}


//-(void)setSelectIndex:(int)selectIndex{
//    [super setSelectIndex:selectIndex];
//    HKLiveCourseVC * vc = (HKLiveCourseVC *)self.parentViewController;
//    if (selectIndex == self.myTitles.count-1) {
//        vc.bottomView.hidden = YES;
//        vc.commentView.hidden = NO;
//    }else{
//        vc.bottomView.hidden = NO;
//        vc.commentView.hidden = YES;
//    }
//}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    if (!self.model) {
        return 0;
    }
    return self.myViewcontrollers.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == self.myViewcontrollers.count-1) {
        if ([self.model.course.price floatValue]>0) {
            [MobClick event:eclass_free_comment];
        }else{
            [MobClick event:liveclass_cost_comment];
        }
    }
    NSString * name = self.myTitles[index];
    if ([name containsString:@"目录"]) {
        if ([self.model.course.price floatValue]>0) {
            [MobClick event:liveclass_list];
        }else{
            [MobClick event:liveclass_free_list];
        }
    }
    return self.myViewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        if ([self.model.course.price floatValue]>0) {
            [MobClick event:liveclass_free_view];
        }else{
            [MobClick event:liveclass_view];
        }
    }
    
    pageController.menuView.isSelectedBold = pageController.isSelectedBold;
    if (pageController.selectIndex == index) {
        pageController.menuView.selItem.isSelectedBold = pageController.isSelectedBold;
        [pageController.menuView.selItem setFont:HK_FONT_SYSTEM_WEIGHT(pageController.titleSizeSelected, UIFontWeightMedium)];
    }
    NSString * name = self.myTitles[index];
    
    HKLiveCourseVC * vc = (HKLiveCourseVC *)self.parentViewController;
    if ([name containsString:@"评价"]) {
        vc.bottomView.hidden = YES;
        vc.commentView.hidden = NO;
        vc.recentlyView.hidden = YES;
    }else if ([name containsString:@"目录"]){
        vc.bottomView.hidden = NO;
        vc.commentView.hidden = YES;
        vc.recentlyView.hidden = vc.showRecentlyView ? NO : YES;
        if (vc.recentlyView.hidden == NO) {
            vc.recentlyView.y =  CGRectGetMinY(vc.bottomView.frame) - 44;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    vc.recentlyView.y =  CGRectGetMaxY(vc.bottomView.frame);
                } completion:^(BOOL finished) {
                    vc.recentlyView.hidden = YES;
                }];
            });
        }
    }else{
        vc.bottomView.hidden = NO;
        vc.commentView.hidden = YES;
        vc.recentlyView.hidden = YES;
    }
    return self.myTitles[index];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];

    if (scrollView.contentOffset.y < _heigthTop && scrollView.contentOffset.y > 0.0) {
        // 开始播放
        if (self.playState == ZFPlayerPlayStatePaused && self.isPauseByUs) {
            self.isPauseByUs = NO;
            [self.topPlayerView.controlView hk_pauseOrStart];
        }
    }else if (scrollView.contentOffset.y >= _heigthTop){
        // 暂停播放
        if (self.playState == ZFPlayerPlayStatePlaying) {
            self.isPauseByUs = YES;
            [self.topPlayerView.controlView hk_pauseOrStart];
        }
    }
}

// 进入直播间或者回放  主动触发
- (void)gotoLivingVCOrPlayBack {
    
    if (self.isLocalVideo) return;
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    
    if (self.model.live.free_learn) {
        if (self.model.live.live_status == HKLiveStatusLiving) {
            HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
            vc.live_id = self.model.live.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            // 已经报名直接播放
            [self playLookbackServer];
        }
        return;
    }
    
    // 正在直播并且需要付费，并且没有报名
    if (self.model.live.live_status == HKLiveStatusLiving && !self.model.live.isEnroll && self.model.live.price.doubleValue > 0) {
        showTipDialog(@"请至网站付费报名哦~");
        return;
    }
    
    if (self.model.live.live_status != HKLiveStatusEnd) {
        
        // 报名了直接进入
        if (self.model.isEnroll) {
            HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
            vc.live_id = self.model.live.ID;
            [self.navigationController pushViewController:vc animated:YES];
            //[self pushToOtherController:vc];
        } else {
            [self userEnroll:YES];
        }
    } else if (self.model.live.video_id.intValue != 0 && self.model.live.live_status == HKLiveStatusEnd) {
        
        // 回放
        
        if (!self.model.isEnroll) {
            
            // 收费的
            if (self.model.course.price.doubleValue > 0) {
                showTipDialog(@"请至网站付费报名哦~");
            } else {
                
                // 免费的直接报名 并且
                [self userEnrollToServer:NO complete:^{
                    [weakSelf playLookbackServer];
                }];
            }
            
        } else {
            // 已经报名直接播放
            [self playLookbackServer];
        }
        
        NSLog(@"点击回放按钮");
    }
    
}

- (void)playLookbackServer {
    
    NSDictionary *param = @{@"live_course_id" : self.model.course.ID, @"id" : self.model.live.ID};
    [HKHttpTool POST:@"live/play-back" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            self.permissionModel = [HKPermissionVideoModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (self.permissionModel.videoId.length) {
                self.permissionModel.video_type = @"999";
            }
            //url = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"url"]];
        } else {
                        
        }
        
        
        if ([self.topPlayerView.controlView isDownloadFinsh:self.permissionModel]) {
            [self checkNetworkAndPlayBack:self.permissionModel];
        }else{
            // 回放
            if ([HkNetworkManageCenter shareInstance].networkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
                [LEEAlert alert].config
                .LeeAddTitle(^(UILabel *label) {
                    label.text = @"提示";
                    label.textColor = [UIColor blackColor];
                    label.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
                })
                .LeeAddContent(^(UILabel *label) {
                    label.text = @"当前没有Wifi，回放会消耗流量哦~";
                    label.textColor = [UIColor blackColor];
                    label.font = [UIFont systemFontOfSize:15.0];
                })
                .LeeAddAction(^(LEEAction *action) {
                    
                    action.type = LEEActionTypeCancel;
                    action.title = @"取消";
                    action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
                    action.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
                    action.backgroundColor = [UIColor whiteColor];
                    action.clickBlock = ^{
                        //[self.navigationController popViewControllerAnimated:YES];
                    };
                })
                .LeeAddAction(^(LEEAction *action) {
                    
                    action.type = LEEActionTypeDefault;
                    action.title = @"继续观看";
                    action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
                    action.backgroundColor = [UIColor whiteColor];
                    action.font = [UIFont systemFontOfSize:15.0];
                    action.clickBlock = ^{
                        [self checkNetworkAndPlayBack:self.permissionModel];
                    };
                })
                .LeeHeaderColor([UIColor whiteColor])
                .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
                .LeeShow();
            } else {
                [self checkNetworkAndPlayBack:self.permissionModel];
            }
        }
                
        
    } failure:^(NSError *error) {
        
        [self checkNetworkAndPlayBack:nil];
    }];
}


-(HKPermissionVideoModel *)permissionModel{
    if (_permissionModel == nil) {
        _permissionModel = [HKPermissionVideoModel new];
        _permissionModel.video_type = @"999";
    }
    return _permissionModel;
}

- (void)checkNetworkAndPlayBack:(HKPermissionVideoModel *)permissionModel {
    [self.topPlayerView.controlView showTitle:self.model.course.name coverURLString:nil fullScreenMode:IS_IPAD ? ZFHKNormalFullScreenModePortrait : ZFHKNormalFullScreenModeLandscape];
    if (self.isLocalVideo) {
        self.permissionModel.videoId = self.live_id;
//        self.permissionModel.isFromDownload = YES;
    }
    self.topPlayerView.permissionModel = self.permissionModel;
    [self.topPlayerView.playInfoView removeFromSuperview];
    //暂停虎课读书
    [HKBookPlayer pauseAndHiddenWindowBooKView:YES];
}

// 报名观看直播  点击立即开通主动触发
- (void)userEnroll:(BOOL)isEnterLivingVC {
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    
    // 收费引导去PC购买
    if (self.model.course.price.doubleValue > 0 && !self.model.isEnroll) {
        //showTipDialog(@"请至网站付费报名哦~");
        // 跳转浏览器
        HKMapModel *mapModel = self.model.redirect_package;
        if (mapModel.list.count > 0) {
            [HKH5PushToNative runtimePush:mapModel.class_name arr:mapModel.list currectVC:self];
        }
        
    } else if (self.model.course.price.doubleValue > 0 && self.model.isEnroll) {
        showTipDialog(@"报名成功后不可取消哦~");
    } else {
        [self userEnrollToServer:isEnterLivingVC complete:nil];
    }
}

- (void)userEnrollToServer:(BOOL)isEnterLivingVC complete:(void(^)())completeBlock {
    
    if (!self.model.content.live_course_id) return;
    
    NSString *enRollString = self.model.isEnroll? @"0" : @"1";
    
    [HKHttpTool POST:@"live/enroll-or-un-enroll" parameters:@{@"op_type" : enRollString, @"live_course_id" : self.model.content.live_course_id,@"live_catalog_small_id":self.course_id} success:^(id responseObject) {
        
        if (HKReponseOK) {
            
            if (enRollString.intValue == 1) {
                
                
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.model.live.start_live_at.integerValue];
                NSDate* nowDate = [NSDate date];
                NSTimeInterval time = [startDate timeIntervalSinceDate:nowDate];
                NSInteger timeTemp = time;
                if (timeTemp > 0 && (timeTemp / 60.0 / 60.0) > 1.0 && ![CommonFunction isOpenNotificationSetting]) {
                    // 针对免费直播，若当前距离直播开播时间大于1h
                    HKShowEntrollSuccessVC *showSuccess = [[HKShowEntrollSuccessVC alloc] init];
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) { showSuccess.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    } else {
                        self.modalPresentationStyle = UIModalPresentationCurrentContext;
                    }
                    [self presentViewController: showSuccess animated:YES completion:nil];
                } else {
                    showTipDialog(@"报名成功");
                }
                
                if (!isEnterLivingVC) {
                    // 不做操作
                    // 注意：针对免费直播，若当前直播距离开播时间不足1h或者正在直播时，报名成功后自动跳转至直播间页面1
                    
                } else if (self.model.live.live_status == HKLiveStatusLiving || self.model.live.coutDownForLive > 0 || isEnterLivingVC) {
                    HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                    vc.live_id = self.model.live.ID;
                    [self.navigationController pushViewController:vc animated:YES];
                    //[self.navigationController pushToOtherController:vc];
                }
                
            } else {
                showTipDialog(@"取消报名");
            }
            
            // 更新数据
            self.model.isEnroll = enRollString.intValue == 1;
            
            if (self.refreshBottomBlock) {
                self.refreshBottomBlock(self.model);
            }            
            // 更新报名
            self.model.live.isEnroll = self.model.isEnroll;
                        
            !completeBlock? : completeBlock();
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

// 进入直播间 主动触发
- (void)enterLivingVC {
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }
    
    // 是否已经报名 222
    if (self.model.isEnroll) {
        
        HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
        vc.live_id = self.model.live.ID;
        [self.navigationController pushViewController:vc animated:YES];
        //[self pushToOtherController:vc];
        
    } else if (self.model.live.price.doubleValue > 0) {
        showTipDialog(@"请至网站付费报名哦~");
    } else {
        [self userEnrollToServer:YES  complete:nil];
    }
}

#pragma mark <友盟分享>
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
    popView.delegate = self;
    [popView createUIWithModel:model];
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

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)dealloc {
    [self.topPlayerView removeFromSuperview];
    self.topPlayerView.player = nil;
    self.topPlayerView = nil;
    NSLog(@"控制器销毁 =HKBaseLiveCourseVC");
    HK_NOTIFICATION_REMOVE();
}

@end
