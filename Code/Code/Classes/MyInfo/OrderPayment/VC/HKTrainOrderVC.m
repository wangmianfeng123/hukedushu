//
//  HKPGCOrderVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/13.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTrainOrderVC.h"
#import "HKOrderPaymentModel.h"
#import "HKTrainOrderCell.h"
#import "TBScrollViewEmpty.h"
#import "HKPgcCategoryModel.h"
#import "VideoPlayVC.h"
#import "HKTrainModel.h"
#import "HKTrainDetailVC.h"


@interface HKTrainOrderVC ()<UITableViewDelegate, UITableViewDataSource, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKTrainModel *> *dataSource;

@end

@implementation HKTrainOrderVC



- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self setupNav];
    [self setupTableView];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.tableView.backgroundColor = COLOR_F8F9FA_3D4752;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    [self.view addSubview:tableView];
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor= HKColorFromHex(0xF8F9FA, 1.0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView = tableView;
    tableView.tb_EmptyDelegate = self;
    
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTrainOrderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKTrainOrderCell class])];
    
    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, kHeight44, 0);
    
    WeakSelf;    
    [HKRefreshTools headerRefreshWithTableView:tableView completion:^{
        StrongSelf;
        [strongSelf loadNewData];
    }];
    [tableView.mj_header beginRefreshing];
    
    [HKRefreshTools footerAutoRefreshWithTableView:tableView completion:^{
        StrongSelf;
        [strongSelf loadMoreData ];
    }];
}


- (void)setupNav {
    self.title = @"我的订单";
    self.emptyText = @"目前暂无订单";
    [self createLeftBarButton];
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count ?1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 202;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTrainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTrainOrderCell class])];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HKTrainModel *model = self.dataSource[indexPath.row];
    if (2 == model.state) {
        // 结束大于7 天
        if (model.is_expire) {
            // 过期不能观看
            [self trainEndAlert];
        }else{
            [self pushToTrainDetailWithId:model.training_id];
        }
    }else{
        [self pushToTrainDetailWithId:model.training_id];
    }
}




/// 跳转训练营详情
/// @param trainingId 训练营ID
- (void)pushToTrainDetailWithId:(NSString*)trainingId {
    HKTrainDetailVC *vc = [[HKTrainDetailVC alloc] init];
    vc.trainingId = trainingId;
    [self pushToOtherController:vc];
}



/// 训练营 结束 到现在的时间 天数
- (NSInteger)daysWithDateString:(NSString*)dateString {
    NSDate *time = [DateChange dayFromString:dateString];
    NSDate *currentTime = [DateChange dayFromString:[DateChange getCurrentTime_day]];
    NSInteger days = [DateChange numberOfDaysWithFromDate:time toDate:currentTime];
    return days;
}



/// 训练营 结束弹窗
- (void)trainEndAlert {
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"训练营已结束";
        label.font = HK_FONT_SYSTEM_BOLD(15);
        label.textColor = COLOR_030303;
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = @"敬请期待下一期";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
    })
    .LeeAddAction(^(LEEAction *action) {
        action.font = HK_FONT_SYSTEM(15);
        action.type = LEEActionTypeCancel;
        action.title = @"知道了";
        action.titleColor = COLOR_0076FF;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            return ;
        };
    })
    .LeeHeaderColor(COLOR_ffffff)
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



#pragma mark <HKTrainOrderCellDelegate>
- (void)immediateStudy:(id)sender {
//    HKTrainModel *model = sender;
//    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:model.title
//                                         placeholderImage:nil LOOKStatus:LookStatusInternetVideo
//                                                  videoId:model.video_id model:model];
//    VC.videoType = HKVideoType_PGC;
//    [self pushToOtherController:VC];
}



#pragma mark <TBEmptyDelegate>
- (NSString *)tb_emptyString {
    return @"你暂时无订单";
}

- (UIEdgeInsets)tb_emptyViewInset {
    return UIEdgeInsetsMake(50, 0, 0, 0);
}


- (NSMutableArray <HKTrainModel*>*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark <Server>
- (void)loadNewData {
    
    self.tableView.mj_footer.hidden = NO;
    
    [HKHttpTool POST:@"training/orders" parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.dataSource = [HKTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                [self.tableView reloadData];
                
                
                BOOL is_end = ![[NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_end"]] isEqualToString:@"0"];
                
                if (is_end) {
                    self.tableView.mj_footer.hidden = YES;
                }
            }
            
            [self.tableView.mj_header endRefreshing];
            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    
    NSDictionary *param = @{@"lastId" : self.dataSource.lastObject.ID};
    
    [HKHttpTool POST:@"training/orders" parameters:param success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSArray *array = [HKTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                [self.dataSource addObjectsFromArray:array];
                [self.tableView reloadData];
                
                
                BOOL is_end = ![[NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_end"]] isEqualToString:@"0"];
                
                if (is_end) {
                    self.tableView.mj_footer.hidden = YES;
                }
            }
            
            [self.tableView.mj_footer endRefreshing];
            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


@end
