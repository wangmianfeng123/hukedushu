//
//  HKPGCOrderVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPGCOrderVC.h"
#import "HKOrderPaymentModel.h"
#import "HKTrainOrderCell.h"
#import "TBScrollViewEmpty.h"
#import "HKPgcCategoryModel.h"
#import "VideoPlayVC.h"

@interface HKPGCOrderVC ()<UITableViewDelegate, UITableViewDataSource, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKPgcCourseModel *> *dataSource;

@end

@implementation HKPGCOrderVC



- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    HKAdjustsScrollViewInsetNever(self, self.tableView);
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, kHeight44, 0);
    
    WeakSelf;    
    [HKRefreshTools headerRefreshWithTableView:tableView completion:^{
        StrongSelf;
        [strongSelf loadNewData];
    }];
    [tableView.mj_header beginRefreshing];
    
    [HKRefreshTools footerAutoRefreshWithTableView:tableView completion:^{
        StrongSelf;
        [strongSelf loadMoreData ];
    }];
}


- (void)setupNav {
    self.title = @"我的订单2";
    self.emptyText = @"目前暂无订单";
    [self createLeftBarButton];
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count ?1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 10;
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 202;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTrainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTrainOrderCell class])];
    HKPgcCourseModel *model = self.dataSource[indexPath.row];
    cell.pgcModel = model;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // v2.17 禁止点击
    NSString *str = @"名师机构课程维护中，请前往网站观看哦~";
    showWarningDialog(str, self.tableView, 2);

    
//    HKPgcCourseModel *model = self.dataSource[indexPath.row];
//    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:model.title
//                                         placeholderImage:nil lookStatus:LookStatusInternetVideo
//                                                  videoId:model.video_id model:model];
//    VC.videoType = HKVideoType_PGC;
//    [self pushToOtherController:VC];
}





#pragma mark <HKTrainOrderCellDelegate>
- (void)immediateStudy:(id)sender {
    HKPgcCourseModel *model = sender;
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:model.title
                                         placeholderImage:nil lookStatus:LookStatusInternetVideo
                                                  videoId:model.video_id model:model];
    VC.videoType = HKVideoType_PGC;
    [self pushToOtherController:VC];
}



#pragma mark <TBEmptyDelegate>
- (NSString *)tb_emptyString {
    return @"你暂时无订单";
}

- (UIEdgeInsets)tb_emptyViewInset {
    return UIEdgeInsetsMake(50, 0, 0, 0);
}


- (NSMutableArray <HKPgcCourseModel*>*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark <Server>
- (void)loadNewData {
    self.tableView.mj_footer.hidden = YES;
    [HKHttpTool POST:PGC_MY_ORDER parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
//            NSMutableArray *arr = [HKPgcCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
//            for (int i= 0; i<5; i++) {
//                [self.dataSource addObject:arr[0]];
//            }
            self.dataSource = [HKPgcCourseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    
}


@end
