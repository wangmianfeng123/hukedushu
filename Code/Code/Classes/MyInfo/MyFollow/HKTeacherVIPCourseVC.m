//
//  HKTeacherVIPCourseVC.m
//  Code
//
//  Created by Ivan li on 2017/7/20.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTeacherVIPCourseVC.h"
#import "VideoModel.h"
#import "CollectionCell.h"
#import "VideoPlayVC.h"
#import "UIBarButtonItem+Extension.h"
  
#import "UIBarButtonItem+Badge.h"

#import "HKSeriesCourseCell.h"
#import <Availability.h>
#import "HKCollectionTagView.h"
#import "SeriseCourseModel.h"


@interface HKTeacherVIPCourseVC ()<UITableViewDelegate,UITableViewDataSource,HKCollectionTagViewDelegate>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,strong)CollectionCell   *collectionCell;
@property(nonatomic,strong)HKCollectionTagView  *tabHeaderView;
@property(nonatomic,strong)NSMutableArray <SeriseTagModel*>*tagArr;
@property(nonatomic,strong)SeriseTagModel *tagModel;
/** 1- 普通视频 2-PGC (默认值-1) */
@property(nonatomic,copy)NSString *collectType;

@property(nonatomic,copy)NSString *page;

@end



@implementation HKTeacherVIPCourseVC

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:UM_RECORD_COLLECT_DEFAULT];
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)createUI {
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.tableView];
    //空视图
    self.emptyText = EMPETY_NO_COLLECTION;
    // 空视图 图片竖直 偏移距离
    self.verticalOffset =  -KNavBarHeight64 + PADDING_25;
//    [self setTitle:@"收藏视频" color:[UIColor whiteColor]];
    self.collectType = @"1";
    [self createLeftBarButton];
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 125;
        UIColor *color = COLOR_F6F6F6_3D4752;
        _tableView.separatorColor = color;
        _tableView.backgroundColor = color;
        //_tableView.tableHeaderView = [self tabHeaderView];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        // 注册cell
        [_tableView registerClass:[CollectionCell class] forCellReuseIdentifier:cellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSeriesCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSeriesCourseCell class])];
        
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
        //cell.watchLabel.hidden = NO;// 观看人数
        cellTemp = cell;
    }else{// 收藏的系列视频
        HKSeriesCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSeriesCourseCell class])];
        cell.model = videoModel;
        cellTemp = cell;
    }
    return cellTemp;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollectionListModel *listModel = self.dataArray[indexPath.row];
    VideoModel *model = ([self.collectType integerValue] == 1) ?listModel.class_1 :listModel.class_2;

    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                                videoName:model.video_titel
                                         placeholderImage:model.img_cover_url
                                               lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
    VC.videoType = ([self.collectType integerValue] == 2) ?HKVideoType_PGC :HKVideoType_Ordinary;
    [self pushToOtherController:VC];

}



#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = @"1";
        [strongSelf getCollectionList:nil page:strongSelf.page];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getCollectionList:nil page:strongSelf.page];
    }];
    self.page = @"1";
    [self getCollectionList:nil page:self.page];
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

    if (!self.teacher.teacher_id.length) {
        NSLog(@"教师ID不能为空");
        return;
    }
    
    NSDictionary *params = @{@"teacher_id" : self.teacher.teacher_id, @"page" : page, @"type" : @"1"};
    
    [HKHttpTool POST:TEACHER_OGC_COURSE parameters:params success:^(id responseObject) {
        
        [self tableHeaderEndRefreshing];
        if (HKReponseOK) {
            NSMutableArray *array = [NSMutableArray array];
            if ([responseObject[@"data"] objectForKey:@"lists"] && [[responseObject[@"data"] objectForKey:@"lists"] isKindOfClass:[NSArray class]]) {
                NSArray *videoArray = [VideoModel mj_objectArrayWithKeyValuesArray:[responseObject[@"data"] objectForKey:@"lists"]];
                
                // 2.10版本兼容短视频接口修改
                for (VideoModel *model in videoArray) {
                    CollectionListModel *collectionModel = [[CollectionListModel alloc] init];
                    collectionModel.type = @"1";
                    collectionModel.class_1 = model;
                    [array addObject:collectionModel];
                }
            }
            NSString *total_page = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"pageCount"]];
            if ([total_page integerValue] == [page integerValue]){
                [self tableFooterEndRefreshing];
            }else{
                [self tableFooterStopRefreshing];
                self.page = [NSString stringWithFormat:@"%d", [self.page intValue] + 1];
            }
            if ([page isEqualToString:@"1"]) {
                self.dataArray = array;
            }else{
                [self.dataArray addObjectsFromArray:array];
            }
        }else{
            if (!isLogin()) {
                NSMutableArray *array = [NSMutableArray array];
                self.dataArray = array;
            }
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
