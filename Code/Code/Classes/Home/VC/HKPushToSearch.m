//
//  HKPushToSearch.m
//  Code
//
//  Created by Ivan li on 2021/7/20.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPushToSearch.h"
#import "PYSearch.h"
#import "SearchResultVC.h"
#import "TagModel.h"

@interface HKPushToSearch ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>
@property (nonatomic, weak) PYSearchViewController *searchViewController;
@property(nonatomic,strong)NSMutableArray<NSString*> *hotWordArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;
@property(nonatomic,strong) NSMutableArray <NSURLSessionDataTask *> *sessionTaskArray;

@property(nonatomic,strong)NSMutableArray * redirectWordsArray;
@property(nonatomic,strong)NSMutableArray<NSString*> *suggestArray;
//@property(nonatomic,strong)NSMutableArray<NSString*> *searchHistoryArray;
@property (nonatomic , assign) int index ;
@property (nonatomic, copy)NSString * keyWords;  //
@end

@implementation HKPushToSearch

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


- (void)hkPushToSearchWithVC:(UIViewController *)vc withKeyWord:(NSString *)keyWord withIndex:(int)index{
    self.index = index;
    self.keyWords = keyWord;
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
    
    vc.hidesBottomBarWhenPushed = YES;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)vc;
        [nav pushViewController:searchViewController animated:YES];
    }else{
        [vc.navigationController pushViewController:searchViewController animated:YES];
    }
    
    //[vc pushToOtherController:searchViewController];
    
    searchViewController.hk_hideNavBarShadowImage = YES;
    searchViewController.searchWord = keyWord;
    self.searchViewController = searchViewController;
    [self hotWordRequest];
    
    if (self.isPush && self.keyWords.length) {
            SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:self.keyWords];
            vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
            if (vc.viewcontrollers.count > index) {
                vc.selectIndex = self.index;
            }
            self.searchViewController.searchResultController = vc;
            
            [self.searchViewController saveSearchCacheAndRefreshView];
    }
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
        vc.selectIndex = self.index;
    }
}


- (void)searchViewController:(PYSearchViewController *)searchViewController  didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText {

    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        vc.selectIndex = self.index;
    }
    [MobClick event:um_searchpage_history];
}


- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText {
    if (searchText.length>0) {
        SearchResultVC * vc = [[SearchResultVC alloc]initWithNibName:nil bundle:nil keyWord:searchText];
        vc.redirectWordsArray = self.searchViewController.redirectWordsArray;
        searchViewController.searchResultController = vc;
        vc.selectIndex = self.index;
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
        vc.selectIndex = self.index;
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
//- (NSMutableArray<NSString*>*)searchHistoryArray {
//    if (!_searchHistoryArray) {
//        _searchHistoryArray = [NSMutableArray array];
//    }
//    return _searchHistoryArray;
//}

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


@end
