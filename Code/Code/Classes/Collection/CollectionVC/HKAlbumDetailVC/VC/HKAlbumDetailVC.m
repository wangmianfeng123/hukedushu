
//
//  HKAlbumDetailVC.m
//  Code
//
//  Created by Ivan li on 2017/12/3.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKAlbumDetailVC.h"
#import "HKAlbumDetailHeadView.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"
//#import "CollectionCell.h"
#import "HKSeriesCourseCell.h"
#import "HKAlbumListModel.h"
#import "HKContainerModel.h"
#import "HKContainerTagVC.h"
#import "SeriseCourseModel.h"
#import "HKEditContainerVC.h"
#import <TBScrollViewEmpty/TBScrollViewEmpty.h>
#import "HKAlbumDetailCell.h"

#define NAVBAR_CHANGE_POINT 80

@interface HKAlbumDetailVC ()<UITableViewDelegate,UITableViewDataSource,HKAlbumDetailHeadViewDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, assign)NSInteger totalPage;

@property (nonatomic, copy)NSString *albumId;

@property (nonatomic, strong)HKAlbumDetailHeadView *albumDetailHeadView;

@property (nonatomic, strong)HKAlbumListModel *listModel;

@property (nonatomic, assign)BOOL isMyAblum; // YES-用户创建的专辑

@property (nonatomic, weak)UILabel *titleLb;

@property (nonatomic, weak)UIButton *leftBarButton;

@property (nonatomic, assign)NSInteger rowCount;


@end


@implementation HKAlbumDetailVC

/** 空视图偏移量 */
- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    return  CGPointMake(0,180);
}


- (instancetype)initWithAlbumModel:(HKAlbumModel*) model {
    
    if(self = [super init]) {
        self.albumId = model.album_id;
    }
    return self;
}

- (instancetype)initWithAlbumModel:(HKAlbumModel*) model isMyAblum:(BOOL)isMyAblum {
    
    if(self = [super init]) {
        self.albumId = model.album_id;
        self.isMyAblum = isMyAblum;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    if (self.tableView) {
        CGFloat offsetY = self.tableView.contentOffset.y;
        [self setNavBarWithColorAlpha:offsetY];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    //tableView 滚到顶部
    if ([self.tableView.mj_header isRefreshing]) {
        self.tableView.contentOffset = CGPointMake(0, 0);
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}



#pragma mark - 滑动页面时 navBar 的颜色变化
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    [self setNeedsStatusBarAppearanceUpdate];
    if (offsetY > 0) {
        CGFloat alpha = MIN(1, offsetY/64);
        [self setNavBarWithColorAlpha:alpha];
        if (offsetY >KNavBarHeight64) {
            self.titleLb.textColor = COLOR_27323F;
            [self setButtonImage:self.leftBarButton imageName:@"nac_back"];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }else{
            self.titleLb.textColor = COLOR_ffffff;
            [self setButtonImage:self.leftBarButton imageName:@"nac_back_white"];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    } else {
        if (offsetY < -KNavBarHeight64) {
            [self setNavBarWithColorAlpha:1];
            self.titleLb.textColor = COLOR_27323F;
            [self setButtonImage:self.leftBarButton imageName:@"nac_back"];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }else{
            [self setNavBarWithColorAlpha:0];
            self.titleLb.textColor = COLOR_ffffff;
            [self setButtonImage:self.leftBarButton imageName:@"nac_back_white"];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }
    
}


#pragma mark 设置导航栏颜色
- (void)setNavBarWithColorAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.1 animations:^{
        [self.navigationController.navigationBar lt_setBackgroundColor:[NAVBAR_Color colorWithAlphaComponent:alpha]];
    }];
}


- (void)loadView {
    [super loadView];
    [self createUI];
}


- (void)createUI {
    
    self.page = 1;
    self.view.backgroundColor = COLOR_FFFFFF_333D48;// [UIColor whiteColor];
    self.emptyText = @"暂无更多数据";
    [self createLeftBarButton];
    [self setTitle:@"专辑" color:[UIColor whiteColor]];
    // 右边 navbar 按钮
    //[self createRightBarButtonWithImage:@"point_white" size:CGSizeMake(PADDING_40, PADDING_40)];
    [self getAlbumListByPage:[NSString stringWithFormat:@"%lu",self.page] albumId:self.albumId];
}



- (void)createLeftBarButton {
    
    UIButton *button = [UIButton new];
    [self setButtonImage:button imageName:@"nac_back_white"];

    button.size = CGSizeMake(PADDING_35, PADDING_35);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 44/2)];
    
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.leftBarButton = button;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)setButtonImage:(UIButton*)btn  imageName:(NSString*)imageName {
    [btn setImage:imageName(imageName) forState:UIControlStateNormal];
    [btn setImage:imageName(imageName) forState:UIControlStateHighlighted];
}



#pragma mark  导航栏上的标题
- (void)setTitle:(NSString *)title color:(UIColor*)color {
    
    UILabel* titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    [titleLb setText:title];
    [titleLb setTextColor:color];
    [titleLb setFont:HK_FONT_SYSTEM_BOLD(18)];
    [titleLb setTextAlignment:NSTextAlignmentCenter];
    [titleLb setAdjustsFontSizeToFitWidth:YES];
    self.titleLb = titleLb;
    self.navigationItem.titleView = titleLb;
}


- (void)rightBarBtnAction {
    return;
}


- (NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (HKAlbumDetailHeadView*)albumDetailHeadView {
    WeakSelf;
    if (!_albumDetailHeadView) {
        //_albumDetailHeadView = [[HKAlbumDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130+Ratio*113+KNavBarHeight64)];
        CGFloat height = [self headViewHeight:[self textRowWithText:self.listModel.introduce]];
        height = IS_IPHONE_X? height + 20 : height;
        _albumDetailHeadView = [[HKAlbumDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        
        _albumDetailHeadView.delegate = self;
        _albumDetailHeadView.isMyAblum = self.isMyAblum;
        
        _albumDetailHeadView.editMyAlbumBlock = ^(HKAlbumListModel *model) {
            StrongSelf;
            HKEditContainerVC *VC = [HKEditContainerVC new];
            VC.model = model;
            VC.albumId = strongSelf.albumId;
            VC.hKEditContainerVCBlock = ^(HKAlbumListModel *albumM) {
                strongSelf.albumDetailHeadView.model = albumM;
                //更新headview 高度
                CGFloat height = [strongSelf headViewHeight:[strongSelf textRowWithText:albumM.introduce]];
                height = IS_IPHONE_X? height + 20 : height;
                strongSelf.albumDetailHeadView.height = height;
                [strongSelf.tableView reloadData];
            };
            [strongSelf pushToOtherController:VC];
        };
    }
    return _albumDetailHeadView;
}


- (void)collectAblumList:(id)model {
    
    if (![HKAccountTool shareAccount]) {
        [self setLoginVC];
    }
}



- (void)setTableView {
    
    if (self.tableView) {
        return;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.separatorColor = COLOR_F8F9FA_333D48;
    // 兼容iOS11
    HKAdjustsScrollViewInsetNever(self, tableView);
    
    [tableView registerClass:[HKAlbumDetailCell class] forCellReuseIdentifier:NSStringFromClass([HKAlbumDetailCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSeriesCourseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSeriesCourseCell class])];
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0);
    tableView.rowHeight = 130;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 添加表格头部
    WeakSelf;
    self.albumDetailHeadView.model = self.listModel;
    self.albumDetailHeadView.quitOrCollectAlbumBlock = ^(HKAlbumListModel *model) {
        [MobClick event:UM_RECORD_COLLECTION_PAGE_COLLECT];
        weakSelf.listModel = model;
        !weakSelf.operationAlbumActionBlock? : weakSelf.operationAlbumActionBlock(model);
    };
    tableView.tableHeaderView = self.albumDetailHeadView;
    self.tableView = tableView;
    
    [self.view addSubview:self.tableView];
    tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self refreshUI];
    [tableView reloadData];
    [self refreshUI];
}

                                                                                      
                                                                                      
- (CGFloat)headViewHeight:(NSInteger)row {
      CGFloat height = 0;
      switch (row) {
          case 0:
              height = 516/2;
              break;
          case 1:
              height =  546/2;
              break;
          default:
              height =  580/2;
      }
    return height;
}


#pragma mark 文本行数
- (NSInteger)textRowWithText:(NSString *)text {
    if (isEmpty(text)) {
        return 0;
    }
    
    NSString *temp = [NSString stringWithFormat:@"简介：%@",text];
    //去除掉首尾的空白字符
    NSString *desc = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger count = [CommonFunction getTextRow:desc font:HK_FONT_SYSTEM(14) lineSpacing:0 width:SCREEN_WIDTH -20 lineBreakMode:0];
    return  count;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.dataArray.count>0) ?self.dataArray.count :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.dataArray.count>0) ?1 :0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoModel *videoModel = self.dataArray[indexPath.section];
    UITableViewCell *_cell = nil;
    
    if (videoModel.videoType != 1) {
        // 普通视频
        HKAlbumDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAlbumDetailCell class])];
        cell.model = videoModel;
        cell.isShowShadow = YES;
        _cell = cell;
    }else{
        // 收藏的系列视频
        HKSeriesCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSeriesCourseCell class])];
        cell.model = videoModel;
        _cell = cell;
    }
    return _cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.4f];
    VideoPlayVC *VC = nil;
    VideoModel *model = self.dataArray[indexPath.section];
    VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
                                       videoName:model.video_titel
                                placeholderImage:model.img_cover_url
                                      lookStatus:LookStatusInternetVideo
                                         videoId:model.video_id
                                           model:model];
    
    [self pushToOtherController:VC];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



//滑动删除 cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isMyAblum;
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
                                                                     
                                                                     VideoModel *model = weakSelf.dataArray[indexPath.section];
                                                                     [weakSelf deleteCollectWithVideoId:model.video_id index:indexPath];
                                                                 }
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

-(nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    
    if (@available(iOS 11.0, *)) {

        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"取消收藏"
                                                                                 handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            WeakSelf;
            if (weakSelf.dataArray.count >0) {
                // 1. 更新数据  2. 更新UI
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要取消收藏?" message:nil preferredStyle:1];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     if (weakSelf.dataArray.count >0) {
                                                                         VideoModel *model = weakSelf.dataArray[indexPath.section];
                                                                         [weakSelf deleteCollectWithVideoId:model.video_id index:indexPath];
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





#pragma mark - 刷新
- (void)refreshUI {

    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        [strongSelf getAlbumListByPage:[NSString stringWithFormat:@"%lu",strongSelf.page] albumId:strongSelf.albumId];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        [strongSelf getAlbumListByPage:pageNum albumId:strongSelf.albumId];
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


#pragma mark - 获取用户创建专辑
- (void)getAlbumListByPage:(NSString*)page  albumId:(NSString*)albumId {
    WeakSelf;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",albumId,@"album_id",nil];
    [HKHttpTool POST:ALBUM_DETAIL parameters:parameters success:^(id responseObject) {
        
        [weakSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            HKAlbumListModel *model = [HKAlbumListModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            weakSelf.listModel = model;
            
            if ([page isEqualToString:@"1"]) {
                [weakSelf setTableView];
                weakSelf.dataArray = model.video_list;
                weakSelf.totalPage = [[[responseObject objectForKey:@"data"] objectForKey:@"total_page"] intValue];
            }else{
                [weakSelf.dataArray addObjectsFromArray:model.video_list];
            }
            if (weakSelf.page >= weakSelf.totalPage) {
                [weakSelf tableFooterEndRefreshing];
            }else{
                [weakSelf tableFooterStopRefreshing];
                weakSelf.page++;
            }
        }else{
            [weakSelf tableFooterStopRefreshing];
        }
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf tableFooterStopRefreshing];
        [weakSelf tableHeaderEndRefreshing];
    }];
}



#pragma mark - 删除收藏 到专辑的视频
- (void)deleteCollectWithVideoId:(NSString*)videoId  index:(NSIndexPath*)index {
    WeakSelf;
    if (isEmpty(self.albumId)) {
        return;
    }
    NSDictionary *dict = @{@"album_id":self.albumId,@"video_id":videoId};
    [HKHttpTool POST:ALBUM_DELETE_ALBUM_VIDEO parameters:dict success:^(id responseObject) {
        if (HKReponseOK) {
            StrongSelf;
            showTipDialog(responseObject[@"msg"]);
            [strongSelf.dataArray removeObjectAtIndex:index.section];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:index.section];
            [strongSelf.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
        }
    } failure:^(NSError *error) {
        
    }];
}




@end



