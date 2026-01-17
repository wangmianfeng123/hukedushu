//
//  HKProductBookCommentVC.m
//  Code
//
//  Created by Ivan li on 2019/8/26.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKProductBookCommentVC.h"
#import "HKBookCommentModel.h"
#import "HKMyInfoNotificationCell.h"
#import "HKMyInfoNotificationHeaderView.h"
#import "UIBarButtonItem+Extension.h"
#import "NewCommentModel.h"
#import "HKMessageReplyVC.h"
#import "HKUserInfoVC.h"
#import "VideoPlayVC.h"
#import "HKJobPathModel.h"
#import "HKListeningBookVC.h"


@interface HKProductBookCommentVC ()<UITableViewDataSource, UITableViewDelegate, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKBookCommentModel *> *dataSource;

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, copy)NSString *unread_msg_total;

@end

@implementation HKProductBookCommentVC

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

- (NSMutableArray<HKBookCommentModel *> *)dataSource {
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
- (void)redToServer:(HKBookCommentModel *)model {
    
    // 如果已读直接返回
    if (model.is_read) return;
    /// 1- 全部已读 (REPLY_ID传空, 默认为标记所有已读)  2- 某条已读 (reply_id 不为空)
    NSDictionary *param = @{@"reply_id" : isEmpty(model.reply_id) ?@" " : model.reply_id};
    
    [HKHttpTool POST:NOTICE_MARK_BOOK_REPLAY_AS_READ parameters:param success:^(id responseObject) {
        
        if (HKReponseOK) {
            // 单个
            if (model.reply_id.length) {
                model.is_read = YES;
                self.unread_msg_total = [NSString stringWithFormat:@"%d", self.unread_msg_total.intValue - 1];
            } else { // 全部
                for (HKBookCommentModel *model in self.dataSource) {
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
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    HKAdjustsScrollViewInsetNever(self,self.tableView);
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyInfoNotificationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyInfoNotificationCell class])];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    tableView.mj_header = header;
    header.automaticallyChangeAlpha = YES;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.hidden = YES;
    tableView.mj_footer = footer;
    
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
        
        HKBookCommentModel *model = bookModel;
        HKUserInfoVC *vc = [[HKUserInfoVC alloc] init];
        vc.userId = model.uid;
        [weakSelf pushToOtherController:vc];
    };
    
    cell.replyBtnClickBlock = ^(id modelTemp,HKBookCommentModel *bookModel) {
        
        HKMessageReplyVC *VC = [[HKMessageReplyVC alloc]initWithModel:modelTemp];
        VC.MessageType = HKMessageType_book;
        VC.bookCommentModel = bookModel;
        [weakSelf redToServer:bookModel];
        [weakSelf pushToOtherController:VC];
    };
    
    cell.bookCommentModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].cellMyNotiHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKBookCommentModel *model = self.dataSource[indexPath.row];
    if (!isEmpty(model.book_id)) {
        HKListeningBookVC *bookVC = [HKListeningBookVC new];
        bookVC.courseId = model.course_id;
        bookVC.bookId = model.book_id;
        [self pushToOtherController:bookVC];
    }
}




#pragma makr <Server>
- (void)loadNewData {
    
    self.page = 1;
    NSDictionary *param = @{@"page" : @(self.page)};
    [HKHttpTool POST:NOTICE_BOOK_REPLY_LIST parameters:param success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            NSMutableArray *array = [HKBookCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            
            self.dataSource = array;
            __block NSInteger count = 0;
            [self.dataSource enumerateObjectsUsingBlock:^(HKBookCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.is_read) {
                    count++;
                }
            }];
            if (count) {
                self.unread_msg_total = [NSString stringWithFormat:@"%ld", count];
            }
            
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page >= pageModel.page_total) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            
            // 预先计算高度
            for (HKBookCommentModel *model in self.dataSource) {
                [model cellMyNotiHeight];
            }
            // 刷新和空处理
            [self.tableView reloadData];
            self.page ++;
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    NSDictionary *param = @{@"page" : @(self.page)};
    
    [HKHttpTool POST:NOTICE_BOOK_REPLY_LIST parameters:param success:^(id responseObject) {
        
        [self.tableView.mj_footer endRefreshing];
        if (HKReponseOK) {
            
            NSMutableArray *array = [HKBookCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"lists"]];
            [self.dataSource addObjectsFromArray:array];
            
            __block NSInteger count = 0;
            [self.dataSource enumerateObjectsUsingBlock:^(HKBookCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.is_read) {
                    count++;
                }
            }];
            if (count) {
                self.unread_msg_total = [NSString stringWithFormat:@"%ld", count];
            }
            
            HKJobPathPageInfoModel *pageModel = [HKJobPathPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page >= pageModel.page_total) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            // 预先计算高度
            for (HKBookCommentModel *model in self.dataSource) {
                [model cellMyNotiHeight];
            }
            // 刷新和空处理
            [self.tableView reloadData];
            self.page ++;
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        // 刷新和空处理
        [self.tableView reloadData];
    }];
    
}

@end
