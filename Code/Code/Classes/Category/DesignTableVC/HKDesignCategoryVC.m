//
//  HKDesignCategoryVC.m
//  Code
//
//  Created by Ivan li on 2020/12/14.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKDesignCategoryVC.h"
#import "DesignTableVC.h"
#import "WMPageController+Category.h"
#import "HKDesignTypeModel.h"
#import "SearchBar.h"
#import "PYSearch.h"
#import "TagModel.h"
#import "SearchResultVC.h"

@interface HKDesignCategoryVC ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>
@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;
@property (nonatomic , strong) NSArray * dataArray;

/** 搜索栏 */
@property(nonatomic,strong)SearchBar *searchBar;
@property (nonatomic, weak) PYSearchViewController *searchViewController;
@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;

@property(nonatomic,strong)NSMutableArray * redirectWordsArray;
/** 搜索热词 */
@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *suggestArray;
@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;
@property (nonatomic , assign) int currentIndex ;
@end

@implementation HKDesignCategoryVC
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

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    //self.category = @"1";
    self.currentIndex = 0;
    [self createUI];
    [self loadData];
    [self setSearchBar];
}

- (void)setSearchBar {
    CGFloat leftMargin = IS_IPHONE_XS ? -10 : 0;
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH-15-60, 44);
    
    self.searchBar = [SearchBar searchBarWithPlaceholder:SEARCH_TIP_CATEGORY frame:rect];
    self.searchBar.searchBarBackgroundColor = COLOR_EFEFF6_333D48;
    
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
        [MobClick event:list_search];
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

- (void)loadData{
    if (self.category.length) {
        NSDictionary *param = @{@"class_id" : self.category};
        @weakify(self);
        [HKHttpTool POST:@"/video/class-video-head" parameters:param success:^(id responseObject) {
            @strongify(self);
            if (HKReponseOK) {
                self.dataArray = [HKDesignTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            }
            
            NSInteger index = 0;
            for (int i = 0; i<self.dataArray.count; i++) {
                HKDesignTypeModel * model = self.dataArray[i];
                NSString * class_id = [NSString stringWithFormat:@"%@",model.class_id];
                if ([class_id isEqualToString:self.category]) {
                    self.currentIndex = i;
                }
            }
            
            [self prepareSetup];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    [self hotWordRequest];
    
}

- (void)createUI {
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.size = CGSizeMake(PADDING_35, PADDING_35);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.hk_hideNavBarShadowImage = YES;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/*************************  UIViewController **************************/
- (void)prepareSetup {
    NSMutableArray *arrayVC = [NSMutableArray array];
    for (int i  = 0; i<self.dataArray.count; i++) {
        HKDesignTypeModel * typeModel = self.dataArray[i];
        DesignTableVC *VC =  [[DesignTableVC alloc] init];
        if (self.currentIndex == i) {
            VC.defaultSelectedTag = self.defaultSelectedTag;
        }
        VC.typeModel = typeModel;
        [arrayVC addObject:VC];
    }
    self.viewcontrollers = arrayVC;
    self.controllerType = WMStickyPageControllerType_videoDetail;
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewHeight = 40.0;
    self.itemMargin = 15;
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;

    if (self.currentIndex<self.dataArray.count) {
        self.selectIndex = self.currentIndex;
    }
    
    [self reloadData];
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    [MobClick event: list_tab];
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index<self.dataArray.count) {
        HKDesignTypeModel * typeModel = self.dataArray[index];
        return typeModel.name;
    }
    return @"";
    
}

- (BOOL)pageController:(WMStickyPageController *)pageController shouldScrollWithSubview:(UIScrollView *)subview {
    
    return NO;
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

    if (self.suggestArray.count > indexPath.row) {
        NSString *text = self.suggestArray[indexPath.row];
        searchBar.text = text;
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:text];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
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

@end
