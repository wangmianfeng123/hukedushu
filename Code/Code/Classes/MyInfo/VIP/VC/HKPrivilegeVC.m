//
//  HKPrivilegeVC.m
//  Code
//
//  Created by eon Z on 2021/11/9.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPrivilegeVC.h"
#import "HKPrivilegeListCell.h"
#import "HKVipPrivilegeModel.h"

@interface HKPrivilegeVC ()<UITableViewDelegate ,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation HKPrivilegeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event: @"C11005"];//特权说明点击
    self.title = @"特权说明";
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    
    [MobClick event: @"C11101"];
}

-(void)setDataArray:(NSMutableArray<HKVipPrivilegeModel *> *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}


- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT - KNavBarHeight64)
                                                 style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 防止 reloadsection UI 错乱
        _tableView.estimatedRowHeight = 200;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        // 注册cell
        //顶部headerCell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKPrivilegeListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKPrivilegeListCell class])];
                
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        
        // 40 为标题高度
        _tableView.backgroundColor = HKColorFromHex(0xF8F9FA, 1.0);
        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKPrivilegeListCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPrivilegeListCell class])];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}
   

@end
