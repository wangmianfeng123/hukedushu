//
//  HKTestDownloadVC2.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/26.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKTestDownloadVC2.h"
#import "HKDownloadModel.h"
#import "HKTestDownloadCell.h"
#import "HKDownloadManager.h"

@interface HKTestDownloadVC2 ()<HKDownloadManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<HKDownloadModel *> *dataSource;

@end

@implementation HKTestDownloadVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabelView];
    
    [self createLeftBarButton];
    self.title = @"完成下载";
    
    [[HKDownloadManager shareInstance] observerDownload:self array:^(NSMutableArray *notFinishArray, NSMutableArray *historyArray) {
        
        self.dataSource = historyArray;
        [self.tableView reloadData];
    }];
    
    
    [CommonFunction freeDiskSpaceInBytes:^(unsigned long long freeSpace) {
        NSString *str = [NSString stringWithFormat:@"手机剩余存储空间为：%0.2lld MB",freeSpace/1024/1024];
        NSLog(@"%@", str);
    }];
}

#pragma mark <HKDownloadManagerDelegate>
- (void)downloaded:(HKDownloadModel *)model historyArray:(NSMutableArray<HKDownloadModel *> *)array {
    self.dataSource = array;
    [self.tableView reloadData];
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
    cell.deleteBlock = ^(NSIndexPath *index) {
        HKDownloadModel *model = weakSelf.dataSource[index.row];
        [[HKDownloadManager shareInstance] deletedDownload:model delete:^(BOOL success, HKDownloadModel *model) {
            
        }];
    };
    return cell;
}



@end
