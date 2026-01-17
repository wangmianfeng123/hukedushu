//
//  HKBookTabVC.m
//  Code
//
//  Created by Ivan li on 2019/10/31.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKBookTabVC.h"
#import "HKTabBookCell.h"
#import "HKBookModel.h"
#import "HKListeningBookVC.h"
#import "HKJobPathModel.h"


@interface HKBookTabVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray <HKBookModel*> *dataArr;

@property (nonatomic,assign)NSInteger page;

@end



@implementation HKBookTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"1" bookId:@"0" courseId:@"0"];
}


- (void)createUI {
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self.view addSubview:self.tableView];
    [self refreshUI];
}


- (NSMutableArray <HKBookModel*>*)dataArr {
    if (!_dataArr ) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


#pragma mark - 刷新
- (void)refreshUI {
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        self.page = 1;
        [self loadData:self.page];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        self.page = (1 == self.page) ?2 :self.page;
        [self loadData:self.page];
    }];
    
    self.page = 1;
    [self loadData:self.page];
}


- (void)headerEndRefresh {
    [self.tableView.mj_header endRefreshing];
}


- (void)footerNoMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


- (void)footerStopRefresh {
    [self.tableView.mj_footer endRefreshing];
}



- (void)loadData:(NSInteger)page {
    NSDictionary *dict = @{@"tag_id":self.tagModel.tagId, @"page":@(page)};
    [HKHttpTool POST:BOOK_BOOK_LIST_BY_TAG parameters:dict success:^(id responseObject) {
        [self headerEndRefresh];
        if (HKReponseOK) {
            NSMutableArray *arr  = [HKBookModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (1 == page) {
                self.dataArr = arr;
            }else{
                [self.dataArr addObjectsFromArray:arr];
            }
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (page >= pageModel.page_total) {
                [self footerNoMoreData];
            }else{
                [self footerStopRefresh];
            }
            [self.tableView reloadData];
            self.page ++;
        }
    } failure:^(NSError *error) {
        [self headerEndRefresh];
        [self footerStopRefresh];
    }];
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_ffffff;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        [_tableView registerClass:[HKTabBookCell class] forCellReuseIdentifier:NSStringFromClass([HKTabBookCell class])];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49+50, 0);
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count ?1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTabBookCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTabBookCell class]) forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GKPlayer *bookPlayer = [GKPlayer sharedInstance];
    //NSLog(@"%@=== %@",bookPlayer.bookModel.book_id,bookPlayer.bookModel.course_id);

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKBookModel *model = self.dataArr[indexPath.row];
    
    HKListeningBookVC *bookVC = [HKListeningBookVC new];
    bookVC.bookId = model.book_id;
    if ([bookPlayer.bookModel.book_id isEqualToString:model.book_id]) {
        bookVC.courseId = bookPlayer.bookModel.course_id;
    }else{
        bookVC.courseId = model.course_id;
    }
    [self pushToOtherController:bookVC];
    
    [MobClick event:um_hukedushushouye_ruanjian];
    
    [[HKALIYunLogManage sharedInstance]hkBookClickLogWithFlag:@"2" bookId:model.book_id courseId:model.course_id];
}

@end
