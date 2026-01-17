//
//  HKMyInfoNotification.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights//

#import "HKProductLikeVC.h"
#import "HKMyInfoNotificationModel.h"
#import "HKMyProductLikeCell.h"
#import "HKMyInfoNotificationHeaderView.h"
#import "UIBarButtonItem+Extension.h"
#import "NewCommentModel.h"
#import "HKTaskModel.h"
#import "HKMessageReplyVC.h"
#import "HKTaskDetailVC.h"
#import "HKUserInfoVC.h"
#import "HKNotesThumbsCell.h"

@interface HKProductLikeVC ()<UITableViewDataSource, UITableViewDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKMyProductLikeCellModel *> *dataSource;

@property (nonatomic , assign) int page ;

@end

@implementation HKProductLikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置UI
    [self setup];
    
    // 设置Nav
    [self setupNav];
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (NSMutableArray<HKMyProductLikeCellModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setupNav {
    self.title = @"收到的赞";
    [self createLeftBarButton];
    [self setRightBarButtonItem];

}

- (void)setRightBarButtonItem {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 40);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setTitle:@"一键已读" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(allRedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    NSLog(@"self.navigationControlle %@", self.navigationController);
    NSLog(@"self.parentViewController.navigationController %@", self.parentViewController.navigationController);
}


- (void)allRedBtnClicked {
    
    BOOL hasUnRead = NO;
    for (HKMyProductLikeCellModel *model in self.dataSource) {
        if (!model.is_read) {
            hasUnRead = YES;
            break;
        }
    }
    
    if (!hasUnRead) {
        showTipDialog(@"当前所有信息已读");
        return;
    }
    
    // 弹窗失败界面
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定已读所有信息吗？" preferredStyle:UIAlertControllerStyleAlert];
    // 兼容iPad alert
    if (alertVC.popoverPresentationController) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat width = 300;
        CGFloat height = 300;
        alertVC.popoverPresentationController.sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        alertVC.popoverPresentationController.sourceRect = CGRectMake((screenWidth - width ) * 0.5, (screenHeight - height ) * 0.5, 300, 300);
    }
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self redToServer:nil];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action2];
    [alertVC addAction:action1];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setup {
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.emptyText = @"暂无消息";
    // 设置表格
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:tableView];
    tableView.frame = self.view.bounds;
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0 );
    tableView.scrollIndicatorInsets = tableView.contentInset;
    // 兼容iOS11
    HKAdjustsScrollViewInsetNever(self, tableView);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 注册cell  HKNotesThumbsCell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKNotesThumbsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKNotesThumbsCell class])];
    
    // MJ 刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewListData)];
    tableView.mj_header = header;
    header.automaticallyChangeAlpha = YES;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadListData)];
    footer.hidden = YES;
    tableView.mj_footer = footer;
    [header beginRefreshing];
}

#pragma mark <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKNotesThumbsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKNotesThumbsCell class])];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    HKTaskModel *taskModel = [HKTaskModel mj_objectWithKeyValues:self.dataSource[indexPath.row].mj_JSONData];
//    HKTaskDetailVC *vc = [[HKTaskDetailVC alloc] init];
//    vc.model = taskModel;
//    [self pushToOtherController:vc];
//    [self redToServer:self.dataSource[indexPath.row]];
//    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
//}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma makr <Server>

- (void)redToServer:(HKMyProductLikeCellModel *)model {
    
    // 已读直接返回
    if (model.is_read) return;
    
    [HKHttpTool POST:@"/notice/mark-read" parameters:model.ID.length? @{@"id" : model.ID} : nil success:^(id responseObject) {
        if (HKReponseOK) {
            model.is_read = @"1";
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadListData {
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    @weakify(self);
    [HKHttpTool POST:@"/notice/likes" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSMutableArray *array = [HKMyProductLikeCellModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }
            if (array.count) {
                if (pageModel.current_page >= self.page) {
                    [self.dataSource addObjectsFromArray:array];
                    if (pageModel.current_page >= pageModel.page_total) {
                        [self tableFooterEndRefreshing];
                    }else{
                        [self tableFooterStopRefreshing];
                    }
                    self.page ++ ;
                    [self.tableView.mj_header endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];
        
    }];

}

- (void)tableFooterEndRefreshing {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}
- (void)loadNewListData{
    self.page = 1;
    [self loadListData];
}

@end
