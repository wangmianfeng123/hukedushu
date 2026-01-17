//
//  HKAudioListVC.m
//  Codeww
///
//  Created by Ivan li on 2018/3/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleCategoryVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"

#import "TagModel.h"
#import "HKAudioListCell.h"

#import "UIBarButtonItem+Extension.h"
#import "HKAudioHotVC.h"
#import "HKAudioAllSortVC.h"
#import "HKArticleListVC.h"
#import "WMPageController+Category.h"
#import "HKArticleCategoryModel.h"
#import "HKArticleCategoryListVC.h"                                                 
#import "HKArticleCategoryModel.h"
#import "PYSearchViewController.h"

#import "PYSearch.h"
#import "SearchResultVC.h"

@interface HKArticleCategoryVC () <HKArticleListVCDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;


@property(nonatomic,strong)NSMutableArray<HKArticleCategoryModel *> *categoryDataSource;

@property (nonatomic, weak)UIView *todayCountView;
@property (nonatomic, weak) PYSearchViewController *searchViewController;
@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;
@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@property(nonatomic,strong)NSMutableArray * redirectWordsArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *suggestArray;


@end


@implementation HKArticleCategoryVC

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

#pragma mark <HKArticleListVCDelegate>
- (void)todayView:(NSString *)count hide:(BOOL)hide {
    [self setTodayView:count hide:hide];
}

- (void)setTodayView:(NSString *)count hide:(BOOL)hide {
    
    if (!self.todayCountView) {
        UIView *todayCountView = [[UIView alloc] init];
        todayCountView.backgroundColor = [UIColor orangeColor];
        todayCountView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame) - 30, self.view.width, 30);
        self.todayCountView = todayCountView;
        UILabel *countLB = [[UILabel alloc] init];
        countLB.frame = todayCountView.bounds;
        countLB.font = [UIFont systemFontOfSize:14.0];
        countLB.textColor = HKColorFromHex(0x27323F, 1.0);
        countLB.tag = 520;
        countLB.textAlignment = NSTextAlignmentCenter;
        countLB.backgroundColor = HKColorFromHex(0xFDDB3C, 1.0);
        [todayCountView addSubview:countLB];
        [self.view insertSubview:todayCountView belowSubview:self.menuView];
    }
    
    UILabel *countLB = [self.todayCountView viewWithTag:520];
    countLB.text = [NSString stringWithFormat:@"今日更新%@篇文章", count];
    
    // 显示
    if (!hide && count.length && count.intValue > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.todayCountView.y = CGRectGetMaxY(self.menuView.frame);;
        }];
        
    } else {// 隐藏
        [UIView animateWithDuration:0.3 animations:^{
            self.todayCountView.y = CGRectGetMaxY(self.menuView.frame) - 30;
        }];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.hk_hideNavBarShadowImage = YES;
    self.title = @"设计文章";
    self.navigationItem.title = self.title;
    [self setLeftBarButtonItem];
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithImage:[UIImage hkdm_imageWithNameLight:@"ic_search_notes_2_30" darkImageName:@"search_gray_dark"] target:self action:@selector(rightBarBtnAction) size:CGSizeMake(40, 40)];

    [self loadCategoryData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTodayView:@"11" hide:NO];
    });
}

-(void)rightBarBtnAction{
    NSLog(@"点击搜索");
    [self setSearchView];
    [MobClick event:designarticlepage_search];
}


- (void)prepareSetup {
    [super prepareSetup];
    //self.menuItemWidth = SCREEN_WIDTH * 0.185;
    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 25;
    self.menuViewContentMargin = 0;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0 ; i < self.titles.count; i++) {
            HKArticleListVC *vc2 = [[HKArticleListVC alloc] init];
            vc2.delegate = self;
            vc2.model = self.categoryDataSource[i];
            [array addObject:vc2];
        }
        _viewcontrollers = [NSArray arrayWithArray:array];
    }
    return _viewcontrollers;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hotWordRequest];
    
}

//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = COLOR_ffffff;
    return CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, kHeight44);
}

- (void)menuView:(WMMenuView *)menu moreButtonClick:(UIButton *)button {
    
    if (!self.categoryDataSource.count) return;
    
    WeakSelf;
    // 全部分类
    HKArticleCategoryListVC *vc = [[HKArticleCategoryListVC alloc] init];
    vc.dataSource = self.categoryDataSource;
    vc.didSelectHKArticleCategoryModelBlock = ^(HKArticleCategoryModel *model, int index) {
        weakSelf.selectIndex = index;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0,KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT-kHeight44);
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {

    return self.titles[index];
}



#pragma mark <Server>
- (void)loadCategoryData {

//    NSDictionary *dict = @{@"tag" : @"0", @"page" : @(1)};
    [HKHttpTool POST:@"article/get-tags" parameters:nil success:^(id responseObject) {

        if (HKReponseOK) {
            NSMutableArray *tagArr = [HKArticleCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tags"]];

            self.titles = [tagArr valueForKey:@"name"];
            self.categoryDataSource = tagArr;
            [self prepareSetup];
            [self reloadData];
        }
    } failure:^(NSError *error) {

    }];
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
        if (vc.viewcontrollers.count > 6) {
            vc.selectIndex = 6;
        }
    }
}


- (void)searchViewController:(PYSearchViewController *)searchViewController  didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {

    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        if (vc.viewcontrollers.count > 6) {
            vc.selectIndex = 6;
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
        if (vc.viewcontrollers.count > 6) {
            vc.selectIndex = 6;
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
        if (vc.viewcontrollers.count > 6) {
            vc.selectIndex = 6;
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

