//
//  HKTestVC.m
//  Code
//
//  Created by Ivan li on 2020/12/23.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKTestVC.h"

@interface HKTestVC ()<UITableViewDataSource,UITableViewDelegate,TBSrollViewEmptyDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation HKTestVC

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (UITableView*)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,100, SCREEN_WIDTH, SCREEN_HEIGHT-100)
                                                 style:UITableViewStylePlain];
        _tableView.rowHeight = 130;
        _tableView.separatorColor = COLOR_F8F9FA;
        _tableView.backgroundColor = COLOR_F8F9FA;
        _tableView.tableFooterView = [UIView new];
        //_tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tb_EmptyDelegate = self;
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, 30 + 27.5, 0);
        _tableView.backgroundColor = COLOR_F8F9FA_3D4752;
        _tableView.separatorColor = COLOR_F8F9FA_333D48;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
    // 收藏文章空视图
    self.emptyText = @"您还没有收藏任何内容哦~";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld ===== %ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
}

@end
