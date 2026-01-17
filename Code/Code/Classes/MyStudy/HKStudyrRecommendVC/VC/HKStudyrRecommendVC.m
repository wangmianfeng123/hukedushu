//
//  HKStudyrRecommendVC.m
//  Code
//
//  Created by Ivan li on 2019/3/24.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKStudyrRecommendVC.h"
#import "HKStudyrRecommendCell.h"
#import "HKStudyRecommendTopView.h"
#import "AppDelegate.h"
#import "CYLTabBarController.h"
#import "VideoPlayVC.h"


@interface HKStudyrRecommendVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <VideoModel*> *dataArr;

@property (nonatomic,strong) HKStudyRecommendTopView *topView;

@property (nonatomic,strong) UIButton *moreVideoBtn;

@end

@implementation HKStudyrRecommendVC



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.backFrontVCCallBack) {
        self.backFrontVCCallBack();
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)createUI {
    self.hk_hideNavBarShadowImage = YES;
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.moreVideoBtn];
    
    [self makeConstraints];
    [self refreshUI];
}


- (void)makeConstraints {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(KNavBarHeight64+5);
        make.height.mas_equalTo(100);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.moreVideoBtn.mas_top).offset(-5);
    }];
    
    [self.moreVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(50);
    }];
}




- (NSMutableArray<VideoModel*>*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


- (HKStudyRecommendTopView*)topView {
    if (!_topView) {
        _topView = [[HKStudyRecommendTopView alloc]initWithFrame:CGRectZero];
    }
    return _topView;
}


- (UIButton*)moreVideoBtn {
    
    if(!_moreVideoBtn){
        _moreVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _moreVideoBtn.titleLabel.font = HK_FONT_SYSTEM_WEIGHT(17, UIFontWeightMedium);
        [_moreVideoBtn setTitle:@"查看更多好课" forState:UIControlStateNormal];
        [_moreVideoBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
        [_moreVideoBtn setTitleColor:[COLOR_ffffff colorWithAlphaComponent:0.8] forState:UIControlStateSelected];
        
        [_moreVideoBtn addTarget:self action:@selector(moreVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _moreVideoBtn.clipsToBounds = YES;
        _moreVideoBtn.layer.cornerRadius = 25;
        // 按钮渐变背景
        UIColor *color = [UIColor colorWithHexString:@"#FF9200"];
        UIColor *color1 = [UIColor colorWithHexString:@"#FFA200"];
        UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
        UIImage *image = [[UIImage alloc]createImageWithSize:CGSizeMake(SCREEN_WIDTH - 30, 50) gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.6),@(1)] gradientType:GradientFromLeftToRight];
        
        [_moreVideoBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _moreVideoBtn;
}



- (void)moreVideoBtnClick:(UIButton*)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HK_NOTIFICATION_POST_DICT(HKSelectStudyTagNotification, nil, nil);
    });
    [self popFirstTab];
}



///选中 第一个 tabbar
- (void)popFirstTab {
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    UIViewController *tabViewController = appDelegate.window.rootViewController;
    if ([tabViewController isKindOfClass:[CYLTabBarController class]]) {
        [(CYLTabBarController*)tabViewController setSelectedIndex:0];
        
    }else if ([tabViewController isKindOfClass:[UITabBarController class]]) {
        [(UITabBarController *)tabViewController setSelectedIndex:0];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getVideoList];
    }];
    [self getVideoList];
}


- (void)getVideoList {
    
    [HKHttpTool POST:HOME_GET_INTERESTIONS_VIDEO_LIST parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            self.dataArr = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"recommend_list"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.05;
        _tableView.sectionFooterHeight = 0.05;
        
        _tableView.rowHeight = 95;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count ? 1 :0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    HKStudyrRecommendCell *cell = [HKStudyrRecommendCell initCellWithTableView:tableView];
    cell.collectBtnClickCallBack = ^(UIButton * _Nonnull btn, VideoModel * _Nonnull model) {
        StrongSelf;
        if (NO == model.is_collected) {
            //无收藏的，先响应收藏
            [strongSelf collectVideo:model collectBtn:btn];
        }else{
            VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:model.title placeholderImage:model.cover_image_url lookStatus:LookStatusInternetVideo videoId:model.video_id model:nil];
            [strongSelf pushToOtherController:VC];
        }
        [strongSelf umCollectClick:indexPath];
    };
    
    cell.model = self.dataArr[indexPath.row];
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoModel *model = self.dataArr[indexPath.row];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:model.title placeholderImage:model.cover_image_url lookStatus:LookStatusInternetVideo videoId:model.video_id model:nil];
    [self pushToOtherController:VC];
    
    [self umClick:indexPath];
}


/// 收藏视频
- (void)collectVideo:(VideoModel*)model collectBtn:(UIButton*)collectBtn {
    [[FWNetWorkServiceMediator sharedInstance] collectOrQuitVideoWithToken:nil videoId:model.video_id type:model.is_collect? @"2" : @"1" videoType:nil postNotification:NO completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            showTipDialog(@"已收藏在【学习-收藏教程】里");
            model.is_collected = !model.is_collected;
            collectBtn.selected = model.is_collected;
            collectBtn.layer.borderColor = model.is_collected ?COLOR_7B8196_A8ABBE.CGColor :COLOR_27323F_EFEFF6.CGColor;
        }else{
            showTipDialog(response.msg);
        }
    } failBlock:^(NSError *error) {
        
    }];
}




#pragma mark - 友盟收藏统计
- (void)umCollectClick:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTFIRSTVIDEO];
            break;
            
        case 1:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTSECONDVIDEO];
            break;
            
        case 2:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTTHIRDVIDEO];
            break;
            
        case 3:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_COLLECTFOURTHVIDEO];
            break;
            
        default:
            break;
    }
}



#pragma mark - 友盟点击统计
- (void)umClick:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_FIRSTVIDEO];
            break;
            
        case 1:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_SECONDVIDEO];
            break;
            
        case 2:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_THIRDVIDEO];
            break;
            
        case 3:
            [MobClick event:SELECTINTEREST_RECOMMENDEDCOURSE_FOURTHVIDEO];
            break;
            
        default:
            break;
    }
}



@end

