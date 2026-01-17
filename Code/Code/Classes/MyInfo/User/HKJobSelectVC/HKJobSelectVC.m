
//
//  HKJobSelectVC.m
//  Code
//
//  Created by Ivan li on 2018/6/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKJobSelectVC.h"
#import "HKJobSelectCell.h"
#import "HKJobModel.h"


@interface HKJobSelectVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray <HKJobModel*> *dataArray;

@end



@implementation HKJobSelectVC

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
    
    self.title = (self.selectVCType == SelectVCTypeJob) ? @"请选择职业" :@"请选择能力水平";
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self hkDarkModel];
}

- (void)hkDarkModel {
    self.tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
}


- (NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
//        for (int i = 0; i<10; i++) {
//            [_dataArray addObject:[NSString stringWithFormat:@"虎课%d",i]];
//        }
    }
    return _dataArray;
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA;
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
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
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKJobSelectCell *cell = [HKJobSelectCell initCellWithTableView:tableView];
    HKJobModel *model =  self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.isSelectJob = model.is_selectd;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKJobModel *model =  self.dataArray[indexPath.row];
    [self updateJobWithModel:model indexPath:indexPath];
    
    //HKJobSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.imageName = @"ddd";
    //self.jobSelectBlock ?self.jobSelectBlock(cell.textLabel.text) :nil;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self backAction];
//    });
}




- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getServerData];
    }];
}



- (void)getServerData {
    
    [HKHttpTool POST:SETTING_JOB_DETAIL parameters:@{@"job_id":self.jobModel.job_id} success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            NSMutableArray *arr = [HKJobModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.dataArray = arr;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark -  修改 或者 添加 用户选择的职业
- (void)updateJobWithModel:(HKJobModel*)model  indexPath:(NSIndexPath *)indexPath {
    
    [HKHttpTool POST:SETTING_ADD_JOB parameters:@{@"job_id":self.jobModel.job_id, @"id":model.ID} success:^(id responseObject) {
        if (HKReponseOK) {
            [self.dataArray enumerateObjectsUsingBlock:^(HKJobModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == indexPath.row) {
                    obj.is_selectd = YES;
                }else{
                    obj.is_selectd = NO;
                }
            }];
            // 增加 job_id 
            model.job_id = self.jobModel.job_id;
            [self.tableView reloadData];
            self.jobSelectBlock ?self.jobSelectBlock(model) :nil;
            [self backAction];
        }
        NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
        showTipDialog(msg);
    } failure:^(NSError *error) {
        
    }];
}



@end










