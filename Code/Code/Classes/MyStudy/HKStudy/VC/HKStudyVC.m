//
//  HKStudyVC.m
//  Code
//
//  Created by Ivan li on 2018/1/29.1
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKStudyVC.h"
#import "HKShowDownloadCourseVC.h"
#import "OtherSetUpCell2.h"
#import "HKMyLearningCenterModel.h"
#import "HKLearnCenterHeader.h"
#import "HkStudyCell.h"
#import "HKStudyDownloadCell.h"
#import "VideoPlayVC.h"
#import "MyDownloadVC.h"
#import "HKJobPathCourseVC.h"
#import "LearnedVC.h"
#import "HKStudyLineChartVC.h"
#import "HKMyFollowVC.h"
#import "HKMyCollectionVC.h"
#import "HKCollectionAlbumVC.h"
#import "HKLearnCenterLoginView.h"
#import "HKAllLearnedVC.h"
#import "MyDownloadVC.h"
#import "HKStudyCertificateVC.h"
#import "HKStudyTagVC.h"
#import "HKStudyTagSelectGuideView.h"
#import "UIView+SNFoundation.h"
//#import "HKLiveListVC.h"
#import "HKH5PushToNative.h"
#import "HtmlShowVC.h"
#import "HKMyInfoNotLoginCell.h"
#import "BannerModel.h"
#import "HKStudyLearnedMiddleCell.h"
#import "HKStudyHeaderCellModel.h"
#import "HKStudyHeaderCell.h"
#import "HKMyLikeShortVideoVC.h"
#import "HKALIYunLogManage.h"
#import "HKStudyInterestCell.h"
#import "HKDownloadManager.h"
#import "MyLoadingVC.h"
#import "HKStudyLoginView.h"
#import <UMShare/UMShare.h>
#import "HKWechatLoginShareCallback.h"
#import "HKPhoneLoginViewModel.h"
#import "HKVerificationPhoneVC.h"
#import "BindPhoneVC.h"
#import "HKPhoneLoginVC.h"
#import "HKAttentionTeacherCell.h"
#import "HKUpDateCourseCell.h"
#import "HKFollowTeacherModel.h"
#import "HKLiveCourseVC.h"
#import "HKTeacherCourseVC.h"
#import <OneLoginSDK/OneLoginSDK.h>
#import "LoginVC.h"

#import "HKNavigationController.h"

#define downloadDetailIndex 2


@interface HKStudyVC ()<UITableViewDelegate,UITableViewDataSource,HKLearnCenterHeaderDelegate, HKMyInfoNotLoginCellDelegate, HKDownloadManagerDelegate,WXApiDelegate>

@property(nonatomic, strong)UITableView    *tableView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)NSMutableArray *followTeacherArray;
@property(nonatomic, strong)NSMutableArray *followVideoArray;

@property(nonatomic, strong)NSMutableArray *textArray;

@property(nonatomic, strong)NSMutableArray <UIImage*>*iconArray;

@property(nonatomic, weak)HKLearnCenterHeader *headerView;

@property(nonatomic, strong)HKMyLearningCenterModel *model;
/** 学习兴趣引导 */
@property(nonatomic, strong)HKStudyTagSelectGuideView *guideView;

@property(nonatomic,assign)CGRect rect;

/** 下载的数据 */
@property (nonatomic, strong)NSMutableArray *historyArray; // 已经下载
@property (nonatomic, strong)NSMutableArray *notFinishArray; // 正在下载
@property (nonatomic, strong)NSMutableArray *directoryArray; // 目录

@end

@implementation HKStudyVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self setupHeaderView];
    [self setupNotification];
    
    self.zf_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 监听下载数据的变化
    [self initDownloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    // 推广渠道
    [HkChannelData requestHkChannelData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.tableView) {
        // 刷新 奖励标签
        [self loadNewData:YES];
    }
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)setupNotification {
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, setupHeaderView);
    HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, setupHeaderView);
}

#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        [weakSelf loadNewData:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
}



#pragma mark   (isReloadSection 刷新 第一个 Section)
- (void)loadNewData:(BOOL)isReloadSection {
    
    // 没有登录直接返回
    if (![HKAccountTool shareAccount]) {
        [self.tableView.mj_header endRefreshing];
        return;
    };
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //interest_str：在学习兴趣上显示的文案；study_total：视频学习总数，diploma_total：学习成就数量
        [HKHttpTool POST:USER_MY_STUDY baseUrl:BaseUrl parameters:nil success:^(id responseObject) {
            if (HKReponseOK) {
                HKMyLearningCenterModel *model = [HKMyLearningCenterModel mj_objectWithKeyValues:responseObject[@"data"]];

                // 更多的已学按钮
                if (model.hasMore && model.recentStudiedList.count) {
                    VideoModel *hasMoreModel = [[VideoModel alloc] init];
                    hasMoreModel.isMoreModel = YES;
                    hasMoreModel.cover = @"check_more_cell_image";
                    [model.recentStudiedList addObject:hasMoreModel];
                }

                //移除学习成就数量  数量为0时 自动隐藏
                model.diploma_total = @"0";

                self.headerView.model = model;
                self.model = model;
            }
            dispatch_group_leave(group);
        } failure:^(NSError *error) {
            dispatch_group_leave(group);
        }];
//    });
    
    
    dispatch_group_enter(group);
//    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HKHttpTool POST:USER_Follow_teacherData parameters:nil success:^(id responseObject) {
            if (HKReponseOK) {
                self.followTeacherArray = [HKFollowTeacherModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"teacher"]];
                self.followVideoArray = [HKFollowVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"video"]];
            }
            dispatch_group_leave(group);
        } failure:^(NSError *error) {
            dispatch_group_leave(group);
        }];
//    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    });
}


- (void)createUI {
    [self.view addSubview:self.tableView];
    if (NO == isLogin()) {
        [self setStudyLogin];
    }
}

- (void)setStudyLogin {
    
    if ([OneLogin isPreGettedTokenValidate]) {
        LoginVC *loginVC = [LoginVC new];
        loginVC.loginViewThemeType = HKLoginViewThemeType_study;
        HKNavigationController *navigationController = [[HKNavigationController alloc]initWithRootViewController:loginVC];
        navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:navigationController animated:NO completion:nil];
        [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
    } else {
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            UIViewController *topVC = [CommonFunction topViewController];
            if ([topVC isKindOfClass:[HKStudyVC class]]) {
                if (NO == isLogin()) {
                    LoginVC *loginVC = [LoginVC new];
                    loginVC.sender = sender;
                    //loginVC.isFromStudy = YES;
                    loginVC.loginViewThemeType = HKLoginViewThemeType_study;
                    HKNavigationController *navigationController = [[HKNavigationController alloc]initWithRootViewController:loginVC];
                    navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [self presentViewController:navigationController animated:NO completion:nil];
                    [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
                }
                
            }
        }];
    }
    
    
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        //_tableView.rowHeight = IS_IPHONE6PLUS ?PADDING_30*2 :PADDING_25*2;
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HkStudyCell class] forCellReuseIdentifier:NSStringFromClass([HkStudyCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKStudyDownloadCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HKStudyDownloadCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKStudyInterestCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HKStudyInterestCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKStudyLearnedMiddleCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HKStudyLearnedMiddleCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyInfoNotLoginCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HKMyInfoNotLoginCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKStudyHeaderCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HKStudyHeaderCell class])];
        
        [_tableView registerClass:[HKStudyLoginView class] forCellReuseIdentifier:NSStringFromClass([HKStudyLoginView class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKAttentionTeacherCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKAttentionTeacherCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKUpDateCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKUpDateCourseCell class])];
        
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        
        if (IS_IPHONE_X) {
            [_tableView setContentInset:UIEdgeInsetsMake(15, 0, KTabBarHeight49 + 20, 0)];
        } else {
            [_tableView setContentInset:UIEdgeInsetsMake(5, 0, KTabBarHeight49 + 20, 0)];
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_3C4651];
    }
    return _tableView;
}

- (void)setupHeaderView {
    
    
//     设置头部
    if ([HKAccountTool shareAccount]) {
        // 登录
//        CGFloat height = IS_IPHONE_X? 253.0 + 16.0 + 20.0 : 253.0 + 16.0;
//        HKLearnCenterHeader *headerView = [[HKLearnCenterHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
//        headerView.learnCenterHeaderDelegate = self;
//        self.headerView = headerView;
//        self.tableView.tableHeaderView = headerView;
        self.tableView.mj_header.hidden = NO;
        [self refreshUI];
    } else {
        // 未登录
        self.tableView.mj_header.hidden = YES;
//        HKLearnCenterLoginView *headerView = [HKLearnCenterLoginView viewFromXib];
//        headerView.height = 254 + 25 + 11;
//        WeakSelf;
//        headerView.logBtnClickBlock = ^{
//            [weakSelf setStudyLoginVC];
//        };
//        self.tableView.tableHeaderView = headerView;
        //将未领取奖励置空
        self.model = nil;
    }

    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    
    // 下载数据
    [self initDownloadData];
//    学习兴趣引导
//    [self setStudyTagGuideView];
}



/** HKLearnCenterHeader  delegate  */
- (void)hkLearnCenterAchieveClick:(id)sender {
    
//    [MobClick event:UM_RECORD_STUDY_ACHIEVEMENT];
    if (isLogin()) {
        [self pushToOtherController:[HKStudyCertificateVC new]];
    }else{
        [self setStudyLoginVC];
    }
}



- (NSMutableArray<UIImage*>*)iconArray {
    //UIImage *starImage = [UIImage hkdm_imageWithNameLight:@"myStudy_star" darkImageName:@"myStudy_star_dark"];
    //UIImage *teacherImage = [UIImage hkdm_imageWithNameLight:@"myStudy_teacher" darkImageName:@"myStudy_teacher_dark"];
    if (!_iconArray) {
        UIImage *praiseImage = [UIImage hkdm_imageWithNameLight:@"ic_special_v2_13" darkImageName:@"ic_special_v2_13_dark"];
        
        UIImage *specialImage = [UIImage hkdm_imageWithNameLight:@"myStudy_special" darkImageName:@"myStudy_special_dark"];
        _iconArray = [NSMutableArray arrayWithObjects:praiseImage,specialImage, nil];
    }
    return _iconArray;
}


- (NSMutableArray*)textArray {
    if (!_textArray) {
        _textArray = [NSMutableArray arrayWithObjects:@"我的点赞", @"专辑", nil];//@"我的收藏", @"关注讲师",
    }
    return  _textArray;
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.guideView delayRemoveView];
}

#pragma mark - HKMyInfoNotLoginCellDelegate
- (void)notLoginBtnDidClick:(UIButton *_Nullable)btn {
    [self setStudyLoginVC];
    NSLog(@"%s", __func__);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ![HKAccountTool shareAccount]? 1 : 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        int count = 1;
        if (self.followVideoArray.count) {
            count ++;
        }
        if (self.followTeacherArray.count) {
            count++;
        }
        return count;
    }else if (section == 5){
        return 2;
    }else{
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CGFloat normalCellHeight = IS_IPHONE6PLUS? PADDING_30 * 2.0 : PADDING_25 * 2.0;
//
//    // 没登录
//    if (![HKAccountTool shareAccount]) {
//        return self.view.height;
//    }
//
//    // 正常登录的逻辑
//    if (0 == indexPath.section) {
//
//        // 头部学习数量
//        return 183.0 + 18.0;
//    } else if (1 == indexPath.section) {
//        // 已学教程
//        return self.model.recentStudiedList.count? 122.0 : normalCellHeight;
//    } else if (downloadDetailIndex == indexPath.section) {
//
//        // 正在下载的
//        return (self.directoryArray.count || self.notFinishArray.count)? 136.0 : normalCellHeight;
//
//    } else if (4 == indexPath.section) {
//
//        // 兴趣选择
//        return 35.0;
//    }
//    return normalCellHeight;
    
    
    CGFloat normalCellHeight = IS_IPHONE6PLUS? PADDING_30 * 2.0 : PADDING_25 * 2.0;
    
    // 没登录
    if (![HKAccountTool shareAccount]) {
        return self.view.height;
    }
    
    // 正常登录的逻辑
    if (0 == indexPath.section) {
        
        // 头部学习数量
        return 183.0 + 18.0;
    } else if (1 == indexPath.section) {
        // 已学教程
        return self.model.recentStudiedList.count? 122.0 : normalCellHeight;
    } else if (downloadDetailIndex == indexPath.section) {
        
        // 正在下载的
        return (self.directoryArray.count || self.notFinishArray.count)? 136.0 : normalCellHeight;
        
    } else if (4 == indexPath.section) {
        if (indexPath.row == 0) {
            return normalCellHeight;
        }else{
            if (self.followTeacherArray.count) {
                if (indexPath.row == 1) {
                    return 95;
                }
                return 70;
            }else{
                return 70;
            }
        }
    }else if (6 == indexPath.section) {
        // 兴趣选择
        return 35.0;
    }
    return normalCellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 没有登录
    if (![HKAccountTool shareAccount]) {
//        HKMyInfoNotLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyInfoNotLoginCell class])];
//        cell.delegate = self;
//        return cell;
        tableView.scrollEnabled = NO;
        HKStudyLoginView *cell = [self studyLoginViewWithTableView:tableView];
        return cell;
    }
    
    tableView.scrollEnabled = YES;
    // 已经登录走正常的逻辑
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    UITableViewCell *_cell = nil;
    WeakSelf;
    
    if (0 == section) {
        // 学习数量详情
        HKStudyHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStudyHeaderCell class])];
        cell.medalBtnClickBlock = ^{
            
            [MobClick event:UM_RECORD_STUDY_ACHIEVEMENT];
            
            if (isLogin()) {
                HKMapModel *mapModel = weakSelf.model.achievement_info;
                if (!isEmpty(mapModel.redirect_package.class_name)) {
                    [HKH5PushToNative runtimePush:mapModel.redirect_package.class_name arr:mapModel.redirect_package.list currectVC:weakSelf];
                }
            }else{
                [weakSelf setStudyLoginVC];
            }
        };
        
        cell.todayLBClickBlock = ^{
            // 今日学习点击
            [MobClick event:UM_RECORD_STUDY_TREND];
            HKStudyLineChartVC *studyLineChartVC = [[HKStudyLineChartVC alloc] init];
            studyLineChartVC.model = weakSelf.model;
            [weakSelf pushToOtherController:studyLineChartVC];
        };
        
        cell.model = self.model;
        _cell = cell;
    } else if (1 == section) {
        
        // 已学没有数据
        if (!self.model.recentStudiedList.count) {
            
            HkStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HkStudyCell class])];
            cell.leftLab.text = @"";
            cell.sep.hidden = NO;
            [cell.leftLab setText:@"我的已学"];
            
            UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"myStudy_study") darkImage:imageName(@"myStudy_study_dark")];
            cell.leftImageV.image = image;
            _cell = cell;
        } else {
            // 已学教程 有学习数据
            HKStudyLearnedMiddleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStudyLearnedMiddleCell class])];
            cell.model = self.model;
            cell.videoSelectedBlock = ^(NSIndexPath *indexPath, VideoModel *model) {
                
                if (model.isMoreModel) {
                    
                    // 更多的点击按钮
                    [weakSelf pushToOtherController:[HKAllLearnedVC new]];
                } else if (model.root_type.intValue == 4) {
                    
                    // 职业路径
                    HKJobPathCourseVC *VC = [HKJobPathCourseVC new];
                    VC.courseId = model.root_id;
                    [weakSelf pushToOtherController:VC];
                } else {
                    
                    // 视频的跳转
                    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                                videoName:model.video_titel
                                                         placeholderImage:model.img_cover_url
                                                               lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
                    [weakSelf pushToOtherController:VC];
                }
            };
            cell.moreBtnClickBlock = ^{
                [MobClick event:UM_RECORD_STUDY_PLAYLIST];
                [weakSelf pushToOtherController:[HKAllLearnedVC new]];
            };
            _cell = cell;
        }
        
    } else if (section == 2) {
        
        if (!self.directoryArray.count && !self.notFinishArray.count) {
            // 没有正在下载的数据
            HkStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HkStudyCell class])];
            cell.leftLab.text = @"";
            cell.sep.hidden = NO;
            [cell.leftLab setText:@"我的下载"];
            
            UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"myStudy_download") darkImage:imageName(@"myStudy_download_dark")];
            cell.leftImageV.image = image;
            _cell = cell;
            
        } else {
            // 我的正在下载详细数据
            HKStudyDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStudyDownloadCell class])];
            [cell setHistory:self.historyArray notFinish:self.notFinishArray diretory:self.directoryArray];
            cell.modelSelectedBlock = ^(NSIndexPath *indexPath, HKDownloadModel *model) {
                
                if (model.isDownloadingCountModel) {
                    
                    // 正在下载的
                    MyLoadingVC *loadingVC = [MyLoadingVC new];
                    [weakSelf pushToOtherController:loadingVC];
                } else if (model.isMoreModel) {
                    
                    // 更多的点击
                    MyDownloadVC *downloadVC = [MyDownloadVC new];
                    [weakSelf pushToOtherController:downloadVC];
                } else {
                    [weakSelf pushVideoVCOrDirectory:model];
                }
            };
            _cell = cell;
        }
        
    } else if (section == 3) {
        // 我的下载等其他cell
        HkStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HkStudyCell class])];
        cell.leftLab.text = @"";
        cell.sep.hidden = NO;
        [cell.leftLab setText:@"我的收藏"];
        cell.leftImageV.image = [UIImage hkdm_imageWithNameLight:@"myStudy_star" darkImageName:@"myStudy_star_dark"];
        _cell = cell;
        
    }else if (section == 4){
        if (indexPath.row == 0) {
            // 我的下载等其他cell
            HkStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HkStudyCell class])];
            cell.leftLab.text = @"";
            cell.sep.hidden = YES;
            [cell.leftLab setText:@"我的关注"];
            cell.leftImageV.image = [UIImage hkdm_imageWithNameLight:@"myStudy_teacher" darkImageName:@"myStudy_teacher_dark"];
            _cell = cell;
        }else if (indexPath.row == 1){
            HKAttentionTeacherCell * cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAttentionTeacherCell class])];
            cell.followTeacherArray = self.followTeacherArray;
            WeakSelf
            cell.didCellBlock = ^(HKFollowTeacherModel * _Nonnull model,NSInteger row) {
                if (row > 9) {
                    [self UMEvent: 3];
                    [self pushToOtherController:[HKMyFollowVC new]];
                }else{
                    [MobClick event:study_focus_teacher];
                    if (model.status == 1) {
                        [MobClick event:study_focus_teacher_live];
                    }else if (model.status == 2){
                        [MobClick event:study_focus_teacher_update];
                    }else{
                        [MobClick event:study_focus_teacher_normal];
                    }
                    if (model.status == 1) {
                        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
                        VC.course_id = model.live_catalog_small_id;
                        [weakSelf pushToOtherController:VC];
                    }else{
                        HKTeacherCourseVC *vc = [[HKTeacherCourseVC alloc] init];
                        vc.teacher_id = model.teacher_id;
                        [weakSelf pushToOtherController:vc];
                    }
                }
                
            };
            _cell = cell;
        }else{
            HKUpDateCourseCell * cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKUpDateCourseCell class])];
            cell.followVideoArray = self.followVideoArray;
            WeakSelf
            cell.lookBlock = ^(HKFollowVideoModel * _Nonnull model) {
                [MobClick event:study_focus_class_update];
                VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                       videoName:nil
                placeholderImage:nil
                      lookStatus:LookStatusInternetVideo
                         videoId:model.video_id model:nil];
                [weakSelf pushToOtherController:VC];
            };
            _cell = cell;
        }
    }else if (section == 5){
        // 我的下载等其他cell
        HkStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HkStudyCell class])];
        cell.leftLab.text = @"";
        cell.sep.hidden = indexPath.row + 1 == self.textArray.count;
        [cell.leftLab setText:self.textArray[row]];
        cell.leftImageV.image = self.iconArray[row];
        _cell = cell;
    }
    else {
        // 我的兴趣
        HKStudyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStudyInterestCell class])];
        _cell = cell;
    }
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    
    if (!isLogin()) {
        return;
    }
        
    // 已经登录的正常逻辑
    if (0 == section) {
        
        // 学习数量
        
    } else if (1 == section) {
        // 已学教程,更多的点击按钮
        [self pushToOtherController:[HKAllLearnedVC new]];
        [self UMEvent:0];
    } else if (downloadDetailIndex == section) {
        // 下载详情数据
        [self pushToOtherController:[MyDownloadVC new]];
        [self UMEvent:1];
    }else if (section == 3){
        [self UMEvent: 2];
        [self pushToOtherController:[HKMyCollectionVC new]];
    }else if (section == 4){
        if (indexPath.row == 0) {
            [self UMEvent: 3];
            [self pushToOtherController:[HKMyFollowVC new]];
        }
        
    }else if (section == 5){
        if (indexPath.row == 0) {
            [self UMEvent: 4];
            [self pushToOtherController:[HKMyLikeShortVideoVC new]];
        }else{
            [self UMEvent: 5];
            [self pushToOtherController:[HKCollectionAlbumVC new]];
        }
        
    }else{
        // 学习兴趣
        [MobClick event:UM_RECORD_STUDY_INTEREST];
        [self pushToOtherController:[HKStudyTagVC new]];
    }
}

- (void)pushVideoVCOrDirectory:(HKDownloadModel *)fileInfo {
    
    UIViewController *vc = nil;
    
    // 目录视频
    if (fileInfo.isDirectory) {
        
        HKShowDownloadCourseVC *directVC = [[HKShowDownloadCourseVC alloc] init];
        directVC.directoryModel = fileInfo;
        vc = directVC;
    } else {
        
        // 普通视频
        VideoPlayVC *videoPlayVC = [[VideoPlayVC alloc] initWithNibName:nil bundle:nil fileUrl:fileInfo.url videoName:fileInfo.name placeholderImage:fileInfo.imageUrl
                                                             lookStatus:LookStatusLocalVideo videoId:fileInfo.videoId model:fileInfo];
        videoPlayVC.videoType = fileInfo.videoType;
        videoPlayVC.isFromDownload = YES;
        vc = videoPlayVC;
    }
    [self pushToOtherController:vc];
}

/** 友盟统计事件 */
- (void)UMEvent:(NSInteger)row {

    switch (row) {
        case 0:
            [MobClick event:UM_RECORD_STUDY_PLAYLIST];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            [MobClick event:UM_RECORD_STUDY_FOCUS];
            break;
        case 4:
            [MobClick event:UM_RECORD_STUDY_MYLIKE];
            break;
        case 5:
            [MobClick event:UM_RECORD_STUDY_MYCOLLECTION];
            break;
    }
}


/** 学习兴趣引导*/
- (void)setStudyTagGuideView {
    
    if (self.rect.origin.y>0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (isEmpty([defaults valueForKey:@"StudyTagGuideView"])) {
            TTVIEW_RELEASE_SAFELY(self.guideView);
            [self.view addSubview:self.guideView];
            [defaults setValue:@"2" forKey:@"StudyTagGuideView"];
            [defaults synchronize];
        }
    }
}


- (HKStudyTagSelectGuideView*)guideView {
    
    if (!_guideView) {
        CGRect rect = CGRectMake(30, self.rect.origin.y - (IS_IPHONE6PLUS ?5 :10), 463/2, 125/2);
        _guideView = [[HKStudyTagSelectGuideView alloc]initWithFrame:rect];
    }
    return _guideView;
}



#pragma HKDownloadManagerDelegate
- (void)initDownloadData {
    
    WeakSelf;
    [[HKDownloadManager shareInstance] observerDownload:weakSelf array:^(NSMutableArray *notFinishArray, NSMutableArray *historyArray, NSMutableArray *directoryArray) {
        weakSelf.historyArray = [historyArray mutableCopy];//已经下载
        weakSelf.notFinishArray = [notFinishArray mutableCopy];// 正在下载
        weakSelf.directoryArray = [directoryArray mutableCopy]; // 目录
        [weakSelf.tableView reloadData];
//        if (weakSelf.tableView.numberOfSections > downloadDetailIndex) {
//            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:downloadDetailIndex] withRowAnimation:UITableViewRowAnimationNone];
//        } else {
//            [weakSelf.tableView reloadData];
//        }
    }];
}

- (void)download:(HKDownloadModel *)model notFinishArray:(NSMutableArray<HKDownloadModel *> *)array {
    // model已经自动添加到array
    self.notFinishArray = [array mutableCopy]; // 尚未完成的
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:downloadDetailIndex] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didFailedDownload:(HKDownloadModel *)model {
    [self initDownloadData];
}
- (void)didPausedDownload:(HKDownloadModel *)model {
    [self initDownloadData];
}
- (void)beginDownload:(HKDownloadModel *)model {
    [self initDownloadData];
}

- (void)downloaded:(HKDownloadModel *)model historyArray:(NSMutableArray<HKDownloadModel *> *)array {
    
    // model已经自动添加到array
    self.historyArray = [array mutableCopy]; // 已完成的
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:downloadDetailIndex] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)downloaded:(HKDownloadModel *)model directory:(NSMutableArray<HKDownloadModel *> *)array {
    
    // model已经自动添加到array
    self.directoryArray = [array mutableCopy]; // 已完成的
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:downloadDetailIndex] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark -----登陆

- (HKStudyLoginView*)studyLoginViewWithTableView:(UITableView *)tableView {
    @weakify(self);
    HKStudyLoginView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStudyLoginView class])];
    cell.registerBtnClickBlock = ^(UIButton *btn) {
        @strongify(self);
        [self setStudyLoginVC];
    };
    cell.socialphoneLoginBlock = ^(UIButton *btn, UIButton *selectBtn) {
        @strongify(self);
        if (selectBtn.selected) {
            [self socialphoneLoginAction:btn];
        }else{
            showTipDialog(ONE_LOGIN_MSG);
        }
    };
    cell.privacyBtnClickBlock = ^(UIButton *privacyBtn) {
        @strongify(self);
        [self privacyBtnClick];
    };
    cell.agreementBtnClickBlock = ^(UIButton *agreementBtn) {
        @strongify(self);
        [self agreementBtnClick];
    };
    cell.otherPhoneBtnClickBlock = ^(UIButton *btn) {
        @strongify(self);
        [self pushToViewController:[HKPhoneLoginVC new] animated:YES];
    };
    return cell;
}

- (void)agreementBtnClick {

    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}


- (void)privacyBtnClick {
    
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}


- (void)socialphoneLoginAction:(UIButton*)btn {
    NSInteger tag = btn.tag;
    
    UMSocialPlatformType type = 0;
    if (102 == tag) {
        // QQ
        type = UMSocialPlatformType_QQ;
    }else if(104 == tag) {
        // 微信
        type = UMSocialPlatformType_WechatSession;
    }else if(106 == tag) {
        // 微博
        type = UMSocialPlatformType_Sina;
    }
    [self getUserInfoForPlatform:type currentViewController:self];
}



- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
         currentViewController:(UIViewController*)currentViewController {
    
    @weakify(self);
    //[HKProgressHUD showEnabledHUDStatus:LMBProgressHUDStatusWaitting text:@"登录中..."];
                
        if (platformType == UMSocialPlatformType_WechatSession) {
            // 微信登录 微信原生 SDK
            NSString * platType = @"2";
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            
            [WXApi sendReq:req completion:^(BOOL success) {
                
            }];
            
            [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = nil;
            [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = ^(NSDictionary * _Nonnull userInfoDict) {
                @strongify(self);
                NSString *name = isEmpty(userInfoDict[@"nickname"]) ? nil :userInfoDict[@"nickname"];
                NSString *iconurl = isEmpty(userInfoDict[@"headimgurl"]) ? nil :userInfoDict[@"headimgurl"];
                NSError * parseError;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:userInfoDict options:NSJSONWritingPrettyPrinted error:&parseError];
                   if (parseError) {
                     //解析出错
                    showTipDialog(@"授权信息解析出错");
                   }
                NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [[HKPhoneLoginViewModel signalLoginWithUnionId:userInfoDict[@"unionid"] name:name openid:userInfoDict[@"openid"] iconurl:iconurl clientType:platType registerType:platType jsonString:str] subscribeNext:^(FWServiceResponse *response) {
                    if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                        HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
                        [self loginActionWithModel:model];
                    }else{
                        showTipDialog(response.msg);
                    }
                } error:^(NSError * _Nullable error) {
                    
                }];
            };
            
            
        }else{
            [[HKPhoneLoginViewModel signalUMSocialLoginForPlatform:platformType currentViewController:currentViewController]subscribeNext:^(FWServiceResponse *response) {
                @strongify(self);
                if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                    HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
                    [self loginActionWithModel:model];
                }else{
                    showTipDialog(response.msg);
                    
                }
                
            } error:^(NSError * _Nullable error) {
                
            }];
        }
}




#pragma mark - 根据 out_line 进行界面跳转
- (void)loginActionWithModel:(HKUserModel *)model {
    //out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录
    NSInteger outLine = [model.out_line intValue];
    switch (outLine) {
        case 1:
        {   //登录成功
            [self loginSucessWithModel:model];
        }
            break;
            
        case 2:
        {
            HKVerificationPhoneVC *VC = [HKVerificationPhoneVC new];
            VC.userInfoModel = model;
            [self pushToOtherController:VC];
        }
            break;
            
        case 3:
        {
            BindPhoneVC *VC = [BindPhoneVC new];
            VC.bindPhoneType = HKBindPhoneType_Limit;
            VC.userInfoModel = model;
            [self pushToOtherController:VC];
        }
            break;
            
        case 4:
            [HKLoginTool forbidLoginWithContent:LIMIT_TOO_MANY_LOGIN];
            break;
            
        case 5:
        {
            BindPhoneVC *VC = [BindPhoneVC new];
            VC.bindPhoneType = HKBindPhoneType_ForceBind;
            VC.userInfoModel = model;
            [self pushToOtherController:VC];
        }
            break;
    }
}


#pragma mark - 登录成功
- (void)loginSucessWithModel:(HKUserModel *)model {
    if (!isEmpty(model.access_token)) {
        // 保存账号信息
        userDefaultsWithModel(model);
        showTipDialog(@"登录成功");
        //统计登录人数
        [CommonFunction recordUserLoginCount];
        // 发送登录成功通知
        HK_NOTIFICATION_POST(HKLoginSuccessNotification, nil);
    }
}


@end








