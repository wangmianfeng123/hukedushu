//
//  HKCouponVC.m
//  Code
//
//  Created by Ivan li on 2018/1/18.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCouponVC.h"
#import "HKCouponCell.h"
#include "HKCouponModel.h"


@interface HKCouponVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, assign)NSUInteger page;

@end

@implementation HKCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self refreshUI];
    self.page = 1;
    [self getUserCouponList:self.page];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadView {
    [super loadView];
    [self createUI];
}


- (void)createUI {
    self.title = @"优惠券";
    self.emptyText = @"您还没有优惠券，去虎课币商城逛逛吧~";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self.view addSubview:self.tableView];
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 90;
        UIColor *color = COLOR_F6F6F6_3D4752;
        _tableView.backgroundColor = color;
        [_tableView setSeparatorColor:color];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self,_tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
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
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return PADDING_10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.05;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKCouponCell *cell = [HKCouponCell initCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
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
        [strongSelf getUserCouponList:strongSelf.page];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getUserCouponList:strongSelf.page];
    }];
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


#pragma mark - 获取优惠券列表
- (void)getUserCouponList:(NSUInteger)page {

    [HKHttpTool POST:USER_COUPONS parameters:@{@"page" : @(page)} success:^(id responseObject) {
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *array = [HKCouponModel mj_objectArrayWithKeyValuesArray:[[responseObject objectForKey:@"data"] objectForKey:@"list"]];
            self.dataArray = array;
            NSString *totalPage = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"total_page"]];
            if (self.page >= totalPage.intValue) {
                [self tableFooterEndRefreshing];
            }
            self.page++;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self tableHeaderEndRefreshing];
        [self tableFooterStopRefreshing];
        [self.tableView reloadData];
    }];
}


@end




