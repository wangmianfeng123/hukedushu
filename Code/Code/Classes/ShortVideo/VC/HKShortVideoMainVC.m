//
//  HKShortVideoMainVC.m
//  Code
//
//  Created by Ivan li on 2019/3/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoMainVC.h"
#import "HKShortVideoCell.h"
#import "HKShortVideoControlView.h"
#import "HKShortVideoMainVC+Category.h"
#import "UMpopView.h"
#import "ZFHKNormalPlayer.h"
#import "ZFHKNormalAVPlayerManager.h"
#import "ZFHKNormalPlayerControlView.h"
#import "ZFHKNormalPlayerControlView+Category.h"
#import "HKStudyVC.h"
#import "HKUserInfoVC.h"
#import "HKTeacherCourseVC.h"
#import "HKShortVideoCommentVC.h"
#import "HKShortVideoModel.h"
#import "NSString+MD5.h"
#import "TXLiteAVPlayerManager.h"

#import <ZFPlayer.h>

#define  HKshortVideoPraiseKey  @"HKshortVideoPraiseKey"

#define  HKShortVideoCellKey  @"HKShortVideoCellKey"


@interface HKShortVideoMainVC ()  <UITableViewDelegate,UITableViewDataSource,HKShortVideoCellDelegate,HKShortVideoControlViewDelegate,TBSrollViewEmptyDelegate, UMpopViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) ZFHKNormalPlayerController *player;
@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) HKShortVideoControlView *controlView;

@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) UIButton *backBtn;
/** post 回话 */
@property (nonatomic,strong)NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@property (nonatomic, strong) UIView *tableViewBackgroundView;
/***/
@property (nonatomic, copy)NSString *shortVideoUrl;

@property (nonatomic, strong)HKShortVideoCommentVC *shortVideoCommentVC; // 评论VC

@property (nonatomic, assign)BOOL loadLastVCDataSource; // 加载分类进入的数据


@end


@implementation HKShortVideoMainVC

- (instancetype)initWithShowBackBtn:(BOOL)showBackBtn {
    if (self = [super init]) {
        self.showBackBtn = showBackBtn;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    // 监听nav 数量变化用于隐藏弹出的评论VC
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
    !self.deallocBlock? : self.deallocBlock();
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 时长统计
    [self recordVideoPlayTimeLog];
    [self resetProgressTimer];
    [self superViewWillDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self superViewWillDisappear:animated];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backBtn.x = 15;
    self.backBtn.y = IS_IPHONE_X ?60 :35;
}


#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}


-(BOOL)prefersHomeIndicatorAutoHidden {
    // 自动隐藏 X系列手机横线
    return YES;
}

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    self.zf_prefersNavigationBarHidden = YES;

    [self refreshUI];
    [self setPlayerCallBack];
    [self userLoginAndLogotObserver];
    //点赞通知
    HK_NOTIFICATION_ADD(HKShortVideoPraiseNotification, shortVideoPraiseNotification:);
    
    // 提示每日更新数量
    [self setShortVideoUpdateCountPerDay];
        
    // 返回按钮
    [self.view addSubview:self.backBtn];
}

- (void)topBtnClick:(UIButton *)button {
    
    button.selected = !button.selected;
    
    NSLog(@"%s %@", __func__, button);
    
    if (button.tag == 111) {
        
    } else if (button.tag == 222) {
        
    }
}




#pragma mark - 通知
- (void)userloginSuccessNotification {
    if (0 == self.dataSource.count) {
        [self loadNewData];
    }
}


#pragma mark - 退出后操作
- (void)userlogoutSuccessNotification {
    [self.urls removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    if (self.player) {
        [self.player.currentPlayerManager stop];
    }
}


#pragma mark - 点赞
- (void)shortVideoPraiseNotification:(NSNotification*)noti {
    
    if(NO ==  [[noti.userInfo allKeys] containsObject:HKshortVideoPraiseKey]) {
        return;
    }
    
    BOOL isContainCell = [[noti.userInfo allKeys] containsObject:HKShortVideoCellKey];
    HKShortVideoModel *model = noti.userInfo[HKshortVideoPraiseKey];
    
    if (isContainCell) {
        // 当前 页面 点赞
        HKShortVideoCell *cell = noti.userInfo[HKShortVideoCellKey];
        cell.videoModel.likeCount = model.likeCount;
        if (cell) {
            cell.likeBtn.selected = model.like;
            cell.likeLB.text = [NSString shortVideoFormatCount:model.likeCount];
        }
    }else{
        // 单个视频页点赞
        [self.dataSource enumerateObjectsUsingBlock:^(HKShortVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.video_id isEqualToString:model.video_id]) {
                NSIndexPath *indepath = [NSIndexPath indexPathForRow:idx inSection:0];
                HKShortVideoCell *cell = (HKShortVideoCell*)[self.tableView  cellForRowAtIndexPath:indepath];
                
                obj.likeCount = model.likeCount;
                obj.like = model.like;
                
                if (cell) {
                    cell.likeBtn.selected = obj.like;
                    cell.likeLB.text = [NSString shortVideoFormatCount:obj.likeCount];
                }
                *stop = YES;
            }
        }];
    }
}


- (void)setShowBackBtn:(BOOL)showBackBtn {
    _showBackBtn = showBackBtn;
    self.backBtn.hidden = !showBackBtn;
}



- (void)refreshUI {

    [self shortVideoUrl];
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
        [strongSelf loadNewData];
    }];

    [self.tableView.mj_header beginRefreshing];
    //[self loadNewData];
    
    switch (self.shortVideoType) {
        case HKShortVideoType_main_tab:
        case HKShortVideoType_category:
        case HKShortVideoType_teacher:
        case HKShortVideoType_my_praise:
        {
            [HKRefreshTools shortVideoFooterAutoRefreshWithTableView:self.tableView completion:^{
                StrongSelf;
                [strongSelf loadMoreData:YES];
            }];
        }
            
            break;
            
        case HKShortVideoType_sigle_video:
        case HKShortVideoType_notification:
            break;
            
        default:
            break;
    }
}



- (void)setShortVideoType:(HKShortVideoType)shortVideoType {
    _shortVideoType = shortVideoType;
    
    switch (shortVideoType) {
        case HKShortVideoType_main_tab:
            self.shortVideoUrl = SHORT_VIDEO_INDEX;
            break;
            
        case HKShortVideoType_category:
            self.shortVideoUrl = SHORT_VIDEO_TAG_INDEX;
            break;
            
        case HKShortVideoType_sigle_video:
            self.shortVideoUrl = SHORT_VIDEO_PLAY_VIDEO;
            break;
            
        case HKShortVideoType_notification:
            self.shortVideoUrl = SHORT_VIDEO_PLAY_VIDEO;
            break;
            
        case HKShortVideoType_teacher:
            self.shortVideoUrl = TEACHER_SHORT_COURSE;
            break;
            
        case HKShortVideoType_my_praise:
            self.shortVideoUrl = SHORT_VIDEO_LIKES;
            break;
            
        default:
            break;
    }
}



// 首次安装APP提示短视频福利
- (void)showFirstExperience {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"HKShowShortVideoFirstExperience"];
    if (!str || ![str isEqualToString:@"1"]) {
        showOffsetTipDialog(@"恭喜你\n短视频免费体验福利领取成功", CGPointMake(0, 0));
        [userdefaults setObject:@"1" forKey:@"HKShowShortVideoFirstExperience"];
        [userdefaults synchronize];
    }
}

- (void)loadNewData {

    @weakify(self)
    NSDictionary *dict = nil;
    switch (self.shortVideoType) {
        case HKShortVideoType_main_tab:
        {
            [self.player stopCurrentPlayingCell];
            dict = @{HKneedNoLoginCallBack:@"1"};
        }
            break;
            
        case HKShortVideoType_category:
        {
            dict = @{HKneedNoLoginCallBack:@"1", @"tag_id" : self.tag_model.tag_id};
        }
            break;
            
        case HKShortVideoType_sigle_video:
        case HKShortVideoType_notification:
        {
            [self.player stopCurrentPlayingCell];
            dict = @{@"video_id":self.videoId,HKneedNoLoginCallBack:@"1"};
        }
            break;
            
        case HKShortVideoType_teacher:
        {
            dict = @{@"teacher_id" : self.teacher.teacher_id, @"page" : @(self.page)};
        }
            break;
            
        case HKShortVideoType_my_praise:
        {
            dict = @{@"user_id" : self.user.ID, @"page" : @(self.page)};
        }
            break;
        default:
            break;
    }
    
    // 即时加载分类的第一组数据
    //if (self.tag_model.tag_id.length && !self.loadLastVCDataSource) {
    if (self.dataSourceTemp.count && !self.loadLastVCDataSource) {
        self.loadLastVCDataSource = YES;
        [self.tableView.mj_header endRefreshing];
        self.dataSource = self.dataSourceTemp;
        
        [self.urls removeAllObjects];
        for (HKShortVideoModel *model in self.dataSource) {
            NSURL *url = [NSURL URLWithString:model.video_url];
            [self.urls addObject:url];
        }
        self.player.assetURLs = self.urls;
        
        // 移动到指定位置
        int row = 0;
        for (int i = 0; i < self.dataSource.count; i++) {
            if (self.tag_model == self.dataSource[i]) {
                row = i;
                break;
            }
        }
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
        // 解决偏移偏差的问题
        int detal = ceilf(self.tableView.contentOffset.y / self.tableView.rowHeight);
        CGFloat offsetY = detal * self.tableView.rowHeight - self.tableView.contentOffset.y;
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + offsetY);
        
        /// 找到可以播放的视频并播放
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
        return;
    }

    switch (self.shortVideoType) {
        case HKShortVideoType_main_tab:
        case HKShortVideoType_sigle_video:
        case HKShortVideoType_notification:
            break;
            
        case HKShortVideoType_category:
        case HKShortVideoType_teacher:
        case HKShortVideoType_my_praise:
        {
            [self.tableView.mj_header endRefreshing];
            return;
        }
            break;
        default:
            break;
    }
    

    [HKHttpTool POST:self.shortVideoUrl parameters:dict success:^(id responseObject) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            // 首次安装APP提示短视频福利，防止首次进来无网络访问
            [self showFirstExperience];
            
            self.dataSource = [HKShortVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            
            [self.urls removeAllObjects];
            for (HKShortVideoModel *model in self.dataSource) {
                NSURL *url = [NSURL URLWithString:model.video_url];
                
                //URL = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200fd70000bi7jfchdli3jt4f8bfug&line=0";
                //NSString *temp = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200fd70000bi7jfchdli3jt4f8bfug&line=0";
                //url = HKURL(temp);
                [self.urls addObject:url];
            }
            self.player.assetURLs = self.urls;
            [self.tableView reloadData];
            /// 找到可以播放的视频并播放
            [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
                @strongify(self)
                [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            }];
        }
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if (0 == self.dataSource.count) {
            [self.tableView reloadData];
        }
    }];
}



- (void)loadMoreData:(BOOL)isFooterEnd {

    NSDictionary *dict = nil;
    switch (self.shortVideoType) {
        case HKShortVideoType_main_tab:
            break;
        case HKShortVideoType_sigle_video:
        case HKShortVideoType_notification:
        {
            [self.tableView.mj_footer endRefreshing];
            return;
        }
            break;
            
        case HKShortVideoType_category:
        {
            dict = @{@"tag_id" : self.tag_model.tag_id};
        }
            break;
            
        case HKShortVideoType_teacher:
        {
            dict = @{@"teacher_id" : self.teacher.teacher_id, @"page" : @(self.page)};
        }
            break;
            
        case HKShortVideoType_my_praise:
        {
            dict = @{@"user_id" : self.user.ID, @"page" : @(self.page)};
        }
            break;
        default:
            break;
    }

    [self.sessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self.sessionTaskArray removeAllObjects];
    
    NSURLSessionDataTask *sessionTask = [HKHttpTool hk_taskPost:self.shortVideoUrl allUrl:nil isGet:NO parameters:dict success:^(id responseObject) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            NSMutableArray *arr = [HKShortVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            if (arr.count) {
                [self.dataSource addObjectsFromArray:arr];
                for (HKShortVideoModel *model in arr) {
                    NSURL *url = [NSURL URLWithString:model.video_url];
                    [self.urls addObject:url];
                }
                self.player.assetURLs = self.urls;
            }
            
            switch (self.shortVideoType) {
                case HKShortVideoType_main_tab:
                case HKShortVideoType_sigle_video:
                case HKShortVideoType_notification:
                case HKShortVideoType_category:
                    break;
                case HKShortVideoType_teacher:
                case HKShortVideoType_my_praise:
                {
                    // 无更多数据集
                    NSString *pageCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"pageCount"]];
                    if (self.page >= pageCount.intValue) {
                        self.tableView.mj_footer.hidden = YES;
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    self.page++;
                }
                    break;
                default:
                    break;
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    [self.sessionTaskArray addObject:sessionTask];
}




#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}


#pragma <TBSrollViewEmptyDelegate>
-(UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return nil;
}

- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {

    NSString *stringTemp = (status == TBNetworkStatusNotReachable)? @"网络未连接，请检查网络设置": @"暂无内容~";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:stringTemp];
    [str addAttribute:NSForegroundColorAttributeName value: ((status == TBNetworkStatusNotReachable)?[UIColor whiteColor]:[UIColor clearColor])
                range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, str.length)];
    return str;
}

- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {

    return CGPointMake(0,IS_IPHONE5S ?100 :200);
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKShortVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKShortVideoCell class])];
    cell.videoModel = self.dataSource[indexPath.row];
    cell.showTopTool = YES;
    cell.delegate = self;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

/** 友盟分享 */
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
    popView.delegate = self;
    [popView createUIWithModel:model];
}

- (void)uMShareWebSucess:(id)sender {
    showTipDialog(Share_Sucess);
    [[HKALIYunLogManage sharedInstance]shortVideoClickLogWithIdentify:@"6"];
}
- (void)uMShareImageSucess:(id)sender {
    showTipDialog(Share_Sucess);
    [[HKALIYunLogManage sharedInstance]shortVideoClickLogWithIdentify:@"6"];
}


#pragma mark - HKShortVideoCellDelegate
/** 点赞 */
- (void)hkShortVideoCell:(HKShortVideoCell*)view likeBtn:(UIButton*)likeBtn model:(HKShortVideoModel *)model {

    [[HKALIYunLogManage sharedInstance]shortVideoClickLogWithIdentify:model.like ?@"3" :@"4"];
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    [self postPraiseRequest:view model:model likeBtn:likeBtn];
}

/** 评论 */
- (void)hkShortVideoCell:(HKShortVideoCell*)view commentBtn:(UIButton *)commentBtn model:(HKShortVideoModel *)model {
    NSLog(@"%s", __func__);
    
    [MobClick event:UM_RECORD_SHORTVIDEO_COMMENT];
    WeakSelf;
    HKShortVideoCommentVC *shortVideoCommentVC = [[HKShortVideoCommentVC alloc] init];
    shortVideoCommentVC.userTapActionBlock = ^(HKShortVideoCommentModel * _Nonnull modelTemp) {
        
        
        // 教师主页
        if (modelTemp.is_teacher) {
            HKTeacherCourseVC *vc = [HKTeacherCourseVC new];
            vc.teacher_id = modelTemp.reply_tid;
            vc.userVCDeallocBlock = ^{
                [weakSelf superViewDidAppear:YES];
            };
            [weakSelf pushToOtherController:vc];
            
        } else {
            
            // 普通用户的主页
            HKUserInfoVC *vc = [HKUserInfoVC new];
            
            // 退出用户中心时候显示评论页
            vc.userVCDeallocBlock = ^{
                [weakSelf superViewDidAppear:YES];
            };
            vc.userId = modelTemp.commentUser.ID;
            [weakSelf pushToOtherController:vc];
        }
        
        // 隐藏评论页
        [weakSelf superViewWillDisappear:YES];
    };
    shortVideoCommentVC.shortVideoCommentAddOne = ^{
        [weakSelf.tableView reloadData];
    };
    shortVideoCommentVC.shortVideoModel = model;
    self.shortVideoCommentVC  = shortVideoCommentVC;
    [self.tabBarController.view addSubview:self.shortVideoCommentVC.view];
}


/** 分享 */
- (void)hkShortVideoCell:(HKShortVideoCell*)view shareBtn:(UIButton *)shareBtn model:(HKShortVideoModel *)model {
    
    [MobClick event:UM_RECORD_SHORTVIDEO_SHARE];
    [self shareWithUI:model.share_data];
}

/** 关注 */
- (void)hkShortVideoCell:(HKShortVideoCell*)view followBtn:(UIButton*)followBtn model:(HKShortVideoModel *)model{
    [[HKALIYunLogManage sharedInstance]shortVideoClickLogWithIdentify:@"2"];
    [MobClick event:SHORTVIDEO_FOLLOWTEACHER];
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    [self postFollowTeacher:view model:model];
}

/** 头像 */
- (void)hkShortVideoCell:(HKShortVideoCell*)view userBtn:(UIButton*)userBtn model:(HKShortVideoModel *)model{

    [MobClick event:SHORTVIDEO_TEACHER];
    if (HKShortVideoType_teacher == self.shortVideoType ) {
        //讲师主页 头像不能点击
        return;
    }
    if (isEmpty(model.teacher.ID) || (self.showBackBtn && !self.tag_model)) {
        return;
    }
    HKTeacherCourseVC *vc = [HKTeacherCourseVC new];
    vc.teacher_id = model.teacher.ID;
    [self pushToOtherController:vc];

    @weakify(self);
    vc.followBlock = ^(BOOL is_follow, NSString *teacher_id) {
        @strongify(self);
        [self.dataSource enumerateObjectsUsingBlock:^(HKShortVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.teacher.ID isEqualToString:teacher_id]) {
                obj.teacher.flower = is_follow;
                HKShortVideoCell *cell = view;
                cell.followBtn.hidden = is_follow;
            }
        }];
    };
}


#pragma mark --  点赞
- (void)postPraiseRequest:(HKShortVideoCell*)view model:(HKShortVideoModel *)model likeBtn:(UIButton*)likeBtn {
    
    [MobClick event:SHORTVIDEO_LIKE];
    
    if (isEmpty(model.video_id)) {
        return;
    }

    NSString *status = model.like ?@"0" : @"1"; //  1:点赞  0:取消点赞
    NSDictionary *dict = @{@"video_id":model.video_id ,@"status":status};
    @weakify(self);
    [HKHttpTool POST:SHORT_VIDEO_LIKE parameters:dict success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            model.like = !model.like;
            model.likeCount = model.likeCount + (model.like ?(1) : (- 1));
            
            // 点赞通知
            if (model) {
                NSDictionary *dict = nil;
                if (self.showBackBtn) {
                    dict = @{HKshortVideoPraiseKey:model};
                }else{
                    if (view) {
                        dict = @{HKshortVideoPraiseKey:model,HKShortVideoCellKey:view};
                    }else{
                        dict = @{HKshortVideoPraiseKey:model};
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    HK_NOTIFICATION_POST_DICT(HKShortVideoPraiseNotification, nil, dict);
                });
            }
        }
    } failure:^(NSError *error) {
        
    }];
}




/// 关注
- (void)postFollowTeacher:(HKShortVideoCell*)cell model:(HKShortVideoModel *)model {

    if (isEmpty(model.teacher.ID)) {
        return;
    }
    //type ---当前的关注状态, 1已关注，0未关注
    NSString *type = ((model.teacher.flower)? @"1":@"0");
    NSDictionary *param = @{@"teacher_id": model.teacher.ID,@"type": type};
    @weakify(self);
    [HKHttpTool POST:FOLLOW_TEACHER parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            model.teacher.flower = !model.teacher.flower;
            cell.followBtn.hidden = model.teacher.flower;
            for (HKShortVideoModel *videoModel in self.dataSource) {
                // 找出相同的教师 同步关注
                if ([videoModel.teacher.ID isEqualToString:model.teacher.ID]) {
                    videoModel.teacher.flower = model.teacher.flower;
                }
            }
        }
    } failure:^(NSError *error) {

    }];
}



///相关视频按钮
- (void)hkShortVideoCell:(HKShortVideoCell*)view relatedVideoBtn:(UIButton*)relatedVideoBtn  model:(HKShortVideoModel *)model {
    
    [MobClick event:UM_RECORD_SHORTVIDEO_ASSOCIATED_VIDEO];
    if (self.shortVideoWholeVideoClickCallBack) {
        self.shortVideoWholeVideoClickCallBack(model);
    }
}


///标签点击
- (void)hkShortVideoCell:(HKShortVideoCell*)view tagView:(UIView*)tagView  model:(HKShortVideoModel *)model {
    
    if (HKShortVideoType_teacher == self.shortVideoType) {
        return;
    }
    [MobClick event:UM_RECORD_SHORTVIDEO_LABEL];
    if (self.shortVideoTagClickCallBack) {
        self.shortVideoTagClickCallBack(model);
    }
}



- (UIView *)tableViewBackgroundView {

    if (!_tableViewBackgroundView) {
        _tableViewBackgroundView = [[UIView alloc] init];
        UIImage *image = imageName(@"bg_video_v2_10");
        _tableViewBackgroundView.layer.contents = (id)image.CGImage;
        UITapGestureRecognizer  *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [_tableViewBackgroundView addGestureRecognizer:singleTap];
    }
    return _tableViewBackgroundView;
}



- (void)handleSingleTap {
    if (!isLogin()) {
        [self setLoginVC];
    }
}


#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        [_tableView registerClass:[HKShortVideoCell class] forCellReuseIdentifier:NSStringFromClass([HKShortVideoCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //_tableView.backgroundColor = [UIColor blackColor];

        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;

        _tableView.scrollsToTop = NO;
        _tableView.tb_EmptyDelegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];

        _tableView.backgroundView = [self tableViewBackgroundView];

        if (IS_IPHONE_X) {
            CGFloat H = self.view.height - KTabBarHeight49;
            _tableView.frame = CGRectMake(0, 0, self.view.width, H);
            _tableView.rowHeight = _tableView.height;
            //_tableView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
        }else{
            _tableView.frame = self.view.bounds;
            _tableView.rowHeight = _tableView.height;
        }
        
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            
            switch (self.shortVideoType) {
                case HKShortVideoType_main_tab:
                case HKShortVideoType_category:
                case HKShortVideoType_teacher:
                case HKShortVideoType_my_praise:
                    //不分页
                    if (indexPath.row == self.dataSource.count-1) {
                        /// 加载下一页数据
                        [self loadMoreData:NO];
                    }
                    break;
                case HKShortVideoType_sigle_video:
                case HKShortVideoType_notification:
                    break;
                default:
                    break;
            }
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };

    }
    return _tableView;
}



- (NSMutableArray<HKShortVideoModel *> *) dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = [NSMutableArray array];
    }
    return _urls;
}



- (NSMutableArray <NSURLSessionDataTask *> *)sessionTaskArray{
    if (!_sessionTaskArray) {
        _sessionTaskArray = [NSMutableArray array];
    }
    return _sessionTaskArray;
}



- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:imageName(@"nac_back_white") forState:UIControlStateNormal];//@"zfplayer_back"
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden = YES;
        [_backBtn setHKEnlargeEdge:PADDING_30];
        [_backBtn sizeToFit];
    }
    return _backBtn;
}


- (void)backClick:(UIButton*)btn {
    [self backAction];
}


- (LOTAnimationView*)praiseAnimationView {
    if (!_praiseAnimationView) {
        _praiseAnimationView = [LOTAnimationView animationNamed:@"hk_double_click_praise_1.json"];
        _praiseAnimationView.loopAnimation = NO;
        _praiseAnimationView.cacheEnable = NO;
        _praiseAnimationView.layer.shadowColor = [UIColor blackColor].CGColor;
        _praiseAnimationView.layer.shadowOffset = CGSizeMake(0, 2);
        _praiseAnimationView.layer.shadowRadius = 5;
        _praiseAnimationView.layer.shadowOpacity = 0.4;
    }
    return _praiseAnimationView;
}



- (LOTAnimationView*)scrollAnimationView {
    if (!_scrollAnimationView) {
        _scrollAnimationView = [LOTAnimationView animationNamed:@"hk_scorll_up.json"];
        _scrollAnimationView.loopAnimation = NO;
        _scrollAnimationView.cacheEnable = NO;
        _scrollAnimationView.layer.shadowColor = [UIColor blackColor].CGColor;
        _scrollAnimationView.layer.shadowOffset = CGSizeMake(0, 2);
        _scrollAnimationView.layer.shadowRadius = 5;
        _scrollAnimationView.layer.shadowOpacity = 0.4;

    }
    return _scrollAnimationView;
}




#pragma mark - 播放器
- (HKShortVideoControlView *)controlView {
    if (!_controlView) {
        _controlView = [HKShortVideoControlView new];

        @weakify(self);
        _controlView.gestureDoubleCallback = ^{
            @strongify(self);

            if (isLogin()) {
                HKShortVideoCell *cell = (HKShortVideoCell*)[self.tableView  cellForRowAtIndexPath:self.tableView.zf_playingIndexPath];
                if (cell) {
                    [cell autoLikeBtnClick];
                }
            }else{
                [self setLoginVC];
            }
        };

        _controlView.wiFiplayCallback = ^{
            @strongify(self);
            NSIndexPath *index = self.tableView.zf_shouldPlayIndexPath;
            //NSIndexPath *inde_1 = self.tableView.zf_playingIndexPath;
            [self playTheVideoAtIndexPath:index scrollToTop:NO];
        };

        _controlView.delegate = self;
    }
    return _controlView;
}


#pragma mark -  HKShortVideoControlView  delegate
/** 登录 */
- (void)hkShortVideoControlView:(UIView*)view login:(BOOL)login {
    [self setLoginVC];
}


/// 播放状态
- (void)hkShortVideoControlView:(UIView*)view videoPlayer:(ZFHKNormalPlayerController *)videoPlayer
               playStateChanged:(ZFHKNormalPlayerPlaybackState)state {

    if (state == ZFHKNormalPlayerPlayStatePlaying) {
        //self.playBtn.hidden = YES;
    } else if (state == ZFHKNormalPlayerPlayStatePaused) {
        //self.playBtn.hidden = NO;

    }else if (state == ZFHKNormalPlayerPlayStateUnknown) {

    } else if (state == ZFHKNormalPlayerPlayStatePlayStopped) {

    }else if (state == ZFHKNormalPlayerPlayStatePlayFailed) {

    }
    
    if (videoPlayer.viewControllerDisappear) {
        // 不在当前窗口
        if (videoPlayer.currentPlayerManager.isPlaying) {
            [videoPlayer.currentPlayerManager pause];
        }
    }
}



- (ZFPlayerController*)player {
    if (nil == _player) {
        TXLiteAVPlayerManager *playerManager = [[TXLiteAVPlayerManager alloc] init];
        playerManager.timeRefreshInterval = 1;
        playerManager.isNoGPRSPlayShortVideo = YES;
        /// player,tag值必须在cell里设置
        _player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];

    }
    return _player;
}


#pragma mark - 播放器回调
- (void)setPlayerCallBack {

    self.player.disableGestureTypes = ZFHKNormalPlayerDisableGestureTypesPan | ZFHKNormalPlayerDisableGestureTypesPinch;

    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = NO;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1.0;

    self.player.currentPlayerManager.rate = 1.0;
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
        HKShortVideoModel *model = self.dataSource[self.tableView.zf_playingIndexPath.row];
        //播放次数
        [self postShortVideoPlayCount:model.video_id];
    };
    
    
    WeakSelf
    self.player.playerPrepareToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
    };
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
//        weakSelf.player.currentPlayerManager.seekTime = 30;
    };
    
}



#pragma mark - 播放滚动到的视频
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {

    //    if (!isLogin()) {
    //        [self setLoginVC];
    //        return;
    //    }

    if (0 == indexPath.row) {
        [self showScorllAnimationView];
    }

    if (1 == indexPath.row) {
        //点赞动画
        [self showPraiseAnimationView];
    }

    if (AFNetworkReachabilityStatusReachableViaWWAN == [HkNetworkManageCenter shareInstance].networkStatus) {
        if (self.player) {
            [self.player.currentPlayerManager pause];
            @weakify(self);
            
            [self playtipByWWAN:^{
                @strongify(self);
                [self startPlayAtIndexPath:indexPath scrollToTop:scrollToTop];
            } cancelAction:^{
                @strongify(self)
                if (self.player.currentPlayerManager.isPreparedToPlay) {
                    [self.player.currentPlayerManager pause];
                }
            }];
        }
    }else{
        [self startPlayAtIndexPath:indexPath scrollToTop:scrollToTop];
    }
}



- (void)startPlayAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {

    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];

    if (self.dataSource.count) {
        if (indexPath.row <self.dataSource.count) {
            HKShortVideoModel *data = self.dataSource[indexPath.row];
            data.isHiddenBottomView = YES;

            [self recordVideoPlayTimeLog];
            [self.controlView resetControlView];

            self.controlView.videoModel = data;
            [self.controlView showCoverViewWithUrl:data.cover_url];
            //播放次数
            [self postShortVideoPlayCount:data.video_id];
            
            // 播放通知
            if (data) { //HKShortVideoStartPlayNotification
                NSDictionary *dict = @{HKshortVideoPraiseKey:data};
                HK_NOTIFICATION_POST_DICT(HKShortVideoStartPlayNotification, nil, dict);
            }
            HKShortVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                [cell hiddenBottomToolView];
            }
            
            
        }
    }
}


/** 视频播放时长 */
- (void)recordVideoPlayTimeLog{
    [[HKALIYunLogManage sharedInstance]shortVideoPlayTimeLogWithVideoId:self.controlView.videoModel.video_id second:[self.controlView playVideoTime]];
}


/** 重置计时器 */
- (void)resetProgressTimer {
    [self.controlView resetProgressTimer];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self superViewDidAppear:animated];
}


- (void)superViewWillDisappear:(BOOL)animated {
    self.shortVideoCommentVC.view.hidden = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.shortVideoCommentVC.view.superview bringSubviewToFront:self.shortVideoCommentVC.view];
    });
    
    [self.shortVideoCommentVC.view.superview bringSubviewToFront:self.shortVideoCommentVC.view];
}

- (void)superViewDidAppear:(BOOL)animated {
    self.shortVideoCommentVC.view.hidden = NO;
    [self.shortVideoCommentVC.view.superview bringSubviewToFront:self.shortVideoCommentVC.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.shortVideoCommentVC.view.superview bringSubviewToFront:self.shortVideoCommentVC.view];
    });
}


@end


