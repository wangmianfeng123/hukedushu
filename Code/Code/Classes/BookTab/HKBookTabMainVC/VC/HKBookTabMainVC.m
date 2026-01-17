//
//  HKBookTabMainVC.m
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookTabMainVC.h"
#import "HKBookTabMainBannerCell.h"
#import "HKBookTabMainOfficialBookCell.h"
#import "HKBookModel.h"
#import "HKBookTabVC.h"
#import "HKListeningBookVC.h"
#import "HKCustomMarginLabel.h"
#import "UIBarButtonItem+Extension.h"
#import "PYSearch.h"
#import "SearchResultVC.h"
#import "TagModel.h"



@interface HKBookTabMainVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HKBookTabMainBannerDelegate,TBSrollViewEmptyDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>

@property (strong,nonatomic)UICollectionView *contentCollectionView;

@property (nonatomic,strong) NSMutableArray<UIViewController *> *viewcontrollers;

@property (nonatomic,strong)NSMutableArray  <HKMapModel*>*bannerArr;

@property (nonatomic,strong)HKBookModel  *bookModel;
/// tab
@property (nonatomic,strong)NSMutableArray <HKTagModel*>*tagArr;

@property(nonatomic,assign)BOOL isNeedHiddenNavigationBar;
///
@property(nonatomic,assign) CGFloat bannerHeight;

@property(nonatomic,assign) CGFloat contentOffsetY;

@property(nonatomic,assign) BOOL isCanRefresh;

@property (nonatomic, weak) PYSearchViewController *searchViewController;
@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;

@property(nonatomic,strong)NSMutableArray * redirectWordsArray;
/** 搜索热词 */
@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *suggestArray;
@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@end



@implementation HKBookTabMainVC


- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
            // 主题模式 发生改变
            if (_tagArr.count) {
                [self setDarkUI];
                [self wm_resetMenuView];
            }
    }
}

//搜索记录
- (NSMutableArray<NSString*>*)searchHistoryArray {
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}

- (NSMutableArray<NSString*>*)hotWordArray {
    if (!_hotWordArray) {
        _hotWordArray = [NSMutableArray array];
    }
    return  _hotWordArray;
}

- (NSMutableArray <NSURLSessionDataTask *> *)sessionTaskArray{
    if (!_sessionTaskArray) {
        _sessionTaskArray = [NSMutableArray array];
    }
    return _sessionTaskArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}



#pragma mark - 添加StatusBar
static UIView *statusBar = nil;
- (void)addStatusBar:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        if(!statusBar) {
            statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
            statusBar.backgroundColor = color;
            [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
        }else{
            statusBar.backgroundColor = color;
        }
    }else{
        [self setStatusBarColor:color];
    }
}


- (void)setStatusBarColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


#pragma mark - 移除StatusBar
- (void)removeStatusBar {
    if(@available(iOS 13.0, *)) {
        if(statusBar) {
            TTVIEW_RELEASE_SAFELY(statusBar);
        }
    }else{
        [self setStatusBarColor:[UIColor clearColor]];
    }
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    // 推广渠道
    [HkChannelData requestHkChannelData];
    if (self.isNeedHiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self addStatusBar:COLOR_FFFFFF_3D4752];
    [self hotWordRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    //[self addStatusBar:[UIColor whiteColor]];
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.contentOffsetY>0) {
            if ([self.view viewWithTag:100]) {
                //强制设置 Offset 由于有的机型侧滑返回 触发 scrollViewDidScroll
                [self setContentViewContentOffset:self.contentOffsetY];
            }
        }
        self.isCanRefresh = YES;
    });
}


- (void)viewDidDisappear:(BOOL)animated {
    [self removeStatusBar];
    [super viewDidDisappear:animated];
    self.isCanRefresh = NO;
}




- (void)createUI {
    [self setTitle:@"虎课读书" color:COLOR_27323F_EFEFF6];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.hk_hideNavBarShadowImage = YES;
    [self getBannerInfo];
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:image highBackgroudImage:image target:self action:@selector(backAction)];
    
//    [self createRightBarButtonWithImage:@"ic_search_notes_2_30" size:CGSizeMake(40, 40)];
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithImage:[UIImage hkdm_imageWithNameLight:@"ic_search_notes_2_30" darkImageName:@"search_gray_dark"] target:self action:@selector(rightBarBtnAction) size:CGSizeMake(40, 40)];
//    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"ic_search_notes_2_30"
//                                                                            highBackgroudImageName:@"ic_search_notes_2_30"
//                                                                                            target:self
//                                                                                            action:@selector(rightBarBtnAction) size:CGSizeMake(40, 40)];

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)rightBarBtnAction{
    NSLog(@"点击搜索");
    [self setSearchView];
    
    [MobClick event:hukedushushouye_search];
}

#pragma mark  导航栏上的标题
- (void)setTitle:(NSString *)title color:(UIColor*)color {
    
    HKCustomMarginLabel *_title = [[HKCustomMarginLabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = HK_FONT_SYSTEM_BOLD(20);
    _title.textInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    _title.text = title;
    _title.textColor = color;
    
    self.navigationItem.titleView = _title;
}



- (NSMutableArray <HKTagModel*>*)tagArr {
    if (!_tagArr) {
        _tagArr = [NSMutableArray array];
    }
    return _tagArr;
}



- (NSMutableArray<HKMapModel*>*)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}



- (UICollectionView*)contentCollectionView {
    if (!_contentCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing =0;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.frame = CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, self.bannerHeight +190);
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.tag = 100;
        
        [_contentCollectionView registerClass:[HKBookTabMainBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([HKBookTabMainBannerCell class])];
        [_contentCollectionView registerClass:[HKBookTabMainOfficialBookCell class] forCellWithReuseIdentifier:NSStringFromClass([HKBookTabMainOfficialBookCell class])];
        HKAdjustsScrollViewInsetNever(self, _contentCollectionView);
        _contentCollectionView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _contentCollectionView;
}




#pragma mark <UICollectionViewDelegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (isEmpty(self.bookModel.book_id) && (self.tagArr.count == 0)) {
        return 0;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    NSInteger section = indexPath.section;
    if (0 == section) {
        HKBookTabMainBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKBookTabMainBannerCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.didSelectItemblock = ^(HW3DBannerView * _Nonnull bannerView, NSInteger index) {
            if (self.bannerArr.count >index) {
                HKMapModel *mapModel = weakSelf.bannerArr[index];
                [HKH5PushToNative runtimePush:mapModel.redirect_package.className arr:mapModel.redirect_package.list currectVC:weakSelf];
                [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"2" bookId:@"0" courseId:@"0"];
            }
            [MobClick event:um_hukedushushouye_banner];
        };
        [cell setBannerWithUrlArray:self.bannerArr];
        return cell;
    }else {
        HKBookTabMainOfficialBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKBookTabMainOfficialBookCell class])
                                                                                        forIndexPath:indexPath];
        WeakSelf;
        cell.playBtnClickBlock = ^(HKBookModel * _Nonnull model) {
            HKListeningBookVC *bookVC = [HKListeningBookVC new];
            bookVC.bookId = model.book_id;
            bookVC.courseId = model.course_id;
            [weakSelf.navigationController pushViewController:bookVC animated:YES];
            [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"2" bookId:model.book_id courseId:model.course_id];
        };
        cell.model = self.bookModel;
        return cell;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (1 == indexPath.section) {
        HKListeningBookVC *bookVC = [HKListeningBookVC new];
        bookVC.bookId = self.bookModel.book_id;
        bookVC.courseId = self.bookModel.course_id;
        [self.navigationController pushViewController:bookVC animated:YES];
        [MobClick event:um_hukedushushouye_meiridushu];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        return self.bannerArr.count? CGSizeMake(SCREEN_WIDTH, self.bannerHeight) : CGSizeMake(SCREEN_WIDTH, isEmpty(self.bookModel.book_id) ?0 :0.01);
    }else{
        return CGSizeMake(SCREEN_WIDTH, isEmpty(self.bookModel.book_id) ?0 :190);
    }
}


static CGFloat kWMMenuViewHeight = 50.0;

- (void)prepareSetup {
    kWMMenuViewHeight = (IS_IPHONE_X ?(55.0) :(50.0));
    
    // 标题
    NSMutableArray *titleArr = [NSMutableArray array];
    // 间距
    NSMutableArray *marginArr = [NSMutableArray array];
    [marginArr addObject:@15];
    
    for (HKTagModel *tagModel in self.tagArr) {
        HKBookTabVC *book = [[HKBookTabVC alloc]init];
        book.tagModel = tagModel;
        [self.viewcontrollers addObject:book];
        [titleArr addObject:tagModel.tag];
        [marginArr addObject:@20];
    }
    
    self.titles = titleArr.copy;
    self.itemsMargins = marginArr.copy;
    
    [self setDarkUI];
    self.menuViewHeight = kWMMenuViewHeight;
    self.maximumHeaderViewHeight = KNavBarHeight64;
    
    if (self.bannerArr.count) {
        self.maximumHeaderViewHeight += self.bannerHeight;
    }
    
    if (NO == isEmpty(self.bookModel.book_id)) {
        self.maximumHeaderViewHeight += 190;
    }
    //self.minimumHeaderViewHeight = 20;
    self.minimumHeaderViewHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self reloadData];
}


- (void)setDarkUI {
    self.controllerType = WMStickyPageControllerType_ordinary;
    self.automaticallyCalculatesItemWidths = YES;
        
    UIColor *normalColor = [UIColor hkdm_colorWithColorLight:COLOR_2C3949 dark:COLOR_EFEFF6];
    UIColor *selectColor = [UIColor hkdm_colorWithColorLight:COLOR_344153 dark:COLOR_EFEFF6];
    self.titleColorNormal = normalColor;
    self.titleColorSelected = selectColor;
    
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 17;
}




- (NSMutableArray<UIViewController *> *)viewcontrollers {
    if (nil == _viewcontrollers ) {
        _viewcontrollers = [NSMutableArray array];
    }
    return _viewcontrollers;
}



#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return self.viewcontrollers.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    return self.viewcontrollers[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, self.maximumHeaderViewHeight+kWMMenuViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT- kWMMenuViewHeight);
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index >= self.titles.count) return nil;
    return self.titles[index];
}


- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex {
    [MobClick event:um_hukedushushouye_biaoqian];
}




- (void)pageController:(WMStickyPageController *)pageController scrollViewDidScrollWithSubview:(UIScrollView *)subview {
    
    if (self.isCanRefresh) {
        if (subview.contentOffset.y >= self.maximumHeaderViewHeight - kWMMenuViewHeight) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            self.isNeedHiddenNavigationBar = YES;
            self.contentOffsetY = subview.contentOffset.y;
            
        }else{
            self.isNeedHiddenNavigationBar = NO;
            self.contentOffsetY = subview.contentOffset.y;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}



- (void)getBannerInfo {
    [HKHttpTool POST:BOOK_GET_BANNER parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            HKBookModel *bookModel = [HKBookModel mj_objectWithKeyValues:responseObject[@"data"][@"dailyBook"]];
            self.bookModel = bookModel;
            self.tagArr = [HKTagModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"bookTags"]];
            self.bannerArr = [HKMapModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"bannerList"]];
            
            // test
//                self.bookModel = [HKBookModel new];
//                self.bookModel.book_id = @"123";
//                self.bookModel.title = @"虎课虎课虎课虎课虎课虎课虎课虎课";
//                self.bookModel.listen_number = @"123";
//                self.bookModel.cover  = @"http://file02.16sucai.com/d/file/2014/0829/372edfeb74c3119b666237bd4af92be5.jpg";
//                self.bookModel.short_introduce = @"ddddddddd";
//
//                [self.bannerArr removeAllObjects];

            
            if (self.bannerArr.count) {
                CGFloat realHeight = (SCREEN_WIDTH - 30.0) * 240.0 / 690.0;
                self.bannerHeight = floor(realHeight);
            }
            if (nil == [self.view viewWithTag:100]) {
                [self.view addSubview:self.contentCollectionView];
            }
            
            self.contentCollectionView.height = 0;
            if (self.tagArr.count) {
                self.contentCollectionView.height += self.bannerHeight;
            }
            
            if (NO == isEmpty(self.bookModel.book_id)) {
                self.contentCollectionView.height += 190;
            }
            //self.contentCollectionView.height = self.bannerHeight +195;
            [self.contentCollectionView reloadData];
            [self prepareSetup];
        }
    } failure:^(NSError *error) {
        if (nil == [self.view viewWithTag:100]) {
            [self.view addSubview:self.contentCollectionView];
            self.contentCollectionView.height = SCREEN_HEIGHT;
            [self.contentCollectionView reloadData];
            [self.contentCollectionView reloadData];
        }
    }];
}



- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    [self getBannerInfo];
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
    [self.navigationController pushViewController:searchViewController animated:YES];
    //[self pushToOtherController:searchViewController];

    searchViewController.hk_hideNavBarShadowImage = YES;
    self.searchViewController = searchViewController;

    [self hotWordRequest];
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText {
    
    if (searchText.length>0) {
        [self suggestWordWithSearchText:searchText];
    }
}



- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {

    if (searchText.length>0) {
        [MobClick event:UM_RECORD_SEARCH_PAGE_HOT];
        
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        if (vc.viewcontrollers.count > 5) {
            vc.selectIndex = 5;
        }
    }
}


- (void)searchViewController:(PYSearchViewController *)searchViewController  didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {

    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        if (vc.viewcontrollers.count > 5) {
            vc.selectIndex = 5;
        }
    }
    [MobClick event:um_searchpage_history];
}


- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        if (vc.viewcontrollers.count > 5) {
            vc.selectIndex = 5;
        }
    }
}



- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar {

    if (self.suggestArray.count > indexPath.row) {
        NSString *text = self.suggestArray[indexPath.row];
        searchBar.text = text;
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:text];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        if (vc.viewcontrollers.count > 5) {
            vc.selectIndex = 5;
        }
    }
    [MobClick event:um_searchpage_related];
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
    
    
    NSString *url = hk_testServer == 1 ? SEARCH_RECOMMEND_WORD_TEST : SEARCH_RECOMMEND_WORD;
    //NSString *url = HKIsDebug ?SEARCH_RECOMMEND_WORD_TEST :SEARCH_RECOMMEND_WORD;
    
    NSURLSessionDataTask *sessionTask = [HKHttpTool hk_taskPost:nil allUrl:url isGet:YES parameters:@{@"word":searchText} success:^(id responseObject) {
        if ([responseObject[@"data"][@"lists"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"data"][@"lists"];
            self.suggestArray = arr.mutableCopy;
            
            self.searchViewController.searchSuggestions = self.suggestArray;
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

- (void)hotWordRequest {
    // 无热门搜索数据
    [HKHttpTool POST:@"/search/search-words" parameters:nil success:^(id responseObject) {
        if (HKReponseOK){
            [self.searchHistoryArray removeAllObjects];
            [self.hotWordArray removeAllObjects];
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


@end

