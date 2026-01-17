//
//  HKCategoryAlbumVC.m
//  Code
//
//  Created by Ivan li on 2017/12/4.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCategoryAlbumVC.h"
#import "HKVideoNormalTBCell.h"
#import "UIBarButtonItem+Extension.h"
#import "FWNetWorkServiceMediator.h"
#import "MJExtension.h"
#import "VideoModel.h"
  
#import "CategoryModel.h"
#import "VideoPlayVC.h"

#import "VideoServiceMediator.h"
#import "TagModel.h"
#import "HKCategoryAlbumModel.h"
#import "HKCategoryAlbumCell.h"
#import "HKAlbumDetailVC.h"
#import "HKAlbumListModel.h"
#import "HKContainerModel.h"

#import "HKDropMenu.h"
#import "HKDropMenuModel.h"

#import "PYSearch.h"
#import "SearchResultVC.h"
#import "HKPushToSearch.h"

@interface HKCategoryAlbumVC ()<TBSrollViewEmptyDelegate, UITableViewDelegate,UITableViewDataSource,HKDropMenuDelegate,PYSearchViewControllerDelegate,PYSearchViewControllerDataSource>


@property(nonatomic,strong)NSMutableArray *dataArray;


@property(nonatomic,strong)UITableView    *tableView;

@property(nonatomic,copy)NSString  *videoCount; //记录筛选视频数

@property(nonatomic,strong)NSMutableDictionary *tagDict;// 保存标签

@property(nonatomic,assign)NSUInteger selectIndex;// 保存排序 index

@property(nonatomic,assign)NSUInteger loadCount;

@property(nonatomic,strong)HKCategoryAlbumModel *categoryAlbumModel;

@property(nonatomic,strong)HKDropMenu *dropMenu;

@property (nonatomic , strong)HKPushToSearch * manager;
@end


@implementation HKCategoryAlbumVC


- (instancetype)initWithModel:(CategoryModel*)model {
    
    self = [super init];
    if (self) {
        self.category = model.className;
        self.loadCount = SetupCountOnce;
    }
    return self;
}



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSString*)category{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.category = category;
        self.loadCount = SetupCountOnce;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.hk_hideNavBarShadowImage = YES;
    [self creatUI];
    [self refreshUI];
    [self sortVideoByPage:@"1"];
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithImage:[UIImage hkdm_imageWithNameLight:@"ic_search_notes_2_30" darkImageName:@"search_gray_dark"] target:self action:@selector(rightBarBtnAction) size:CGSizeMake(40, 40)];
}

-(void)rightBarBtnAction{
    NSLog(@"点击搜索");
    self.manager =[[HKPushToSearch alloc] init];
    [self.manager hkPushToSearchWithVC:self withKeyWord:@"" withIndex:4];
    [MobClick event:albumpage_search];
}



- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableDictionary*)tagDict {
    if (!_tagDict) {
        _tagDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _tagDict;
}



- (void)creatUI {
    
    [self createLeftBarButton];
    self.title = @"专辑";
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)setVideoCount:(NSString *)videoCount {
    _videoCount = videoCount;   
    
    NSString *title = [NSString stringWithFormat:@"%@个专辑",isEmpty(videoCount) ?@"0" :videoCount];
    [self.dropMenu resetFirstMenuTitleWithTitle:title];
}



- (HKDropMenu*)dropMenu {
    if (!_dropMenu) {
        _dropMenu = [[HKDropMenu alloc]initWithFrame:CGRectZero];
    }
    return _dropMenu;
}


- (void)setMenuConfigWithArr:(NSMutableArray <AlbumSortTagListModel*> *)tagArr  videoCount:(NSString*)videoCount {
    
    HKDropMenuModel *configuration = [[HKDropMenuModel alloc]init];
    configuration.recordSeleted = YES;
    configuration.titles = [HKDropMenuModel albumMenuArray:tagArr videoCount:[videoCount integerValue]];
    [self setUpDropMenuWithConfig:configuration];
}


#pragma mark - 设置 menu
- (void)setUpDropMenuWithConfig:(HKDropMenuModel*)configuration {
    
    HKDropMenu *dropMenu = [HKDropMenu creatDropMenuWithConfiguration:configuration frame:CGRectMake(0, KNavBarHeight64,SCREEN_WIDTH, 40) dropMenuTitleBlock:^(HKDropMenuModel * _Nonnull dropMenuModel) {
        
    } dropMenuTagArrayBlock:^(NSArray * _Nonnull tagArray) {
        
    }];
    dropMenu.titleViewBackGroundColor = COLOR_FFFFFF_3D4752;
    
    dropMenu.delegate = self;
    dropMenu.durationTime = 0.5;
    
    self.dropMenu = dropMenu;
    [self.view addSubview:dropMenu];
}



#pragma mark -  HKDropMenu  代理;
- (void)dropMenu:(HKDropMenu *)dropMenu dropMenuTitleModel:(HKDropMenuModel *)dropMenuTitleModel {
    
    self.selectIndex = dropMenuTitleModel.cellRow;
    [self sortVideoByPage:@"1"];
    [self umRecorded:dropMenuTitleModel.cellRow];
}


- (void)dropMenu:(HKDropMenu *)dropMenu tagArray:(nullable NSArray<HKDropMenuModel *> *)tagArray {
    [self.tagDict removeAllObjects];
    for (int i = 0; i < tagArray.count; i++) {
        HKDropMenuModel *model = tagArray[i];
        [self.tagDict setObject:@(model.tagId) forKey:[NSString stringWithFormat:@"tag%d",i]];
    }
    [self sortVideoByPage:@"1"];
}


- (void)dropMenu: (HKDropMenu *)dropMenu reset:(BOOL)reset {
    [self.tagDict removeAllObjects];
}


#pragma mark - 友盟统计
- (void)umRecorded:(NSUInteger)btnIndex {
    
    switch (btnIndex) {
        case 0:
            [MobClick event:UM_RECORD_LIST_DEFAULT_SORT];
            break;
        case 1:
            [MobClick event:UM_RECORD_LIST_NEW_SORT];
            break;
        case 2:
            [MobClick event:UM_RECORD_LIST_HOT_SORT];
            break;
        case 3:
            [MobClick event:UM_RECORD_LIST_HARD_SORT];
            break;
        case 4:
            [MobClick event:UM_RECORD_LIST_EASY_SORT];
            break;
    }
}



#pragma mark - 按所选tag值  筛选视频
- (void)sortVideoByPage:(NSString*)page {
    
    NSString *str[20];
    for (int i = 0; i<self.tagDict.count; i++) {
        str[i] = self.tagDict[[NSString stringWithFormat:@"tag%d",i]];
    }
    [self filterVideoListWithClassName:self.category sort:[NSString stringWithFormat:@"%ld",self.selectIndex]
                                      page:page tag1:str[0] tag2:str[1] tag3:str[2] tag4:str[3]];
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.rowHeight = 230/2;//113*Ratio+PADDING_5;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_eeeeee;
        _tableView.backgroundColor = COLOR_F6F6F6;
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64 + 40, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.tb_EmptyDelegate = self;
        
        UIColor *separatorColor = [UIColor hkdm_colorWithColorLight:COLOR_eeeeee dark:COLOR_333D48];
        _tableView.separatorColor = separatorColor;
        UIColor *bgColor = COLOR_F6F6F6_3D4752;
        _tableView.backgroundColor = bgColor;
    }
    return _tableView;
}



#pragma mark <UITablViewDelegate>

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HKCategoryAlbumCell *cell = [HKCategoryAlbumCell initCellWithTableView:tableView];
    cell.model = _dataArray[[indexPath row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    __block HKAlbumModel *albumModel = _dataArray[indexPath.row];
    HKAlbumDetailVC *VC  = [[HKAlbumDetailVC alloc]initWithAlbumModel:albumModel];
    __block NSInteger row = indexPath.row;
    WeakSelf;
    VC.operationAlbumActionBlock = ^(HKAlbumListModel *model) {
        albumModel.collect_num = model.collect_num;
        [weakSelf.dataArray replaceObjectAtIndex:row withObject:albumModel];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self pushToOtherController:VC];
}




#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        [strongSelf sortVideoByPage:@"1"];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)strongSelf.dataArray.count/HomePageSize+1];
        [strongSelf sortVideoByPage:pageNum];
    }];
}



#pragma mark - 筛选视频
- (void)filterVideoListWithClassName:(NSString*)className  sort:(NSString*)sort page:(NSString*)page
                                tag1:(NSString*)tag1 tag2:(NSString*)tag2 tag3:(NSString*)tag3 tag4:(NSString*)tag4 {
    
    WeakSelf;
    [[VideoServiceMediator sharedInstance] filterAlbumListWithSort:sort page:page tag1:tag1 tag2:tag2
                                                               tag3:tag3 tag4:tag4 completion:^(FWServiceResponse *response) {
               [weakSelf tableHeaderEndRefreshing];
               if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                   
                   NSString *count =  [response.data objectForKey:@"album_count"];
                   weakSelf.videoCount = count;
                   HKCategoryAlbumModel *model = [HKCategoryAlbumModel mj_objectWithKeyValues:response.data];
                   
                   if (weakSelf.loadCount == SetupCountOnce) {
                       weakSelf.categoryAlbumModel = model;
                       //创建排序 筛选导航
                       [weakSelf setMenuConfigWithArr:weakSelf.categoryAlbumModel.label_list videoCount:self.videoCount];
                       weakSelf.loadCount = SetupCountSecond;
                   }
                   
                   NSMutableArray *array = model.album_list;
                   if (array.count==0||array.count % HomePageSize!=0){
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
                                                                   
                   if ([page isEqualToString:@"1"]) {
                       if (weakSelf.tableView.visibleCells.count) {
                           [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                       }
                   }
               
           } failBlock:^(NSError *error) {
               
               [weakSelf tableHeaderEndRefreshing];
               [weakSelf tableFooterStopRefreshing];
                if (weakSelf.dataArray.count<1) {
                    [weakSelf.tableView reloadData];
                }
           }];
}

//*********************** 刷新 ***********************／/
- (void)tableHeaderEndRefreshing {
    [self.tableView.mj_header endRefreshing];
}

- (void)tableFooterEndRefreshing {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
}

@end

