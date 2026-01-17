//
//  HKUserTaskVC.m
//  Code
//
//  Created by Ivan li on 2018/7/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserTaskVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"
#import "HKUserTaskCell.h"
#import "HKTaskModel.h"
#import "HKTaskDetailVC.h"


@interface HKUserTaskVC ()<UITableViewDelegate,UITableViewDataSource,UITableViewDataSource,TBSrollViewEmptyDelegate>

@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,strong)NSMutableArray  *dataArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)HKTaskModel *taskM;

@end


@implementation HKUserTaskVC




- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    self.title = @"已学视频";
    //空视图
    self.emptyText = @"暂无作品";
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
    
    [self.view addSubview:self.tableView];
    [self createLeftBarButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    self.page = 1;
    
}

#pragma mark <TBEmpty>
- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return CGPointMake(0, -80);
}


- (HKTaskModel*)taskM {
    if (!_taskM) {
        _taskM = [HKTaskModel new];
    }
    return _taskM;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 234/2;
        _tableView.separatorColor = COLOR_F8F9FA_333D48;
        _tableView.backgroundColor = COLOR_F8F9FA_3D4752;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KNavBarHeight64, 0);
        _tableView.tb_EmptyDelegate = self;
    }
    return _tableView;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.taskM.list.count? 1 :0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskM.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKUserTaskCell *taskCell =  [HKUserTaskCell initCellWithTableView:tableView];
    taskCell.model = self.taskM.list[indexPath.row];
    return taskCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HKTaskDetailVC *vc = [HKTaskDetailVC new];
    vc.model = self.taskM.list[indexPath.row];
    [self pushToOtherController:vc];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getTaskListWithPage:@"1"];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        [strongSelf getTaskListWithPage:pageNum];
    }];
    [self getTaskListWithPage:@"1"];
}


- (void)tableHeaderEndRefreshing {
    [_tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [_tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_tableView.mj_footer endRefreshing];
}


#pragma mark - 获取视频列表
- (void)getTaskListWithPage:(NSString*)page {
    
    //page uid
    @weakify(self);
    NSDictionary *dict = @{@"page":page,@"uid":self.userModel.ID};
    [HKHttpTool POST:USER_USER_TASK parameters:dict success:^(id responseObject) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            HKTaskModel *model = [HKTaskModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.taskM = model;
            if (self.page >= model.total_page){
                [self tableFooterEndRefreshing];
            }else{
                self.page++;
                [self tableFooterStopRefreshing];
            }
        } else {
            [self tableFooterStopRefreshing];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
    }];
}



@end

