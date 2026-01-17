//
//  HKSearchCourseNoteVC.m
//  Code
//
//  Created by Ivan li on 2020/12/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSearchCourseNoteVC.h"
#import "HKSearchNoteCourseCell.h"
#import "HKNotesListModel.h"
#import "HKNotesListVC.h"

@interface HKSearchCourseNoteVC ()<UITableViewDataSource,UITableViewDelegate,TBSrollViewEmptyDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HKSearchCourseNoteVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self.view addSubview:self.tableView];
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadNewListData];
    }];

    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadListData];
    }];
    [self loadNewListData];
}

-(void)setKeyWord:(NSString *)keyWord{
    _keyWord = keyWord;
    [self loadNewListData];
}

- (void)loadNewListData{
    if (!_keyWord.length) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    self.emptyText = [NSString stringWithFormat:@"没有搜到“%@”课程\n多写点笔记再来搜搜看吧",self.keyWord];
    self.page = 1;
    [self loadListData];
}

- (void)loadListData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    [dic setObject:self.keyWord forKey:@"keyword"];
    @weakify(self);
    [HKHttpTool POST:@"/note/search-my-noted-video" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * resultArray = [HKNotesVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (resultArray.count) {
                if (pageModel.current_page >= self.page) {
                    
                    [self.dataArray addObjectsFromArray:resultArray];
                    if (pageModel.current_page >= pageModel.page_total) {
                        [self tableFooterEndRefreshing];
                    }else{
                        [self tableFooterStopRefreshing];
                    }
                    self.page ++ ;
                    [self.tableView.mj_header endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)tableFooterEndRefreshing {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = YES;
        _tableView.tb_EmptyDelegate = self;
        
        //[_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0)];
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSearchNoteCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSearchNoteCourseCell class])];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSearchNoteCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSearchNoteCourseCell class])];
    cell.noteVideoModel = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HKNotesListVC * vc = [[HKNotesListVC alloc]init];
    vc.videoModel = self.dataArray[indexPath.row];
    //vc.isFold = YES;
    [self pushToOtherController:vc];
    
    [MobClick event: notelist_search_class_click];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count ? 1 : 0;
}

//#pragma mark ======== TBSrollViewEmptyDelegate
//- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
//    if (status == TBNetworkStatusNotReachable){
//        return imageName(NETWORK_ALREADY_LOST_IMAGE);
//    }else{
//        return [UIImage imageNamed:@"img_nothing_note_2_30"];
//    }
//}
//
//- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
//    return nil;
//}


-(void)dealloc{
    HK_NOTIFICATION_REMOVE();
}
@end
