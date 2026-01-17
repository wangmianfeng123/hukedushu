//
//  HKBookCollectVC.m
//  Code
//
//  Created by Ivan li on 2019/8/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookCollectVC.h"
#import "HKBookRecordCell.h"
#import "HKBookModel.h"
#import "HKListeningBookVC.h"
#import "HKJobPathModel.h"


@interface HKBookCollectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,assign)NSInteger page;


@end



@implementation HKBookCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
//    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccess);

}

//- (void)loginSuccess{
//    [self.tableView.mj_header beginRefreshing];
//}


- (void)createUI {
    [self.view addSubview:self.tableView];
    [self refreshUI];
    [self hkDarkMoldel];
}

- (void)hkDarkMoldel {
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.tableView.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 127;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = COLOR_F6F6F6;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(kHeight44, 0, KTabBarHeight49, 0);
        [_tableView registerClass:[HKBookRecordCell class] forCellReuseIdentifier:NSStringFromClass([HKBookRecordCell class])];
    }
    return _tableView;
}


- (NSMutableArray*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


#pragma mark - 刷新
- (void)refreshUI {
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf loadNewData];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf loadNewData];
    }];
    self.page = 1;
    [self.tableView.mj_header beginRefreshing];
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


- (void)loadNewData {
    
    @weakify(self);
    NSDictionary *dict = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    [HKHttpTool POST:BOOK_COLLECTED_LIST parameters:dict success:^(id responseObject) {
        
        @strongify(self);
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *arr = [HKBookModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (1 == self.page) {
                self.dataArr = arr;
            }else{
                [self.dataArr addObjectsFromArray:arr];
            }
            if (pageModel.current_page >= pageModel.page_total) {
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
            }
            [self.tableView reloadData];
            self.page ++;
        }
    } failure:^(NSError *error) {
        @strongify(self);
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
    }];
    
//    HKBookModel *model = [HKBookModel new];
//    model.cover = @"http://pic33.nipic.com/20131007/13639685_123501617185_2.jpg";
//    model.title = @"虎课读书虎课读书虎课读书";
//    model.time = @"23分钟";
//    model.short_introduce = @"虎课读书虎课读书虎课读书虎课读书虎课读书虎课读书";
//    model.book_id = @"1";
//
//    for (int i = 0; i< 10; i++) {
//        [self.dataArr addObject:model];
//    }
//    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count ?1 :0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKBookRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKBookRecordCell class]) forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HKBookModel *model = self.dataArr[indexPath.row];
    if (!isEmpty(model.book_id)) {
        HKListeningBookVC *bookVC = [HKListeningBookVC new];
        bookVC.courseId = model.course_id;
        bookVC.bookId = model.book_id;
        [self pushToOtherController:bookVC];
    }
}






@end
