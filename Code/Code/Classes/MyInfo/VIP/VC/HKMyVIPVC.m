//
//  HKMyVIPVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyVIPVC.h"
#import "HKMyVIPCell.h"
#import "HKMyVIPModel.h"
#import "UIBarButtonItem+Extension.h"
#import "TBScrollViewEmpty.h"
#import "HKMyVIPModel.h"
#import "HKVIPCategoryVC.h"
#import "HKAutoBuyView.h"
#import "HKVIPCategoryVC.h"


@interface HKMyVIPVC ()<UITableViewDelegate, UITableViewDataSource, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSource;
/** 底部提示 VIP网站升级 */
@property (nonatomic, strong)UILabel *bottomLabel;
/** 要升级的类型，0-没有可升级的 999-可升级到全站通 9999-可升级终身全站通  */
@property (nonatomic, copy)NSString *upgradeType;
/** vip购买页 跳转*/
@property (nonatomic, copy)NSString *classType;

@end




@implementation HKMyVIPVC

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self setupNav];
    
    [self initTable];
    
    [self loadNewData];
    
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
}

- (void)setupNav {
    self.title = @"我的VIP";
    [self createLeftBarButton];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 40);
    [btn setTitle:@"了解更多VIP" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(moreVIPClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}



- (void)moreVIPClick {
    [MobClick event:UM_RECORD_VIP_MY_VIP_MORE];    
    HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
    VC.class_type = self.classType;
    [self pushToOtherController:VC];
    [HKALIYunLogManage sharedInstance].button_id = @"14";
}


- (UILabel*)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196_A8ABBE titleFont:nil titleAligment:NSTextAlignmentCenter];
        _bottomLabel.font = HK_FONT_SYSTEM(13);
        _bottomLabel.backgroundColor = COLOR_FFFFFF_333D48;
    }
    return _bottomLabel;
}

/** 底部 购买VIP 提示文案 */
- (void)setupBottomLabel:(NSString*)upgradeType {
    
    if ([upgradeType isEqualToString:@"0"]) {
        //0-没有可升级的
    }else {

        [self.view addSubview:self.bottomLabel];
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.mas_equalTo(PADDING_35);
        }];

        if ([upgradeType isEqualToString:@"999"]) {
            //999-可升级到全站通
            self.bottomLabel.text = @"分类VIP可在网页上升级成全站通VIP";
        }else if ([upgradeType isEqualToString:@"9999"]) {
            //9999-可升级终身全站通
            self.bottomLabel.text = @"全站通VIP可在网页上升级成终身全站通VIP";
        }
    }
}




- (void)initTable {
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame =  self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tb_EmptyDelegate = self;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyVIPCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyVIPCell class])];
    
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
    
    HKAdjustsScrollViewInsetNever(self, self.tableView);
    
    // refresh
    MJRefreshHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.automaticallyChangeAlpha = YES;
    tableView.mj_header = mj_header;
    
    self.tableView.backgroundColor = COLOR_FFFFFF_3D4752;
}

#pragma mark <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyVIPCell class])];
    HKMyVIPModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    WeakSelf;
    cell.myVIPCellBlock = ^(HKMyVIPModel *model) {
            [MobClick event:UM_RECORD_VIP_MYVIP_RENEWALS];
            HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
            VC.class_type = model.class_type;
            [weakSelf pushToOtherController:VC];
            [HKALIYunLogManage sharedInstance].button_id = @"16";
    };
    cell.autoBuyBlock = ^{
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 225)];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor = [UIColor brownColor];

        HKAutoBuyView * autoView = [HKAutoBuyView createView];
        autoView.renewalInfoModel = model.renewalInfo;
        [bgView addSubview:autoView];
        autoView.knownBlock = ^{
            [LEEAlert closeWithCompletionBlock:nil];
        };        
        [LEEAlert alert].config
        .LeeCustomView(bgView)
        .LeeQueue(YES)
        .LeePriority(1)
        .LeeCornerRadius(0)
        .LeeHeaderColor([UIColor clearColor])
        .LeeHeaderInsets(UIEdgeInsetsZero)
        .LeeMaxWidth(320)
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 121;
}

#pragma mark TBEmptyDelegate
- (NSString *)tb_emptyString {
    return @"你暂时无VIP";
}

- (UIEdgeInsets)tb_emptyViewInset {
    return UIEdgeInsetsMake(50, 0, 0, 0);
}


#pragma mark <Server>
- (void)loadNewData {
    
    [HKHttpTool POST:VIP_MY_VIP baseUrl:BaseUrl parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            self.upgradeType = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"upgrade_type"]];
            self.classType = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"class_type"]];
            
            self.dataSource = [HKMyVIPModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"vip_list"]];
            [self.tableView reloadData];
            [self setupBottomLabel:self.upgradeType];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
    
    /*
    [HKHttpTool POST:VIP_MY_VIP parameters:@{} success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            self.upgradeType = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"upgrade_type"]];
            
            self.dataSource = [HKMyVIPModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"vip_list"]];
            [self.tableView reloadData];
            [self setupBottomLabel:self.upgradeType];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    */
    
}


@end
