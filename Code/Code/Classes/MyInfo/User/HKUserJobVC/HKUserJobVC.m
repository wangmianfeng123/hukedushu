//
//  HKUserJobVC.m
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKUserJobVC.h"
#import "HKUserJobCell.h"
#import "HKJobSelectVC.h"
#import "HKJobModel.h"




@interface HKUserJobVC ()<UITableViewDelegate,UITableViewDataSource> {

}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end


@implementation HKUserJobVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
    [self getServerData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createUI {
    self.title = @"职业";
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.tableView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_3D4752];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
}


- (NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA;
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count ? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    HKUserJobCell *cell = [HKUserJobCell initCellWithTableView:tableView];
    HKJobModel *model = self.dataArray[row];
    cell.title =  model.selectd;
    cell.textLabel.text = model.name;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    __block HKJobModel *model = self.dataArray[row];
    
    HKJobSelectVC *VC = [HKJobSelectVC new];
    VC.jobModel = model;
    
    if ([model.job_id isEqualToString:@"1"]) {
        VC.selectVCType = SelectVCTypeJob;
    }else if ([model.job_id isEqualToString:@"2"]) {
        VC.selectVCType = SelectVCTypeSkill;
    }
    WeakSelf;
    VC.jobSelectBlock = ^(HKJobModel *jobModel) {
        StrongSelf;
        HKUserJobCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.title = jobModel.name;
        model.selectd = jobModel.name;
        [strongSelf.dataArray replaceObjectAtIndex:row withObject:model];
        
        strongSelf.userJobSelectBlock ?strongSelf.userJobSelectBlock(jobModel) :nil;
    };
    [self pushToOtherController:VC];
}


- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getServerData];
    }];
}



- (void)getServerData {
    
    [HKHttpTool POST:SETTING_JOB_DATA parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            NSMutableArray *arr = [HKJobModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.dataArray = arr;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end









