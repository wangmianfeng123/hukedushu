//
//  HKLiveCommentVC.m
//  Code
//
//  Created by Ivan li on 2020/12/22.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKLiveCommentVC.h"
#import "HKLiveCommentModel.h"
#import "HKBaseVC+EmptyData.h"
#import "UIBarButtonItem+Extension.h"
#import "ZFNormalPlayer.h"

#import "VideoPlayVC.h"
#import "VideoModel.h"

#import "DownloadCacher.h"
#import "DownloadManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
  
#import "MyDownloadIngCell.h"
#import "MyDownloadedCell.h"
#import "MyDownloadBottomView.h"

#import "MyLoadingVC.h"
#import "HKDownloadManager.h"
#import "HKBottomCapacityView.h"
#import "HKDownloadQABottomView.h"
#import "HtmlShowVC.h"
#import "HKLiveCommentCell.h"
#import "HKLiveCommentHeaderView.h"
#import "HKUserInfoVC.h"

@interface HKLiveCommentVC ()<UITableViewDataSource,UITableViewDelegate,TBSrollViewEmptyDelegate,HKLiveCommentCellDelegate>
@property (nonatomic , strong) NSMutableArray * dataArray;
@property (nonatomic , assign) int page ;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) HKLiveCommentHeaderView * headerView;
@property (nonatomic , assign) BOOL isLoad ;
@end

@implementation HKLiveCommentVC

-(HKLiveCommentHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [HKLiveCommentHeaderView viewFromXib];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 70.0);
    }
    return _headerView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
//        for (int i = 0; i<10; i++) {
//            HKLiveCommentModel * model = [[HKLiveCommentModel alloc] init];
//            model.content = @"撒即可附近的萨克雷锋的撒发卡萨联发科螺丝刀范德萨理发卡是开发商开发商理发卡仕达开始发的发";
//            model.username = @"username";
//            model.createdAt = @"2020-10-09 17:40";
//            if (i == 3 || i == 5 || i == 9) {
//                model.commentImages = @[@"werwe",@"fdasfds"];
//            }else if (i == 7){
//                model.uid = [CommonFunction getUserId];
//            }
//            [_dataArray addObject:model];
//        }
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self.view addSubview:self.tableView];
    [MyNotification addObserver:self selector:@selector(refreshData) name:@"refreshCommentData" object:nil];
    
    @weakify(self);
    [HKRefreshTools headerRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadNewListData];
    }];
    
    [HKRefreshTools footerAutoRefreshWithTableView:self.tableView completion:^{
        @strongify(self);
        [self loadListData];
    }];
}

- (void)refreshData{
    [self loadNewListData];
}

-(void)setVideoId:(NSString *)videoId{
    _videoId = videoId;
    [self loadNewListData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isLoad) {
        [self loadNewListData];
    }
    self.isLoad = YES;
}

- (void)loadNewListData{
    self.page = 1;
    [self loadListData];
}

- (void)loadListData{
    if (self.videoId.length == 0) return;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:self.videoId forKey:@"live_id"];
    [dic setObject:[NSNumber numberWithInt:20] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    @weakify(self);
    [HKHttpTool POST:@"/live/live-comment-list" parameters:dic success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            NSArray * resultArray = [HKLiveCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            HKPageInfoModel *pageModel = [HKPageInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"pageInfo"]];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (resultArray.count) {
                if (pageModel.current_page >= self.page) {
                    [self.dataArray addObjectsFromArray:resultArray];
                    if (pageModel.current_page >= pageModel.page_total) {
                        [self tableFooterEndRefreshing];
                    }else{
                        [self tableFooterStopRefreshing];
                    }
                    self.page ++ ;
                    [self.tableView.mj_header endRefreshing];

                    self.headerView.countZh = responseObject[@"data"][@"countZh"];
                    NSString * countZh = responseObject[@"data"][@"countZh"];
                    if (countZh.length) {
                        [MyNotification postNotificationName:@"pageControllerTitle" object:nil userInfo:@{@"count":countZh}];
                    }
                    
                    self.headerView.allScore = [responseObject[@"data"][@"allScore"] floatValue];
                    self.headerView.allStar = [responseObject[@"data"][@"allStar"] intValue];
                    self.headerView.hidden = NO;
                }
                
            }else{
                self.headerView.hidden = YES;
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }
            
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        self.headerView.hidden = YES;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)tableFooterEndRefreshing {
    self.tableView.mj_footer.alpha = 1;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = NO;
    
}

- (void)tableFooterStopRefreshing {
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}


- (UITableView*)tableView {
    if (_tableView == nil) {//138 * Ratio + KNavBarHeight64
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(IS_IPHONE_X ?70 :50)-KNavBarHeight64) style:UITableViewStylePlain];
        _tableView.y = 0.5; // 分割线
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
        //_tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.headerView;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10* Ratio, 0);
        _tableView.tb_EmptyDelegate = self;
        
        // 注册cell
        //任务项cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLiveCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLiveCommentCell class])];
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.rowHeight = 60;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKLiveCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLiveCommentCell class])];
    cell.commentModel = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

//#pragma <TBSrollViewEmptyDelegate>
//-(UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//    return nil;
//}
//
//- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//
//    NSString *stringTemp = (status == TBNetworkStatusNotReachable)? @"网络未连接，请检查网络设置": @"列表为空";
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:stringTemp];
//    [str addAttribute:NSForegroundColorAttributeName value: ((status == TBNetworkStatusNotReachable)?[UIColor whiteColor]:[UIColor clearColor])
//                range:NSMakeRange(0, str.length)];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, str.length)];
//    return str;
//}
//
//- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//
//    return CGPointMake(0,IS_IPHONE5S ?100 :200);
//}


#pragma mark ==== HKLiveCommentCellDelegate
- (void)liveCommentCellDidZanBtn:(HKLiveCommentModel *)commentModel{
    [HKHttpTool POST:@"/live/comment-praise" parameters:@{@"comment_id":commentModel.ID} success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        if ([CommonFunction detalResponse:responseObject]) {
            //showTipDialog(@"作业已提交");
            
            int commentPraise = [commentModel.commentPraise intValue];
            commentModel.commentPraise = [NSNumber numberWithInt:commentPraise+1];
            showTipDialog(responseObject[@"msg"]);
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)liveCommentCellDidDeleteBtn:(HKLiveCommentModel *)commentModel{
    [HKHttpTool POST:@"/live/comment-delete" parameters:@{@"comment_id":commentModel.ID} success:^(id responseObject) {
        [HKProgressHUD hideHUD];
        if ([CommonFunction detalResponse:responseObject]) {
            //showTipDialog(@"作业已提交");
            showTipDialog(@"评论已删除");
            [self.dataArray removeObject:commentModel];
            [self.tableView reloadData];
        }else{
            showTipDialog(responseObject[@"msg"]);
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)liveCommentCellDidHeaderImg:(HKLiveCommentModel *)commentModel{
    HKUserInfoVC *vc = [HKUserInfoVC new];
    vc.userId = commentModel.uid;
    [self pushToOtherController:vc];
}

//-(void)liveCommentCellDidHeaderImg:(HKLiveCommentModel *)commentModel{
//    HKUserInfoVC *vc = [HKUserInfoVC new];
//    vc.userId = commentModel.uid;
//    [self pushToOtherController:vc];
//}

@end
