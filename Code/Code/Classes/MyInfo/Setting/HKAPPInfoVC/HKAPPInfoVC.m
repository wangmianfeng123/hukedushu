//
//  HKAPPInfoVC.m
//  Code
//
//  Created by Ivan li on 2019/7/3.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKAPPInfoVC.h"
#import "HKAPPInfoCell.h"
#import "UIDeviceHardware.h"


@interface HKAPPInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HKAPPInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)createUI {
    self.title = @"APP信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self createLeftBarButton];
}



- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView registerClass:[HKAPPInfoCell class] forCellReuseIdentifier:NSStringFromClass([HKAPPInfoCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 44;
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HKAPPInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAPPInfoCell class]) forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSString *title = nil;
    NSString *info = nil;
    
    switch (row) {
        case 0:
            title = @"APP昵称";
            info = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];;
            break;
            
        case 1:
            title = @"APP版本";
            info = [CommonFunction appCurVersion];
            break;
            
        case 2:
            title = @"系统版本";
            info = [[UIDevice currentDevice] systemVersion];
            break;
            
        case 3:
            title = @"手机型号";
            info = [[UIDeviceHardware new]platformString];
            break;
            
        default:
            break;
    }
    [cell setTitle:title info:info];
    return cell;
}



@end
