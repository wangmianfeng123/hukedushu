//
//  HKMyInfoNotification.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights//

#import "HKProductCommentVC.h"
#import "HKMyInfoNotificationModel.h"
#import "HKMyInfoNotificationHeaderView.h"
#import "UIBarButtonItem+Extension.h"
#import "NewCommentModel.h"
#import "HKMessageReplyVC.h"
#import "HKUserInfoVC.h"
#import "VideoPlayVC.h"
#import "HKMyNotificationCell.h"
#import "HKMyInfoNotificationCell.h"

@interface HKProductCommentVC ()<UITableViewDataSource, UITableViewDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKMyInfoNotificationModel *> *dataSource;

@property (nonatomic, copy)NSString *page;

@property (nonatomic, copy)NSString *unread_msg_total;

@end

@implementation HKProductCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置UI
    [self setup];
    
    // 设置Nav
    [self setupNav];
    [MobClick event:UM_RECORD_PERSON_CENTEE_NEWS];
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (NSMutableArray<HKMyInfoNotificationModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setupNav {
    [self createLeftBarButton];
    [self setRightBarButtonItem];
}


- (void)backAction {
    [MobClick event:UM_RECORD_DOWNLOAD_PAGE_BACK];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    for (HKMyInfoNotificationModel *model in self.dataSource) {
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

#pragma mark <Server>
- (void)redToServer:(HKMyInfoNotificationModel *)model {
    
    // 如果已读直接返回
    if (model.is_read) return;
    
    [HKHttpTool POST:@"/video/comment-read" parameters:model.comment_id.length? @{@"comment_id" : model.comment_id} : nil success:^(id responseObject) {
        
        if (HKReponseOK) {
            
            // 单个
            if (model.comment_id.length) {
                model.is_read = YES;
                self.unread_msg_total = [NSString stringWithFormat:@"%d", self.unread_msg_total.intValue - 1];
            } else { // 全部
                for (HKMyInfoNotificationModel *model in self.dataSource) {
                    model.is_read = YES;
                    self.unread_msg_total = [NSString stringWithFormat:@"%d", self.unread_msg_total.intValue - 1];
                }
            }
            
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setUnread_msg_total:(NSString *)unread_msg_total {
    _unread_msg_total = unread_msg_total;
    !self.unread_msg_totalBlock? : self.unread_msg_totalBlock(unread_msg_total, self.index);
}

- (void)setup {
    
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    self.emptyText = @"您暂无消息";
    // 设置表格
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:tableView];
    tableView.frame = self.view.bounds;
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64 + 40.0, 0, 0, 0 );
    tableView.scrollIndicatorInsets = tableView.contentInset;
    // 兼容iOS11
    HKAdjustsScrollViewInsetNever(self, tableView);
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyInfoNotificationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyInfoNotificationCell class])];
    
    // MJ 刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_header = header;
    header.automaticallyChangeAlpha = YES;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.hidden = YES;
    tableView.mj_footer = footer;
//    [header beginRefreshing];
    [self loadNewData];
}

#pragma mark <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyInfoNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyInfoNotificationCell class])];
    WeakSelf;
    cell.avatorClickBlock = ^(HKMyInfoNotificationModel *model,HKBookCommentModel *bookModel) {
        HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
        vc.userId = model.uid;
        [weakSelf pushToOtherController:vc];
//        [weakSelf redToServer:model];
    };

    cell.replyBtnClickBlock = ^(HKMyInfoNotificationModel *model,HKBookCommentModel *bookModel) {

        NewCommentModel *commentModel = [[NewCommentModel alloc] init];
        commentModel.commentId = self.dataSource[indexPath.row].comment_id;
        commentModel.username = self.dataSource[indexPath.row].username;
        commentModel.content = self.dataSource[indexPath.row].content;
        HKMessageReplyVC *VC = [[HKMessageReplyVC alloc]initWithModel:commentModel];
        VC.MessageType = HKMessageType_video;

        [weakSelf redToServer:model];
        [weakSelf pushToOtherController:VC];
    };

    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    VideoPlayVC *VC = [[VideoPlayVC alloc] initWithNibName:nil bundle:nil fileUrl:nil
                                                 videoName:nil
                                          placeholderImage:nil
                                                lookStatus:LookStatusInternetVideo videoId:self.dataSource[indexPath.row].video_id model:nil];
    [self pushToOtherController:VC];
    
//    NewCommentModel *model = [NewCommentModel new];
//    model.commentId = self.dataSource[indexPath.row].comment_id;
//    model.username = self.dataSource[indexPath.row].username;
//    model.content = self.dataSource[indexPath.row].content;
//    HKMessageReplyVC *VC = [[HKMessageReplyVC alloc]initWithModel:model];
//    VC.commentBlock = ^(NSString *comment, NSInteger section, NSMutableArray<CommentChildModel *> *modelArr) {
//    };
//    [self pushToOtherController:VC];
//    [self redToServer:self.dataSource[indexPath.row]];
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
}


- (void) deleselect {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma makr <Server>
- (void)loadNewData {
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page = @"1";
    
    [mange userInfoNotificationWithToken:[CommonFunction getUserToken] page:self.page completion:^(FWServiceResponse *response) {
        [self.tableView.mj_header endRefreshing];
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSMutableArray *array = [HKMyInfoNotificationModel mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
//            HKMyInfoNotificationModel *temp = array.firstObject;
//            temp.content = @"汤彬萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊范德萨ddddd啊";
            self.dataSource = array;
            self.unread_msg_total = [NSString stringWithFormat:@"%@", response.data[@"unread_msg_total"]];
//            self.unread_msg_total = @"10";
            
            NSString *total_page = [NSString stringWithFormat:@"%@", response.data[@"total_page"]];
            if (array.count == 0 || [self.page isEqualToString:total_page]) {
                self.tableView.mj_footer.hidden = YES;
            }else {
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView.mj_footer resetNoMoreData];
            
            // 预先计算高度
            for (HKMyInfoNotificationModel *model in self.dataSource) {
                [model cellHeight];
            }
            
            // 刷新和空处理
            [self.tableView reloadData];
        }
        
    } failBlock:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];
    }];

}

- (void)loadMoreData {
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    self.page = [NSString stringWithFormat:@"%d", [self.page intValue] + 1];
    
    [mange userInfoNotificationWithToken:[CommonFunction getUserToken] page:self.page completion:^(FWServiceResponse *response) {
        [self.tableView.mj_footer endRefreshing];
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            NSMutableArray *array = [HKMyInfoNotificationModel mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
            
            [self.dataSource addObjectsFromArray:array];
            
            NSString *total_page = [NSString stringWithFormat:@"%@", response.data[@"total_page"]];
            self.unread_msg_total = [NSString stringWithFormat:@"%@", response.data[@"unread_msg_total"]];
            if (array.count == 0 || [self.page isEqualToString:total_page]) {
                self.tableView.mj_footer.hidden = YES;
            }else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            // 预先计算高度
            for (HKMyInfoNotificationModel *model in self.dataSource) {
                [model cellHeight];
            }
            // 刷新和空处理
            [self.tableView reloadData];
        }
        
    } failBlock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];

    }];
}

@end
