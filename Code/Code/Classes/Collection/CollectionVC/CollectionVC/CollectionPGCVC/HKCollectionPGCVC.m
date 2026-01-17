//
//  HKCollectionPGCVC.m
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKCollectionPGCVC.h"
#import "VideoModel.h"
#import "CollectionCell.h"
#import "MJExtension.h"
#import "AFNetworkTool.h"

#import "VideoPlayVC.h"
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


@interface HKCollectionPGCVC ()<UITableViewDelegate,UITableViewDataSource,HKCollectionTagViewDelegate>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,strong)CollectionCell   *collectionCell;

/** 1- 普通视频 2-PGC (默认值-1) */
@property(nonatomic,copy)NSString *collectType;

@end



@implementation HKCollectionPGCVC

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


- (void)createUI {
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
        _tableView.separatorColor = COLOR_F6F6F6;
        _tableView.backgroundColor = COLOR_F6F6F6;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        // 注册cell
        [_tableView registerClass:[CollectionCell class] forCellReuseIdentifier:cellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSeriesCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSeriesCourseCell class])];
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


/*

//滑动删除 cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 110000
#pragma mark - 设置删除按钮的样式
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        if (weakSelf.dataArray.count >0) {
            // 1. 更新数据  2. 更新UI
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要取消收藏?" message:nil preferredStyle:1];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 if (weakSelf.dataArray.count >0) {
                                                                     
                                                                     CollectionListModel *listModel = self.dataArray[indexPath.row];
                                                                     VideoModel *model = ([self.collectType integerValue] == 1) ?listModel.class_1 :listModel.class_2;
                                                                     if (!isEmpty(model.video_id)) {
//                                                                         [weakSelf deleteCollectWithVideoId:model.video_id index:indexPath videoType:self.collectType];
                                                                     }
                                                                 }
                                                                 
                                                                 //                if (weakSelf.dataArray.count <= 0){
                                                                 //                     tableView.emptyDataSetSource = weakSelf;
                                                                 //                     tableView.emptyDataSetDelegate = weakSelf;
                                                                 //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                 //                            [tableView reloadData];
                                                                 //                    });
                                                                 //                 }
                                                                 //如果删除的时候数据紊乱,可延迟0.5s刷新一下
                                                                 //[self performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
                                                             }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
    }];
    deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#ff3b30"];
    NSArray *array = nil;
    array = [[NSArray alloc]initWithObjects:deleteRowAction, nil];
    return array;
}

//#else

-(nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (@available(iOS 11.0, *)) {
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"取消收藏" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            WeakSelf;
            if (weakSelf.dataArray.count >0) {
                // 1. 更新数据  2. 更新UI
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要取消收藏?" message:nil preferredStyle:1];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     if (weakSelf.dataArray.count >0) {
                                                                         CollectionListModel *listModel = self.dataArray[indexPath.row];
                                                                         VideoModel *model = ([self.collectType integerValue] == 1) ?listModel.class_1 :listModel.class_2;
                                                                         if (!isEmpty(model.video_id)) {
//                                                                             [weakSelf deleteCollectWithVideoId:model.video_id index:indexPath videoType:self.collectType];
                                                                         }
                                                                         completionHandler(NO);
                                                                     }
                                                                 }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:okAction];
                [alert addAction:cancel];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        }];
        //也可以设置图片
        deleteAction.backgroundColor = [UIColor colorWithHexString:@"#ff3b30"];
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        return config;
    } else {
        // Fallback on earlier versions
        return nil;
    }
}

//#endif
 
 */




#pragma mark - 刷新
- (void)refreshUI {

    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf getCollectionList:nil page:@"1"];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
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
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange getCOllectionVideoListWithToken:nil pageNum:page collectType:weakSelf.collectType completion:^(FWServiceResponse *response) {
        //[mange getCOllectionVideoListWithToken:nil pageNum:page completion:^(FWServiceResponse *response) {
        

        [weakSelf tableHeaderEndRefreshing];
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSMutableArray *array = nil;
            if ([response.data objectForKey:@"list"] && [[response.data objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                //array = [VideoModel mj_objectArrayWithKeyValuesArray:[[response.data objectForKey:@"list"] objectForKey:@"video_list"]];
                array = [CollectionListModel mj_objectArrayWithKeyValuesArray:[response.data objectForKey:@"list"]];
            }
            
            if ([[NSString stringWithFormat:@"%@", response.data[@"total_page"]] isEqualToString:page]){
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
    } failBlock:^(NSError *error) {
        
        [weakSelf tableHeaderEndRefreshing];
        [weakSelf tableFooterStopRefreshing];
        if (weakSelf.dataArray.count<1) {
            [weakSelf.tableView reloadData];
        }else{
            showTipDialog(NETWORK_NOT_POWER);
        }
    }];
}



//#pragma mark - 删除收藏视频
/*
- (void)deleteCollectWithVideoId:(NSString*)videoId  index:(NSIndexPath*)index videoType:(NSString*)videoType {
    //1-收藏视频 2-取消收藏视频
    WeakSelf;
    HKVideoType type = [videoType integerValue] == 1 ? HKVideoType_Ordinary : HKVideoType_PGC;
    [[FWNetWorkServiceMediator sharedInstance] collectOrQuitVideoWithToken:nil videoId:videoId type:@"2" videoType:type postNotification:NO completion:^(FWServiceResponse *response) {

        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {

            [weakSelf.dataArray removeObjectAtIndex:index.row];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
            }
            showTipDialog(@"取消成功");
        }else{
            showTipDialog(response.msg);
        }
    } failBlock:^(NSError *error) {

    }];
}
*/

@end

