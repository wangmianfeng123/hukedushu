//
//  HKTeacherLiveVC.m
//  Code
//
//  Created by Ivan li on 2019/9/15.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKTeacherLiveVC.h"
#import "VideoModel.h"
#import "HKTeacherLiveCell.h"
#import "VideoPlayVC.h"
#import "HKTrainModel.h"
#import "HKJobPathModel.h"
#import "HKLivingPlayVC2.h"
#import "HKLiveCourseVC.h"


@interface HKTeacherLiveVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,strong)NSMutableArray  *dataArray;

@property(nonatomic,assign)NSInteger page;

@end



@implementation HKTeacherLiveVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self.view addSubview:self.tableView];
    //空视图
    self.emptyText = EMPETY_NO_COLLECTION;
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
    
    [self refreshUI];
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130;
        UIColor *color = [UIColor hkdm_colorWithColorLight:COLOR_F6F6F6 dark:COLOR_333D48];
        _tableView.separatorColor = color;
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];

        [_tableView registerClass:[HKTeacherLiveCell class] forCellReuseIdentifier:NSStringFromClass([HKTeacherLiveCell class])];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, KNavBarHeight64, 0)];
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
    return self.dataArray.count ? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    
    HKTrainModel *model = self.dataArray[indexPath.row];
    HKTeacherLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTeacherLiveCell class])];
    cell.model = model;
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //if (DEBUG) {
        // 需要 status 才能跳转
    //}
    HKTrainModel *model = self.dataArray[indexPath.row];
    //1 直播中
    if (1 == model.status) {
        HKLivingPlayVC2 *vc = [[HKLivingPlayVC2 alloc] init];
        vc.live_id = model.live_small_id;
        [self pushToOtherController:vc];
    }else{
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.course_id = model.live_small_id;
        [self pushToOtherController:VC];
    }
}



#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getTeacherLiveListWithPage:strongSelf.page];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getTeacherLiveListWithPage:strongSelf.page];
    }];
    self.page = 1;
    [self getTeacherLiveListWithPage:self.page];
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


#pragma mark - 获取直播列表
- (void)getTeacherLiveListWithPage:(NSInteger)page {
    
    if (!self.teacher.teacher_id.length) {
        return;
    }
    
    NSDictionary *params = @{@"teacher_id" : self.teacher.teacher_id, @"page" : @(page), @"type" : @"1"};
    
    [HKHttpTool POST:LIVE_LIST_OF_TEACHER parameters:params success:^(id responseObject) {
        
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *array = [HKTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (1 == page ) {
                self.dataArray = array;
            }else{
                [self.dataArray addObjectsFromArray:array];
            }
            
            if (page >= pageModel.page_total){
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
        if (self.dataArray.count<1) {
            [self.tableView reloadData];
        }
    }];
}





@end
