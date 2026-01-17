//
//  HKMyInfoNotification.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights//

#import "HKMyInfoNotificationVC.h"
#import "HKMyNotificationCell.h"
#import "HKMyInfoNotificationHeaderView.h"
#import "UIBarButtonItem+Extension.h"
#import "NewCommentModel.h"
#import "HKMessageReplyVC.h"
#import "HKProductLikeVC.h"
#import "HKProductVideoVC.h"

@interface HKMyInfoNotificationVC ()<UITableViewDataSource, UITableViewDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKMyNotificationCellModel *> *dataSource;

@end

@implementation HKMyInfoNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置UI
    [self setup];
    
    // 设置Nav
    [self setupNav];
    [MobClick event:UM_RECORD_PERSON_CENTEE_NEWS];
    self.hk_hideNavBarShadowImage = YES;
}

- (NSMutableArray<HKMyNotificationCellModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setupNav {
    self.title = @"消息中心";
    [self createLeftBarButton];
}


- (void)backAction {
    [MobClick event:UM_RECORD_DOWNLOAD_PAGE_BACK];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 重新刷新数据
    [self loadNewData];
    
    // 设置推送头部提示
    [self setupNotificationHeaderView];
    
}

- (void)setupNotificationHeaderView {
    
    // 已经设置关闭
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *closeValue = [userDefaults objectForKey:colseNotKey];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone && self.tableView.tableHeaderView == nil && closeValue == nil) {
        HKMyInfoNotificationHeaderView *headerView = [HKMyInfoNotificationHeaderView viewFromXib];
        CGFloat height = [headerView textHeight];
        headerView.frame = CGRectMake(0, 0, self.view.width, height);
        
        // 跳到APP设置页面
        WeakSelf;
        headerView.openBtnClickBlock = ^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (HKSystemVersion > 10.0) {
                if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                }
            }else{
                if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        };
        
        // 关闭
        headerView.closeBtnClickBlock = ^{
            weakSelf.tableView.tableHeaderView = nil;
            [weakSelf.tableView reloadData];
        };
        self.tableView.tableHeaderView = headerView;
    } else if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone && self.tableView.tableHeaderView != nil) {
        self.tableView.tableHeaderView = nil;
        [self.tableView reloadData];
    }
}

- (void)setup {
    
    self.emptyText = @"您暂无消息";
    // 设置表格
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    tableView.frame = self.view.bounds;
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0 );
    tableView.scrollIndicatorInsets = tableView.contentInset;
    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyNotificationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyNotificationCell class])];
    
    // 设置推送头部提示
    [self setupNotificationHeaderView];
    
    // MJ 刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_header = header;
    header.automaticallyChangeAlpha = YES;
    [header beginRefreshing];
    self.emptyText = @"暂无消息";
    tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
}

#pragma mark <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count? 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyNotificationCell class])];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0) { // 视频/作品评论
        HKProductVideoVC *vc = [[HKProductVideoVC alloc] init];
        [self pushToOtherController:vc];
        [MobClick event: personalcenter_news_comment];
    } else if (indexPath.row == 1) { // 点赞2
        HKProductLikeVC *vc = [[HKProductLikeVC alloc] init];
        [self pushToOtherController:vc];
        [MobClick event: personalcenter_news_like];
    }
    
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma makr <Server>
- (void)loadNewData {
    
    [HKHttpTool POST:@"/notice/message-center" parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        
        if (HKReponseOK) {
            HKMyNotificationCellModel *model0 = [[HKMyNotificationCellModel alloc] init];
            model0.avator = @"ic_comment_center_v2_2";
            model0.title = @"评论/回复";
            
            //NSString *short_video_unread_msg_total = responseObject[@"data"][@"short_video_unread_msg_total"];
            //NSString *comment_unread_msg_total = responseObject[@"data"][@"comment_unread_msg_total"];
            
            HKMyNotificationCellModel *cellModel = [HKMyNotificationCellModel mj_objectWithKeyValues:responseObject[@"data"]];
            model0.count = [NSString stringWithFormat:@"%d", cellModel.short_video_unread_msg_total + cellModel.comment_unread_msg_total +cellModel.unread_book_reply];
            
            HKMyNotificationCellModel *model1 = [[HKMyNotificationCellModel alloc] init];
            model1.avator = @"ic_good_center_v2_2";
            model1.title = @"收到的赞";
            model1.count = [NSString stringWithFormat:@"%ld",(long)cellModel.like_unread_msg_total];
            //model1.count = responseObject[@"data"][@"like_unread_msg_total"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:model0];
            [self.dataSource addObject:model1];
        }
        
        // 刷新和空处理
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];
    }];
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


@end
