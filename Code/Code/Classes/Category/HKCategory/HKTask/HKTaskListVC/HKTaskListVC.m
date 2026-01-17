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

@interface HKTaskListVC ()<UITableViewDelegate,UITableViewDataSource,HKTaskListCellDelegate>

@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,strong)NSMutableArray<HKTaskModel*> *dataArr;

@end




@implementation HKTaskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger temp = (self.type ==0) ?1 :self.type;
    [self.view addSubview:self.tableView];
    [self getTaskList:temp page:1];
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
        
        //_tableView.estimatedRowHeight = 300;
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
    
    return _dataArr[section].comment.count + 1;
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
        HKTaskListCell *cell = [HKTaskListCell initCellWithTableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.model = self.dataArr[indexPath.section];
        return cell;
    }else{
        HKTaskCommentCell *cell = [HKTaskCommentCell initCellWithTableView:tableView row:indexPath.row-1];
        cell.commentM = self.dataArr[indexPath.section].comment[indexPath.row-1];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKTaskDetailVC *vc = [HKTaskDetailVC new];
    vc.model = self.dataArr[indexPath.section];
    [self pushToOtherController:vc];
}



#pragma mark HKTaskListCell delegate

- (void)userInfoClick:(HKTaskModel*)model indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        HKUserInfoVC *vc = [HKUserInfoVC new]; vc.userId = model.uid;
        [self pushToOtherController:vc];
    }else{
        [self setLoginVC];
    }
}

- (void)didClickPraiseBtnInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (isLogin()) {
        
    }else{
        [self setLoginVC];
    }
}




- (void)getTaskList:(NSInteger)sort page:(NSInteger)page {
    //sort 排序：1-最新 2-最热    page
    NSDictionary *dict = @{@"sort":@(sort),@"page":@(page)};
    [HKHttpTool POST:TASK_INDEX parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            //"total_page" = 8;
            //NSInteger page = responseObject[@"data"][@"total_page"];
            NSMutableArray *arr = [HKTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            self.dataArr = arr;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end


























////
////  HKTaskListVC.m
////  Code
////
////  Created by Ivan li on 2018/7/12.
////  Copyright © 2018年 pg. All rights reserved.
////
//
//#import "HKTaskListVC.h"
//#import "HKTaskModel.h"
//#import "HKTaskListCell.h"
//
//@interface HKTaskListVC ()<UITableViewDelegate,UITableViewDataSource,HKTaskListCellDelegate>
//
//@property(nonatomic,strong)UITableView    *tableView;
//
//@property(nonatomic,strong)NSMutableArray *dataArr;
//
//@end
//
//
//
//
//@implementation HKTaskListVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    NSInteger temp = (self.type ==0) ?1 :self.type;
//    [self.view addSubview:self.tableView];
//    [self getTaskList:temp page:1];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (NSMutableArray*)dataArr {
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }
//    return _dataArr;
//}
//
//
//
//- (UITableView*)tableView {
//
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        _tableView.tableFooterView = [UIView new];
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
//
//        _tableView.estimatedRowHeight = 300;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        HKAdjustsScrollViewInsetNever(self, _tableView)
//        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
//    }
//    return _tableView;
//}
//
//
//
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _dataArr.count ? 1 :0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _dataArr.count;
//}
//
//
////- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
////    return nil;
////}
////
////- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
////    return nil;
////}
////
////- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
////
////    return 0.05;
////}
////
////- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
////    return 0.05;
////}
//
//
////- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
////    // 先从缓存中查找图片
////    HKTaskModel *model = self.dataArr[indexPath.row];
////    return 150.0 + model.imageHeight;
////}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HKTaskListCell *cell = [HKTaskListCell initCellWithTableView:tableView];
//    cell.delegate = self;
//    cell.indexPath = indexPath;
//    cell.model = self.dataArr[indexPath.row];
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//
//
//- (void)reloadTaskListCell:(HKTaskModel *)model indexPath:(NSIndexPath *)indexPath {
//    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:model];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}
//
//
//
//- (void)getTaskList:(NSInteger)sort page:(NSInteger)page{
//    //sort 排序：1-最新 2-最热    page
//    NSDictionary *dict = @{@"sort":@(sort),@"page":@(page)};
//    [HKHttpTool POST:TASK_INDEX parameters:dict success:^(id responseObject) {
//        if (HKReponseOK) {
//            //"total_page" = 8;
//            //NSInteger page = responseObject[@"data"][@"total_page"];
//            NSMutableArray *arr = [HKTaskModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
//            self.dataArr = arr;
//            [self.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}
//
//@end
//
//
//
//
//
//
//
//
//
