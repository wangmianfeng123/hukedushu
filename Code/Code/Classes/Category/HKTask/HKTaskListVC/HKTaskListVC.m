//
//  HKTaskListVC.m
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//


#import "HKTaskListVC.h"
#import "HKTaskModel.h"
#import "HKTaskListCell.h"
#import "HKTaskCommentCell.h"
#import "HKUserInfoVC.h"
#import "HKTaskDetailVC.h"
#import "XLPhotoBrowser.h"

@interface HKTaskListVC ()<UITableViewDelegate,UITableViewDataSource,HKTaskListCellDelegate>

@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,strong)NSMutableArray<HKTaskModel*> *dataArr;

@property(nonatomic,assign)NSInteger page;

@end




@implementation HKTaskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.page = 1;
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray<HKTaskModel*>*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.backgroundColor = COLOR_F8F9FA;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView.sectionHeaderHeight = 0.005;
        _tableView.sectionFooterHeight = 0.005;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //ios 11
        HKAdjustsScrollViewInsetNever(self, _tableView)
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
    }
    return _tableView;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = _dataArr[section].comment.count >3 ? 4 : _dataArr[section].comment.count;
    return count + 1;
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 120;
    }else{
        return 30;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.row) {
        
        if (0 == indexPath.section) {
            HKTaskListCell *cell = [HKTaskListCell initCellWithTableView:tableView indexPath:indexPath identif:@"HKTaskListCell-0"];
            cell.delegate = self;
            cell.model = self.dataArr[indexPath.section];
            return cell;
        }else{
            HKTaskListCell *cell = [HKTaskListCell initCellWithTableView:tableView indexPath:indexPath identif:@"HKTaskListCell"];
            cell.delegate = self;
            cell.model = self.dataArr[indexPath.section];
            return cell;
        }
    }else{
        NSInteger row = indexPath.row;
        HKTaskCommentCell *cell = [HKTaskCommentCell initCellWithTableView:tableView row:row-1];
        cell.attrLabel.numberOfLines = (1 == row)?1 :0;
        cell.commentM = self.dataArr[indexPath.section].comment[row-1];
        return cell;
    }
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (0 == indexPath.row) {
//        HKTaskListCell *cell = [HKTaskListCell initCellWithTableView:tableView indexPath:indexPath];
//        cell.delegate = self;
//        cell.model = self.dataArr[indexPath.section];
//        return cell;
//    }else{
//        NSInteger row = indexPath.row;
//        HKTaskCommentCell *cell = [HKTaskCommentCell initCellWithTableView:tableView row:row-1];
//        cell.attrLabel.numberOfLines = (1 == row)?1 :0;
//        cell.commentM = self.dataArr[indexPath.section].comment[row-1];
//        return cell;
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    if (0 == row) {
        [MobClick event:UM_RECORD_WORKSLIST_WORKSCLICK];
    }else if (1 == row) {
        [MobClick event:UM_RECORD_WORKSLIST_TEACHERCOMMENT];
    }else {
        [MobClick event:UM_RECORD_WORKSLIST_USERCOMMENT];
    }
    HKTaskDetailVC *vc = [HKTaskDetailVC new];
    vc.model = self.dataArr[indexPath.section];
    vc.row = row;
    [self pushToOtherController:vc];
}



#pragma mark - 刷新
- (void)refreshUI {
    
    NSInteger temp = (self.type ==0) ?1 :self.type;
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getTaskList:temp page:strongSelf.page];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        [strongSelf getTaskList:temp page:strongSelf.page];
    }];
    [self getTaskList:temp page:self.page];
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




- (void)getTaskList:(NSInteger)sort page:(NSInteger)page {
    //sort 排序：1-最新 2-最热    page
    WeakSelf;
    NSDictionary *dict = @{@"sort":@(sort),@"page":@(page)};
    [HKHttpTool POST:TASK_INDEX parameters:dict success:^(id responseObject) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            NSString *totalPage = responseObject[@"data"][@"total_page"];
            NSMutableArray <HKTaskModel*> *arr = [HKTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (1 == page){
                strongSelf.dataArr = arr;
            }else{
                [strongSelf.dataArr addObjectsFromArray:arr];
            }
            
            if ([totalPage intValue] <= strongSelf.page){
                [strongSelf tableFooterEndRefreshing];
            }else{
                strongSelf.page++;
                [strongSelf tableFooterStopRefreshing];
            }
        } else {
            [strongSelf tableFooterStopRefreshing];
        }
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
    }];
}





#pragma mark HKTaskListCell delegate

- (void)userInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        HKUserInfoVC *vc = [HKUserInfoVC new]; vc.userId = model.uid;
        [self pushToOtherController:vc];
    }else{
        [self setLoginVC];
    }
    [MobClick event:UM_RECORD_WORKSLIST_USERCLICK];
}

- (void)didClickPraiseBtnInCell:(HKTaskListCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        [self praiseWithTaskM:cell.model cell:cell indexPath:indexPath];
    }else{
        [self setLoginVC];
    }
    [MobClick event:UM_RECORD_WORKSLIST_LIKE];
}



/** 点赞 */
- (void)praiseWithTaskM:(HKTaskModel*)taskM cell:(HKTaskListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    [HKHttpTool POST:TASK_LIKE_TASK parameters:@{@"task_id":taskM.task_id} success:^(id responseObject) {
        if (HKReponseOK) {
            showTipDialog(responseObject[@"msg"]);
            taskM.is_like = !taskM.is_like;
            NSInteger count = (taskM.is_like ? 1:-1 )+taskM.thumbs;
            taskM.thumbs = count ?count :0;
            [self.dataArr replaceObjectAtIndex:indexPath.section withObject:taskM];
            
            NSString *title = nil;
            if (count) {
                title = [NSString stringWithFormat:@"%ld",count];
            }else{
                title = @"赞";
            }
            [cell.praiseBtn setTitle:title forState:UIControlStateNormal];
            cell.praiseBtn.selected = taskM.is_like;
        }
    } failure:^(NSError *error) {
        
    }];
}



@end






















