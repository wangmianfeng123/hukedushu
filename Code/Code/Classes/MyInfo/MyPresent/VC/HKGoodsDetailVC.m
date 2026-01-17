
//
//  HKGoodsDetailVC.m
//  Code
//
//  Created by Ivan li on 2017/9/7.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKGoodsDetailVC.h"
#import "HKAllPlatformTopCell.h"
#import "VipExplainCell.h"
#import "YHIAPpay.h"
  
#import "HKBuyVipModel.h"
#import "HKGoodsDetailTopCell.h"
#import "HKGoodsDetailBottomCell.h"
#import "HKGoodsModel.h"


#define VIP298  @"com.cainiu.HuKeWangVip298" //@"com.cainiu.HuKeWangAll298"

#define TEST_VIP_6  @"com.cainiu.HuKeWangVIP6"

#define VIP18 @"com.cainiu.HuKeWang18"



@interface HKGoodsDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIButton *buyBtn;

@property(nonatomic,strong)UITableView *tableView;



@end

@implementation HKGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self getGoodsDetail];
}

- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                 style:UITableViewStylePlain];
        //_tableView.separatorColor = RGB(240, 240, 240, 1);
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _tableView.sectionHeaderHeight = 0.;
        _tableView.sectionFooterHeight = 0.;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKGoodsDetailTopCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKGoodsDetailTopCell class])];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKGoodsDetailBottomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKGoodsDetailBottomCell class])];
        
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, 50, 0)];
        _tableView.backgroundColor = HKColorFromHex(0xf6f6f6, 1.0);
    }
    return _tableView;
}

- (UIButton *)buyBtn {
    if (_buyBtn == nil) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.frame = CGRectMake(0, UIScreenHeight - 50, UIScreenWidth, 50);
        _buyBtn.backgroundColor = HKColorFromHex(0xddba73, 1.0);
        [_buyBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:HKColorFromHex(0x333333, 1.0) forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
        [_buyBtn addTarget:self action:@selector(buyClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (void)createUI {
    self.title = @"商品详情";
    [self createLeftBarButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buyBtn];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)buyClickAction:(id)sender {
    if (isLogin()) {
        [self buyGoods];
    }else{
        [self resetUserLogin];
    }
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 227;
            break;
            
        case 1:
            height = 190+60;
            break;
            
        default:
            height = 100;
            break;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        HKGoodsDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKGoodsDetailTopCell class])];
        if (self.model) {
            cell.model = self.model;
        }
        return cell;
    } else if (indexPath.section == 1) {
        VipExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipExplainCell"];
        if (!cell ) {
            cell = [[VipExplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VipExplainCell"];
        }
        [cell titleForBtn:@[[NSString stringWithFormat:@"%@无限学习", self.model.abbr]]];
        return cell;
    } else {
        HKGoodsDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKGoodsDetailBottomCell"];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = HKColorFromHex(0xf6f6f6, 1.0);
    myView.height = 10.0;
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

#pragma mark <Server>
- (void) getGoodsDetail{
    [HKHttpTool POST:@"/activity/goods-detail" parameters:@{@"goods_id" : self.model.goods_id} success:^(id responseObject) {
        
        if (HKReponseOK) {
            HKGoodsModel *model = [HKGoodsModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.model = model;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)setModel:(HKGoodsModel *)model {
    _model = model;
    // 设置可以销售状态
    self.buyBtn.enabled = model.stock.intValue > 0;
    if (self.buyBtn.enabled) {
        _buyBtn.backgroundColor = HKColorFromHex(0xddba73, 1.0);
    }else {
        _buyBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)buyGoods {
    
    // 提示消耗
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定兑换" message:[NSString stringWithFormat:@"此次兑换将消耗您%@虎课币哦~", self.model.price] preferredStyle:UIAlertControllerStyleAlert];
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
        [HKHttpTool POST:@"/activity/buy-goods" parameters:@{@"goods_id" : self.model.goods_id} success:^(id responseObject) {
            // state：1-兑换成功 2-虎课币不足
            if (!HKReponseOK) return;
            if ([[NSString stringWithFormat:@"%@", responseObject[@"data"][@"state"]] isEqualToString:@"1"]) {
                showTipDialog(@"兑换成功");
                
                // 刷新并且退出
                !self.refreshBlock? : self.refreshBlock();
                
                // 刷新
                [self getGoodsDetail];
            } else if ([[NSString stringWithFormat:@"%@", responseObject[@"data"][@"state"]] isEqualToString:@"2"]) {
                showTipDialog(@"非常遗憾，您的虎课币不足，暂时无法兑换哦~");
            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action2];
    [alertVC addAction:action1];
    [self presentViewController:alertVC animated:YES completion:nil];
}





@end


