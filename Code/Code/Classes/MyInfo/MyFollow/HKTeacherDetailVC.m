//
//  HKTeacherDetailVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTeacherDetailVC.h"
#import "HKUserModel.h"
#import "VideoModel.h"
#import "HKTeacherDetailHeaderView.h"
#import "VideoPlayVC.h"
#import "CollectionCell.h"
#import "AFNetworkTool.h"

@interface HKTeacherDetailVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)HKUserModel *user;

@property (nonatomic, strong)NSMutableArray<VideoModel *> *dataArray;

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, assign)int page;

@end

@implementation HKTeacherDetailVC


#pragma mark -- TBSrollViewEmptyDelegate
///** 空视图偏移 */
- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return  CGPointMake(0,200);
}



- (NSMutableArray<VideoModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_F6F6F6;
    
    [self setupBasic];
    
    [self getPersonInfo];
    self.emptyText = @"该教师暂无视频教程";
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setupBasic {
    
    // 创建表格
    UITableView *tableView = [[UITableView alloc] init];
    
    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.frame = self.view.bounds;
    self.tableView = tableView;
    _tableView.rowHeight = 120;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    // 设置头部个人资料
    HKTeacherDetailHeaderView *headerView = [HKTeacherDetailHeaderView viewFromXib];
    
    // 点击返回的block
    __weak typeof(self) weakSelf = self;
    headerView.backClickBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    // 关注按钮点击
    headerView.followBtnClickBlock = ^{
        [weakSelf followTeacherToServer];
    };
    
    // 高度block
    headerView.heightBlock = ^(CGFloat height) {
        weakSelf.tableView.tableHeaderView.height = height;
        UIView *headerView = weakSelf.tableView.tableHeaderView;
        weakSelf.tableView.tableHeaderView = nil;
        weakSelf.tableView.tableHeaderView = headerView;
        // ios 9.3 死循环
        //[tableView reloadData];
    };
    tableView.tableHeaderView = headerView;
    headerView.user = self.user;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });
    [self refreshUI];
}

#pragma mark - 刷新
- (void)refreshUI {

    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf loadNewData];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf loadMoreData];
    }];
}


#pragma mark <UITablViewDataSource>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0? 25 : CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.05;
}

static NSString * const cellIdentifier = @"CollectionCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionCell *collectionCell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!collectionCell ) {
        collectionCell = [[CollectionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellIdentifier];
    }
    VideoModel *model = self.dataArray[indexPath.section];
    collectionCell.model = model;
    collectionCell.isShowShadow = YES;
    return collectionCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoModel *model = self.dataArray[indexPath.section];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                videoName:model.video_titel
                                         placeholderImage:model.img_cover_url
                                               lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
    [self pushToOtherController:VC];
    
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark <UITablViewDatasource>

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HKColorFromHex(0xf6f6f6, 1.0);
        view.height = 25;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = [NSString stringWithFormat:@"讲师教程 (共%@节)", self.user.video_count];
        label.height = label.font.pointSize;
        label.width = 300;
        label.x = 15;
        label.centerY = view.height * 0.5;
        [view addSubview:label];
        return view;
    }else {
        return nil;
    }
}

#pragma mark <Server>
- (void)getPersonInfo {
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page = 1;
    
    [mange teacherHomeWithToken:nil teacherId:self.teacher_id page:[NSString stringWithFormat:@"%d", self.page]
                     completion:^(FWServiceResponse *response) {
        [self.tableView.mj_footer endRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            HKUserModel *user = [HKUserModel mj_objectWithKeyValues:response.data];
            self.user = user;
            HKTeacherDetailHeaderView *headerView = (HKTeacherDetailHeaderView *)self.tableView.tableHeaderView;
            headerView.user = self.user;
            [self.tableView reloadData];
            
            // 获取视频
            [self loadNewData];
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)loadNewData {
    
    WeakSelf;
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page = 1;
    
    [mange teacherHomeWithToken:nil teacherId:self.teacher_id page:[NSString stringWithFormat:@"%d", self.page]
                     completion:^(FWServiceResponse *response) {
        
        [self.tableView.mj_header endRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:response.data[@"video_list"]];
            self.dataArray = array;
            
            if (array.count == 0) {
                self.tableView.mj_footer.hidden = YES;
            }else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer resetNoMoreData];
            
            [self.tableView.mj_header endRefreshing];
        }
    } failBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}


- (void)loadMoreData {
    WeakSelf;
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page++;
    
    [mange teacherHomeWithToken:nil teacherId:self.teacher_id page:[NSString stringWithFormat:@"%d", self.page]
                     completion:^(FWServiceResponse *response) {
        
        [self.tableView.mj_footer endRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:response.data[@"video_list"]];
            [self.dataArray addObjectsFromArray:array];
            
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [weakSelf.tableView reloadData];
        }
        
    } failBlock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}

- (void)followTeacherToServer{
    
    WeakSelf;
    if (!isLogin()) {
        [weakSelf setLoginVC];
        return;
    }

    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange followTeacherVideoWithToken:nil teacherId:self.user.teacher_id type:((self.user.is_follow)? @"1":@"0")completion:^(FWServiceResponse *response) {
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            // 反向取值
            self.user.is_follow = !self.user.is_follow;
            // 更细数据
            HKTeacherDetailHeaderView *headerView = (HKTeacherDetailHeaderView *)self.tableView.tableHeaderView;
            headerView.user = self.user;
            showTipDialog(self.user.is_follow? @"关注成功" : @"取消关注");
            
            // 执行block
            !self.followBlock? : self.followBlock(self.user.is_follow, self.user.teacher_id);
        }
    } failBlock:^(NSError *error) {
        
    }];
    
}


@end
