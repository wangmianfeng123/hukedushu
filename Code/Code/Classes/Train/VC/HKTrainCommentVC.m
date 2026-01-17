//
//  HKTrainCommentVC.m
//  Code
//
//  Created by Ivan li on 2021/3/31.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKTrainCommentVC.h"
#import "HKTrainSubVC.h"
#import "HKTainItemDetailCell.h"
#import "HKTrainItemModel.h"
#import "UMpopView.h"
#import "VideoPlayVC.h"
#import "HKTrainTeacherQRCodeVC.h"
#import "HKTrainShareWebVC.h"
#import "HKUserInfoVC.h"
#import "HKPunchCardCell.h"
#import "HKTrainAddwxCell.h"
#import "HKTrainSectionHeaderView.h"
#import "MyTool.h"
#import "HKPunchClockModel.h"
#import "HKDayTaskVC.h"
#import "UIView+HKLayer.h"
#import "HKTrainDetailVC.h"
#import "HKJobPathModel.h"

@interface HKTrainCommentVC ()<UITableViewDelegate,UITableViewDataSource, UMpopViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, assign) int pages;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation HKTrainCommentVC

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    self.emptyText = @"列表为空";
    if (self.taskCalendarModel.is_start == 1) {
        
        @weakify(self);
        [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
            @strongify(self);
            [self loadListData];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadNewListData];
}

- (UITableView*)tableView {
    if (!_tableView) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - KNavBarHeight64 - 40 * Ratio) style:UITableViewStylePlain];
//        _tableView.y = 0.5; // 分割线
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else{
            self.automaticallyAdjustsScrollViewInsets = false;
        }
        //_tableView.contentInset = UIEdgeInsetsMake(0, 0, 10* Ratio, 0);
        
        //评论区cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTainItemDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKTainItemDetailCell class])];
        //评论区空数据cell
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 400;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (void)loadNewListData{
    self.pages = 1;
    [self loadListData];
}

- (void)loadListData{
    @weakify(self);
    NSDictionary *param = @{@"date" : self.date, @"training_id" : self.trainingId,@"type":self.typeString,@"pages":[NSNumber numberWithInt:self.pages]};

    [HKHttpTool POST:HK_TrainingWorkList_URL parameters:param success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * data = [HKPunchClockModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            int page_total = [responseObject[@"data"][@"page_total"] intValue];
            if (self.pages == 1) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:data];
            }else{
                [self.dataArray addObjectsFromArray:data];
            }
            if (self.dataArray.count >= page_total) {
                [self tableFooterEndRefreshing];
            }else{
                self.pages ++;
                [self tableFooterStopRefreshing];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        @strongify(self);
        [self tableFooterStopRefreshing];
    }];
}

- (void)tableFooterEndRefreshing {
    [_tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [_tableView.mj_footer endRefreshing];
}

- (void)createUI {
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 学员的作品
    HKTainItemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTainItemDetailCell class]) forIndexPath:indexPath];
    HKPunchClockModel * model = self.dataArray[indexPath.row];
    cell.typeString = self.typeString;
    cell.punchClockModel = model;
    WeakSelf
    cell.coverIVTapBlock = ^(HKPunchClockModel * _Nonnull model) {
        [weakSelf watchHeightQualityImage:model];
    };
    cell.userHeaderIVTapBlock = ^(HKPunchClockModel * _Nonnull model) {
        HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
        vc.userId = model.uid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.deleteBlock = ^(HKPunchClockModel * model){
        [MyTool presentAlertController:@"确定删除作品吗" withMessage:@"删除后可重新提交作品" withViewController:self withCancelTxt:@"否" withSureTitle:@"是" withSureBlcok:^{
            [self detelProductData:model];
        }];
        
    };
    cell.likeBlock = ^(HKPunchClockModel * model) {
        [weakSelf postLike:model];
    };
    return cell;
}

#pragma mark <浏览大图>
- (void)watchHeightQualityImage:(HKPunchClockModel *)model {
    
    if (model.image_url.length) {
        [HKPhotoBrowserTool initPhotoBrowserWithUrl:model.image_url];
    }
}

- (void)postLike:(HKPunchClockModel *)model{
    NSString * type = model.like ? @"2":@"1";
    NSDictionary *param = @{@"task_id" : model.ID,@"type":type};

    [HKHttpTool POST:HK_TrainingWorkLike_URL parameters:param success:^(id responseObject) {
        if (HKReponseOK) {
            if (model.like) {
                model.like = 0;
                model.thumbs_up = [NSString stringWithFormat:@"%d",[model.thumbs_up intValue]-1];
            }else{
                model.like = 1;
                model.thumbs_up = [NSString stringWithFormat:@"%d",[model.thumbs_up intValue]+1];
            }
        }
    } failure:^(NSError *error) {
    }];
}


- (void)detelProductData:(HKPunchClockModel * )model{
    @weakify(self);
    NSDictionary *param = @{@"id" : model.ID};

    [HKHttpTool POST:HK_TrainingDeleWork_URL parameters:param success:^(id responseObject) {
        @strongify(self);
        if ([CommonFunction detalResponse:responseObject]) {
            [self loadNewListData];
        }
        showTipDialog(responseObject[@"msg"]);
    } failure:^(NSError *error) {

    }];
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status{
    return [UIImage imageNamed:@"empty_img1"];
}

@end
