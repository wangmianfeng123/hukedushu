//
//  HKMyAblumVC.m
//  Code
//
//  Created by Ivan li on 2017/12/2.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyAblumVC.h"
#import "HKContainerListCell.h"
#import "HKContainerModel.h"
#import "HKAlbumDetailVC.h"
#import "HKBulidContainerVC.h"
#import <TBScrollViewEmpty/TBScrollViewEmpty.h>
#import "UIButton+ImageTitleSpace.h"

@interface HKMyAblumVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray  *dataArray;

@property(nonatomic,assign)NSInteger    totalPage;
@property(nonatomic,assign)NSInteger    page;
@property(nonatomic,strong)UIButton     *bulidBtn;

@end

@implementation HKMyAblumVC

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


- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    //[self getAlbumByPage:[NSString stringWithFormat:@"%ld",(long)self.page]];
    //删除专辑通知
    HK_NOTIFICATION_ADD(HKDeleteAlbumNotification, deleteAlbumNotification:);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)deleteAlbumNotification:(NSNotification*)noti {
    
    NSString *albumId = noti.userInfo[@"albumId"];
    if (isEmpty(albumId)) {
        return;
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[HKAlbumModel class]]) {
            //查找专辑 delete
            if ([((HKAlbumModel*)obj).album_id isEqualToString:albumId]) {
                
                [self.dataArray removeObjectAtIndex:idx];
                if (0 == self.dataArray.count) {
                    [self.tableView reloadData];
                }else{
                    NSIndexPath *indexP = [NSIndexPath indexPathForRow:idx inSection:0];
                    [self.tableView deleteRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
                }
                *stop = YES;
            }
        }
    }];
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick event:UM_RECORD_COLLECT_MY_COLLECTION];
    if (0 == self.dataArray.count) {
        [self.tableView reloadData];
    }
}





- (void)loadView{
    [super loadView];
    self.emptyText = @"您暂无专辑";

    [self.view addSubview:self.tableView];
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    self.tableView.backgroundColor = COLOR_F8F9FA_3D4752;
    [self refreshUI];
}




- (UIButton*)bulidBtn {
    if (!_bulidBtn) {
        _bulidBtn = [UIButton buttonWithTitle:@"新建专辑" titleColor:COLOR_7B8196_A8ABBE titleFont:@"15"  imageName:(@"ic_add_yellow")];
        [_bulidBtn setImage:imageName(@"ic_add_yellow") forState:UIControlStateHighlighted];
        [_bulidBtn addTarget:self action:@selector(bulidBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bulidBtn setEnlargeEdgeWithTop:10 right:200 bottom:0 left:10];
        [_bulidBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    return _bulidBtn;
}



- (void)bulidBtnClick {
    
    WeakSelf;
    HKBulidContainerVC *VC = [HKBulidContainerVC new];
    VC.hkBulidContainerVCBlock = ^(HKAlbumModel *model) {
        StrongSelf;
        if (!isEmpty(model.album_id)) {
            [strongSelf.dataArray insertObject:model atIndex:0];

            if (1 == strongSelf.dataArray.count) {
                [strongSelf.tableView  reloadData];
            }else{
                [strongSelf.tableView beginUpdates];
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0];
                [strongSelf.tableView insertRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
                [strongSelf.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionNone animated:YES];
                [strongSelf.tableView endUpdates];
            }
        }
    };
    [self pushToOtherController:VC];
    
    [MobClick event:UM_RECORD_STUDY_MYCOLLECTION_ADD];
}





#pragma mark - emptyView  delegate
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    
    if (status == TBNetworkStatusReachableViaWWAN || status== TBNetworkStatusReachableViaWiFi) {
        
        [self bulidBtnClick];
        
    } else if (status == TBNetworkStatusNotReachable) {
        // 重新加载
        [self.tableView.mj_header beginRefreshing];
    }
}


- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    if (status == TBNetworkStatusReachableViaWWAN || status== TBNetworkStatusReachableViaWiFi) {
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"新建专辑" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:HK_FONT_SYSTEM(15)}];
        return str;
    } else if (status == TBNetworkStatusNotReachable) {
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"重新加载" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:HK_FONT_SYSTEM(14)}];
        return str;
    }
    return nil;
}



- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 260/2;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_F8F9FA;
        //_tableView.separatorColor = COLOR_F8F9FA;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        [_tableView reloadData];
    }
    return _tableView;
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count? 1 :0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (0 == section) {
        UIView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foot"];
        if (footView == nil) {
            UIView *view = [[UIView alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 56)];
            view.backgroundColor = COLOR_FFFFFF_3D4752;// [UIColor whiteColor];
            [view addSubview:self.bulidBtn];
            [self.bulidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(PADDING_25);
                make.top.equalTo(view).offset(22);
            }];
            footView = view;
        }
        return footView;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 56;
    }
    return 0.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKContainerListCell *cell = [HKContainerListCell initCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKAlbumModel *model = self.dataArray[indexPath.row];
    HKAlbumDetailVC *VC = [[HKAlbumDetailVC alloc]initWithAlbumModel:model isMyAblum:YES];
    VC.operationAlbumActionBlock = ^(HKAlbumListModel *model) {
        
    };
    [self pushToOtherController:VC];
}




#pragma mark - 刷新
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        StrongSelf;
        strongSelf.page = 1;
        NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)strongSelf.page];
        [strongSelf getAlbumByPage:pageNum];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        StrongSelf
        NSString  *pageNum = [NSString stringWithFormat:@"%ld",(long)strongSelf.page];
        [strongSelf getAlbumByPage:pageNum];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
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
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:page,@"page",@"1",@"type",nil];//type //1-我的专辑 2-收藏专辑
    [HKHttpTool POST:ALBUM_MY_ALBUM parameters:parameters success:^(id responseObject) {
        
        [weakSelf tableHeaderEndRefreshing];
        if (HKReponseOK) {
            HKContainerModel *model =[HKContainerModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            if ([page isEqualToString:@"1"]) {
                weakSelf.dataArray = model.album_list;
                weakSelf.totalPage = [model.total_page intValue];
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




