//
//  HKLearnPgcVC.m
//  Code
//
//  Created by Ivan li on 2018/2/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLearnPgcVC.h"
#import "VideoModel.h"
#import "LearnedPgcCell.h"
#import "MJExtension.h"
#import "VideoPlayVC.h"
#import "UIBarButtonItem+Extension.h"
#import "UIBarButtonItem+Badge.h"
#import "HKCollectionTagView.h"
#import "SeriseCourseModel.h"


@interface HKLearnPgcVC ()<UITableViewDelegate,UITableViewDataSource,TBSrollViewEmptyDelegate>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
/** 1- 普通视频 2-PGC (默认值-1) */
@property(nonatomic,copy)NSString *videoType;

@end


@implementation HKLearnPgcVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick event:UM_RECORD__PERSON_PLAYLIST];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    //self.title = @"已学视频";
    self.videoType = @"2";
    //空视图
    self.emptyText = @"您暂无已学视频";
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
    
    [self.view addSubview:self.tableView];
    [self createLeftBarButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"] ;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = IS_IPHONE5S ? 120 :130;
        _tableView.separatorColor = COLOR_eeeeee;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
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
    return _dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.05;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.05;
}


static NSString * const cellIdentifier = @"LearnedPgcCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LearnedPgcCell *pgcCell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!pgcCell ) {
        pgcCell = [[LearnedPgcCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
    }
    id model = self.dataArray[[indexPath row]];
    if ([model isKindOfClass: [VideoModel class]]) {
        ((VideoModel*)model).videoType = ([self.videoType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
        pgcCell.model = model;
    }
    return pgcCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
    id model = self.dataArray[[indexPath row]];
    VideoPlayVC *VC = nil;
    
    if ([model isKindOfClass: [VideoModel class]]) {
        
        VideoModel  *tempModel = (VideoModel*)model;
        VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil
                                         fileUrl:tempModel.video_url
                                       videoName:tempModel.video_titel
                                placeholderImage:tempModel.img_cover_url
                                      lookStatus:LookStatusInternetVideo videoId:tempModel.video_id model:tempModel];
        VC.videoType = ([self.videoType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
    }
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
        [strongSelf getLearnedListWithPage:@"1"];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.dataArray.count/HomePageSize+1];
        [strongSelf getLearnedListWithPage:pageNum];
    }];
    [self getLearnedListWithPage:@"1"];
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




#pragma mark - 获取视频列表
- (void)getLearnedListWithPage:(NSString*)page {
    WeakSelf;
    [[FWNetWorkServiceMediator sharedInstance] getStudyVideoListWithToken:nil pageNum:page videoType:weakSelf.videoType completion:^(FWServiceResponse *response) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            //NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"list"]];
            NSMutableArray *array = [VideoModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"pgc"]];
            if (array.count==0||array.count % HomePageSize!=0) {
                [strongSelf tableFooterEndRefreshing];
            }else{
                [strongSelf tableFooterStopRefreshing];
            }
            if ([page isEqualToString:@"1"]) {
                strongSelf.dataArray = array;
            }else{
                [strongSelf.dataArray addObjectsFromArray:array];
            }
        } else {
            [weakSelf tableFooterStopRefreshing];
        }
        [strongSelf.tableView reloadData];
    } failBlock:^(NSError *error) {
        StrongSelf;
        [strongSelf tableHeaderEndRefreshing];
        [strongSelf tableFooterStopRefreshing];
        [strongSelf.tableView reloadData];
    }];
}


@end

