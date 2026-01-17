//
//  HKLiveingOrderVC.m
//  Code
//
//  Created by Ivan li on 2019/8/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKLiveingOrderVC.h"
#import "HKOrderPaymentModel.h"
#import "HKTrainOrderCell.h"
#import "TBScrollViewEmpty.h"
#import "HKPgcCategoryModel.h"
#import "VideoPlayVC.h"
#import "HKTrainModel.h"
#import "HKJobPathModel.h"
#import "HKLivingPlayVC2.h"
#import "HKLiveCourseVC.h"
#import "HKSaveQrCodeView.h"
#import "HKVersionModel.h"
#import "HKTakeGifView.h"

@interface HKLiveingOrderVC ()<UITableViewDelegate, UITableViewDataSource, TBSrollViewEmptyDelegate,HKTrainOrderCellDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKTrainModel *> *dataSource;

@property (nonatomic,assign) NSInteger  page;

@end

@implementation HKLiveingOrderVC



- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, kHeight44, 0);
    HKAdjustsScrollViewInsetNever(self, self.tableView);
    
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf loadNewData];
    }];
    [tableView.mj_header beginRefreshing];
    
    [HKRefreshTools footerAutoRefreshWithTableView:tableView completion:^{
        StrongSelf;
        [strongSelf loadMoreData ];
    }];
}


- (void)setupNav {
    self.emptyText = @"目前暂无订单";
    [self createLeftBarButton];
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count ?1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 10;
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 202;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKTrainOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTrainOrderCell class])];
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HKTrainModel *model = self.dataSource[indexPath.row];
    HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
    VC.course_id = model.live_small_id;
    [self pushToOtherController:VC];
}




#pragma mark <HKTrainOrderCellDelegate>
- (void)immediateStudy:(id)sender {

}



#pragma mark <TBEmptyDelegate>
//- (NSString *)tb_emptyString {
//    return @"你暂时无订单";
//}

- (UIEdgeInsets)tb_emptyViewInset {
    return UIEdgeInsetsMake(50, 0, 0, 0);
}


- (NSMutableArray <HKTrainModel*>*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)tableHeaderEndRefreshing {
    [self.tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark <Server>
- (void)loadNewData {
    
    self.tableView.mj_footer.hidden = NO;
    NSDictionary *dict = @{@"page":@(self.page)};
    [HKHttpTool POST:LIVE_ORDER_LIST parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                self.dataSource = [HKTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                
//                NSArray * array = [HKTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
//                for (HKTrainModel * trainModel in array) {
//
//                    HKTrainModel * gifModel = [[HKTrainModel alloc] init];
//                    gifModel.name = @"哈哈";
//                    [trainModel.giveVipList addObject:gifModel];
//
//
//                    [trainModel.giveLiveList addObject:gifModel];
//                    [trainModel.giveLiveList addObject:gifModel];
//                    [trainModel.giveLiveList addObject:gifModel];
//                    trainModel.hasGive = @"1";
//                }
//                for (int i = 0 ; i < 10; i++) {
//                    [self.dataSource addObjectsFromArray:array];
//                }
                
                
                [self.dataSource enumerateObjectsUsingBlock:^(HKTrainModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.isLive  = YES;
                }];
                
                
                
                
                
                HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"page_info"]];
                if (pageModel.current_page >= pageModel.page_total) {
                    [self tableFooterEndRefreshing];
                }else{
                    [self tableFooterStopRefreshing];
                }
                [self.tableView reloadData];
            }
            self.page ++;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    
    NSDictionary *dict = @{@"page":@(self.page)};
    [HKHttpTool POST:LIVE_ORDER_LIST parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSArray *array = [HKTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
                [self.dataSource addObjectsFromArray:array];
                [self.dataSource enumerateObjectsUsingBlock:^(HKTrainModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.isLive  = YES;
                }];
                HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
                if (pageModel.current_page >= pageModel.page_total) {
                    [self tableFooterEndRefreshing];
                }else{
                    [self tableFooterStopRefreshing];
                }
                [self.tableView reloadData];
            }
            self.page ++;
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)trainOrderCell:(HKTrainOrderCell *)cell didGifBtn:(HKTrainModel *)model{
    HKTakeGifView * gifView = [[HKTakeGifView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [gifView createWithVIPArray:model.giveVipList liveArray:model.giveLiveList];
    WeakSelf
    gifView.didCourseBlock = ^(HKTrainModel * _Nonnull courseModel) {
        HKLiveCourseVC *VC = [[HKLiveCourseVC alloc]init];
        VC.course_id = courseModel.live_small_catalog_id;
        [weakSelf pushToOtherController:VC];
    };
    
    CGPoint point = [cell convertPoint:cell.gifButton.center toView:[UIApplication sharedApplication].keyWindow];
    [gifView showWithPoint:point];    
    
}


- (void)trainOrderCellDidTeacherBtn:(HKTrainModel *)model{
    HKVersionModel *mod = [HKVersionModel new];
    mod.url = model.teacher_qr;
    [HKSaveQrCodeView showDownAppViewWithModel:mod nextBlock:^{
        [HKImagePickerController hk_savedPhotosAlbum:model.teacher_qr];
    }];
    
}


@end
