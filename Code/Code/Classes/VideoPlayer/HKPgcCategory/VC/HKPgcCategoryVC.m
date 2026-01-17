//
//  HKPgcCategoryVC.m
//  Code
//
//  Created by Ivan li on 2017/12/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPgcCategoryVC.h"
#import "VideoPlayVC.h"
#import "HKPgcCategoryCell.h"
#import "HKPgcCategoryModel.h"

@interface HKPgcCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,strong)HKPgcCategoryCell   *collectionCell;
@property(nonatomic,copy)NSString *classId;//分类ID

@end

@implementation HKPgcCategoryVC

- (void)loadView {
    [super loadView];
    [self createUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUI];
    [self getPGCListWithPage:@"1" tagId:nil sort:@"0"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:UM_RECORD_COLLECT_DEFAULT];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    self.emptyText = EMPETY_NO_COLLECTION;
    [self setTitle:@"名师机构" color:COLOR_27323F];
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
        _tableView.separatorColor = COLOR_F6F6F6;
        _tableView.backgroundColor = COLOR_F6F6F6;
        [_tableView registerClass:[HKPgcCategoryCell class] forCellReuseIdentifier:NSStringFromClass([HKPgcCategoryCell class])];
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0)];
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
    return _dataArray.count ? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
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
    
    HKPgcCourseModel *pgcModel = _dataArray[indexPath.row];
    HKPgcCategoryCell *cell = [HKPgcCategoryCell initCellWithTableView:tableView];
    cell.model = pgcModel;
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
    
    HKPgcCourseModel *pgcModel = _dataArray[indexPath.row];
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                videoName:pgcModel.title
                                         placeholderImage:pgcModel.cover_url
                                               lookStatus:LookStatusInternetVideo videoId:pgcModel.video_id model:pgcModel];
    VC.videoType = HKVideoType_PGC;
    [self pushToOtherController:VC];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}






#pragma mark - 刷新
- (void)refreshUI {

    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getPGCListWithPage:@"1" tagId:nil sort:nil];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)strongSelf.dataArray.count/HomePageSize+1];
        [strongSelf getPGCListWithPage:pageNum tagId:nil sort:nil];
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


#pragma mark - 获取PGC列表
- (void)getPGCListWithPage:(NSString*)page tagId:(NSString*)tagId  sort:(NSString*)sort{
    WeakSelf;
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",sort,@"sort",tagId,@"tag_id",nil];
    [HKHttpTool POST:PGC_LIST parameters:parameters success:^(id responseObject) {
        [weakSelf tableHeaderEndRefreshing];

        if (HKReponseOK) {
            HKPgcCategoryModel *model = [HKPgcCategoryModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSMutableArray *array = model.course_list;
            
            if ([[NSString stringWithFormat:@"%@", responseObject[@"data"][@"total_page"]] isEqualToString:page]){
                [weakSelf tableFooterEndRefreshing];
            }else{
                [weakSelf tableFooterStopRefreshing];
            }
            if ([page isEqualToString:@"1"]) {
                weakSelf.dataArray = array;
            }else{
                [weakSelf.dataArray addObjectsFromArray:array];
            }
        }else{
            [weakSelf tableFooterStopRefreshing];
        }
        
        
        [weakSelf.tableView reloadData];

    } failure:^(NSError *error) {
        
        [weakSelf tableHeaderEndRefreshing];
        [weakSelf tableFooterStopRefreshing];
        
        
        if (weakSelf.dataArray.count<1) {
            [weakSelf.tableView reloadData];
        }else{
            showTipDialog(NETWORK_NOT_POWER);
        }
    }];

}


@end
