//
//  HKOverflowVC.m
//  Code
//
//  Created by Ivan li on 2021/5/21.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKOverflowVC.h"
#import "HKTrainOrderCell.h"
#import "HKPageInfoModel.h"
#import "VideoPlayVC.h"

@interface HKOverflowVC ()<UITableViewDelegate, UITableViewDataSource, TBSrollViewEmptyDelegate>
@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic , assign) int page ;
@end

@implementation HKOverflowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
    [self setupTableView];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.tableView.backgroundColor = COLOR_F8F9FA_3D4752;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    [self.view addSubview:tableView];
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor= HKColorFromHex(0xF8F9FA, 1.0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView = tableView;
    tableView.tb_EmptyDelegate = self;
    
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTrainOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKTrainOrderCell class])];
    
    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, kHeight44, 0);
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:tableView completion:^{
        StrongSelf;
        weakSelf.page = 1;
        [strongSelf loadData];
    }];
    [tableView.mj_header beginRefreshing];
    
    [HKRefreshTools footerAutoRefreshWithTableView:tableView completion:^{
        StrongSelf;
        [strongSelf loadData];
    }];
}


- (void)setupNav {
    self.emptyText = @"目前暂无订单";
    [self createLeftBarButton];
}


#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count ?1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 202;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTrainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTrainOrderCell class])];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HKTrainModel *model = self.dataSource[indexPath.row];
    if (model.video_id.length) {
        VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil
                                                   lookStatus:LookStatusInternetVideo videoId:[NSString stringWithFormat:@"%@",model.video_id] model:nil];
        [self pushToOtherController:VC];
    }
}

#pragma mark <TBEmptyDelegate>
- (NSString *)tb_emptyString {
    return @"你暂时无订单";
}

- (UIEdgeInsets)tb_emptyViewInset {
    return UIEdgeInsetsMake(50, 0, 0, 0);
}


- (NSMutableArray <HKTrainModel*>*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)loadData {
    
    NSDictionary *params = @{@"page" : @(self.page), @"page_size" : @"10"};
    
    [HKHttpTool POST:@"series/orders" parameters:params success:^(id responseObject) {
        
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *array = [HKTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (1 == self.page ) {
                self.dataSource = array;
            }else{
                [self.dataSource addObjectsFromArray:array];
            }
            
            if (self.page >= pageModel.page_total){
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
            self.page ++;
        }else{
            [self tableFooterStopRefreshing];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        if (self.dataSource.count<1) {
            [self.tableView reloadData];
        }
    }];
}


- (void)tableHeaderEndRefreshing {
    [self.tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
}


@end
