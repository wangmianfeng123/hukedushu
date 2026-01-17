//
//  HKDefaultCollectionVC.m
//  Code
//
//  Created by Ivan li on 2017/12/2.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKDefaultAlbumVC.h"
#import "HKContainerListCell.h"
#import "HKContainerModel.h"
#import "HKAlbumDetailVC.h"
#import "HKAlbumListModel.h"
#import "HKNavigationController.h"

@interface HKDefaultAlbumVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;
@property(nonatomic,assign)NSInteger    totalPage;
@property(nonatomic,assign)NSInteger    page;

@end

@implementation HKDefaultAlbumVC

#pragma mark - emptyView  delegate
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    
    if (status == TBNetworkStatusNotReachable) {
        // 重新加载
        [self.tableView.mj_header beginRefreshing];
    }
}

- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    if (status == TBNetworkStatusNotReachable) {
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"重新加载" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:HK_FONT_SYSTEM(14)}];
        return str;
    }
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        self.page = 1;
        [self userLoginAndLogotObserver];
    }
    return self;
}


- (void)userloginSuccessNotification {
    self.page = 1;
    self.totalPage = 0;
    [self getAlbumByPage:[NSString stringWithFormat:@"%ld",(long)self.page]];
}

- (void)userlogoutSuccessNotification {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        if ([self.navigationController isKindOfClass:[HKNavigationController class]]) {
                HKNavigationController *navController = (HKNavigationController *)self.navigationController;
              UINavigationBar *navigationBar = navController.navigationBar;
              NSArray<__kindof UIView *> *subviews = navigationBar.subviews;
              for (UIView *subview in subviews) {
                  if ([NSStringFromClass([subview class]) containsString:@"UIPointerInteractionAssistantEffectContainerView"]) {
                      subview.hidden = YES;
                  }
              }
            }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAlbumByPage:[NSString stringWithFormat:@"%ld",(long)self.page]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
    self.tableView.backgroundColor = COLOR_F8F9FA_3D4752;
    self.emptyText = @"您暂无专辑";
    [self refreshUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick event:UM_RECORD_COLLECT_OTHER_COLLECTION];
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kHeight44)
                                                 style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 260/2;
        _tableView.backgroundColor = COLOR_F8F9FA;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.separatorColor = COLOR_F8F9FA;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.005;
        _tableView.sectionFooterHeight = 0.005;
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
    }
    return _tableView;
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count>0 ? _dataArray.count :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKContainerListCell *cell = [HKContainerListCell initCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
    HKAlbumModel *albumModel = self.dataArray[indexPath.section];
    HKAlbumDetailVC *VC = [[HKAlbumDetailVC alloc]initWithAlbumModel:albumModel];
    
    WeakSelf;
    __block NSInteger section = indexPath.section;
    VC.operationAlbumActionBlock = ^(HKAlbumListModel *model) {
        // 0-- 取消   1--收藏
        if ([model.is_collect isEqualToString:@"0"] && weakSelf.dataArray.count) {
            [weakSelf.dataArray removeObjectAtIndex:section];
            [weakSelf.tableView deleteSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];            
        }
        else if([model.is_collect isEqualToString:@"1"]) {
            NSInteger section =  weakSelf.dataArray.count;
            [weakSelf.dataArray insertObject:model atIndex:section];
            [weakSelf.tableView insertSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
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
        strongSelf.page = 1;
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        [strongSelf getAlbumByPage:pageNum];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%lu",strongSelf.page];
        [strongSelf getAlbumByPage:pageNum];
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
- (void)getAlbumByPage:(NSString*)page {
    WeakSelf;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"2",@"type",nil];//type //1-我的专辑 2-收藏专辑
    [HKHttpTool POST:ALBUM_MY_ALBUM parameters:parameters success:^(id responseObject) {
        
        [weakSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            HKContainerModel *model =[HKContainerModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            if ([page isEqualToString:@"1"]) {
                weakSelf.dataArray = model.album_list;
                weakSelf.totalPage = [[[responseObject objectForKey:@"data"] objectForKey:@"total_page"] intValue];
            }else{
                [weakSelf.dataArray addObjectsFromArray:model.album_list];
            }
            if (weakSelf.page >= weakSelf.totalPage) {
                [weakSelf tableFooterEndRefreshing];
                weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                weakSelf.tableView.mj_footer.hidden = NO;
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
        if (weakSelf.dataArray.count<1) {
            [weakSelf.tableView reloadData];
        }
    }];
}




@end
