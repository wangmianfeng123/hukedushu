//
//  HKLiveCourseVC.m
//  Code
//
//  Created by hanchuangkeji on 2018/10/17.1
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCourseVC.h"
#import "HKLiveCoursePlayer.h"
#import "HKLiveCourseTeacherInfoCell.h"
//#import "HKLiveCourseInfoDesCell.h"
#import "HKLiveCourseBottomView.h"
#import "HKLiveDetailModel.h"
#import "UMpopView.h"
#import "HKLivingPlayVC2.h"
#import "HKTeacherCourseVC.h"
#import "Reachability.h"
#import "VideoPlayVC.h"
#import "HKShowEntrollSuccessVC.h"
#import "HKBaseLiveCourseVC.h"
#import "HKAirPlayGuideVC.h"
#import "HKH5PushToNative.h"
#import "HKVersionModel.h"
#import "HKSaveQrCodeView.h"
#import "commentBottomView.h"
#import "HKLiveEvaluationVC.h"

#define  liveInfoIndex 0
#define  teacherInfoIndex 1
#define  courseInfoIndex 2


@interface HKLiveCourseVC ()<commentBottomViewDelegate>

@property (nonatomic, strong)HKBaseLiveCourseVC *baseLiveCourseVC;

@property (nonatomic, strong)HKLiveDetailModel *model;

// 顶部播放器
//@property (nonatomic, weak)HKLiveCoursePlayer *topPlayerView;


//@property (nonatomic, assign)ZFPlayerPlaybackState playState; // 播放状态

@property (nonatomic, assign)CGFloat heigthTop;

//@property (nonatomic, assign)BOOL isPauseByUs; // 进入别的页面暂停开始直播

@property (nonatomic, assign)NSInteger internetStatus;
@property (nonatomic, copy)NSString * recentlyCourse_id;
@property (nonatomic , strong)UILabel * txtLabel;

@end

@implementation HKLiveCourseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self initMySettingView];
    [self loadNewData];
    
    
    self.zf_prefersNavigationBarHidden = YES;
    [MyNotification addObserver:self selector:@selector(loadNewData) name:HKLoginSuccessNotification object:nil];
    
    
    int vcCount = 0;
    NSArray * vcArray = [self.navigationController viewControllers];
    for (UIViewController *tempVC in vcArray) {
        if ([tempVC isKindOfClass:[HKLiveCourseVC class]]) {
            vcCount++;
        }
    }

    if (vcCount > 1) {
        NSArray * vcArray = [self.navigationController viewControllers];
        for (UIViewController *tempVC in vcArray) {
            if ([tempVC isKindOfClass:[HKLiveCourseVC class]]) {
                [tempVC removeFromParentViewController];
                return;
            }
        }
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


#pragma mark ---- 屏幕切换
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.baseLiveCourseVC.topPlayerView.player.isStatusBarHidden;
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

    if (self.baseLiveCourseVC.topPlayerView.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)prefersHomeIndicatorAutoHidden {
    // 自动隐藏 X系列手机横线
    return YES;
}

- (void)removeBaseVideoVC {
    [_baseLiveCourseVC didMoveToParentViewController:nil];
    [_baseLiveCourseVC.view removeFromSuperview];
    [_baseLiveCourseVC removeFromParentViewController];
    _baseLiveCourseVC = nil;
}

- (void)addBaseCourseVC:(BOOL)requestSuccess{
    if (self.baseLiveCourseVC) {
        [self removeBaseVideoVC];
    }
    
    CGFloat y = self.heigthTop;
    CGFloat height = UIScreenHeight - self.heigthTop;
    
    height = UIScreenHeight;
    WeakSelf;
    HKBaseLiveCourseVC *VC =  [[HKBaseLiveCourseVC alloc] init];
    VC.isLocalVideo = self.isLocalVideo;
    VC.live_id = self.live_id ;
    VC.model = self.model;
    self.baseLiveCourseVC = VC;
    VC.didselectCourse = ^(HKLiveDetailModel * _Nonnull model) {
        HKLiveCourseVC *vc = [[HKLiveCourseVC alloc] init];
        vc.course_id = model.ID;
        [weakSelf pushToOtherController:vc];
    };
    VC.didSelectedRecBlock = ^(VideoModel * _Nonnull model) {
        [weakSelf enterVideoVC:model];
    };
    VC.refreshBlock = ^{
        [weakSelf loadNewData];
    };
    VC.refreshBottomBlock = ^(HKLiveDetailModel * _Nonnull model) {
        weakSelf.bottomView.model = model;
    };
    [self addChildViewController:VC];
    [self.view addSubview:VC.view];
    [self.view sendSubviewToBack:VC.view];
    VC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, UIScreenHeight);
    [VC didMoveToParentViewController:self];
}

- (void)enterVideoVC:(VideoModel *)model {
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                videoName:model.video_titel
                                         placeholderImage:model.img_cover_url
                                               lookStatus:LookStatusInternetVideo videoId:model.video_id.length? model.video_id : model.ID model:model];
    [self pushToOtherController:VC];
}

- (void)initMySettingView {
    
    [self.view addSubview:self.commentView];
    // 底部立即开通
    WeakSelf
    HKLiveCourseBottomView *bottomView = [HKLiveCourseBottomView viewFromXib];
    self.bottomView = bottomView;
    bottomView.buyNowBtnBlock = ^{
        if ([weakSelf.model.course.price floatValue]>0) {
            [MobClick event:liveclass_enroll_button];
        }else{
            [MobClick event:liveclass_free_enroll_button];
        }
        [MobClick event:UM_RECORD_LIVE_INTRODUCTION_APPLY];
        [weakSelf userEnroll:NO];
    };
    bottomView.contectTeacherBlock = ^{
        [MobClick event:livestudio_assistant];

        HKVersionModel *model = [HKVersionModel new];
        model.url = weakSelf.model.course.teacher_qr;
        [HKSaveQrCodeView showDownAppViewWithModel:model nextBlock:^{
            [HKImagePickerController hk_savedPhotosAlbum:model.url];
        }];
    };
    [self.view addSubview:bottomView];
    CGFloat bottomHeight = 84;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomHeight);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    
    self.recentlyView= [[UIView alloc] init];
    self.recentlyView.hidden = YES;
    self.recentlyView.backgroundColor = [UIColor colorWithHexString:@"#EEF5FF"];
    [self.view addSubview:self.recentlyView];
    [self.recentlyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(@44);
    }];
    [self.view bringSubviewToFront:self.bottomView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.recentlyView addGestureRecognizer:tap];
    
    self.txtLabel = [UILabel labelWithTitle:CGRectZero title:@"" titleColor:COLOR_27323F titleFont:@"14" titleAligment:NSTextAlignmentLeft];
    [self.recentlyView addSubview:self.txtLabel];
    [self.txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.recentlyView);
        make.left.equalTo(self.recentlyView).offset(20);
        make.right.equalTo(self.recentlyView).offset(-40);
    }];
    
    UIImageView * iconImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_go_contents_2_39"]];
    [self.recentlyView addSubview:iconImgV];
    [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.equalTo(self.recentlyView).offset(-15);
        make.centerY.equalTo(self.recentlyView);
    }];
}

- (void)tapClick{
//    HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
//    VC.course_id = model.ID;
//    [self pushToOtherController:VC];
    NSLog(@"点击了最近播放");
    HKLiveCourseVC *vc = [[HKLiveCourseVC alloc] init];
    vc.course_id = self.recentlyCourse_id;
    [self pushToOtherController:vc];
}


- (commentBottomView*)commentView {
    //播放后显示  并进入评论视图 显示评论框
    if (!_commentView) {
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT- (IS_IPHONE_X ?70 :50), SCREEN_WIDTH, (IS_IPHONE_X ?70 :50));
        _commentView = [[commentBottomView alloc]initWithFrame:rect];
        _commentView.titleLabel.text = @"说点什么吧~";
        _commentView.delegate = self;
        _commentView.hidden = YES;
    }
    return _commentView;
}

#pragma mark - commentBottomView 代理
- (void)commentBottomView:(commentBottomView*)view  comment:(id)comment {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    if ([self.model.course.price floatValue]>0) {
        [MobClick event:liveclass_comment_publish];
    }else{
        [MobClick event:liveclass_free_comment_publish];
    }
    
    
    WeakSelf;
    [self checkBindPhone:^{
        StrongSelf;
        [strongSelf setEvaluationVC];
    } bindPhone:^{
        
    }];
        
}

- (void)setEvaluationVC {
    
    if (self.model.live.isEnroll) {
        HKLiveEvaluationVC *VC = [[HKLiveEvaluationVC alloc]initWithNibName:nil bundle:nil videoId:self.model.content.live_course_id];
        [self pushToOtherController:VC];
    }else{
        showTipDialog(@"报名后才能参与课程评价哦");
    }
    
}

- (void)pushToTeacherCourseVC:(NSString *)teacherId {
    
    if (isEmpty(teacherId)) {
        NSLog(@"教师id为空!");
        return;
    }
    HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
    vc.teacher_id = teacherId;
    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
        
    };
    [self pushToOtherController:vc];
}

#pragma mark <友盟分享>
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
//    popView.delegate = self;
    [popView createUIWithModel:model];
}

#pragma mark <Server>
- (void)loadNewData {
    NSDictionary *dic = @{@"id" : self.course_id.length? self.course_id : @"47"};
    WeakSelf
    [HKHttpTool POST:LIVE_DETAIL parameters:dic success:^(id responseObject) {
        
        if (HKReponseOK) {
            HKLiveDetailModel *model = [HKLiveDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            // 寻找当前播放目录
            for (HKLiveCategoryModel *detailModel in model.series_courses) {
                for (HKLiveDetailModel *modelTemp in detailModel.child) {
                    if ([modelTemp.ID isEqualToString:model.live.ID]) {
                        modelTemp.isCurrent = YES;
                        weakSelf.showRecentlyView = [modelTemp.recently_play intValue] ? NO : YES;
                        break;
                    }
                }
            }
            
            for (HKLiveCategoryModel *detailModel in model.series_courses) {
                for (HKLiveDetailModel *modelTemp in detailModel.child) {
                    if ([modelTemp.recently_play intValue]) {
                        weakSelf.recentlyCourse_id = modelTemp.ID;
                        weakSelf.txtLabel.text = [NSString stringWithFormat:@"最近学习小节《%@》",modelTemp.title];
                        break;
                    }
                }
            }
            
            //最近播放小节id存在并且不等于当前播放的小节显示  否则 不显示
            if (weakSelf.recentlyCourse_id.length && ![weakSelf.recentlyCourse_id isEqualToString:model.live.ID] ) {
                weakSelf.showRecentlyView = YES;
            }else{
                weakSelf.showRecentlyView = NO;
            }
            
            
            model.live.isEnroll = model.isEnroll;
            model.live.price = model.course.price;
            weakSelf.model = model;
            weakSelf.bottomView.model = model;
            // 添加baseVC
            [weakSelf addBaseCourseVC:YES];
        }
    } failure:^(NSError *error) {
        // 添加baseVC
        [weakSelf addBaseCourseVC:NO];
    }];
}







// 报名观看直播  点击立即开通主动触发
- (void)userEnroll:(BOOL)isEnterLivingVC {
    if (!isLogin()) {
        [self setLoginVC];
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
    WeakSelf
    [HKHttpTool POST:@"live/enroll-or-un-enroll" parameters:@{@"op_type" : enRollString, @"live_course_id" : self.model.content.live_course_id,@"live_catalog_small_id":self.course_id} success:^(id responseObject) {

        if (HKReponseOK) {

            if (enRollString.intValue == 1) {


                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:weakSelf.model.live.start_live_at.integerValue];
                NSDate* nowDate = [NSDate date];
                NSTimeInterval time = [startDate timeIntervalSinceDate:nowDate];
                NSInteger timeTemp = time;
                if (timeTemp > 0 && (timeTemp / 60.0 / 60.0) > 1.0 && ![CommonFunction isOpenNotificationSetting]) {
                    // 针对免费直播，若当前距离直播开播时间大于1h
                    HKShowEntrollSuccessVC *showSuccess = [[HKShowEntrollSuccessVC alloc] init];
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) { showSuccess.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    } else {
                        weakSelf.modalPresentationStyle = UIModalPresentationCurrentContext;
                    }
                    [weakSelf presentViewController: showSuccess animated:YES completion:nil];
                } else {
                    showTipDialog(@"报名成功");
                }

                if (!isEnterLivingVC) {
                    // 不做操作
                    // 注意：针对免费直播，若当前直播距离开播时间不足1h或者正在直播时，报名成功后自动跳转至直播间页面1

                } else if (weakSelf.model.live.live_status == HKLiveStatusLiving || weakSelf.model.live.coutDownForLive > 0 || isEnterLivingVC) {
                    HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
                    vc.live_id = weakSelf.model.live.ID;
                    [weakSelf pushToOtherController:vc];
                }

            } else {
                showTipDialog(@"取消报名");
            }

            // 更新数据
            weakSelf.model.isEnroll = enRollString.intValue == 1;
            weakSelf.bottomView.model = weakSelf.model;

            // 更新报名
            weakSelf.model.live.isEnroll = weakSelf.model.isEnroll;
            !weakSelf.refreshBlock? : weakSelf.refreshBlock(weakSelf.model.live);

            !completeBlock? : completeBlock();
        }


    } failure:^(NSError *error) {

    }];

}

#pragma mark <网络切换变换监听>
//- (void)networkObserver {
//
//    [MyNotification addObserver:self
//                       selector:@selector(networkNotification:)
//                           name:KNetworkStatusNotification
//                         object:nil];
//
//}
//
//- (void)networkNotification:(NSNotification *)noti {
//
//    NSDictionary *dict = noti.userInfo;
//    NSInteger  status  = [dict[@"status"] integerValue];
//    self.internetStatus = status;
//
//
//    // 如果正在播放4g
//    if (self.playState == ZFPlayerPlayStatePaused && status == AFNetworkReachabilityStatusReachableViaWWAN) {
//        showTipDialog(@"当前没有Wifi，回放会消耗流量哦~");
//    }
//}




- (NSInteger)networkStatus {
    
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if ([conn currentReachabilityStatus] == NotReachable) {
        //无网
        NSLog(@"NotReachable");
        return NotReachable;
    } else if([conn currentReachabilityStatus] == ReachableViaWiFi) {
        //WiFi
        NSLog(@"WiFi");
        return ReachableViaWiFi;
    } else {
        //4G
        NSLog(@"4G");
        return ReachableViaWWAN;
    }
}


-(void)dealloc {
    NSLog(@"控制器销毁 =HKLiveCourseVC");
    HK_NOTIFICATION_REMOVE();
}

@end
