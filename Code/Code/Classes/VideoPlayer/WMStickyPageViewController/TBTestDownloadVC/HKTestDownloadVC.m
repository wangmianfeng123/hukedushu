//
//  HKTestDownloadVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTestDownloadVC.h"
#import "HKDownloadModel.h"
#import "HKTestDownloadCell.h"
#import "HKDownloadManager.h"

@interface HKTestDownloadVC ()<HKDownloadManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKDownloadModel *> *dataSource;

@end

@implementation HKTestDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabelView];
    
    [self createLeftBarButton];
    self.title = @"下载管理";
    
    [[HKDownloadManager shareInstance] observerDownload:self array:^(NSMutableArray *notFinishArray, NSMutableArray *historyArray, NSMutableArray *directoryArray) {
        
        self.dataSource = notFinishArray;
        [self.tableView reloadData];
    }];
    
    [self setRightBarButtonItem];
}

- (void)setRightBarButtonItem {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"管理" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pauseAll) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)pauseAll {
    [[HKDownloadManager shareInstance] pauseAllTask];
}


#pragma mark <HKDownloadManagerDelegate>
- (void)download:(HKDownloadModel *)model notFinishArray:(NSMutableArray<HKDownloadModel *> *)array {
    self.dataSource = array;
    [self.tableView reloadData];
}

- (void)download:(HKDownloadModel *)model progress:(NSProgress *)progress index:(NSString *)index {
    HKTestDownloadCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0]];
    [cell setProgress:[NSString stringWithFormat:@"%lld", progress.completedUnitCount]];
}


- (void)setTabelView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.estimatedRowHeight = 0.0;
    tableView.estimatedSectionFooterHeight = 0.0;
    tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKTestDownloadCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKTestDownloadCell class])];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    HKTestDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKTestDownloadCell class])];
    [cell setDownloadModel:self.dataSource[indexPath.row] index:indexPath];
    cell.startBlock = ^(NSIndexPath *index) {
        
        HKDownloadModel *model = weakSelf.dataSource[index.row];
        [[HKDownloadManager shareInstance] downloadModel:model withDelegate:nil];
    };
    cell.pauseBlock = ^(NSIndexPath *index) {
        HKDownloadModel *model = weakSelf.dataSource[index.row];
//        [[HKDownloadManager shareInstance] pauseTask:model];
    };
    cell.deleteBlock = ^(NSIndexPath *index) {
        HKDownloadModel *model = weakSelf.dataSource[index.row];
        [[HKDownloadManager shareInstance] deletedDownload:model delete:^(BOOL success, HKDownloadModel *model) {
            
        }];
    };
    
    return cell;
}



@end
