//
//  HomeVideoVC.m
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.121
//

#import "HomeVideoVC.h"
#import "HKListeningBookVC.h"
#import "HKShortVideoCategoryVC.h"
#import "HomeVideloCell.h"
#import "VideoPlayVC.h"
#import "HKHomeBookCell.h"
#import "HKBookModel.h"
#import "UIBarButtonItem+Extension.h"
#import "HKShowEntrollSuccessVC.h"
#import "UIBarButtonItem+Badge.h"
#import "HKStudyTagVC.h"
#import "HKTaskModel.h"
#import "MyLoadingVC.h"
#import "HKAlbumDetailVC.h"
#import "PYSearch.h"
#import "YHIAPpay.h"
#import "HKTrainH5EntranceVC.h"
#import "SearchBar.h"
#import "SearchResultVC.h"
#import "HomeBanner2_6Cell.h"
#import "HomeSuggestCell.h"
#import "HomeVideoCollectionCell.h"
#import "HKSelectFavorCell.h"
#import "CategoryModel.h"
#import "DesignTableVC.h"
#import "HomeServiceMediator.h"
#import "HomeRecommendeCell.h"
#import "HomeRecommendeFooterMoreCell.h"
#import "HomeMyFollowCell.h"
#import "HomeSeriesAndDesign.h"
#import "HKHomeBookHeader.h"
#import "HKRookieHeaderCell.h"
#import "HKHotProductHeaderCell.h"
#import "BannerModel.h"
#import "HomeCategoryCell.h"
#import "HtmlShowVC.h"
#import "SoftwareVC.h"
#import "SeriseCourseVC.h"
#import "HKMyFollowVC.h"
#import "HKHomeFollowV2Cell.h"
#import "HKTeacherCourseVC.h"
#import "HKHomeAlbumCell.h"
#import "HKContainerModel.h"
#import "SoftwareModel.h"
#import "HKNewLearnerCell.h"
#import "HKArticleCollectionViewCell.h"
#import "HKPopSignView.h"
#import "HKPresentVC.h"
#import "UIDeviceHardware.h"
#import "HKCategoryAlbumVC.h"
#import "TagModel.h"
#import "HKAdsCell.h"
#import "HKH5PushToNative.h"
#import "HomeVideoVC+Category.h"
#import "HKAudioListVC.h"
#import "HomeClassCell.h"
#import "HKMiaoMiaoHeader.h"
#import "HKSoftwareVC.h"
#import "HKTaskSwapVC.h"
#import "HKTaskSwapVC.h"
#import "HKTaskDetailVC.h"
#import "HKNewUserFirstVC.h"
#import "HKNewUserThirdVC.h"
#import <CYLTabBarController/CYLTabBarController.h>
#import "AppDelegate.h"
#import "HKArticleCategoryVC.h"
#import "HKNewUserSecondVC.h"
#import "HKHomeGiftModel.h"
#import "HKHtmlDialogVC.h"
#import "HKArticleModel.h"
#import "HKArticleDetailVC.h"
#import "HKHomeFlowAdView.h"
#import "HKArticleCategoryVC.h"
#import "ZFNoramlViewController.h"
#import "HKMyInfoUserModel.h"
#import "HKNavigationController.h"
#import "YHIAPpay.h"
#import "HKScanCodeVC.h"
#import "HKJobPathVC.h"
#import "HKShortVideoHomeVC.h"
#import "HKHomeLiveCell.h"
#import "HKHomeLiveCellHeader.h"
#import "HKLiveListModel.h"
#import "HKLiveCourseVC.h"
#import "HKHomeSoftwareCell.h"
#import "HKHomeVipCell.h"
#import "HKHomeVipVideoCell.h"
#import "HKHomeVipModel.h"
#import "HKHomeVipHeader.h"
#import "HKMyVIPVC.h"
#import "HNewbieTaskView.h"
#import "HKHNewbieFatherView.h"
#import "HKObtainCampVC.h"
#import "HKHomeNewAlbumCell.h"
#import "HKLearnGuidView.h"
#import "HKHomeLiveGuidView.h"
#import "UIView+HKLayer.h"
#import "HKSuspensionView.h"
#import "HKNewTaskModel.h"
#import "HKLiveRemindModel.h"
#import "HKMyLiveVC.h"
#import "HKBookTabMainVC.h"
#import "HKChoiceNoteListVC.h"
#import "HKRecommendTxtModel.h"
#import "HKSignCollectionViewCell.h"
#import "HKHomeSignModel.h"
#import "HKRecommandVideoCell.h"
#import "HKHomeRecomandVC.h"
#import "TagSelectorVC.h"

//#import "AFNetworkActivityLogger.h"



#define HKVersion @"HKVersion"

#define NAVIGATION_HEIGHT (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))

@interface HomeVideoVC ()<PYSearchViewControllerDelegate ,HomeBannerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HomeCategoryCellDelegate,CAAnimationDelegate,PYSearchViewControllerDataSource,HKSignCollectionViewCellDelegate>


@property(nonatomic,strong)NSMutableArray      *newDataArray;// 最新视频列表
@property(nonatomic,strong)NSMutableArray      *suggestArray;// 推荐视频列表
@property(nonatomic,strong)NSMutableArray      <HKMapModel*>*bannerArr;//轮播图
@property(nonatomic,strong)NSMutableArray      *classArr;//分类

@property(nonatomic,strong)NSMutableArray       *recommendOnePageArr;//推荐视频 第一页数据
@property(nonatomic,strong)NSMutableArray       *newOnePageArr;//最新视频 第一页数据

@property (nonatomic, assign)BOOL isset_interest; // 是否设置兴趣课程

@property (nonatomic, copy)NSString *softwareCount; // 软件入门数量

@property (nonatomic, copy)NSString *article_today_update_count; // 今日文章更新数量

@property (nonatomic, strong)NSMutableArray<HKRecommendTxtModel *> *content_list;// 推荐笔记和评论
@property (nonatomic, strong)NSArray<HKAlbumModel *> *album_list;// 所有的精选专辑
@property (nonatomic, strong)NSArray<HKAlbumModel *> *recommandAlbum_list;//推荐的两个精选专辑
@property (nonatomic, strong)NSMutableArray<SoftwareModel *> *software_list;// 新手入门
@property (nonatomic, strong)NSMutableArray<HKArticleModel *> *article_data;// 文章
@property (nonatomic, strong)NSMutableArray<HKBookModel *> *book_data; // 书籍
@property(nonatomic,strong)HomeVideloCell   *videloCell;
@property(nonatomic, strong)NSMutableArray     *downloadObjectArr;
@property(nonatomic,strong)UICollectionView    *suggestView;
@property (nonatomic, copy)NSString *follow_list_type; // ：1-我的关注列表 2-推荐讲师列表
@property (nonatomic, copy)NSString *update_video_total; // 当天更新视频数
@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;
@property(nonatomic,strong)NSMutableArray * redirectWordsArray;
@property(nonatomic,weak)__block UILabel *tipLabel;
@property (nonatomic, strong)UIView *yellowViewBG;
// 当前学习
@property (nonatomic, strong)VideoModel *currentVideo;
@property (nonatomic, assign)BOOL showedCurrentVideo;
/** 活动 广告*/
@property(nonatomic,strong)HKMapModel *adsModel;

@property(nonatomic,strong)HKMapModel *adFlowModel;

/** H5 广告*/
@property(nonatomic,strong)HKMapModel *h5AdsModel;

/** navbar 阴影背景 */
@property(nonatomic,strong)UIImageView *navBarBgImageView;
/** 音频 位置 */
@property(nonatomic,assign)CGRect audioRect;
/** 搜索栏 */
@property(nonatomic,strong)SearchBar *searchBar;
/** rightBarButtonItem  */
@property(nonatomic,weak)UIButton *rightTopBtn;
/** 推荐教程 页码 */
@property(nonatomic,assign)NSInteger suggestPageCount;
/** 推荐讲师 */
@property(nonatomic, weak)HKHomeFollowV2Cell *homeFollowV2Cell;

/** yes - 下载按钮 显示礼包icon  */
@property(nonatomic,assign)BOOL isShowGiftIcon;

@property (nonatomic, weak) PYSearchViewController *searchViewController;

@property(nonatomic,assign) NSInteger page;
/// 搜索关联词
@property(nonatomic,strong) NSMutableArray <NSString *> *suggestWordArray;

@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;
/** 签到 */
@property(nonatomic,weak)UIButton *signBtn;

@property(nonatomic,strong) HKMyInfoUserModel *signInfoModel;
/// YES 有直播
@property(nonatomic,assign,getter=isHaveLive)BOOL haveLive;

@property(nonatomic,strong) NSMutableArray <HKLiveListModel *> *liveListArr;
/// vip 权益
@property(nonatomic,strong) NSMutableArray <HKHomeVipModel *> *vipListArr;
/// vip 权益 视频
@property(nonatomic,strong) NSMutableArray <VideoModel *> *vipVideoListArr;
/// YES 有vip 权益cell
@property(nonatomic,assign,getter=isHaveVipCell)BOOL haveVipCell;
@property (nonatomic , strong) HKLiveRemindModel * model;//顶部推荐直播的数据
@property (nonatomic , strong) HKHomeLiveGuidView * guidV;
//@property (nonatomic , strong) HKLearnGuidView * guidView;
@property (nonatomic , strong) NSMutableArray * signArray;
@property (nonatomic , strong) HKHomeRecomandVC * recomandVC ;


@property (nonatomic , strong)NSMutableArray * selected_class_list;//登录用户的分类标签数组
@property (nonatomic , strong)NSMutableArray * recommend_videoArray;
@property (nonatomic , assign)BOOL recommend_video_free_play; //新注册用户免费播放

@end


@implementation HomeVideoVC

- (HKHomeRecomandVC *)recomandVC{
    if (_recomandVC == nil) {
        _recomandVC = [[HKHomeRecomandVC alloc] init];
    }
    return _recomandVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //#ifdef DEBUG
    //    [HDWindowLogger show];
    //    [HDWindowLogger hideLogWindow];
    //#else
    //#endif
    
    [self getIsset_interest];
    [self createUI];
    [self loadHomeData];
    [self signNotification];
    [self userLoginAndLogotObserver];
    [self getUserExtInfo];
    
    //验证 VIP 购买 补单
    [[YHIAPpay instance] repairReceipt];
    // 签到
    HK_NOTIFICATION_ADD(HKPresentResultNotification, presentResultNotification:);
    HK_NOTIFICATION_ADD(HKWebPushTargetVCNotification, webPushTargetVCNotification:);
    //    HK_NOTIFICATION_ADD(KNetworkStatusNotification, networkNotification);
    HK_NOTIFICATION_ADD(@"chooseSignTags", reloadPageControllerData);
    //APP status 查询
    [CommonFunction checkAPPStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openActivity) name:@"closeADWindow" object:nil];
    [self addChildViewController:self.recomandVC];
    
}


- (void)reloadPageControllerData{
    //    [self.suggestView.mj_header beginRefreshing];
    [self getRefreshData];
}

/** 登录 后 设置极光推送 别名*/
- (void)userloginSuccessNotification {
    //登录 后 设置极光推送 别名
    [self setJpushAlias];
    [HKNewUserGiftTool newUserGiftAction:NO];
    [self.suggestView.mj_header beginRefreshing];
}

/** 退出 后 删除极光推送 别名*/
- (void)userlogoutSuccessNotification {
    //退出 后 删除极光推送 别名
    [self deleteJpushAlias];
    [self setSignBtnImageWithModel:self.signInfoModel];
    //[self.suggestView.mj_header beginRefreshing];
    [self getRefreshData];
}

//- (void)networkNotification{
//    if ([HkNetworkManageCenter shareInstance].networkStatus != AFNetworkReachabilityStatusNotReachable &&
//        [HkNetworkManageCenter shareInstance].networkStatus != AFNetworkReachabilityStatusUnknown) {
//        [self loadHomeData];
////        showWarningDialog(@"网络已连接", [[[UIApplication sharedApplication] delegate] window], 3.0);
//        showTipDialog(@"网络已连接～");
//    }else{
////        showWarningDialog(@"网络已断开", [[[UIApplication sharedApplication] delegate] window], 3.0);
//        showTipDialog(@"网络已断开～");
//    }
//}


- (void)openActivity{
    [self setHtmlDialogVC];
}

- (void)getIsset_interest {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isset_interest = [userDefaults boolForKey:@"isset_interest"];
}



#pragma mark - 获取额外个人数据 小红点
- (void)getUserExtInfo {
    if (![HKAccountTool shareAccount]) return;
    [[UserInfoServiceMediator sharedInstance] getUserExtInfoCompletion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            //跳转映射
            NSMutableArray <HKMyInfoMapPushModel*> *mapArr = [HKMyInfoMapPushModel mj_objectArrayWithKeyValuesArray:response.data[@"modules_list"]];
            [self postRedPointNoti:mapArr];
        }
    } failBlock:^(NSError *error) {
        
    }];
}



- (HKMyInfoUserModel*)signInfoModel {
    if (!_signInfoModel) {
        _signInfoModel = [HKMyInfoUserModel new];
    }
    return _signInfoModel;
}


/**
 进入引导页
 */
- (void)enterGuideView {
    
    // 动画引导页
    NSMutableArray *array = [NSMutableArray array];
    if (IS_IPAD) {
        [array addObject:@"onboarding1_ipad.png"];
        [array addObject:@"onboarding2_ipad.png"];
        [array addObject:@"onboarding3_ipad.png"];
    }else if (IS_IPHONE_XS) {
        [array addObject:@"onboardingx1.png"];
        [array addObject:@"onboardingx2.png"];
        [array addObject:@"onboardingx3.png"];
    }else{
        [array addObject:@"onboarding1.png"];
        [array addObject:@"onboarding2.png"];
        [array addObject:@"onboarding3.png"];
    }
    
    [self setGuideViewWithImageArray:array isLoadGif:NO];
}

#pragma mark - 更新后 引导页
- (void)enterUpdateGuideView {
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"pic_upgrade1_v2_13"];
    [array addObject:@"pic_upgrade2_v2_13"];
    [array addObject:@"pic_upgrade3_v2_13"];
    [self setGuideViewWithImageArray:array isLoadGif:NO];
}


//首次下载 打开应用 签到引导提示
- (void)signNotification {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (!delegate.webUrl.length) {
        if ([CommonFunction isFistDownload]) {
            [self enterGuideView];
        }else{
            if ([CommonFunction isUpdateAppFirstLoad]) {
                //v2.18.1
                //[self enterUpdateGuideView];
            }
        }
    }
    
    
    if ([CommonFunction isFirstLoad]) {
        secondLoad = 1;
    }else{
        [CommonFunction jumpToAPPSetForSevenDay];
        secondLoad = 2;
    }
}

- (void)presentResultNotification:(NSNotification*)noti {
    self.signInfoModel.sign_type = @"1";
    [self setSignBtnImageWithModel:self.signInfoModel];
}


- (void)webPushTargetVCNotification:(NSNotification*)noti {
    NSDictionary *dict = noti.userInfo;
    NSString *webUrl = dict[@"webUrl"];
    [self webBrowserPushTargetVCWithWebUrl:webUrl];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        if ([self.navigationController isKindOfClass:[HKNavigationController class]]) {
                HKNavigationController *navController = (HKNavigationController *)self.navigationController;
              UINavigationBar *navigationBar = navController.navigationBar;
              NSArray<__kindof UIView *> *subviews = navigationBar.subviews;
              for (UIView *subview in subviews) {
                  if ([NSStringFromClass([subview class]) containsString:@"UIPointerInteractionAssistantEffectContainerView"]) {
                      subview.hidden = YES;
                  }
              }
            }
    }
    [self hotWordRequest];
    //[SDWebImageManager.sharedManager.imageCache clearMemory];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if (self.suggestView) {
        CGFloat offsetY = self.suggestView.contentOffset.y;
        [self setNavBarWithColorAlpha:offsetY];
    }
    
    [self loginConfigData];
    [HkChannelData requestHkChannelData];
    [self.suggestView reloadData];
    self.searchBar.searchBarBackgroundColor = COLOR_EFEFF6_333D48;
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeMemory completion:nil];
    //    [SDWebImageManager.sharedManager.imageCache clearMemory];
    //self.suggestView 滚到顶部
    if ([self.suggestView.mj_header isRefreshing]) {
        self.suggestView.contentOffset = CGPointMake(0, 0);
    }
    
    if (@available(iOS 18.0, *)) {
    } else {
        [self.navigationController.navigationBar lt_reset];
    }
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    if (self.isShowGiftIcon) {
        [HKAnimation removeShakeAnimation:self.rightTopBtn];
    }
    HKStatusBarStyleDefault;
    [HkChannelData requestHkChannelData];
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isShowGiftIcon) {
        [HKAnimation shakeAnimation:self.rightTopBtn];
    }
    
    AppDelegate * delegate = [AppDelegate sharedAppDelegate];
    if (delegate.model.is_show) {
        delegate.suspensionView.hidden = NO;
    }else{
        delegate.suspensionView.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate * delegate = [AppDelegate sharedAppDelegate];
    delegate.suspensionView.hidden = YES;
}



#pragma mark - 滑动页面时 navBar 的颜色变化
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    [self setNavBarWithColorAlpha:offsetY];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:@"obtainFreeCamp"];
    if (show) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"obtainFreeCamp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.suggestView reloadData];
    }
}



#pragma mark 设置导航栏颜色
- (void)setNavBarWithColorAlpha:(CGFloat)offsetY {
    
    // 黄色背景
    CGFloat offSetYReal = self.suggestView.contentInset.top + offsetY;
    CGFloat height = IS_IPHONEMORE4_7INCH? 200 : 150;
    if (offSetYReal < 0) {
        self.yellowViewBG.height = height - offSetYReal;
    } else if (offSetYReal > 10) {
        self.yellowViewBG.height = 0.0;
    } else {
        self.yellowViewBG.height = height;
    }
    
    CGFloat alpha = 1.0;
    HKStatusBarStyleDefault;
    UIImage *itemImage = nil;
    if (self.isShowGiftIcon) {
        itemImage = imageName(@"ic_gift_v2_3");
    }else{
        UIImage *downloadImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"ic_download_v2_6") darkImage:imageName(@"ic_download_v2_6_dark")];
        itemImage = downloadImage;
    }
    [self setRightTopBtnImageWithImage:itemImage];
    
    if (!self.navigationController.navigationBar.hidden) {
        UIColor *color = [self barBgColor:alpha];
        [self.navigationController.navigationBar lt_setBackgroundColor:color];
    }
}




- (UIColor *)barBgColor:(CGFloat )alpha {
    UIColor *color = nil;
    if (0 == alpha) {
        color = [UIColor clearColor];
    }else{
        if (@available(iOS 13.0, *)) {
            color = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_3D4752];
        }else{
            color = COLOR_ffffff;
        }
    }
    return color;
}



- (void)createUI {
    
    [self.view addSubview:self.suggestView];
    [self.view insertSubview:self.yellowViewBG belowSubview:self.suggestView];
    //[self hotWordRequest];
    [self refreshUI];
    [self setRightBarButtonItems];
    [self createObserver];
    [self setSearchBar];
    [self setNavBarShadow];
    
    [self setReadBookGuideView];
    
    [self setHomeLoginView];
}



/** 设置导航栏阴影视图 */
- (void)setNavBarShadow {
    if (!self.navBarBgImageView) {
        self.navBarBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KNavBarHeight64)];
        
        self.navBarBgImageView.image = imageName(@"navbar_shadow");
        self.navBarBgImageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.navBarBgImageView];
    }
}

- (void)setSearchBar {
    
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH-65-40, 44);
    if (@available(iOS 13.0, *)) {
        rect = CGRectMake(0, 0, SCREEN_WIDTH-75-35, 44);
    }
    
    self.searchBar = [SearchBar searchBarWithPlaceholder:SEARCH_TIP frame:rect];
    self.searchBar.searchBarBackgroundColor = COLOR_EFEFF6_333D48;//COLOR_EFEFF6_7B8196;
    
    if (@available(iOS 11.0, *)) {
        UIView *titleView = [[UIView alloc]initWithFrame:self.searchBar.bounds];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.clipsToBounds = YES;
        [titleView addSubview:self.searchBar];
        self.navigationItem.titleView = titleView;
    }else{
        self.navigationItem.titleView = self.searchBar;
    }
    
    WeakSelf;
    self.searchBar.searchBarShouldBeginEditingBlock = ^(UISearchBar *searchBar) {
        [MobClick event:UM_RECORD_HOME_SEARCH];
        [weakSelf setSearchView];
        [searchBar resignFirstResponder];
    };
    
    self.searchBar.didClickBlock = ^(UISearchBar *searchBar,NSString *searchWord) {
        [MobClick event:UM_RECORD_HOME_SEARCH];
        [weakSelf setSearchView];
        [searchBar resignFirstResponder];
        weakSelf.searchViewController.searchWord = searchWord;
    };
}

- (void)suggestWordWithSearchText:(NSString *)searchText {
    
    if (isEmpty(searchText)) {
        return;
    }
    
    [self.sessionTaskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state == NSURLSessionTaskStateRunning || obj.state == NSURLSessionTaskStateSuspended ) {
            [obj cancel];
        }
    }];
    
    //NSString *url = HKIsDebug ?SEARCH_RECOMMEND_WORD_TEST :SEARCH_RECOMMEND_WORD;
    NSString *url = hk_testServer == 1 ? SEARCH_RECOMMEND_WORD_TEST : SEARCH_RECOMMEND_WORD;
    
    NSURLSessionDataTask *sessionTask = [HKHttpTool hk_taskPost:nil allUrl:url isGet:YES parameters:@{@"word":searchText} success:^(id responseObject) {
        if ([responseObject[@"data"][@"lists"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"data"][@"lists"];
            self.suggestWordArray = arr.mutableCopy;
            
            self.searchViewController.searchSuggestions = self.suggestWordArray;
            [self.searchViewController.searchSuggestionView reloadData];
            self.searchViewController.searchSuggestionView.hidden = NO;
        }
    } failure:^(NSError *error) {
        if (NSURLErrorCancelled == error.code) {
            
        }
    }];
    [self.sessionTaskArray removeAllObjects];
    [self.sessionTaskArray addObject:sessionTask];
}




#pragma mark - 搜索UI
- (void)setSearchView{
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:self.hotWordArray withSearchsearchHistories:self.searchHistoryArray];
    // 3. 设置风格
    searchViewController.hotSearchStyle = PYHotSearchStyleRankTag; // 热门搜索风格根据选择
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    searchViewController.cancelButton.tintColor = [UIColor whiteColor];
    searchViewController.searchSuggestionHidden = NO;
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    searchViewController.searchHistoriesCount = 10;
    searchViewController.swapHotSeachWithSearchHistory = YES;
    
    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    if (@available(iOS 13.0, *)) {
        [searchViewController.searchBar.searchTextField setFont:HK_FONT_SYSTEM(14)];
    }
    [self pushToOtherController:searchViewController];
    
    searchViewController.hk_hideNavBarShadowImage = YES;
    self.searchViewController = searchViewController;
    
    [self hotWordRequest];
}


#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar
                  searchText:(NSString *)searchText {
    
    if (searchText.length>0) {
        [self suggestWordWithSearchText:searchText];
    }
}


- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    if (searchText.length>0)  {
        [MobClick event:UM_RECORD_SEARCH_PAGE_HOT];
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
    }
}


- (void)searchViewController:(PYSearchViewController *)searchViewController  didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {
    
    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
    }
    [MobClick event:um_searchpage_history];
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
    }
}


- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar {
    
    if (self.suggestWordArray.count > indexPath.row) {
        NSString *text = self.suggestWordArray[indexPath.row];
        searchBar.text = text;
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:text];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
    }
    [MobClick event:um_searchpage_related];
}

- (void)setIsShowGiftIcon:(BOOL)isShowGiftIcon {
    _isShowGiftIcon = isShowGiftIcon;
    
    //NSString *imageName = isShowGiftIcon ?@"ic_gift_v2_3" : @"ic_download_v2_6";
    UIImage *itemImage = nil;
    if (self.isShowGiftIcon) {
        itemImage = imageName(@"ic_gift_v2_3");
    }else{
        UIImage *downloadImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"ic_download_v2_6") darkImage:imageName(@"ic_download_v2_6_dark")];
        itemImage = downloadImage;
    }
    [self setRightTopBtnImageWithImage:itemImage];
    if (isShowGiftIcon) {
        [HKAnimation removeShakeAnimation:self.rightTopBtn];
        [HKAnimation shakeAnimation:self.rightTopBtn];
    }
}


#pragma mark -
- (void)setRightBarButtonItems {
    
    UIButton *button = [[UIButton alloc] init];
    NSString *imageName = self.isShowGiftIcon ?@"ic_gift_v2_3" : @"ic_download_v2_6";
    [button setImage:imageName(imageName) forState:UIControlStateNormal];
    [button setImage:imageName(imageName) forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.size = CGSizeMake(30, 44);
    [button addTarget:self action:@selector(rightTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightTopBtn = button;
    // 扩大点击范围
    [self.rightTopBtn setEnlargeEdgeWithTop:15 right:20 bottom:5 left:10];
    UIBarButtonItem *downloadBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    UIButton *signBtn = [[UIButton alloc] init];
    [signBtn setImage:imageName(@"ic_sign_in_normal_v2_18") forState:UIControlStateNormal];
    [signBtn setImage:imageName(@"ic_sign_in_normal_v2_18") forState:UIControlStateHighlighted];
    signBtn.size = CGSizeMake(30, 44);
    [signBtn addTarget:self action:@selector(signBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *signBarItem = [[UIBarButtonItem alloc] initWithCustomView:signBtn];
    self.signBtn = signBtn;
    
    self.navigationItem.rightBarButtonItems = @[signBarItem,downloadBarItem];
}



/** 设置背景图片  */

- (void)setRightTopBtnImageWithImage:(UIImage*)image {
    
    [self.rightTopBtn setImage:image forState:UIControlStateNormal];
    [self.rightTopBtn setImage:image forState:UIControlStateHighlighted];
}



- (void)setSignBtnImageWithModel:(HKMyInfoUserModel*)model {
    
    UIImage *image = nil;
    if (isLogin()) {
        image = [self.signInfoModel.sign_type intValue] ?imageName(@"ic_index_sign_in_selected_v2_18"):imageName(@"ic_sign_in_normal_v2_18");
    }else{
        image = imageName(@"ic_sign_in_normal_v2_18");
    }
    [self.signBtn setImage:image forState:UIControlStateNormal];
    [self.signBtn setImage:image forState:UIControlStateHighlighted];
}


- (void)signBtnClick:(UIButton*)sender {
    
    if (isLogin()) {
        [self pushToOtherController:[HKPresentVC new]];
    }else{
        [self setLoginVC];
    }
    
    [MobClick event:um_shouye_qiandao];
}



- (void)rightTopBtnClick:(UIButton*)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rightTopBtnClick) object:nil];
    [self performSelector:@selector(rightTopBtnClick) withObject:nil afterDelay:0.2];
}


- (void)rightTopBtnClick {
    
    if (self.isShowGiftIcon) {
        
        //[MobClick event:UM_RECORD_SHOUYE_GIFT_BUTTON];
        [HKAnimation removeShakeAnimation:self.rightTopBtn];
        if (isLogin()) {
            [HKNewUserGiftTool userGiftInfo];
        }else{
            [self setGiftLoginVC];
        }
    }else{
        if (isLogin()) {
            MyLoadingVC *VC = [MyLoadingVC new];
            [self pushToOtherController:VC];
        }else{
            [self setLoginVC];
        }
    }
    [MobClick event:UM_RECORD_HOME_DOWNLOAD_BUTTON];
}





#pragma mark - 友盟banner 点击统计
- (void)recommandBannerClick:(NSInteger)index {
    switch (index) {
        case 0:
            [MobClick event:UM_RECORD_HOME_BANNER_1];
            break;
        case 1:
            [MobClick event:UM_RECORD_HOME_BANNER_2];
            break;
        case 2:
            [MobClick event:UM_RECORD_HOME_BANNER_3];
            break;
        default:
            break;
    }
}


#pragma mark - banner 点击代理
- (void)homeBannerDidSelectItemAtIndex:(NSInteger)index {
    
    [self recommandBannerClick:index];
    if (self.bannerArr.count) {
        //BannerModel *model = self.bannerArr[index];
        HKMapModel *model = self.bannerArr[index];
        [self recordBannerClickCount:model.bannerId];
        [self homeBannerClick:model];
    }
}



//- (void)homeBanner:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    
//    //NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
//}



#pragma mark  HomeCategoryCell 代理

- (void)HomeCategoryCell:(HomeCategoryModel *)model x:(float)x y:(float)y rect:(CGRect)rect cell:(HomeClassCell *)cell{
    
    if (rect.origin.y>0.0) {
        self.audioRect = rect;
    }
}


- (void)HomeCategoryCell:(HomeCategoryModel *)model index:(NSInteger)index {
    if ([model.redirect_package.className isEqualToString:@"HKCategoryVC"]) {
        // 全部分类
        NSDictionary *dict = @{@"ItemIndex": @1, @"HKCategoryVCIndex" : @(1)};
        HK_NOTIFICATION_POST_DICT(HKSelectTabItemIndexNotification, nil, dict);
        return;
    }
    NSMutableDictionary * dic = [model mj_keyValues];
    [HKH5PushToNative runtimePush:model.redirect_package.className arr:model.redirect_package.list currectVC:nil];
    return;
}



//---------------- collection ----------------//


#pragma mark - collectionView
- (UICollectionView *)suggestView {
    
    if (!_suggestView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UIInterfaceOrientation  m = [UIApplication sharedApplication].statusBarOrientation;
        NSLog(@"%f====%f",SCREEN_WIDTH,SCREEN_HEIGHT);
        NSLog(@"%f====%f",self.view.frame.size.width,self.view.frame.size.height);
        
        
        
        _suggestView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        [_suggestView registerClass:[HomeSuggestCell class] forCellWithReuseIdentifier:@"HomeSuggestCell"];
        [_suggestView registerClass:[HKHomeBookCell class] forCellWithReuseIdentifier:@"HKHomeBookCell"];
        [_suggestView registerClass:[HomeSuggestiPadCell class] forCellWithReuseIdentifier:@"HomeSuggestiPadCell"];
        [_suggestView registerClass:[HomeSuggestiPadRightCell class] forCellWithReuseIdentifier:@"HomeSuggestiPadRightCell"];
        [_suggestView registerClass:[HomeSuggestiPadMiddleCell class] forCellWithReuseIdentifier:@"HomeSuggestiPadMiddleCell"];
        [_suggestView registerClass:[HomeBanner2_6Cell class] forCellWithReuseIdentifier:@"HomeBanner2_6Cell"];
        [_suggestView registerNib:[UINib nibWithNibName:NSStringFromClass([HKRecommandVideoCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKRecommandVideoCell class])];
        
        [_suggestView registerClass:[HomeVideoCollectionCell class] forCellWithReuseIdentifier:@"HomeVideoCollectionCell"];
        
        [_suggestView registerNib:[UINib nibWithNibName:NSStringFromClass([HKNewLearnerCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKNewLearnerCell class])];
        
        [_suggestView registerNib:[UINib nibWithNibName:NSStringFromClass([HKArticleCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKArticleCollectionViewCell class])];
        
        //[_suggestView registerClass:[HKHomeAlbumCell class] forCellWithReuseIdentifier:@"HKHomeAlbumCell"];
        [_suggestView registerNib:[UINib nibWithNibName:NSStringFromClass([HKHomeNewAlbumCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKHomeNewAlbumCell class])];
        
        [_suggestView registerNib:[UINib nibWithNibName:NSStringFromClass([HKHomeFollowV2Cell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKHomeFollowV2Cell class])];
        
        [_suggestView registerClass:[HomeSuggestRightCell class] forCellWithReuseIdentifier:@"HomeSuggestRightCell"];
        [_suggestView registerClass:[HomeCategoryCell class] forCellWithReuseIdentifier:@"HomeCategoryCell"];
        //活动广告
        [_suggestView registerClass:[HKAdsCell class] forCellWithReuseIdentifier:NSStringFromClass([HKAdsCell class])];
        
        //直播
        [_suggestView registerClass:[HKHomeLiveCell class] forCellWithReuseIdentifier:NSStringFromClass([HKHomeLiveCell class])];
        
        // 软件入门
        [_suggestView registerClass:[HKHomeSoftwareCell class] forCellWithReuseIdentifier:NSStringFromClass([HKHomeSoftwareCell class])];
        // vip cell
        [_suggestView registerClass:[HKHomeVipCell class] forCellWithReuseIdentifier:NSStringFromClass([HKHomeVipCell class])];
        // 我的vip 视频
        [_suggestView registerClass:[HKHomeVipVideoCell class] forCellWithReuseIdentifier:NSStringFromClass([HKHomeVipVideoCell class])];
        [_suggestView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSignCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKSignCollectionViewCell class])];
        
        // header
        [_suggestView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSelectFavorCell class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKSelectFavorCell"];
        [_suggestView registerClass:[HomeMyFollowCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeMyFollowCell"];
        [_suggestView registerClass:[HomeSeriesAndDesign class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeSeriesAndDesign"];
        [_suggestView registerClass:[HKHomeBookHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKHomeBookHeader"];
        [_suggestView registerClass:[HKRookieHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKRookieHeaderCell"];
        [_suggestView registerClass:[HKHotProductHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKHotProductHeaderCell"];
        [_suggestView registerClass:[HKHomeLiveCellHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKHomeLiveCellHeader"];
        [_suggestView registerClass:[HomeRecommendeCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeRecommendeCell"];
        [_suggestView registerClass:[HomeRecommendeFooterMoreCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeRecommendeFooterMoreCell"];
        [_suggestView registerClass:[HKHomeVipHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKHomeVipHeader class])];
        [_suggestView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        _suggestView.contentInset = UIEdgeInsetsMake(KNavBarHeight64 + 5, 0, KTabBarHeight49, 0);
        //UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _suggestView.backgroundColor = [UIColor hkdm_colorWithColorLight:[UIColor clearColor] dark:COLOR_3D4752];
        _suggestView.showsVerticalScrollIndicator = NO;
        _suggestView.showsHorizontalScrollIndicator = NO;
        _suggestView.dataSource = self;
        _suggestView.delegate = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _suggestView);
    }
    return _suggestView;
}

- (UIView *)yellowViewBG {
    if (_yellowViewBG == nil) {
        _yellowViewBG = [[UIView alloc] init];
        _yellowViewBG.frame = CGRectMake(0, 0, self.view.width, IS_IPHONEMORE4_7INCH? 200 : 150);
        //_yellowViewBG.backgroundColor = HK_NAVBAR_Color_2_6;
        _yellowViewBG.backgroundColor = [UIColor clearColor];
    }
    return _yellowViewBG;
}



#pragma mark - CollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.classArr.count>0) {
        return 11;
    }
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            if (self.classArr.count) {
                return 1;
            }
            return 0;
        }
            break;
        case 2:
        {// 广告
            BOOL isHaveAd = self.adsModel.is_show;
            return isHaveAd ? 1: 0;
        }
            break;
            
        case 3:
        {// 直播
            NSInteger count = self.liveListArr.count;
            self.haveLive = (count >0);
            return count;
        }
            break;
            
        case 4:
        {// vip
            NSInteger count = self.vipListArr.count;
            return self.isHaveVipCell ? count : 0;
        }
            break;
            
        case 5:
        {// vip 视频
            return self.isHaveVipCell ? 1 : 0;
        }
            break;
            
        case 6:
            
            if ([HkNetworkManageCenter shareInstance].networkStatus == AFNetworkReachabilityStatusNotReachable ||
                [HkNetworkManageCenter shareInstance].networkStatus == AFNetworkReachabilityStatusUnknown){
                return 0;
            }else{
                // 今日推荐
                if (isLogin() && self.selected_class_list.count) {
                    return 1;
                }else{
                    return self.suggestArray.count? self.suggestArray.count : 0;
                }
            }
            break;
            
        case 7:
            // // 零基础入门
            return self.software_list.count;
            break;
            
        case 8:
            
            return 3;
            // 精选专辑
            //return self.album_list.count;
            break;
            
        case 9:
            // 安利墙
            //            return 1;
            if (self.content_list.count) {
                return 1;
            }
            return 0;
            break;
            
        case 10://猜你喜欢
            return self.newDataArray.count;
            break;
    }
    return 0;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:// 轮播器
            return self.bannerArr.count? CGSizeMake(SCREEN_WIDTH, IS_IPAD ? SCREEN_WIDTH * 0.5 * 240.0 / 690.0 :(SCREEN_WIDTH - 30.0) * 240.0 / 690.0) : CGSizeMake(SCREEN_WIDTH, 0.01);
            break;
        case 1://金刚区
            
            return CGSizeMake((SCREEN_WIDTH), (IS_IPAD ? 80 * iPadHRatio * 2 + 7 + 8 + 5 + 20: 66 * Ratio* 2 + 7 + 8 + 5 + 30));
            break;
        case 2:
        {// 广告
            BOOL isHaveAd = self.adsModel.is_show;
            return CGSizeMake(SCREEN_WIDTH, isHaveAd ? ( IS_IPAD? 100 : 75) :0);
            break;
        }
        case 3:
        {
            // 直播
            CGFloat height = self.isHaveLive ? 285 :0;
            
            return IS_IPAD ? CGSizeMake((SCREEN_WIDTH-20)/3.0, height) : CGSizeMake((SCREEN_WIDTH-20), height);;
            break;
        }
            
        case 4:
        {
            // vip 权益
            return CGSizeMake(85, self.isHaveVipCell ? 40 :0);
            break;
        }
            
        case 5:
        {
            // vip 权益 视频
            return CGSizeMake(SCREEN_WIDTH, self.isHaveVipCell ? (IS_IPAD ? 190 : 160) :0);
            break;
        }
            
        case 6:{
            CGSize recommendCellSize = IS_IPAD? CGSizeMake((SCREEN_WIDTH) / 4.0, 220) : CGSizeMake((SCREEN_WIDTH)/2, 161);
            // 今日推荐
            if (isLogin() && self.selected_class_list.count) {
                return CGSizeMake(SCREEN_WIDTH, recommendCellSize.height * 3 + 44 + 40 * 2 + 40 + 10);
            }else{
                if (IS_IPAD) {
                    return CGSizeMake((SCREEN_WIDTH - 20) / 4.0, 220);
                }else{
                    return CGSizeMake((SCREEN_WIDTH - 20) / 2.0, 161);
                }
            }
            break;
        }
            
        case 7:
            // // 零基础入门
            return CGSizeMake(floor(IS_IPAD ? (SCREEN_WIDTH - 100) / 10.0 : SCREEN_WIDTH / 5.0), 80);
            break;
        case 8: // 精选专辑
            return CGSizeMake(SCREEN_WIDTH, (IS_IPAD ? 180: 140) + 58);
            break;
        case 9:
            // 安利墙
            return CGSizeMake(SCREEN_WIDTH, (IS_IPAD ? 293 + 25 : 280 + 25 ));
            break;
        case 10:{////猜你喜欢
            if (self.newDataArray.count>indexPath.row) {
                VideoModel *model = self.newDataArray[indexPath.row];
                if (model.isHomeSign) {
                    
                    if (IS_IPAD) {
                        return CGSizeMake((SCREEN_WIDTH - 20), 120); // 最新的案例
                    }else{
                        return CGSizeMake((SCREEN_WIDTH), 220);
                    }
                }else{
                    return IS_IPAD? CGSizeMake((SCREEN_WIDTH - 20) * 0.25, 220+2) : CGSizeMake((SCREEN_WIDTH - 20), 281+2); // 最新的案例
                }
            }
        }
            break;
    }
    
    return CGSizeZero;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    // 尾部
    if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // 今日 推荐的尾部
        if (indexPath.section == 6) {
            HomeRecommendeFooterMoreCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeRecommendeFooterMoreCell" forIndexPath:indexPath];
            cell.changeVideoBlock = ^{
                if (0 == weakSelf.suggestPageCount) {
                    weakSelf.suggestPageCount = 1;
                }
                //从第二页数据 开始
                NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)weakSelf.suggestPageCount+1];
                [weakSelf getHomeRecommendeCourseWithPage:pageNum indexPath:indexPath];
            };
            return cell;
        }
        
        if (7 == indexPath.section) {
            UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
            cell.backgroundColor = COLOR_F8F9FA_333D48;
            return cell;
        }
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 头部
        
#pragma mark ----- 3重用的问题
        UICollectionReusableView *header = nil;
        NSInteger section = [indexPath section];
        if (kind == UICollectionElementKindSectionHeader){
            if (3 == section){
                HKHomeLiveCellHeader *cellHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKHomeLiveCellHeader" forIndexPath:indexPath];
                header = cellHeader;
                return header;
            }
            if (4 == section){
                HKHomeVipHeader *vipHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HKHomeVipHeader class]) forIndexPath:indexPath];
                [vipHeader setMoreBtnTitle:@"查看会员权益" headerTitle:@"我的会员课程"];
                vipHeader.moreBtnClickBlock = ^{
                    [weakSelf pushToOtherController:[HKMyVIPVC new]];
                };
                header = vipHeader;
                return header;
            }
            
            if ( 6 == section){
                //                WeakSelf;
                HomeRecommendeCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeRecommendeCell" forIndexPath:indexPath];
                cell.freeLabel.hidden = self.recommend_video_free_play ? NO : YES;
                //                cell.changeVideoBlock = ^{
                //                    NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)weakSelf.suggestPageCount+1];
                //                    [weakSelf getHomeRecommendeCourseWithPage:pageNum indexPath:indexPath];
                //                };
                cell.rightTitleLabel.text = @"";
                header = cell;
                return cell;
            }
            if (7 == section) {
                
                // 软件入门
                HKRookieHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKRookieHeaderCell" forIndexPath:indexPath];
                [cell setChangeBtnText:self.softwareCount];
                cell.moreSolfwareBlock = ^{
                    CategoryModel *model = [[CategoryModel alloc] init];
                    model.name = @"软件入门";
                    [weakSelf pushToOtherController:[HKSoftwareVC new]];
                };
                header = cell;
                return header;
                
            }
            if (9 == section) {
                
                // 推荐讲师
                HomeMyFollowCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeMyFollowCell" forIndexPath:indexPath];
                cell.follow_list_type = [self.follow_list_type integerValue];
                cell.moreFollowBlock = ^{
                    [MobClick event:shouye_recommend_more];
                    HKChoiceNoteListVC *vc = [HKChoiceNoteListVC new];
                    [weakSelf pushToOtherController:vc];
                };
                header = cell;
                return header;
            }if (10 == section) {
                // 猜你喜欢
                HKSelectFavorCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HKSelectFavorCell" forIndexPath:indexPath];
                cell.clickIVClickBlock = ^{
                    [MobClick event:UM_RECORD_SHOUYE_NEWEST_FAVOR];
                    // 尚未登录
                    if(![HKAccountTool shareAccount]) {
                        [weakSelf setLoginVC];
                        return;
                    }
                    // 已经设置过兴趣
                    //                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    //                    [userDefaults setBool:YES forKey:@"isset_interest"];
                    //                    weakSelf.isset_interest = YES;
                    //
                    //                    [weakSelf pushToOtherController:[HKStudyTagVC new]];
                    
                    //创建栏目选择器，输入已选栏目列表和备选栏目列表
                    TagSelectorVC *selectorVC = [[TagSelectorVC alloc] initWithSelectedTags:nil andOtherTags:nil];
                    
                    [self pushToOtherController:selectorVC];
                };
                header = cell;
                return header;
            }
            return [UICollectionReusableView new];
        }
    }
    return [UICollectionReusableView new];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0: case 1:case 2 :
            return CGSizeZero;
            break;
        case 3:
            // 今日直播
            return CGSizeMake(SCREEN_WIDTH, self.isHaveLive ?60 :0);
            break;
            
        case 4:
            // vip 权益
            return CGSizeMake(SCREEN_WIDTH, self.isHaveVipCell ? 60 :0);
            break;
            
        case 5:
            // vip 视频
            return CGSizeZero;
            break;
            
        case 6:
            // 今日推荐
            if (isLogin() && self.selected_class_list.count) {
                return CGSizeZero;
            }else if (self.suggestArray.count == 0){
                return CGSizeZero;
            }else{
                return CGSizeMake(SCREEN_WIDTH, 60);
            }
            break;
            
        case 7:
            //  零基础入门
            return CGSizeMake(SCREEN_WIDTH, 60);
            break;
            
        case 8:
            // 精选专辑
            return CGSizeZero;
            break;
            
        case 9:
            // 安利墙
            if (self.content_list.count) {
                return CGSizeMake(SCREEN_WIDTH, 47 + 10);
            }else{
                return CGSizeZero;
            }
            
            break;
        case 10:
            // 猜你喜欢
            return CGSizeMake(SCREEN_WIDTH, 40);
            break;
    }
    return CGSizeZero;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (6 == section) {
        if (isLogin() && self.selected_class_list.count) {
            // 推荐教程
            return CGSizeZero;
        }else if (self.suggestArray.count == 0){
            return CGSizeZero;
        }else{
            return CGSizeMake(SCREEN_WIDTH, 40);
        }
    }
    if (7 == section) {
        return CGSizeMake(SCREEN_WIDTH, 10);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (4 == section) {
        // vip
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    if (7 == section) {
        if (IS_IPAD) {
            return UIEdgeInsetsMake(10, 50, 0, 50);
        }else{
            return UIEdgeInsetsMake(10, 0, 0, 0);
        }
    }
    
    if (6 == section) {
        if (!isLogin() || self.selected_class_list.count == 0) {
            return UIEdgeInsetsMake(0, 10, 0, 10);
        }
        return UIEdgeInsetsZero;
    }
    
    if (3 == section) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    if (section == 10) {
        if (IS_IPAD) {
            return UIEdgeInsetsMake(0, 10, 0, 10);
        }
    }
    return UIEdgeInsetsZero;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    NSInteger tempSction = [indexPath section];
    switch (tempSction) {
        case 0:{
            // 轮播器
            HomeBanner2_6Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBanner2_6Cell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setBannerWithUrlArray:self.bannerArr];
            return cell;
        }
            break;
        case 1:{//金刚区
            
            HomeCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCategoryCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.pageDataArray = self.classArr;
            
            return cell;
        }
            break;
        case 2:
        {// 广告
            HKAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKAdsCell class]) forIndexPath:indexPath];
            cell.model = self.adsModel;
            return cell;
        }
            break;
            
        case 3:{// 今日直播
            
            HKHomeLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHomeLiveCell class]) forIndexPath:indexPath];
            if (indexPath.row < self.liveListArr.count) {
                cell.model = self.liveListArr[indexPath.row];
            }
            return cell;
        }
            break;
            
        case 4:{
            // vip
            HKHomeVipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHomeVipCell class]) forIndexPath:indexPath];
            if (indexPath.row < self.vipListArr.count) {
                cell.vipModel = self.vipListArr[indexPath.row];
            }
            return cell;
        }
            break;
            
        case 5:{
            // vip 视频
            HKHomeVipVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHomeVipVideoCell class]) forIndexPath:indexPath];
            cell.videoSelectedBlock = ^(NSIndexPath * _Nonnull indexPath, VideoModel * _Nonnull videoModel) {
                [weakSelf enterVideoVC:videoModel];
            };
            cell.videoArr = self.vipVideoListArr;
            return cell;
        }
            break;
            
            
        case 6:{//分类推荐
            if (isLogin() && self.selected_class_list.count) {
                HKRecommandVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKRecommandVideoCell" forIndexPath:indexPath];
                [cell.contentView addSubview:self.recomandVC.view];
                return cell;
            }else{
                // 今日推荐 // iPad
                HomeSuggestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSuggestCell" forIndexPath:indexPath];
                if (indexPath.row < _suggestArray.count) {
                    cell.model = _suggestArray[indexPath.row];
                }
                return cell;
            }
        }
            break;
            
        case 7:{ // 零基础入门
            HKHomeSoftwareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHomeSoftwareCell class]) forIndexPath:indexPath];
            if (indexPath.row < self.software_list.count) {
                cell.model = self.software_list[indexPath.row];
            }
            return cell;
        }
            break;
            
        case 8: { // 精选专辑
            
            HKHomeNewAlbumCell *  cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKHomeNewAlbumCell" forIndexPath:indexPath];
            if (indexPath.row<2) {
                if (indexPath.row < self.recommandAlbum_list.count) {
                    cell.model = self.recommandAlbum_list[indexPath.row];
                }
            }else{
                cell.dataArray = self.album_list;
            }
            cell.moreClickBlock = ^(BOOL isAlbum) {
                if (isAlbum) {
                    
                    HKCategoryAlbumVC *VC = [[HKCategoryAlbumVC alloc]initWithNibName:nil bundle:nil category:nil];
                    [weakSelf pushToOtherController:VC];
                    [MobClick event:shouye_albumlist_more];
                    
                }else{
                    if (indexPath.row == 0) {
                        [MobClick event:shouye_album1_more];
                    }else{
                        [MobClick event:shouye_album2_more];
                    }
                    HKAlbumModel *albumModel = self.recommandAlbum_list[[indexPath row]];
                    HKAlbumDetailVC *VC  = [[HKAlbumDetailVC alloc]initWithAlbumModel:albumModel];
                    [self pushToOtherController:VC];
                }
            };
            cell.cellClickBlock = ^(NSObject * _Nonnull obj) {
                if ([obj isKindOfClass:[VideoModel class]]) {
                    
                    if (indexPath.row == 0) {
                        [MobClick event:shouye_album1_video];
                    }else{
                        [MobClick event:shouye_album2_video];
                    }
                    
                    VideoModel * model = (VideoModel *)obj;
                    VideoPlayVC *VC = nil;
                    VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                   videoName:model.video_titel
                                            placeholderImage:model.img_cover_url
                                                  lookStatus:LookStatusInternetVideo
                                                     videoId:model.video_id
                                                       model:model];
                    
                    [self pushToOtherController:VC];
                }else if ([obj isKindOfClass:[HKAlbumModel class]]){
                    // 进入精选专辑
                    [MobClick event:shouye_albumlist_album];
                    [MobClick event:UM_RECORD_SHOUYE_ALBUM_CLICK];
                    HKAlbumModel *albumModel = (HKAlbumModel *)obj;
                    HKAlbumDetailVC *VC  = [[HKAlbumDetailVC alloc]initWithAlbumModel:albumModel];
                    [self pushToOtherController:VC];
                }
            };
            
            return cell;
        }
            break;
            
        case 9: {// 安利墙
            HKHomeFollowV2Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKHomeFollowV2Cell" forIndexPath:indexPath];
            cell.content_list = self.content_list;
            //            self.homeFollowV2Cell = cell;
            
            cell.homeMyFollowVideoSelectedBlock = ^(NSIndexPath *indexPath, HKRecommendTxtModel * model) {
                [MobClick event:shouye_recommend_more];
                HKChoiceNoteListVC *vc = [HKChoiceNoteListVC new];
                [weakSelf pushToOtherController:vc];
            };
            // 视频点击
            cell.videoSelectedBlock = ^(HKRecommendTxtModel * model) {
                if (model.video_id.length) {
                    [MobClick event:shouye_teacherlist_video];
                    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                                videoName:model.title
                                                         placeholderImage:nil
                                                               lookStatus:LookStatusInternetVideo videoId:model.video_id model:nil];
                    [weakSelf pushToOtherController:VC];
                }
            };
            return cell;
            
        }
            break;
        case 10: {//猜你喜欢
            
            VideoModel *model = self.newDataArray[indexPath.row];
            if (model.isHomeSign) {
                HKSignCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKSignCollectionViewCell class]) forIndexPath:indexPath];
                cell.signArray = self.signArray;
                cell.delegate = self;
                cell.didCloseBlock = ^{
                    showTipDialog(@"猜你喜欢右侧“兴趣选择”按钮，点击可以调整兴趣~");
                    for (int i = 0; i < self.newDataArray.count; i++) {
                        VideoModel * model = self.newDataArray[i];
                        if (model.isHomeSign == YES) {
                            [self.newDataArray removeObject:model];
                        }
                    }
                    [HKNSUserDefaults setObject:[DateChange getNowTimeTimestamp] forKey:@"flagTime"];
                    [HKNSUserDefaults synchronize];
                    [self.suggestView reloadData];
                };
                return cell;
            }else{
                HomeVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeVideoCollectionCell" forIndexPath:indexPath];
                cell.indexPath = indexPath;
                
                if (indexPath.row < self.newDataArray.count) {
                    VideoModel *model = self.newDataArray[[indexPath row]];
                    cell.model = model;
                }
                
                // 收藏功能
                cell.collectionBlock = ^(NSIndexPath *indexPath, VideoModel *model) {
                    [weakSelf collectOrQuitVideo:model index:indexPath];
                };
                return cell;
            }
        }
            break;
        default: return nil;
            break;
    }
    
    return nil;
}



- (void)enterVideoVC:(VideoModel *)model {
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                videoName:model.video_titel
                                         placeholderImage:model.img_cover_url
                                               lookStatus:LookStatusInternetVideo videoId:model.video_id.length?model.video_id : model.ID model:model];
    [self pushToOtherController:VC];
}



// 直播列表 的跳转
- (void)liveListpushToVC:(HKLiveListModel*)model {
    switch (model.live_status) {
        case HKLiveStatusNotStart:
        case HKLiveStatusEnd:
        {
            [self pushToLiveCourseVC:model];
        }
            break;
            
        case HKLiveStatusLiving:
        {// 直播中
            if (model.isEnroll) {
                [self pushToLivingPlayVC:model];
            }else{
                [self pushToLiveCourseVC:model];
            }
        }
            break;
            
        default:
            [self pushToLiveCourseVC:model];
            break;
    }
}


// 进入直播
- (void)pushToLivingPlayVC:(HKLiveListModel*)model {
    HKLivingPlayVC2 *VC = [[HKLivingPlayVC2 alloc] init];
    VC.live_id = model.ID;
    [self pushToOtherController:VC];
}

// 进入直播详情
- (void)pushToLiveCourseVC:(HKLiveListModel*)model {
    HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
    VC.course_id = model.ID;
    [self pushToOtherController:VC];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    VideoModel *model = nil;
    switch (section) {
        case 0:
            break;
            
        case 1://金刚区
            break;
            
        case 2:{ // 广告
            if (self.adsModel.redirect_package.list.count>0) {
                [HKALIYunLogManage sharedInstance].button_id = @"3";
                [HKH5PushToNative runtimePush:self.adsModel.redirect_package.class_name arr:self.adsModel.redirect_package.list currectVC:self];
                [MobClick event:UM_RECORD_HOME_PAGE_AD];
            }
            [[HomeServiceMediator sharedInstance] advertisClickCount:self.adsModel.ad_id];
            return;
        }
            break;
            
        case 3:
        {// 直播
            [MobClick event:shouye_livestudio];
            HKLiveListModel *model = self.liveListArr[indexPath.row];
            [self liveListpushToVC:model];
        }
            break;
            
        case 4:
        {// vip
            HKHomeVipModel *model = self.vipListArr[indexPath.row];
            [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:self];
            return;
        }
            break;
            
        case 5:
        {// vip 视频
            
            return;
        }
            break;
            
        case 6:{// 今日推荐
            if (!isLogin() && self.suggestArray.count) {
                model = self.suggestArray[[indexPath row]];
                [MobClick event:UM_RECORD_HOME_RECOMMEND_VIDEO];
                VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                            videoName:model.video_titel
                                                     placeholderImage:model.img_cover_url
                                                           lookStatus:LookStatusInternetVideo videoId:model.video_id.length?model.video_id : model.ID model:model];
                VC.fromHomeRecommandVideo = YES;
                [self pushToOtherController:VC];
                return;
            }
        }
            break;
            
        case 7:{// // 零基础入门
            SoftwareModel *softwareModel = self.software_list[[indexPath row]];
            NSDictionary *dic = [softwareModel mj_JSONObject];
            VideoModel *modeTemp = [VideoModel mj_objectWithKeyValues:dic];
            model = modeTemp;
            [MobClick event:UM_RECORD_HOME_BEGINNER_VIDEO];
            
            [HKH5PushToNative runtimePush:softwareModel.redirect_package.class_name arr:softwareModel.redirect_package.list currectVC:self];
            return;
        }
            break;
            
        case 10:
            // 猜你喜欢
            model = self.newDataArray[[indexPath row]];
            if (model.isHomeSign) return;
            [MobClick event:UM_RECORD_HOME_NEW_VIDEO];
            [MobClick event:shouye_guessyoulike];
            break;
    }
    
    if (model) {
        [self enterVideoVC:model];
    }
}

#pragma mark - 刷新
- (void)refreshUI {
    
    self.page = 1;
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    HKMiaoMiaoHeader *header = [HKMiaoMiaoHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    header.height = 70 * (IS_IPAD ? iPadHRatio:Ratio);
    header.automaticallyChangeAlpha = YES;
    _suggestView.mj_header = header;
    _suggestView.mj_header.lastUpdatedTimeKey.accessibilityElementsHidden = YES;
    
    WeakSelf;
    [HKRefreshTools footerAutoRefreshWithTableView:_suggestView completion:^{
        [weakSelf getNewVideoList];
    }];
}


- (void)getNewVideoList {
    NSString  *page = [NSString stringWithFormat:@"%ld",(long)self.page];
    [self getVideoWithToken:HomeToken page:page];
}


- (void)tableHeaderEndRefreshing {
    [_suggestView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_suggestView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_suggestView.mj_footer endRefreshing];
}

#pragma mark - 保存数据的文件路径
//数据结构调整，保存新数据，老数据遗弃
- (NSString *)fileNewPath {
    NSString *doc =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *sqlitePath = [NSString stringWithFormat:@"%@/NewHomeVideoVC_2.33.plist",doc];
    NSString *sqlitePath = [NSString stringWithFormat:@"%@/NewHomeVideoVC_2.38.plist",doc];
    return sqlitePath;
}


#pragma mark - 获得 banner 推荐 最新教程 第一页数据
- (void)parseData:(NSDictionary *)dataDic weakSelf:(HomeVideoVC *const __weak)weakSelf netDataRefresh:(BOOL)isNetDataRefresh{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [dataDic.mj_JSONData writeToFile:[self fileNewPath] atomically:YES];
    });
    
    // 我的关注 或者 推荐教师
    NSString *follow_list_type = [NSString stringWithFormat:@"%@", dataDic[@"follow_list_type"]];
    self.follow_list_type = follow_list_type;
    self.update_video_total = [NSString stringWithFormat:@"%@", dataDic[@"update_video_total"]];
    {
        //广告
        self.adsModel = [HKMapModel mj_objectWithKeyValues:[dataDic objectForKey:@"ad_data"]];
    }
    
    //    //悬浮小广告
    dispatch_async(dispatch_get_main_queue(), ^{
        self.adFlowModel = [HKMapModel mj_objectWithKeyValues:[dataDic objectForKey:@"suspend_ad_info"]];
        if (self.adFlowModel && self.adFlowModel.is_show) {
            [HKHomeFlowAdView addADViewToView:self.view].model = self.adFlowModel;
            [HKHomeFlowAdView addADViewToView:self.view].adFlowBlock = ^(HKMapModel *model) {
                [MobClick event:UM_RECORD_SHOUYE_GIFT_BUTTON];
                [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:weakSelf];
                [[HomeServiceMediator sharedInstance] advertisClickCount:model.ad_id];
            };
        } else {
            [HKHomeFlowAdView hideADView];
        }
    });
    
    {
        
        NSMutableArray *bannerArr =  [HKMapModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"banner"]];
        //NSMutableArray *bannerArr =  [BannerModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"banner"]];
        weakSelf.bannerArr = bannerArr;
    }
    {
        NSMutableArray *classArr = [PageCategoryModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"class_list"]];
        weakSelf.classArr = classArr;
    }
    {
        NSMutableArray *teacher_list = [HKRecommendTxtModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"recommend_comments_list"]];
        weakSelf.content_list = teacher_list;
    }
    {
        NSMutableArray *album_list = [HKAlbumModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"album_list"][@"list"]];
        weakSelf.album_list = album_list;
    }
    {
        NSMutableArray *recommandAlbum_list = [HKAlbumModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"album_list"][@"top"]];
        weakSelf.recommandAlbum_list = recommandAlbum_list;
    }
    {
        NSMutableArray *newArr = [VideoModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"newest_video"]];
        weakSelf.newDataArray = newArr;
    }
    
    {
        NSMutableArray * selected_class_list = [TagModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"user_selected_class_list"]];
        weakSelf.selected_class_list = selected_class_list;
    }
    {
        NSMutableArray * recommend_videoArray = [VideoModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"guest_user_recommend_video"]];
        //weakSelf.recommend_videoArray = recommend_videoArray;
        weakSelf.suggestArray = recommend_videoArray;
        if (isNetDataRefresh && recommend_videoArray.count) {
            for (VideoModel * model in recommend_videoArray) {
                [HKVideoPlayAliYunConfig videoPlayAliYunVideoID:model.ID btn_type:16];
            }
        }
    }
    
    {
        // 软件入门 兼容旧版本
        if ([[dataDic objectForKey:@"software_list"] isKindOfClass:
             [NSDictionary class]]) {
            NSMutableArray *software_list = [SoftwareModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"software_list"][@"list"]];
            weakSelf.software_list = software_list;
            weakSelf.softwareCount = dataDic[@"software_list"][@"str"];
        }
        
        // 推荐文章 兼容旧版本
        if ([[dataDic objectForKey:@"article"] isKindOfClass:
             [NSDictionary class]]) {
            NSMutableArray *article_data = [HKArticleModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"article"][@"list"]];
            weakSelf.article_data = article_data;
            weakSelf.article_today_update_count = dataDic[@"article"][@"update_num"];
        }
        
        // 推荐书籍 兼容旧版本
        if ([dataDic objectForKey:@"book_list"]) {
            NSMutableArray *book_data = [HKBookModel mj_objectArrayWithKeyValuesArray:[dataDic objectForKey:@"book_list"]];
            weakSelf.book_data = book_data;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isLogin() && isNetDataRefresh) {
            // UI更新代码
            self.recomandVC.isNetDataRefresh = isNetDataRefresh;
            self.recomandVC.dataArray = self.selected_class_list;
        }
    });
}

- (void)getRefreshData{
    
    
    
    [self loadRemindLiveData];
    [self loadHomeData];
}


- (void)loadHomeData{
    //判断token是否在7天后过期
    [self calculateTimeDifference:^{
        [self getBannerAndOnePageData];
    }];
}

- (void)getBannerAndOnePageData{
    
    self.page = 1;
    // 获取本地的缓存数据
    if (self.classArr.count == 0) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary *dataDic = nil;
            NSData *data = [[NSData alloc] initWithContentsOfFile:[self fileNewPath]];
            if (!data) return;
            dataDic = data.mj_JSONObject;
            [self parseData:dataDic weakSelf:self netDataRefresh:NO];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.suggestView reloadData];
            });
        });
    }
    
    // 网络数据
    [[HomeServiceMediator sharedInstance] homeData:^(FWServiceResponse *response) {
        [self tableHeaderEndRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            NSDictionary *dataDic = response.data;
            
            // 异步写入数据 并且处理数据
            [self parseData:dataDic weakSelf:self netDataRefresh:YES];
            
            HKMapModel *advertModel = [HKMapModel mj_objectWithKeyValues:dataDic];
            self.isShowGiftIcon = advertModel.newcomer_activity_icon;
            
            //H5 弹窗
            self.h5AdsModel = [HKMapModel mj_objectWithKeyValues:[dataDic objectForKey:@"pop_data"]];
            
            // 设置当前学习提示
            self.currentVideo = [VideoModel mj_objectWithKeyValues:dataDic[@"study_data"]];
            
            self.recommend_video_free_play = [dataDic[@"recommend_video_free_play"] boolValue];
            
            if (NO == isEmpty(self.currentVideo.video_id)) {
                if (!self.showedCurrentVideo) {
                    [self setCurrentVideoModelTip:self.currentVideo];
                }
                self.showedCurrentVideo = YES;
            }
            //sign_type：1-当天已签到 0-未签
            self.signInfoModel = [HKMyInfoUserModel mj_objectWithKeyValues:response.data[@"sign_info"]];
            [self setSignBtnImageWithModel:self.signInfoModel];
            /// 直播
            self.liveListArr = [HKLiveListModel mj_objectArrayWithKeyValuesArray:dataDic[@"live_list"]];
            
            self.vipListArr = [HKHomeVipModel mj_objectArrayWithKeyValuesArray:dataDic[@"vip_list"][@"my_vip"]];
            
            self.vipVideoListArr = [VideoModel mj_objectArrayWithKeyValuesArray:dataDic[@"vip_list"][@"video_list"]];
            
            HKMapModel *mapModel = [HKMapModel mj_objectWithKeyValues:dataDic[@"vip_list"]];
            self.haveVipCell = mapModel.is_show;
        }
        [self getNewVideoList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self videoCountTip:self.update_video_total];
            [self.suggestView reloadData];
        });
    } failBlock:^(NSError *error) {
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        if (self.classArr.count<1) {
            [self.suggestView reloadData];
        }
    }];
    
    [HKHttpTool POST:@"/user-interest/get-recommend-class" parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            self.signArray = [HKHomeSignModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.suggestView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取最新的视频列表
- (void)getVideoWithToken:(NSString*)token page:(NSString*)page {
    NSString * exclude_vide_ids = @"";
    
    NSInteger index = IS_IPAD ? 8 : 2;
    
    if (self.newDataArray.count>index) {
        for (int i = 0; i < self.newDataArray.count; i++) {
            if (i<index) {
                VideoModel * model = self.newDataArray[i];
                if (model.video_id.length) {
                    if (i == 0) {
                        exclude_vide_ids = model.video_id;
                    }else{
                        exclude_vide_ids = [NSString stringWithFormat:@"%@,%@",exclude_vide_ids,model.video_id];
                    }
                }
            }
        }
    }
    
    @weakify(self);
    [[HomeServiceMediator sharedInstance] homeNewCourse:page video_ids:exclude_vide_ids completion:^(FWServiceResponse *response) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            NSMutableArray *array = [NSMutableArray array];
            if ([response.data isKindOfClass:[NSDictionary class]]) {
                /// v2.17 修改
                array = [VideoModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"list"]];
                
                HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:[response.data objectForKey:@"pageInfo"]];
                if (pageModel.current_page >= pageModel.page_total) {
                    [self tableFooterEndRefreshing];
                }else{
                    [self tableFooterStopRefreshing];
                }
            }else{
                array = [VideoModel mj_objectArrayWithKeyValuesArray:response.data];
                [self tableFooterStopRefreshing];
            }
            
            if ([page isEqualToString:@"1"]) {
                NSInteger time = [[HKNSUserDefaults objectForKey:@"flagTime"] integerValue];
                NSInteger currentTime =[[DateChange getNowTimeTimestamp] integerValue];
                NSInteger index = IS_IPAD ? 8: 2;
                if (currentTime - time > 7 * 24 * 3600 || time == 0) {
                    if (array.count>index) {
                        VideoModel * model = [[VideoModel alloc] init];
                        model.isHomeSign = YES;
                        [array insertObject:model atIndex:index];
                    }
                }
                self.newDataArray =array;
            }else{
                [self.newDataArray addObjectsFromArray:array];
            }
            self.page ++;
            
        }else{
            [self tableFooterStopRefreshing];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.suggestView reloadData];
        });
        
    } failBlock:^(NSError *error) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.newDataArray.count<1) {
                [self.suggestView reloadData];
            }else{
                showTipDialog(NETWORK_NOT_POWER);
            }
        });
    }];
}


#pragma mark - 推荐视频列表
- (void)getHomeRecommendeCourseWithPage:(NSString*)page  indexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    [[HomeServiceMediator sharedInstance] homeRecommendeCourse:page completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            if ([response.data[@"business_code"] intValue] == 200) {
                NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray: response.data[@"list"]];
                
                if ([page isEqualToString:@"1"]) {
                    weakSelf.suggestPageCount = 1;
                }else{
                    weakSelf.suggestPageCount ++;
                }
                if (array) {
                    weakSelf.suggestArray = array;
                }
                if (array.count) {
                    for (VideoModel * model in array) {
                        [HKVideoPlayAliYunConfig videoPlayAliYunVideoID:model.ID btn_type:16];
                    }
                }
                [weakSelf.suggestView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section]];
            }
        }
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)collectOrQuitVideo:(VideoModel *)model index:(NSIndexPath *)indexPath{
    if (!isLogin()) {
        [self setLoginVC];
        return;
    }
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange collectOrQuitVideoWithToken:nil videoId:model.video_id type:model.is_collect? @"2" : @"1"  videoType:HKVideoType_Ordinary postNotification:YES completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            if (!model.is_collect) {
                model.is_collect = YES;
                [MBProgressHUD showSuccessMessage:@"收藏成功" imageName:@"right_red"];
            }else{
                model.is_collect = NO;
                [MBProgressHUD showSuccessMessage:@"取消收藏" imageName:@"right_red"];
            }
            
            if ([self.suggestView cellForItemAtIndexPath:indexPath]) {
                [self.suggestView reloadItemsAtIndexPaths:@[indexPath]];
            }
            
        }else{
            showTipDialog(response.msg);
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 通知
- (void)createObserver {
    HK_NOTIFICATION_ADD_OBJ(KH5UrlNotification, (h5UrlNotification:), [HomeVideoVC class]);
    // 引导页移除
    HK_NOTIFICATION_ADD(KRemoveGuidePageNotification,removeGuidePageNotification);
    HK_NOTIFICATION_ADD(HKSelectHomeTabTwiceNotification, refreshCollectionView);
    HK_NOTIFICATION_ADD(HKSelectStudyTagNotification, refreshCollectionView);
    // 短视频 引导页移除
    HK_NOTIFICATION_ADD(HKRemoveReadBookGuideViewNotification,removeReadBookGuideViewNotification);
}

- (void)refreshCollectionView {
    [self.suggestView.mj_header beginRefreshing];
}

- (void)h5UrlNotification:(NSNotification *)noti {
    
    NSString *videoId  = noti.userInfo[@"video_id"];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo videoId:videoId model:nil];
    [self pushToOtherController:VC];
}

- (void)removeGuidePageNotification {
    
    //H5 弹框
    [self setHtmlDialogVC];
    // 音频 引导
    if (self.audioRect.origin.y>0 ) {
    }
    [HKNewUserGiftTool newUserGiftAction:YES];
    
    //    NSString *content = [[UIPasteboard generalPasteboard] string];
    //    if ([content containsString:@"huke88::"]) {
    //        NSString * stringBase64 = [content stringByReplacingOccurrencesOfString:@"huke88::" withString:@""];
    //        NSData *data = [[NSData alloc] initWithBase64EncodedString:stringBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //
    //        NSString *string =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        string = [NSString stringWithFormat:@"?%@",string];
    //        NSLog(@"%@",string);
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self webBrowserPushTargetVCWithWebUrl:string];
    //        });
    //    }
}

//// 删除 短视频 引导
- (void)removeReadBookGuideViewNotification {
    [self removeReadBookGuideView];
}

- (void)hotWordRequest {
    // 无热门搜索数据
    [HKHttpTool POST:@"/search/search-words" parameters:nil success:^(id responseObject) {
        if (HKReponseOK){
            [self.hotWordArray removeAllObjects];
            [self.searchHistoryArray removeAllObjects];
            [self.redirectWordsArray removeAllObjects];
            NSMutableArray *arr = [TagModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"]objectForKey:@"hot"]];
            for (TagModel *model in arr ) {
                if (!isEmpty(model.words)) {
                    [self.hotWordArray addObject:model.words];
                }
            }
            
            NSMutableArray *hisArr = [NSMutableArray array];
            hisArr = responseObject[@"data"][@"history"];
            for (NSString * string in hisArr ) {
                if (!isEmpty(string)) {
                    [self.searchHistoryArray addObject:string];
                }
            }
            self.searchBar.hotWordArray = self.hotWordArray;
            self.redirectWordsArray = [preciseWordsModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"]objectForKey:@"redirect_words_list"]];
            
            if (self.searchViewController) {
                self.searchViewController.hotSearches = self.hotWordArray;
                self.searchViewController.hisSearches = self.searchHistoryArray;
                self.searchViewController.redirectWordsArray = self.redirectWordsArray;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - CABasicAnimation  代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        CABasicAnimation * animation = (CABasicAnimation *)anim;
        if ([[animation valueForKey:@"AnimationKey"] isEqualToString:@"CABasicAnimation"]) {
            [_tipLabel.layer removeAllAnimations];
            TTVIEW_RELEASE_SAFELY(_tipLabel);
        }
    }
}


- (void)showHomeLiveGuidView{
    //存储日期和次数
    NSString * date = [DateChange getCurrentTime_day];
    NSString * oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"today"];
    if ([oldDate isEqualToString:date]) {
        NSInteger times = [[NSUserDefaults standardUserDefaults] integerForKey:@"liveRecomandTimes"];
        if (times > 3) return;
        times++;
        [[NSUserDefaults standardUserDefaults] setInteger:times forKey:@"liveRecomandTimes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"today"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"liveRecomandTimes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[CommonFunction topViewController] isKindOfClass:[HomeVideoVC class]]) {
        [MobClick event:shouye_topDialogs_view];
        __block HKHomeLiveGuidView * guidView = [HKHomeLiveGuidView viewFromXib];
        guidView.frame = CGRectMake(15, -88, SCREEN_WIDTH - 30,  88);
        guidView.model = self.model;
        [self.navigationController.view addSubview:guidView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remindLiveClick)];
        [guidView addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizerDirectionUp)];
        [recognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        [guidView addGestureRecognizer:recognizer];
        
        self.guidV = guidView;
        [UIView animateWithDuration:0.5 animations:^{
            guidView.y = STATUS_BAR_EH;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    guidView.y = -88;
                    self.guidV.isAnitaiton = NO;
                    
                } completion:^(BOOL finished) {
                    TTVIEW_RELEASE_SAFELY(self.guidV);
                }];
            });
        }];
    }
}

- (void)remindLiveClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.guidV.y = -88;
        self.guidV.isAnitaiton = NO;
        
    } completion:^(BOOL finished) {
        TTVIEW_RELEASE_SAFELY(self.guidV);
        
    }];
    if (self.model.live_course_id.length) {
        //进入直播详情页
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.course_id = self.model.ID;
        [self pushToOtherController:VC];
        [MobClick event:shouye_topDialogs_click];
    }
}

- (void)recognizerDirectionUp{
    [UIView animateWithDuration:0.5 animations:^{
        self.guidV.y = -88;
        self.guidV.isAnitaiton = NO;
        
    } completion:^(BOOL finished) {
        TTVIEW_RELEASE_SAFELY(self.guidV);
    }];
}

- (void)loadRemindLiveData{
    @weakify(self)
    [HKHttpTool POST:@"live/live-message-remind" parameters:nil success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.model = [HKLiveRemindModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (self.model.ID.length) {
                [self showHomeLiveGuidView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma HKSignCollectionViewCellDelegate
- (void)signCollectionViewCellDidSgin:(HKHomeSignModel *)signModel{
    [MobClick event: shouye_guessyoulike_select_card];
    if (isLogin()) {
        if (signModel.isMore) {
            TagSelectorVC *selectorVC = [[TagSelectorVC alloc] initWithSelectedTags:nil andOtherTags:nil];
            [self pushToOtherController:selectorVC];
        }else{
            @weakify(self)
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            NSString * type = signModel.is_check ? @"2" : @"1";
            [params setSafeObject:type forKey:@"type"];
            [params setSafeObject:signModel.class_id forKey:@"class_id"];
            
            
            NSString * exclude_vide_ids = @"";
            
            NSInteger index = IS_IPAD ? 8 : 2;
            if (self.newDataArray.count>index) {
                for (int i = 0; i < self.newDataArray.count; i++) {
                    if (i<index) {
                        VideoModel * model = self.newDataArray[i];
                        if (model.video_id.length) {
                            if (i == 0) {
                                exclude_vide_ids = model.video_id;
                            }else{
                                exclude_vide_ids = [NSString stringWithFormat:@"%@,%@",exclude_vide_ids,model.video_id];
                            }
                        }
                    }
                }
            }
            [params setSafeObject:exclude_vide_ids forKey:@"exclude_video_ids"];
            
            self.page = 1;
            
            [HKHttpTool POST:@"/user-interest/modify-single-class-id" parameters:params success:^(id responseObject) {
                @strongify(self);
                if (HKReponseOK) {
                    NSMutableArray *array = [NSMutableArray array];
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        /// v2.17 修改
                        array = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                        
                        HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
                        if (pageModel.current_page >= pageModel.page_total) {
                            [self tableFooterEndRefreshing];
                        }else{
                            [self tableFooterStopRefreshing];
                        }
                    }
                    
                    NSInteger index = IS_IPAD ? 9 : 3;
                    if (self.newDataArray.count >= index) {
                        
                        NSMutableArray * nwArray = [NSMutableArray array];
                        NSArray *smallArray = [self.newDataArray subarrayWithRange:NSMakeRange(0, index)];
                        [nwArray addObjectsFromArray:smallArray];
                        [nwArray addObjectsFromArray:array];
                        self.newDataArray =nwArray;
                        self.page ++;
                    }
                    for (HKHomeSignModel * model in self.signArray) {
                        if ([model.class_id isEqualToString:signModel.class_id]) {
                            model.is_check = !model.is_check;
                        }
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.suggestView reloadData];
                });
            } failure:^(NSError *error) {
                
            }];
        }
    }else{
        [self setLoginVC];
    }
}

#pragma =========== Lazy
- (NSMutableArray<HKMapModel*> *)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [[NSMutableArray alloc]init];
    }
    return _bannerArr;
}


- (NSMutableArray *)classArr {
    if (!_classArr) {
        _classArr = [[NSMutableArray alloc]init];
    }
    return _classArr;
}


- (NSMutableArray *)newDataArray {
    if (!_newDataArray) {
        _newDataArray = [[NSMutableArray alloc]init];
    }
    return _newDataArray;
}


- (NSMutableArray *)suggestArray {
    if (!_suggestArray) {
        _suggestArray = [[NSMutableArray alloc]init];
    }
    return _suggestArray;
}




- (NSMutableArray *)recommendOnePageArr {
    if (!_recommendOnePageArr) {
        _recommendOnePageArr = [[NSMutableArray alloc]init];
    }
    return _recommendOnePageArr;
}

- (NSMutableArray *)newOnePageArr {
    if (!_newOnePageArr) {
        _newOnePageArr = [[NSMutableArray alloc]init];
    }
    return _newOnePageArr;
}



- (NSMutableArray<HKLiveListModel*> *)liveListArr {
    if (!_liveListArr) {
        _liveListArr = [[NSMutableArray alloc]init];
    }
    return _liveListArr;
}


- (NSMutableArray<HKHomeVipModel*> *)vipListArr {
    if (!_vipListArr) {
        _vipListArr = [[NSMutableArray alloc]init];
    }
    return _vipListArr;
}


- (NSMutableArray<VideoModel*> *)vipVideoListArr {
    if (!_vipVideoListArr) {
        _vipVideoListArr = [[NSMutableArray alloc]init];
    }
    return _vipVideoListArr;
}

- (NSMutableArray * )signArray{
    if (_signArray == nil) {
        _signArray = [NSMutableArray array];
    }
    return _signArray;
}

//热搜词
- (NSMutableArray<NSString*>*)hotWordArray {
    if (!_hotWordArray) {
        _hotWordArray = [NSMutableArray array];
    }
    return  _hotWordArray;
}

//搜索记录
- (NSMutableArray<NSString*>*)searchHistoryArray {
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}


@end





