//
//  HKStoreOrderPayVC.m
//  Code
//
//  Created by Ivan li on 2019/10/25.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStoreOrderPayVC.h"
#import "HKStoreOrderGoodInfoCell.h"
#import "HKStoreOrderAddressCell.h"
#import "HKStoreOrderPayCell.h"
#import "HKStoreOrderPayBottomView.h"


@interface HKStoreOrderPayVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) HKStoreOrderPayBottomView *payBottomView;

@end


@implementation HKStoreOrderPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.title = @"商品确认";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[HKStoreOrderGoodInfoCell class] forCellReuseIdentifier:NSStringFromClass([HKStoreOrderGoodInfoCell class])];
        [_tableView registerClass:[HKStoreOrderAddressCell class] forCellReuseIdentifier:NSStringFromClass([HKStoreOrderAddressCell class])];
        [_tableView registerClass:[HKStoreOrderPayCell class] forCellReuseIdentifier:NSStringFromClass([HKStoreOrderPayCell class])];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [UIView new];
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    CGFloat height = 0;
    switch (section) {
        case 0:
            height =  100;
            break;
            
        case 1:
            height =  150;
            break;
            
        case 2:
            height =  150;
            break;
            
        default:
            break;
    }
    return height;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    if (0 == section) {
        
        HKStoreOrderAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStoreOrderAddressCell class]) forIndexPath:indexPath];
        addressCell.changeAddressBlock = ^(NSString * _Nonnull address, UIButton * _Nonnull btn) {
            
        };
        return addressCell;
        
    }else if (1 == section) {
        HKStoreOrderGoodInfoCell *goodCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStoreOrderGoodInfoCell class]) forIndexPath:indexPath];
        return goodCell;
        
    }else if (2 == section) {
        HKStoreOrderPayCell *payCell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStoreOrderPayCell class]) forIndexPath:indexPath];
        return payCell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (HKStoreOrderPayBottomView*)payBottomView {
    if (!_payBottomView) {
        _payBottomView = [HKStoreOrderPayBottomView new];
    }
    return _payBottomView;
}


@end
