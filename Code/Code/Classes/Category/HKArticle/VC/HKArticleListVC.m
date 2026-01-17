
//
//  HKAudioHotVC.m
//  Code
//
//  Created by Ivan li on 2018/4/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKArticleListVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"
#import "TagModel.h"
#import "HKAudioListCell.h"

#import "UIBarButtonItem+Extension.h"
#import "HKArticleModel.h"
#import "HKArticleCell.h"
#import "HKArticleDetailVC.h"
#import "HKArticleCategoryModel.h"

@interface HKArticleListVC ()<TBSrollViewEmptyDelegate, UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NSMutableArray *tagsArr;

@property(nonatomic,strong)UITableView   *tableView;

/** 接口数据 页码 */
@property(nonatomic,assign)NSInteger page;



@end


@implementation HKArticleListVC

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self refreshUI];
    
    // 收藏文章空视图
    if (self.isMyCollection) {
        self.emptyText = EMPETY_NO_COLLECTION;
    }
}


- (void)creatUI {
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self hkDarkMoldel];
//    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccess);
}

//- (void)loginSuccess{
//    [self.tableView.mj_header beginRefreshing];
//}

- (void)hkDarkMoldel {
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    //self.tableView.backgroundColor = COLOR_F8F9FA_3D4752;
    self.tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.tableView.separatorColor = COLOR_F8F9FA_333D48;
}


- (UITableView*)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_EH - 40 ) style:UITableViewStylePlain];
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.005;
        _tableView.sectionFooterHeight = 0.005;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKArticleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKArticleCell class])];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.tb_EmptyDelegate = self;
        
        if (!self.isMyCollection && !self.isTeacherVC) {
            _tableView.contentInset = UIEdgeInsetsMake(40, 0, KTabBarHeight49, 0);
        } else if (self.isMyCollection) {
            _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, KTabBarHeight49, 0);
        } else {
            _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, KTabBarHeight49, 0);
        }
    }
    return _tableView;
}




#pragma mark <UITablViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count > 0 ? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKArticleCell class])];
    cell.model = self.dataSource[[indexPath row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKArticleDetailVC *vc = [[HKArticleDetailVC alloc] init];
    HKArticleModel *modelTemp = self.dataSource[[indexPath row]];
    vc.model = modelTemp;
    [self pushToOtherController:vc];
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.4f];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        [weakSelf loadNewData];
    }];

    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        [weakSelf loadMoreData];
    }];
    [self.tableView.mj_header beginRefreshing];
}



- (void)loadNewData {
    
    NSDictionary *dict = nil;
    NSString *url = nil;
    self.page = 1;
    
    // 讲师主页的列表
    if (self.isTeacherVC && self.teacher) {
        dict = @{@"teacher_id" : self.teacher.teacher_id, @"page" : @(self.page)};
        url = TEACHER_ARTICLE_COURSE;
    } else if (self.isMyCollection) { // 自己收藏的文章
        url = @"article/my-collect";
        dict = @{@"page" : @(self.page)};
    } else {
        url = ARTICLE_INDEX;
        dict = @{@"tag" : self.model.tagId, @"page" : @(self.page)};
    }
    
    [HKHttpTool POST:url parameters:dict success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (HKReponseOK) {
            
            self.page ++;
            
            // 2.10讲师文章结构兼容
            if ([url isEqualToString:TEACHER_ARTICLE_COURSE]) {
                NSMutableArray *arr = [HKArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
                self.dataSource = arr;
                
                NSString *totalCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"articleCount"]];
                if (arr.count >= totalCount.integerValue) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableView reloadData];
                return;
            }
            
            NSMutableArray *arr = [HKArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.dataSource = arr;
            
            NSMutableArray *tagArr = [HKArticleCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tags"]];
            self.tagsArr = tagArr;
            
            NSString *totalCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"count"]];
            if (arr.count >= totalCount.integerValue) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
            
            // 本日更新多少个
            NSString *todayUpdateCount = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"update_num"]];
            
            // 对比时间超过第二天才显示
            BOOL shouldShowUptate = NO;
            if ([dict objectForKey:@"tag"]) {
                NSDateFormatter *date = [[NSDateFormatter alloc] init];
                [date setDateFormat:@"yyyy-MM-dd"];
                NSString *todayStr = [date stringFromDate:[NSDate date]];
                
                NSString *lastDayString = [[NSUserDefaults standardUserDefaults] objectForKey:@"hk_article_tag"];
                if (!lastDayString || ![lastDayString isEqualToString:todayStr]) {
                    shouldShowUptate = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:todayStr forKey:@"hk_article_tag"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
            // 今天更新多少个文章
//            if ([self.delegate respondsToSelector:@selector(todayView:hide:)] && todayUpdateCount.intValue > 0 && shouldShowUptate) {
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top - 30) animated:YES];
//                    [self.delegate todayView:todayUpdateCount hide:NO];
//                    
//                    // 消失
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
//                        if (self.tableView.contentOffset.y == -self.tableView.contentInset.top - 30) {
//                            [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
//                        }
//                        
//                        [self.delegate todayView:todayUpdateCount hide:YES];
//                    });
//                });
//            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}



- (void)loadMoreData {
    
    NSDictionary *dict = nil;
    NSString *url = nil;
    
    // 讲师主页的列表
    if (self.isTeacherVC && self.teacher) {
        dict = @{@"teacher_id" : self.teacher.teacher_id, @"page" : @(self.page)};
        url = TEACHER_ARTICLE_COURSE;
    } else if (self.isMyCollection) { // 自己收藏的文章
        url = @"article/my-collect";
        dict = @{@"page" : @(self.page)};
    } else {
        url = ARTICLE_INDEX;
        dict = @{@"tag" : self.model.tagId, @"page" : @(self.page)};
    }
    
    [HKHttpTool POST:url parameters:dict success:^(id responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        
        if (HKReponseOK) {
            self.page ++;
            
            
            // 2.10讲师文章兼容
            if ([url isEqualToString:TEACHER_ARTICLE_COURSE]) {
                
                NSMutableArray *arr = [HKArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
                if (arr.count) {
                    [self.dataSource addObjectsFromArray:arr];
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                return;
            }
            
            NSMutableArray *arr = [HKArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (arr.count) {
                [self.dataSource addObjectsFromArray:arr];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    }];
}


@end







