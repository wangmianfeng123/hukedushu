//
//  HKTeacherPGCVC.m
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTeacherPGCVC.h"
#import "VideoModel.h"
#import "CollectionCell.h"
#import "MJExtension.h"

#import "UIBarButtonItem+Extension.h"

#import "UIBarButtonItem+Badge.h"

#import "AFNetworkTool.h"
#import "DownloadManager.h"
#import "DownloadCacher.h"
#import "DownloadManager+Utils.h"
#import "HKSeriesCourseCell.h"
#import <Availability.h>
#import "HKCollectionTagView.h"
#import "SeriseCourseModel.h"
#import "VideoPlayVC.h"

@interface HKTeacherPGCVC ()<UITableViewDelegate,UITableViewDataSource,HKCollectionTagViewDelegate>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,strong)CollectionCell   *collectionCell;

/** 1- 普通视频 2-PGC (默认值-1) */
@property(nonatomic,copy)NSString *collectType;

@end



@implementation HKTeacherPGCVC

- (instancetype)init {
    
    if (self = [super init]) {
        // 注册通知
        HK_NOTIFICATION_ADD_OBJ(HKCollectionVCRefreshNotification, notificationRefreshView, nil);
        [self userLoginAndLogotObserver];
    }
    return self;
}

- (void)notificationRefreshView {
    [self.tableView.mj_header beginRefreshing];
}


- (void)userloginSuccessNotification {
    [self getCollectionList:nil page:@"1"];
}

- (void)userlogoutSuccessNotification {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}



- (void)loadView {
    [super loadView];
    [self createUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUI];
    [self getCollectionList:nil page:@"1"];
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

#pragma mark - WMStickyPageViewControllerDelegate
//- (UIScrollView *)streachScrollView {
//    return self.tableView;
//}

- (void)createUI {
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self.view addSubview:self.tableView];
    //空视图
    self.emptyText = EMPETY_NO_COLLECTION;
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
    [self setTitle:@"收藏视频" color:[UIColor whiteColor]];
    self.collectType = @"2";
    [self createLeftBarButton];
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 120;
        UIColor *color = COLOR_F6F6F6_3D4752;
        _tableView.separatorColor = color;
        _tableView.backgroundColor = color;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        // 注册cell
        [_tableView registerClass:[CollectionCell class] forCellReuseIdentifier:cellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSeriesCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSeriesCourseCell class])];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
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




static NSString * const cellIdentifier = @"CollectionCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionListModel *listModel = self.dataArray[indexPath.row];
    VideoModel *videoModel = ([self.collectType integerValue] == 1) ?listModel.class_1 :listModel.class_2;
    
    UITableViewCell *cellTemp = nil;
    // 普通视频
    if (videoModel.videoType != 1) {
        CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //cell.model = videoModel;
        cell.listModel = listModel;
        cellTemp = cell;
    }else{// 收藏的系列视频
        HKSeriesCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSeriesCourseCell class])];
        cell.model = videoModel;
        cellTemp = cell;
    }
    return cellTemp;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
    
    CollectionListModel *listModel = self.dataArray[indexPath.row];
    VideoModel *model = ([self.collectType integerValue] == 1) ?listModel.class_1 :listModel.class_2;
    
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                videoName:model.video_titel
                                         placeholderImage:model.img_cover_url
                                               lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
    VC.videoType = ([self.collectType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
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
        [strongSelf getCollectionList:nil page:@"1"];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)strongSelf.dataArray.count/HomePageSize+1];
        [strongSelf getCollectionList:nil page:pageNum];
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

#pragma mark - 获取视频列表
- (void)getCollectionList:(NSString*)token page:(NSString*)page {
    WeakSelf;
    
    NSDictionary *params = @{@"teacher_id" : self.teacher.teacher_id, @"page" : page, @"type" : @"2"};
    
    [HKHttpTool POST:@"/teacher/home" parameters:params success:^(id responseObject) {
        
        [weakSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            NSMutableArray *array = nil;
            if ([responseObject[@"data"] objectForKey:@"video_list"] && [[responseObject[@"data"] objectForKey:@"video_list"] isKindOfClass:[NSArray class]]) {
                array = [CollectionListModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"video_list"]];
            }
            
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
            if (!isLogin()) {
                NSMutableArray *array = [NSMutableArray array];
                weakSelf.dataArray = array;
            }
            [weakSelf tableFooterStopRefreshing];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf tableHeaderEndRefreshing];
            [weakSelf tableFooterStopRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (weakSelf.dataArray.count<1) {
                    [weakSelf.tableView reloadData];
                }else{
                    showTipDialog(NETWORK_NOT_POWER);
                }
            });
        });
    }];
}

@end

