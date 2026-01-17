//
//  HKMyLiveListVC.m
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKMyLiveListVC.h"
#import "HKMyLiveModel.h"
#import "HKMyLiveCell.h"
#import "HKLiveCourseVC.h"

@interface HKMyLiveListVC ()<UITableViewDataSource,UITableViewDelegate,TBSrollViewEmptyDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) NSDictionary * dic;
@end

@implementation HKMyLiveListVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self.view addSubview:self.tableView];
    self.emptyText = @"没有安排课程哦~";
    //[MyNotification addObserver:self selector:@selector(refreshData) name:@"refreshCommentData" object:nil];
    [MyNotification addObserver:self selector:@selector(updataByParam:) name:@"myLiveCourseParams" object:nil];
    
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

- (void)updataByParam:(NSNotification *)noti{
    self.dic = noti.userInfo;
    [self loadNewListData];
}

- (void)loadNewListData{
    self.page = 1;
    [self loadListData];
}

- (void)loadListData{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.type forKey:@"type"];
    [dic setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    
    if (self.dic.allKeys.count) {
        [dic addEntriesFromDictionary:self.dic];
    }
    
    @weakify(self);
    [HKHttpTool POST:@"/live/my-live-course" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * resultArray = [HKMyLiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            NSArray * tagArray  =[HKClassListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"classList"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (tagArray.count && self.fetchTagArrayBlock) {
                HKClassListModel * model = tagArray[0];
                model.tagSeleted = YES;
                self.fetchTagArrayBlock(tagArray);
            }
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, KTabBarHeight49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = YES;
        _tableView.tb_EmptyDelegate = self;
        
        //[_tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyLiveCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyLiveCell class])];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyLiveCell class])];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event: mylivestudio_classlist_class];
    HKMyLiveModel * model = self.dataArray[indexPath.row];
    if (!isEmpty(model.smallid)) {
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.course_id = model.smallid;
        [self pushToOtherController:VC];
    }
}

#pragma mark ======== TBSrollViewEmptyDelegate
//- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
//    if (status == TBNetworkStatusNotReachable){
//        return imageName(NETWORK_ALREADY_LOST_IMAGE);
//    }else{
//        return [UIImage imageNamed:@"ic_live_no courses_2_30"];
//    }
//}

-(void)dealloc{
    self.dic = nil;
    HK_NOTIFICATION_REMOVE();
}
@end
