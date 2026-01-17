//
//  HKCategoryVC.m
//  Code
//
//  Created by Ivan li on 2018/4/13.2223355
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCategoryVC.h"
#import "HKCategoryRightView.h"
#import "UIView+SNFoundation.h"
#import "HKCategoryTreeModel.h"
//#import "DesignTableVC.h"
#import "PYSearch.h"
#import "AppDelegate.h"
#import "SearchBar.h"
#import "SearchResultVC.h"
#import "SoftwareVC.h"
#import "SeriseCourseVC.h"
#import "HKH5PushToNative.h"
#import "HKCategoryAlbumVC.h"
#import "TagModel.h"
#import "HKPgcCategoryVC.h"
#import "HKUMpopViewController.h"
#import "HKUserInfoSettingVC.h"
#import "HKSoftwareVC.h"
#import "SeriseCourseVC.h"
#import "HKTeacherDetailVC.h"
#import "VideoPlayVC.h"
#import "HKNavigationController.h"
#import "HKListeningBookVC.h"
#import "HKJobPathModel.h"
#import "HKCategoryLeftView.h"
#import "HKInternetSchoolVC.h"
#import "HKCategorySoftwareVC.h"
#import "HKCategoryDesignVC.h"
#import "HKCategoryDevelopVC.h"
#import "HKCategoryStudentVC.h"
#import "HKCategoryReadBookVC.h"
#import "HKCategoryJobPathVC.h"
#import "HKLeftMenuModel.h"

static CGFloat const Left_Space = 190/2;
static CGFloat const Left_Space_Intert = 0;//15;

@interface HKCategoryVC ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource> {
    
    CGFloat Top_Height;
    CGFloat header_search_top;
}

@property (nonatomic, weak) VideoModel *viewModel;

//@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) HKLeftMenuModel * selectedLeftModel;

///key1:section key2:row
@property (nonatomic, strong) NSMutableDictionary *allSubTreeCategoryDict;
/** 搜索热词 */
@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;

@property (nonatomic, weak) PYSearchViewController *searchViewController;

@property (nonatomic, strong) HKCategoryLeftView *leftTableView;
// 默认选中
//@property (nonatomic, assign)NSInteger defalutSelectedRow;

@property(nonatomic,strong)NSMutableArray<NSString*> *suggestArray;

@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@property(nonatomic,strong) HKInternetSchoolVC *internetSchoolVC;

@property(nonatomic,strong) HKCategorySoftwareVC *softwareVC;

@property(nonatomic,strong) HKCategoryDesignVC *designVC;

@property(nonatomic,strong) HKCategoryDevelopVC *developVC;

@property(nonatomic,strong) HKCategoryStudentVC *studentVC;

@property(nonatomic,strong) HKCategoryReadBookVC *readBookVC;

@property(nonatomic,strong) HKCategoryJobPathVC *jobPathVC;
@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;

@property(nonatomic,strong)NSMutableArray * redirectWordsArray;
@property (nonatomic , strong) SearchBar *searchBar;

@end



@implementation HKCategoryVC


- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setSearchBar];
        Top_Height = KNavBarHeight64;
        
//        HKLeftMenuModel * model = [[HKLeftMenuModel alloc] init];
//        model.ID = 6;
//        model.name = @"虎课读书";
//        model.corner_word = @"";
//        model.type = 5;
//        self.selectedLeftModel = model;
    

//        self.defalutSelectedRow = 5;
//        self.selectedIndex = HKCategoryType_readBooks;
        [self createSubviews];
        
        [self selectTabItemIndexNotification];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCatagoryData];
}

- (void)loadCatagoryData{
    @weakify(self);
    [HKHttpTool POST:HK_CategoryLeftMenu_URL parameters:nil success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.leftModelArr = [HKLeftMenuModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.leftTableView.leftDataArray = self.leftModelArr;
            int index = 0;
            for (int i = 0; i<self.leftModelArr.count;i++ ) {
                HKLeftMenuModel * model = self.leftModelArr[i];
                if (model.type == 0) {
                    index = i;
                    self.selectedLeftModel = model;
                    break;
                }
            }
            self.leftTableView.selectedIndex = index;
            [self setDefaultViewWithLeftModel:self.selectedLeftModel];
            [self.leftTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

// 监听首页读书点击更多
- (void)selectTabItemIndexNotification {
    HK_NOTIFICATION_ADD(HKSelectTabItemIndexNotification, selectLeftTableViewItem:);
}

- (void)selectLeftTableViewItem:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    if (dict && dict[@"HKCategoryVCIndex"]) {
        NSUInteger index = [dict[@"HKCategoryVCIndex"] integerValue];
        [self.leftTableView tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
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
    if (@available(iOS 12.0, *)) {
        [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    }
    [self setDefaultViewWithLeftModel:self.selectedLeftModel];
    if (self.selectedLeftModel.type == 5) {//虎课读书
        // 统计列表
        [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"1" bookId:@"0" courseId:@"0"];
        [MobClick event:UM_RECORD_CATEGORY_PAGE_HUKEDUSHU];
    }
    // 推广渠道
    [HkChannelData requestHkChannelData];
    self.searchBar.searchBarBackgroundColor = COLOR_EFEFF6_333D48;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.leftModelArr.count) {
        [self loadCatagoryData];
    }
}



- (void)setSearchBar {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH-PADDING_10*2, kHeight44);
    if (@available(iOS 13.0, *)) {
        rect = CGRectMake(0, 0, SCREEN_WIDTH-PADDING_10*3, kHeight44);
    }
    
    SearchBar *searchBar = [SearchBar searchBarWithPlaceholder:SEARCH_TIP_CATEGORY frame:rect];
    searchBar.searchBarBackgroundColor = COLOR_EFEFF6_333D48;
    if (@available(iOS 11.0, *)) {
        UIView *titleView = [[UIView alloc]initWithFrame:searchBar.bounds];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.clipsToBounds = YES;
        [titleView addSubview:searchBar];
        self.navigationItem.titleView = titleView;
    }else{
        self.navigationItem.titleView = searchBar;
    }
    WeakSelf;
    searchBar.searchBarShouldBeginEditingBlock = ^(UISearchBar *searchBar) {
        [MobClick event:UM_RECORD_CATEGORY_SEARCH];
        [weakSelf setSearchView];
        [searchBar resignFirstResponder];
    };
    
    self.searchBar = searchBar;
    self.searchBar.didClickBlock = ^(UISearchBar *searchBar,NSString *searchWord) {
        [MobClick event:UM_RECORD_HOME_SEARCH];
        [weakSelf setSearchView];
        [searchBar resignFirstResponder];
        weakSelf.searchViewController.searchWord = searchWord;
    };
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


- (NSMutableArray <NSString*>*)suggestArray {
    if (!_suggestArray) {
        _suggestArray = [NSMutableArray new];
    }
    return _suggestArray;
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

//搜索记录
- (NSMutableArray<NSString*>*)searchHistoryArray {
    if (!_searchHistoryArray) {
        _searchHistoryArray = [NSMutableArray array];
    }
    return _searchHistoryArray;
}

- (void)hotWordRequest {

//    if (0 == self.hotWordArray.count) {
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
//    }else{
//        if (self.searchViewController && 0 == self.searchViewController.hotSearches.count) {
//            self.searchViewController.hotSearches = self.hotWordArray;
//        }
//    }
}




- (void)createSubviews {
    self.title = @"分类";
    [self createLeftView];
    //[self setDefaultViewWithLeftModel:self.selectedLeftModel];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.hk_hideNavBarShadowImage = YES;
}


- (CGRect)view_rect  {
    CGFloat X = self.leftTableView.right- Left_Space_Intert;
    CGFloat Y = self.leftTableView.top;
    CGFloat rightWi = self.view.width - X;
    CGRect rect = CGRectMake(X, Y, rightWi, SCREEN_HEIGHT-Y);
    return rect;
}



- (HKInternetSchoolVC*)internetSchoolVC {
    if (!_internetSchoolVC) {
        CGRect rect = [self view_rect];
        _internetSchoolVC = [[HKInternetSchoolVC alloc]initWitFrame:rect];
    }
    return _internetSchoolVC;
}


- (HKCategorySoftwareVC*)softwareVC {
    if (!_softwareVC) {
        CGRect rect = [self view_rect];
        _softwareVC = [[HKCategorySoftwareVC alloc]initWitFrame:rect];
    }
    return _softwareVC;
}


- (HKCategoryReadBookVC*)readBookVC {
    if (!_readBookVC) {
        CGRect rect = [self view_rect];
        _readBookVC = [[HKCategoryReadBookVC alloc]initWitFrame:rect];
    }
    return _readBookVC;
}


- (HKCategoryDevelopVC*)developVC {
    if (!_developVC) {
        CGRect rect = [self view_rect];
        _developVC = [[HKCategoryDevelopVC alloc]initWitFrame:rect];
    }
    return _developVC;
}


- (HKCategoryStudentVC*)studentVC {
    if (!_studentVC) {
        CGRect rect = [self view_rect];
        _studentVC = [[HKCategoryStudentVC alloc]initWitFrame:rect];
    }
    return _studentVC;
}


- (HKCategoryDesignVC*)designVC {
    if (!_designVC) {
        CGRect rect = [self view_rect];
        _designVC = [[HKCategoryDesignVC alloc]initWitFrame:rect];
    }
    return _designVC;
}



- (HKCategoryJobPathVC*)jobPathVC {
    if (!_jobPathVC) {
        CGRect rect = [self view_rect];
        _jobPathVC = [[HKCategoryJobPathVC alloc]initWitFrame:rect];
    }
    return _jobPathVC;
}




#pragma mark - 设置默认选中View
- (void)setDefaultViewWithLeftModel:(HKLeftMenuModel *)leftModel {
    
    if (leftModel.type == 0) {//软件入门
        [self addSoftwareVCWithLeftModel:leftModel];
    }else if (leftModel.type == 1) {//设计教程
        [self addDesignVCWithLeftModel:leftModel];
    }else if (leftModel.type == 2) {//职业办公
        [self addDevelopVCWithLeftModel:leftModel];
    }else if (leftModel.type == 3) {//学生专区
        [self addStudentVCWithLeftModel:leftModel];
    }else if (leftModel.type == 4) {//职业路径
        [self addJobPathVCWithLeftModel:leftModel];
    }else if (leftModel.type == 5) {//虎课读书
        [self addReadBookVCWithLeftModel:leftModel];
    }else if (leftModel.type == 6) {//虎课网校
        [self addInternetSchoolVCWithLeftModel:leftModel];
    }
}


- (void)addInternetSchoolVCWithLeftModel:(HKLeftMenuModel *)model {
    self.internetSchoolVC.ID = model.ID;
    [self addChildrenVC:self.internetSchoolVC];
    [self.internetSchoolVC refreshData];
}


- (void)addSoftwareVCWithLeftModel:(HKLeftMenuModel *)model  {
    self.softwareVC.ID = model.ID;
    [self addChildrenVC:self.softwareVC];
    [self.softwareVC refreshData];
}


- (void)addDesignVCWithLeftModel:(HKLeftMenuModel *)model  {
    self.designVC.ID = model.ID;
    [self addChildrenVC:self.designVC];
    [self.designVC refreshData];
}


- (void)addStudentVCWithLeftModel:(HKLeftMenuModel *)model  {
    self.studentVC.ID = model.ID;
    [self addChildrenVC:self.studentVC];
    [self.studentVC refreshData];
}


- (void)addDevelopVCWithLeftModel:(HKLeftMenuModel *)model  {
    self.developVC.ID = model.ID;
    [self addChildrenVC:self.developVC];
    [self.developVC refreshData];
}


- (void)addReadBookVCWithLeftModel:(HKLeftMenuModel *)model  {
    self.readBookVC.ID = model.ID;
    [self addChildrenVC:self.readBookVC];
    [self.readBookVC refreshData];
}


- (void)addJobPathVCWithLeftModel:(HKLeftMenuModel *)model  {
    self.jobPathVC.ID = model.ID;
    [self addChildrenVC:self.jobPathVC];
    [self.jobPathVC refreshData];
}


- (void)addChildrenVC:(UIViewController*)childVC {
    if ( ![[self childViewControllers] containsObject:childVC]) {
        [self addChildViewController:childVC];
        [self.view addSubview:childVC.view];
        [childVC didMoveToParentViewController:self];
    }
    [self.view bringSubviewToFront:childVC.view];
}



- (void)createLeftView {
        
    self.leftTableView = [[HKCategoryLeftView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.leftTableView.width = Left_Space;
    
    self.leftTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.leftTableView.tableFooterView = [UIView new];
//    self.leftTableView.selectedIndex = self.defalutSelectedRow;
    [self.view addSubview:self.leftTableView];
    
    self.leftTableView.leftDataArray = self.leftModelArr;
    @weakify(self);
    self.leftTableView.cellClickBlock = ^(NSInteger index, NSString *_id, HKLeftMenuModel *leftMenuModel) {
        @strongify(self);
        HKLeftMenuModel * lastModel = self.selectedLeftModel;
        self.selectedLeftModel = leftMenuModel;
        if (lastModel != leftMenuModel && leftMenuModel.type == 5) {
            // 统计列表
            [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"1" bookId:@"0" courseId:@"0"];
        }
        
        if (leftMenuModel.type == 0) {//软件入门
            [MobClick event:UM_RECORD_DETAIL_PAGE_RUANJIAN_RUMEN];
            [self addSoftwareVCWithLeftModel:leftMenuModel];
        }else if (leftMenuModel.type == 1) {//设计教程
            [MobClick event:UM_RECORD_DETAIL_PAGE_SHEJI_JIAOCHENG];
            [self addDesignVCWithLeftModel:leftMenuModel];
        }else if (leftMenuModel.type == 2) {//职业办公
            [MobClick event:UM_RECORD_DETAIL_PAGE_ZHIYE_FAZHAN];
            [self addDevelopVCWithLeftModel:leftMenuModel];
        }else if (leftMenuModel.type == 3) {//学生专区
            [MobClick event:um_fenleiye_xueshengtab];
            [self addStudentVCWithLeftModel:leftMenuModel];
        }else if (leftMenuModel.type == 4) {//职业路径
            [MobClick event:fenleiye_zhiyelujingtab];
            [self addJobPathVCWithLeftModel:leftMenuModel];
        }else if (leftMenuModel.type == 5) {//虎课读书
            [self addReadBookVCWithLeftModel:leftMenuModel];
        }else if (leftMenuModel.type == 6) {//虎课网校
            [self addInternetSchoolVCWithLeftModel:leftMenuModel];
            [MobClick event:fenleiye_hukewangxiao];
        }
    };
//    self.leftTableView.cellClickBlock = ^(NSInteger index, NSString *_id, HKCategoryType categoryType) {
//        @strongify(self);
//        NSInteger lastIndex = self.selectedIndex;
//        self.selectedIndex = categoryType;
//        if (lastIndex != categoryType && HKCategoryType_readBooks == categoryType) {
//            // 统计列表
//            [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"1" bookId:@"0" courseId:@"0"];
//        }
//        switch (categoryType) {
//            case HKCategoryType_software:
//                [MobClick event:UM_RECORD_DETAIL_PAGE_RUANJIAN_RUMEN];
//                [self addSoftwareVC];
//                break;
//                
//            case HKCategoryType_designCourse:
//                [MobClick event:UM_RECORD_DETAIL_PAGE_SHEJI_JIAOCHENG];
//                [self addDesignVC];
//                break;
//                
//            case HKCategoryType_student:
//                [MobClick event:um_fenleiye_xueshengtab];
//                [self addStudentVC];
//                break;
//                
//            case HKCategoryType_develop:
//                [MobClick event:UM_RECORD_DETAIL_PAGE_ZHIYE_FAZHAN];
//                [self addDevelopVC];
//                break;
//                
//            case HKCategoryType_readBooks:
//                [self addReadBookVC];
//                break;
//                
//            case HKCategoryType_school:
//                [self addInternetSchoolVC];
//                [MobClick event:fenleiye_hukewangxiao];
//                break;
//                
//            case HKCategoryType_jobPath:
//                [MobClick event:fenleiye_zhiyelujingtab];
//                [self addJobPathVC];
//                break;
//        }
//    };
}



//- (NSMutableArray <HKCategoryTreeModel*>*)leftModelArr {
//
//    if (!_leftModelArr) {
//        _leftModelArr = [NSMutableArray array];
//        for (int i = 0; i <= 6; i++) {
//            HKCategoryTreeModel *model = [HKCategoryTreeModel new];
//            model.isNew = NO;
//            NSString *title = nil;
//            switch (i) {
//                case 0:
//                    title = [NSString stringWithFormat:@"软件入门"];
//                    model.isNew = YES;
//                    model.categoryType = HKCategoryType_software;
//                    break;
//                case 1:
//                    title = [NSString stringWithFormat:@"设计教程"];
//                    model.categoryType = HKCategoryType_designCourse;
//                    break;
//                case 2:
//                    title = [NSString stringWithFormat:@"学生专区"];
//                    model.categoryType = HKCategoryType_student;
//                    break;
//                case 3:
//                    title = [NSString stringWithFormat:@"职业办公"];
//                    model.categoryType = HKCategoryType_develop;
//                    break;
//                case 4:
//                    title = [NSString stringWithFormat:@"职业路径"];
//                    model.categoryType = HKCategoryType_jobPath;
//                    break;
//                case 5:
//                    title = [NSString stringWithFormat:@"虎课读书"];
//                    model.categoryType = HKCategoryType_readBooks;
//                    break;
//                case 6:
//                    title = [NSString stringWithFormat:@"虎课网校"];
//                    model.categoryType = HKCategoryType_school;
//                    break;
//            }
//            model.title = title;
//            [_leftModelArr addObject:model];
//        }
//    }
//    return _leftModelArr;
//}




- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}



@end






