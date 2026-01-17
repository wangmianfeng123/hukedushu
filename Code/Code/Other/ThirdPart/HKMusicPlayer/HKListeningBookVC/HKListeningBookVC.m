//
//  HKListeningBookVC.m
//  Code
//
//  Created by Ivan li on 2019/7/16.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKListeningBookVC.h"
#import "HKListeningControlView.h"
#import "HKListeningDescrCell.h"
#import "HKPermissionVideoModel.h"
#import "GKPlayer.h"
#import "HKBookDirectoryVC.h"
#import "HKNavigationController.h"
#import "HKBookModel.h"
#import "HKH5PushToNative.h"
#import "HKBookTimerVC.h"
#import "HKListeningBookNameCell.h"
#import "HKListeningBookVC+Category.h"
#import "GKPlayer+Category.h"
#import "UMpopView.h"
#import "HKBookEvaluationView.h"
#import "HKBookCommentListVC.h"
#import "HKBookEvaluationVC.h"
#import "HKBookRateVC.h"
#import "UIButton+Style.h"



@interface HKListeningBookVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HKListeningControlViewDelegate,GKPlayerDelegate,TBSrollViewEmptyDelegate,UMpopViewDelegate,HKBookEvaluationViewDelegate>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@property (nonatomic, strong)GKPlayer *bookPlayer;

@property (nonatomic, strong)HKMapModel *mapModel;


@property (nonatomic, strong)HKBookPlayInfoModel *playInfoModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSIndexPath *htmlIndexPath;

@property (nonatomic,assign)CGFloat htmlHeight;

@property (nonatomic, strong) HKListeningControlView *listeningControlView;

@property (nonatomic, strong)ShareModel *shareModel;

@property (nonatomic, strong)HKBookEvaluationView *evaluationView;

@property (nonatomic, weak)HKListeningDescrCell *listeningDescrCell;

@property(nonatomic,weak)HKBookDirectoryVC *directoryVC;

@property (nonatomic, strong)HKRelateBookModel *relateBookModel;

@end



@implementation HKListeningBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)dealloc {
    if (_listeningDescrCell) {
        [self.listeningDescrCell  removeBriderHandler];
    }
    TTVIEW_RELEASE_SAFELY(_listeningControlView);
    HK_NOTIFICATION_REMOVE();
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.bookPlayer.isListeningVCDisappr = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bookPlayer.isListeningVCDisappr = NO;
    [self forceShowWindowBooKWithScrollView:self.contentCollectionView];
}


- (void)backAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}


- (void)createUI {
    
    self.bookModel.book_id = self.bookId;
    self.bookModel.course_id = self.courseId;
    
    self.hk_hideNavBarShadowImage = YES;
    [self createShareButtonItem];
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self.view addSubview:self.contentCollectionView];
    [self.contentCollectionView reloadData];
    
    self.bookPlayer.isListeningVCDisappr = NO;
    //isNeedquerRecord:@"1" 查询历史记录
    [self.bookPlayer setPlayerWithBookId:self.bookId courseId:self.courseId isNeedquerRecord:@"1"];

    [self.view addSubview:self.evaluationView];
    [self userLoginAndLogotObserver];
    HK_NOTIFICATION_ADD(HKBuyVIPSuccessNotification,buyVIPSuccessNotification:);
    HK_NOTIFICATION_ADD(KNetworkStatusNotification,networkStateDidChange:);
}

- (HKBookModel*)bookModel {
    if (!_bookModel) {
        _bookModel = [HKBookModel new];
    }
    return _bookModel;
}




- (void)networkStateDidChange:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    NSInteger  status  = [dict[@"status"] integerValue];
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            [self getSeverBookInfo];
        }
            //WI-FI
            break;
            
        default:
            break;
    }
}


#pragma mark - 登录后操作
- (void)userloginSuccessNotification {
    if (!self.bookPlayer.isListeningVCDisappr) {
        [self getSeverBookInfo];
    }
}


#pragma mark - 退出后操作
- (void)userlogoutSuccessNotification {
}


#pragma mark - 购买VIP 成功
- (void)buyVIPSuccessNotification:(NSNotification *)noti {
    
    NSDictionary *dict = noti.userInfo;
    if ([dict[@"model"] isKindOfClass:[HKBuyVipModel class]]) {
        HKBuyVipModel *model = dict[@"model"];
        if ([model.vip_type isEqualToString:@"241"]) {
            //读书VIP
            if (!self.bookPlayer.isPlaying) {
                [self getSeverBookInfo];
            }
        }
    }
}


#pragma mark

- (void)getSeverBookInfo{
    [self.bookPlayer getBookInfoWithBookId:self.bookId courseId:self.courseId isNeedquerRecord:@"1" isLoginUpdate:YES];
}

- (void)getBookInfoWithBookId:(NSString*)bookId  courseId:(NSString*)courseId {
    [self.bookPlayer setPlayerWithBookId:bookId courseId:courseId isNeedquerRecord:@"0"];
}


#pragma mark TBSrollViewEmptyDelegate
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    [self getSeverBookInfo];
}


- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
        [_contentCollectionView registerClass:[HKListeningControlView class] forCellWithReuseIdentifier:NSStringFromClass([HKListeningControlView class])];
        [_contentCollectionView registerClass:[HKListeningDescrCell class] forCellWithReuseIdentifier:NSStringFromClass([HKListeningDescrCell class])];
        [_contentCollectionView registerClass:[HKListeningBookNameCell class] forCellWithReuseIdentifier:NSStringFromClass([HKListeningBookNameCell class])];
        
        [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewFootID"];
        [_contentCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeadID"];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _contentCollectionView);
        _contentCollectionView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        
    }
    return _contentCollectionView;
}



#pragma mark <UICollectionViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self forceShowWindowBooKWithScrollView:scrollView];
}


#pragma mark 设置 是否要强制显示窗口浮标
- (void)forceShowWindowBooKWithScrollView:(UIScrollView *)scrollView {
    if (scrollView == _contentCollectionView) {
        // 滑动 超过一个屏幕高度 显示控制窗口
        CGFloat y = scrollView.contentOffset.y;
        if (self.bookPlayer.isPlaying) {
            self.bookPlayer.forceShowWindowBooKView = (y > SCREEN_HEIGHT);
        }
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (0 == section) {
        
        self.indexPath = indexPath;
        HKListeningControlView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKListeningControlView class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.bookModel = self.bookModel;
        cell.relateBookModel = self.relateBookModel;
        self.listeningControlView = cell;
        return cell;
    }else  if (1 == section) {
        
        HKListeningBookNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKListeningBookNameCell class]) forIndexPath:indexPath];
        cell.model = self.bookModel;
        return cell;
        
    }else{
        @weakify(self);
        HKListeningDescrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKListeningDescrCell class]) forIndexPath:indexPath];
        self.listeningDescrCell = cell;
        cell.model = self.bookModel;
        cell.htmlHeightBlock = ^(float height) {
            @strongify(self);
            if (height) {
                self.htmlHeight = height;
                if (self.contentCollectionView) {
                    [self.contentCollectionView performBatchUpdates:^{
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
        };
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(SCREEN_WIDTH, 1);
    switch (indexPath.section) {
        case 0:
            size = CGSizeMake(SCREEN_WIDTH, 415);
            break;
            
        case 1:
            size = CGSizeMake(SCREEN_WIDTH, 200);
            break;
            
        case 2:
            size = CGSizeMake(SCREEN_WIDTH, self.htmlHeight?self.htmlHeight :0.1);
            break;
            
        default:
            break;
    }
    return  size;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewFootID" forIndexPath:indexPath];
        return view;
    }

    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeadID" forIndexPath:indexPath];
        
        return view;
    }
    return [UICollectionReusableView new];
}



- (GKPlayer*)bookPlayer {
    if (!_bookPlayer) {
        _bookPlayer = [GKPlayer sharedInstance];
        _bookPlayer.isHKBookAudio = YES;
    }
    _bookPlayer.delegate = self;
    return _bookPlayer;
}


#pragma mark - HKListeningControlViewDelegate

/** 封面加载 OK */
- (void)controlView:(HKListeningControlView *)controlView coverIV:(UIImageView*)coverIV {
    if (NO == [self bookEqualToPlayerBook:self.bookPlayer]) {
        return;
    }
    //更新锁屏封面
    [self.bookPlayer setLockScreenImage:coverIV.image];
}


// 滑杆滑动及点击
- (void)controlView:(HKListeningControlView *)controlView didSliderTouchBegan:(float)value {

}


- (void)controlView:(HKListeningControlView *)controlView didSliderTouchEnded:(float)value {
    controlView.currentTime = [GKTool timeStrWithSecTime:(self.bookPlayer.totalTime  * value)];
    [controlView setCurrentLabelColorWithValueChange:NO];
    [self.bookPlayer seekToTime:self.bookPlayer.totalTime * value completionHandler:^(BOOL finished) {
        
    }];
}


- (void)controlView:(HKListeningControlView *)controlView didSliderValueChange:(float)value {
    
    [controlView setCurrentLabelColorWithValueChange:YES];
    controlView.currentTime = [GKTool timeStrWithSecTime:(self.bookPlayer.totalTime  * value)];
}


- (void)controlView:(HKListeningControlView *)controlView didSliderTapped:(float)value {
    
    controlView.currentTime = [GKTool timeStrWithSecTime:(self.bookPlayer.totalTime  * value)];
    self.bookPlayer.seekTime = self.bookPlayer.totalTime  * value;
}



/** 目录点击 */
- (void)controlView:(HKListeningControlView *)controlView didClickRirectory:(UIButton *)directoryBtn {
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAILPAGE_CONTRIBUTION];
    [self lossNetWorkDialog];
    [self addBookDirectoryVC];
}


- (void)addBookDirectoryVC {
    if (isEmpty(self.bookModel.book_id)) {
        return;
    }
    @weakify(self);
    HKBookDirectoryVC *directoryVC = [HKBookDirectoryVC new];
    directoryVC.bookModel = self.bookModel;
    directoryVC.bookDirectoryCellClick = ^(HKBookModel *bookModel, NSInteger currentSelectTimeListIndex) {
        @strongify(self);
        [self getBookInfoWithBookId:bookModel.book_id courseId:bookModel.course_id];
    };
    [self.navigationController addChildViewController:directoryVC];
    [self.navigationController.view addSubview:directoryVC.view];
    [directoryVC setBgViewBackGroundColor];
    self.directoryVC = directoryVC;
}


/** 文稿描述点击 */
- (void)controlView:(HKListeningControlView *)controlView didClickDesc:(UIButton *)descBtn {
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAILPAGE_LIST];
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    [self lossNetWorkDialog];
    
    [HKH5PushToNative runtimePush:self.mapModel.className arr:self.mapModel.list currectVC:self];
}


/** 定时点击 */
- (void)controlView:(HKListeningControlView *)controlView didClickTimer:(UIButton *)timerBtn {
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAILPAGE_TIMING];
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    WeakSelf;
    __block HKBookTimerVC *timerVC = [HKBookTimerVC new];
    timerVC.bookTimerVCCellClick = ^(HKBookTimerType timerType, NSTimeInterval seconds, NSInteger currentSelectTimeListIndex) {
        StrongSelf;
        [strongSelf.bookPlayer setTimerSeconds:seconds];
    };
    HKNavigationController *bookTimerVC = [[HKNavigationController alloc]initWithRootViewController:timerVC];
    bookTimerVC.navigationBarHidden = YES;
    bookTimerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:bookTimerVC animated:NO completion:^{
        [timerVC setBgViewBackGroundColor];
    }];
}


/** 倍速点击 */
- (void)controlView:(HKListeningControlView *)controlView rateBtn:(UIButton *)rateBtn {
    
    WeakSelf;
    HKBookRateVC *rateVC = [HKBookRateVC new];
    rateVC.bookRateVCCellClick = ^(HKBookModel * _Nonnull bookModel, float currentRate, NSInteger index) {
        StrongSelf;
        [strongSelf.bookPlayer setPlayRate:currentRate];
        NSString *title = nil;
        if (2 == index) {
            title = @"倍速";
        }else{
            title = [NSString stringWithFormat:@"%@X",bookModel.title];
        }
        [rateBtn setTitle:title forState:UIControlStateNormal];
        [rateBtn setTitle:title forState:UIControlStateHighlighted];
        [rateBtn hkLayoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:3];
    };
    HKNavigationController *bookRateVC = [[HKNavigationController alloc]initWithRootViewController:rateVC];
    bookRateVC.navigationBarHidden = YES;
    bookRateVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:bookRateVC animated:NO completion:nil];
}


- (void)controlView:(HKListeningControlView *)controlView bookBtn:(UIButton *)bookBtn {
    
    [HKH5PushToNative runtimePush:self.bookModel.book_goods.redirect_package.class_name arr:self.bookModel.book_goods.redirect_package.list currectVC:self];
}

/// 上一节
- (void)controlView:(HKListeningControlView *)controlView didClickPrev:(UIButton *)prevBtn {
    [self getBookInfoWithBookId:self.relateBookModel.last_book.book_id courseId:self.relateBookModel.last_book.course_id];
}


/// 下一节
- (void)controlView:(HKListeningControlView *)controlView didClickNext:(UIButton *)nextBtn {
    [self getBookInfoWithBookId:self.relateBookModel.next_book.book_id courseId:self.relateBookModel.next_book.course_id];
}


- (void)controlView:(HKListeningControlView *)controlView didClickPlay:(UIButton *)playBtn {
    
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAILPAGE_PLAY];
    [MobClick event:hukedushu_detailpage_playing];
    
    if (isLogin()) {
        [self lossNetWorkDialog];
//        if (![self.bookId isEqualToString:self.bookPlayer.bookModel.book_id]) {
//            // 没有播放地址 或者切换了视频
//            [self setPlayPermissionWithModel:self.playInfoModel];
//        }else{
//            [self.bookPlayer playOrPauseAudio];
//        }
        NSString *url = self.bookPlayer.playInfoModel.play_url_qn;
        if (isEmpty(url)) {
            [self getSeverBookInfo];
        }else{
            [self.bookPlayer playOrPauseAudio];
        }
    }else{
        [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:4];
        [self setLoginVC];
    }
}



#pragma mark - GKPlayerDelegate
- (void)gkPlayer:(GKPlayer *)player statusChanged:(GKPlayerStatus)status {
        
    if (NO == [self bookEqualToPlayerBook:player]) {
        return;
    }
    
    self.listeningControlView.isPreparedToPlay = player.isPreparedToPlay;
    self.listeningControlView.isPlaying = player.isPlaying;
    [self.listeningControlView setStatus:status];
    switch (status) {
        case GKPlayerStatusBuffering:
        {
        }
            break;
        case GKPlayerStatusPlaying:
        {
        }
            break;
        case GKPlayerStatusPaused:
        {
            //[[AVAudioSession sharedInstance] setActive:YES error:nil];
        }
            break;
        case GKPlayerStatusStopped:
        {
            
        }
            break;
        case GKPlayerStatusEnded:
        {
        }
            break;
        case GKPlayerStatusError:
        {
        }
            break;
            
        default:
            break;
    }
}


// 获取当前时间（单位：毫秒，更加精确）、总时间(单位：毫秒，更加精确)和进度的代理方法
- (void)gkPlayer:(GKPlayer *)player currentTime:(NSTimeInterval)currentTime
       totalTime:(NSTimeInterval)totalTime
  bufferProgress:(float)bufferProgress
        progress:(float)progress {
    
    if (self.listeningControlView.isDraging) return;
    
    if (NO == [self bookEqualToPlayerBook:player]) {
        return;
    }
    // 更新时间 状态
    self.listeningControlView.currentTime = [GKTool timeStrWithSecTime:currentTime];
    self.listeningControlView.value       = progress;
    self.listeningControlView.bufferValue  = bufferProgress;
    self.listeningControlView.isPreparedToPlay = player.isPreparedToPlay;
    [self.listeningControlView setStatus:player.playState];
    
}

- (void)gkPlayerDidCancel:(GKPlayer *)player{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[self backAction];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}


/// 当前课程 和正在播放的是否是同一个课程
/// @param player 播放器
- (BOOL)bookEqualToPlayerBook:(GKPlayer*)player {
    if ([self.bookModel.book_id isEqualToString:player.bookModel.book_id]) {
        return YES;
    }
    return NO;
}


// 获取总时间（单位：毫秒，更加精确）
- (void)gkPlayer:(GKPlayer *)player duration:(NSTimeInterval)duration {
    
    if (NO == [self bookEqualToPlayerBook:player]) {
        return;
    }
    self.listeningControlView.totalTime = [GKTool timeStrWithSecTime:duration];
}


/// 更新 倒计时
- (void)gkPlayer:(GKPlayer *)player updateDownTime:(NSInteger)DownTime {
    [self.listeningControlView updateTimerBtnTitleWithCurrentTime:DownTime];
}


// 获取当前缓冲的代理方法
- (void)gkPlayer:(GKPlayer *)player loadState:(GKPlayerLoadState)loadState {
    
    if (NO == [self bookEqualToPlayerBook:player]) {
        return;
    }
    
    switch (loadState) {
        case GKPlayerLoadStateUnknown:
            break;
            
        case GKPlayerLoadStatePrepare:
        {//准备加载状态
            [self.listeningControlView showPlayBtnLoadingAnim];
        }
            break;
        case GKPlayerLoadStatePlayable:{
            // 加载状态变成了缓存数据足够开始播放，但是视频并没有缓存完全
            [self.listeningControlView hidePlayBtnLoadingAnim];
        }
            break;
            
        case GKPlayerLoadStatePlaythroughOK:
        {   // 加载完成，即将播放，停止加载的动画，并将其移除
            [self.listeningControlView hidePlayBtnLoadingAnim];
        }
            break;
        case GKPlayerLoadStateStalled: {
            // 可能由于网速不好等因素导致了暂停，重新添加加载的动画
            [self.listeningControlView showPlayBtnLoadingAnim];
        }
            break;
        default:
            break;
    }
}


/// 准备播放
- (void)gkPlayer:(GKPlayer *)player preparedToPlay:(BOOL)preparedToPlay {
    
    if (NO == [self bookEqualToPlayerBook:player]) {
        return;
    }
}


/// 刷新
- (void)gkPlayer:(GKPlayer *)player resetControlView:(BOOL)resetControlView
       bookModel:(HKBookModel*)bookModel
 relateBookModel:(HKRelateBookModel *)relateBookModel{
    [self resetListeningControlView:bookModel relateBookModel:relateBookModel];
}



#pragma mark -- 重置 ControlView
- (void)resetListeningControlView:(HKBookModel*)bookModel
                  relateBookModel:(HKRelateBookModel *)relateBookModel{
    if (nil == _contentCollectionView) {
        return;
    }
    self.relateBookModel = relateBookModel;
    
    self.bookId = bookModel.book_id;
    self.courseId = bookModel.course_id;
    
    self.bookModel = bookModel;
    self.shareModel = self.bookPlayer.shareModel;
    self.mapModel = self.bookPlayer.mapModel;
    // 设置导航栏标题
    [self setTitle:bookModel.course_title];
    [self.contentCollectionView reloadData];
    HKListeningControlView *cell = (HKListeningControlView*)[self.contentCollectionView cellForItemAtIndexPath:self.indexPath];
    if ([cell isKindOfClass:[HKListeningControlView class]]) {
        //重置view
        [cell resetControlView];
    }
    // 底部评论 view 负值
    [self.evaluationView setBookModel:self.bookModel];
    
    if (_directoryVC) {
        self.directoryVC.bookModel = self.bookModel;
    }
}


#pragma mark - 断网提示
- (void)lossNetWorkDialog {
    if (isEmpty(self.bookModel.book_id)) {
        AFNetworkReachabilityStatus networkStatus = [HkNetworkManageCenter shareInstance].networkStatus;
        switch (networkStatus) {
            case AFNetworkReachabilityStatusNotReachable: case AFNetworkReachabilityStatusUnknown:
                // 无网络
                showTipDialog(NETWORK_ALREADY_LOST);
                break;
            default:
                break;
        }
    }
}



#pragma mark --- 分享
- (void)shareBtnItemAction {
    //  分享统计
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAIL_PAGE_SHARE];
    [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"5" bookId:self.bookModel.book_id courseId:self.bookModel.course_id];
    [self shareWithUI:self.shareModel];
}

/** 友盟分享 */
- (void)shareWithUI:(ShareModel *)model {
    UMpopView *popView = [UMpopView sharedInstance];
    popView.delegate = self;
    [popView createUIWithModel:model];
}



- (HKBookEvaluationView*)evaluationView {
    if (!_evaluationView) {
        CGFloat height = IS_IPHONE_X ?65: 50;
        _evaluationView =  [[HKBookEvaluationView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT- height, SCREEN_WIDTH, height)];
        _evaluationView.delegate = self;
    }
    return _evaluationView;
}



#pragma mark --- ListeningEvaluationViewDelegate
// 评价按钮点击
- (void)bookEvaluationView:(HKBookEvaluationView*)view commentBtn:(UIButton*)commentBtn {
    
    HKBookCommentListVC *listVC = [HKBookCommentListVC new];
    listVC.bookId = view.bookModel.book_id;
    listVC.bookModel = view.bookModel;
    [self pushToOtherController:listVC];
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAILPAGE_DIRECTCOMMENT];
}

// 收藏按钮点击
- (void)bookEvaluationView:(HKBookEvaluationView*)view collectBtn:(UIButton*)collectBtn {
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAILPAGE_COLLECT];
    [self collectBooK:view collectBtn:collectBtn];
}

// 评价LB点击
- (void)bookEvaluationView:(HKBookEvaluationView*)view commentLB:(UILabel*)commentLB {
    [MobClick event:UM_RECORD_HUKEDUSHU_DETAILPAGE_COMMENT];
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    @weakify(self);
    [self checkBindPhone:^{
        @strongify(self);
        HKBookEvaluationVC *listVC = [HKBookEvaluationVC new];
        listVC.bookId = view.bookModel.book_id;
        listVC.model = view.bookModel;
        [self pushToOtherController:listVC];
    } bindPhone:^{
        
    }];
}


- (void)collectBooK:(HKBookEvaluationView*)view collectBtn:(UIButton*)collectBtn {
    
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    
    NSString *bookID = view.bookModel.book_id;
    if (isEmpty(bookID)) {
        return;
    }
    NSDictionary *dict = @{@"book_id":bookID};
    [HKHttpTool POST:BOOK_COLLECTED_SWITCHER parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            ///0:取消收藏 1:收藏成功
            int status = [responseObject[@"data"][@"status"] intValue];
            NSString *msg = status ?@"收藏成功" :@"取消收藏";
            showTipDialog(msg);
            
            view.bookModel.is_collected = status ?YES :NO;
            view.bookModel.collect_number = view.bookModel.collect_number + (status ?1 :-1);
            view.bookModel = view.bookModel;
            if (status) {
                [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"6" bookId:view.bookModel.book_id courseId:view.bookModel.course_id];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}



@end


