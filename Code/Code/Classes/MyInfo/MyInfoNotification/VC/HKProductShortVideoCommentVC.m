//
//  HKMyInfoNotification.m
//  Code
//
//  Created by hanchuangkeji on 2017/10/24.
//  Copyright © 2017年 pg. All rights//

#import "HKProductShortVideoCommentVC.h"
#import "HKShortVideoCommentModel.h"
#import "HKMyInfoNotificationCell.h"
#import "HKMyInfoNotificationHeaderView.h"
#import "UIBarButtonItem+Extension.h"
#import "NewCommentModel.h"
#import "HKShortVideoMainVC.h"
#import "HKMessageReplyVC.h"
#import "HKUserInfoVC.h"
#import "VideoPlayVC.h"

@interface HKProductShortVideoCommentVC ()<UITableViewDataSource, UITableViewDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKShortVideoCommentModel *> *dataSource;

@property (nonatomic, copy)NSString *page;

@property (nonatomic, copy)NSString *unread_msg_total;

@end

@implementation HKProductShortVideoCommentVC

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

- (NSMutableArray<HKShortVideoCommentModel *> *)dataSource {
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
    for (HKShortVideoCommentModel *model in self.dataSource) {
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
- (void)redToServer:(HKShortVideoCommentModel *)model {
    
    // 如果已读直接返回
    if (model.is_read) return;
    NSDictionary *param = nil;
    if (model) { // 某条已读
        param = @{@"cid" : model.ID, @"type" : @"0"};
    } else { // 全部已读
        param = @{@"type" : @"1"};
    }
    
    [HKHttpTool POST:@"notice/short-video-read-comment" parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            
            // 单个
            if (model.ID.length) {
                model.is_read = YES;
                self.unread_msg_total = [NSString stringWithFormat:@"%d", self.unread_msg_total.intValue - 1];
            } else { // 全部
                for (HKShortVideoCommentModel *model in self.dataSource) {
                    model.is_read = YES;
                    self.unread_msg_total = @"0";
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
    cell.avatorClickBlock = ^(id modelTemp,HKBookCommentModel *bookModel) {
        
        HKShortVideoCommentModel *model = modelTemp;
        HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
        vc.userId = model.uid;
        [weakSelf pushToOtherController:vc];
//        [weakSelf redToServer:model];
    };
    
    cell.replyBtnClickBlock = ^(id modelTemp,HKBookCommentModel *bookModel) {
        HKShortVideoCommentModel *model = modelTemp;
        NewCommentModel *commentModel = [[NewCommentModel alloc] init];
        commentModel.commentId = model.ID;
        commentModel.username = model.commentUser.username;
        commentModel.content = model.content;
        HKMessageReplyVC *VC = [[HKMessageReplyVC alloc]initWithModel:commentModel];
        VC.MessageType = HKMessageType_shortVideo;
        
        VC.shortVideoCommentModel = model;
        
        [weakSelf redToServer:model];
        [weakSelf pushToOtherController:VC];
    };
    
    cell.shortVideoCommentModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKShortVideoCommentModel *model = self.dataSource[indexPath.row];
    if (!isEmpty(model.ID )) {
        WeakSelf;
        HKShortVideoMainVC *VC = [HKShortVideoMainVC new];
        VC.shortVideoWholeVideoClickCallBack = ^(HKShortVideoModel * _Nonnull model) {
            [weakSelf pushVideoPlayWithModel:model];
        };
        VC.showBackBtn = YES;
        VC.videoId = model.video_id;
        VC.hiddenFooter = YES;
        VC.shortVideoType = HKShortVideoType_notification;
        [self pushToOtherController:VC];
    }
    
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



#pragma mark 跳转到 普通视频详情
- (void)pushVideoPlayWithModel:(HKShortVideoModel *)model {
    NSString *videoId = model.relation_video_id;
    
    if (isEmpty(videoId) || ([videoId integerValue] == 0)) {
        return ;
    }
    //2:相关视频按钮点击
    HKAlilogModel *aliLogModel = [HKAlilogModel new];
    if ([model.relation_type isEqualToString:@"2"]) {
        aliLogModel.shortVideoToVideoCollectFlag = @"3";
        aliLogModel.shortVideoToVideoPlayFlag = @"4";
    }

    if ([model.relation_type isEqualToString:@"1"]) {
        aliLogModel.shortVideoToVideoCollectFlag = @"5";
        aliLogModel.shortVideoToVideoPlayFlag = @"6";
    }
    
    VideoPlayVC *playVC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil videoName:nil placeholderImage:nil lookStatus:LookStatusInternetVideo videoId:videoId model:nil];
    playVC.alilogModel = aliLogModel;
    [self pushToOtherController:playVC];
}




#pragma makr <Server>
- (void)loadNewData {
    
    self.page = @"1";
    NSDictionary *param = @{@"page" : self.page};
    
    [HKHttpTool POST:@"notice/short-video-comment-list" parameters:param success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (HKReponseOK) {
            NSMutableArray *array = [HKShortVideoCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            //            HKShortVideoCommentModel *temp = array.firstObject;
            //            temp.content = @"汤彬萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊萨ddddd啊范德萨ddddd啊";
            self.dataSource = array;
            self.unread_msg_total = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"unread_msg_total"]];
            //            self.unread_msg_total = @"10";
            
            NSString *total_page = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"pageCount"]];
            if (array.count == 0 || [self.page isEqualToString:total_page]) {
                self.tableView.mj_footer.hidden = YES;
            }else {
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView.mj_footer resetNoMoreData];
            
            // 预先计算高度
            for (HKShortVideoCommentModel *model in self.dataSource) {
                [model cellHeight];
            }
            
            // 刷新和空处理
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];
        
    }];

}

- (void)loadMoreData {
    
    self.page = [NSString stringWithFormat:@"%d", [self.page intValue] + 1];
    NSDictionary *param = @{@"page" : self.page};
    
    [HKHttpTool POST:@"notice/short-video-comment-list" parameters:param success:^(id responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        
        if (HKReponseOK) {
            NSMutableArray *array = [HKShortVideoCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            
            [self.dataSource addObjectsFromArray:array];
            
            NSString *total_page = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"pageCount"]];
            self.unread_msg_total = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"unread_msg_total"]];
            if (array.count == 0 || [self.page isEqualToString:total_page]) {
                self.tableView.mj_footer.hidden = YES;
            }else {
                self.tableView.mj_footer.hidden = NO;
            }
            
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            // 预先计算高度
            for (HKShortVideoCommentModel *model in self.dataSource) {
                [model cellHeight];
            }
            // 刷新和空处理
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];
    }];

}

@end
