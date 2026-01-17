//
//  HKCoursePracticeVC.m2
//  Code
//
//  Created by hanchuangkeji on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCoursePracticeVC.h"
#import "HKPracticeModel.h"
#import "BaseVideoViewController.h"
#import "VideoPlayVC.h"
#import "HKPracticeCell.h"
#import "HKDownloadModel.h"
#import "HKDownloadManager.h"

@interface HKCoursePracticeVC ()

@property (nonatomic, strong)NSMutableArray<HKPracticeModel *> *dataSource;

@end

@implementation HKCoursePracticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderView];
    [self setupTablewView];
    [self loadNewData];
}

- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.height = 44;
    self.tableView.tableHeaderView = headerView;
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = HKColorFromHex(0x333333, 1.0);
    titleLabel.text = @"本节教程练习";
    [titleLabel sizeToFit];
    titleLabel.x = 15;
    titleLabel.centerY = headerView.height * 0.5;
    [headerView addSubview:titleLabel];
    
    // 关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:imageName(@"course_practice_close_btn") forState:UIControlStateNormal];
    [closeBtn setImage:imageName(@"course_practice_close_btn") forState:UIControlStateSelected];
    closeBtn.width = 35;
    closeBtn.height = headerView.height;
    closeBtn.x = self.view.width - closeBtn.width;
    closeBtn.centerY = headerView.height * 0.5;
    [headerView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0, headerView.height - 0.5, self.view.width, 0.5);
    separator.backgroundColor =HKColorFromHex(0xf6f6f6, 1.0);
    [headerView addSubview:separator];
}

- (void)setupTablewView {
    
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKPracticeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKPracticeCell class])];
    
    // 刷新
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = mj_header;
    mj_header.automaticallyChangeAlpha = YES;
    // footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.alwaysBounceVertical = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 解决当前表格的滚动的Bug
    if ([self.parentViewController isKindOfClass:[BaseVideoViewController class]]) {
        UIScrollView *scrollView =  (UIScrollView *)self.parentViewController.view;
        scrollView.scrollEnabled = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 解决当前表格的滚动的Bug
    if ([self.parentViewController isKindOfClass:[BaseVideoViewController class]]) {
        UIScrollView *scrollView =  (UIScrollView *)self.parentViewController.view;
        scrollView.scrollEnabled = YES;
    }
    
}

- (void)closeBtnClick {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKPracticeModel *model = self.dataSource[indexPath.row];
    
    HKPracticeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPracticeCell class]) forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKPracticeModel *practiceModel = self.dataSource[indexPath.row];
    
    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:nil
                                                videoName:practiceModel.title
                                         placeholderImage:nil
                                               lookStatus:LookStatusInternetVideo
                                                  videoId:practiceModel.video_id model:nil];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark <Server>
- (void)loadNewData {
        
    self.dataSource = self.videoDetailModel.salve_video_list;
    
    // 查找缓存状态
    for (HKPracticeModel *practiceModel in self.dataSource) {
        HKDownloadModel *downloadModel = [HKDownloadModel mj_objectWithKeyValues:practiceModel.mj_JSONData];
        downloadModel.videoId = practiceModel.video_id;
        practiceModel.isLocalCache = [[HKDownloadManager shareInstance] queryStatus:downloadModel] == HKDownloadFinished;
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    
}



@end
