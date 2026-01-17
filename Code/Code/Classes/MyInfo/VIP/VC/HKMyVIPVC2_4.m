//
//  HKMyVIPVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKMyVIPVC2_4.h"
#import "HKMyVIPCell.h"
#import "HKMyVIPModel.h"
#import "UIBarButtonItem+Extension.h"
#import "TBScrollViewEmpty.h"
#import "HKMyVIPModel.h"
#import "HKVIPCategoryVC.h"
#import "HKMyVIPHeaderCell.h"
#import "HKMyVIPPrivilegeView.h"
#import "HKMyVIPMorePrivilegeView.h"
#import "HKVipPrivilegeModel.h"

@interface HKMyVIPVC2_4 ()<UITableViewDelegate, UITableViewDataSource, TBSrollViewEmptyDelegate>

@property (nonatomic, weak)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *vipPrivilegeDataSource;// 已经有权限

@property (nonatomic, strong)NSMutableArray<HKVipPrivilegeModel *> *vipMorePrivilegeDataSource;// 更多权限

/** vip购买页 跳转*/
@property (nonatomic, copy)NSString *classType;

@end


@implementation HKMyVIPVC2_4

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self initTableView];
    
    [self loadNewData];
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
}


- (void)initTableView {
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame =  self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tb_EmptyDelegate = self;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyVIPHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyVIPHeaderCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyVIPPrivilegeView class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyVIPPrivilegeView class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyVIPMorePrivilegeView class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKMyVIPMorePrivilegeView class])];
    
    tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
    
    // 兼容iOS11
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // refresh
    MJRefreshHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    mj_header.automaticallyChangeAlpha = YES;
    tableView.mj_header = mj_header;
}


#pragma mark <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellTemp = nil;
    
    // 头部信息cell
    if (indexPath.section == 0) {
        HKMyVIPHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyVIPHeaderCell class])];
        cellTemp = cell;
    } else if(indexPath.section == 1) { // 已拥有的权限
        HKMyVIPPrivilegeView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyVIPPrivilegeView class])];
        cell.dataSource = self.vipPrivilegeDataSource;
        cellTemp = cell;
    }else if(indexPath.section == 2) { // 未拥有的权限
        HKMyVIPMorePrivilegeView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKMyVIPMorePrivilegeView class])];
        [cell setDataSource:self.vipMorePrivilegeDataSource title:@"升级为全站通VIP，可享受以下权益"];
        cellTemp = cell;
    }
    
    return cellTemp;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heigth = 0.0;
    if (indexPath.section == 0) {
        heigth = 340.0;
    } else if(indexPath.section == 1) {
        
        // 已拥有的权限
        CGFloat vipPrivilegeHeight;
        if (self.vipPrivilegeDataSource.count) {
            int line = ceil(self.vipPrivilegeDataSource.count / 3.0);
            vipPrivilegeHeight = (line - 1) * 15 + line * (IS_IPHONEMORE4_7INCH? 84 : 78) + 30 + 39;
        }else {
            vipPrivilegeHeight = 100;// 100占位符
        }
        return vipPrivilegeHeight;
        
    }else if(indexPath.section == 2) {
        
        // 未拥有的权限
        CGFloat moreVipPrivilegeHeight;
        if (self.vipPrivilegeDataSource.count) {
            int line = ceil(self.vipPrivilegeDataSource.count / 3.0);
            moreVipPrivilegeHeight = (line - 1) * 15 + line * (IS_IPHONEMORE4_7INCH? 84 : 78) + 30 + 39;
        }else {
            moreVipPrivilegeHeight = 100;// 100占位符
        }
        return moreVipPrivilegeHeight;
    }
    
    return heigth;
}

#pragma mark <Server>
- (void)loadNewData {
    NSMutableArray *vipPrivilegeDataSource = [NSMutableArray array];
    HKVipPrivilegeModel *model0 = [[HKVipPrivilegeModel alloc] init];
    model0.header = @"ic_classifications of infinity_v2_2";
    model0.name = @"16大分类无限学";
    model0.des = @"包含新增分类";
    [vipPrivilegeDataSource addObject:model0];
    
    HKVipPrivilegeModel *model1 = [[HKVipPrivilegeModel alloc] init];
    model1.header = @"ic_video_picture_v2_2";
    model1.name = @"视频+图文教程";
    model1.des = @"多场景学习";
    [vipPrivilegeDataSource addObject:model1];
    
    HKVipPrivilegeModel *model2 = [[HKVipPrivilegeModel alloc] init];
    model2.header = @"ic_clear_v2_2";
    model2.name = @"APP离线缓存";
    model2.des = @"随时随地学";
    [vipPrivilegeDataSource addObject:model2];
    
    HKVipPrivilegeModel *model3 = [[HKVipPrivilegeModel alloc] init];
    model3.header = @"ic_file_v2_2";
    model3.name = @"源文件下载";
    model3.des = @"边学边练";
    [vipPrivilegeDataSource addObject:model3];
    
    HKVipPrivilegeModel *model4 = [[HKVipPrivilegeModel alloc] init];
    model4.header = @"ic_service_v2_9";
    model4.name = @"客服优先接待";
    model4.des = @"为您解疑答惑";
    [vipPrivilegeDataSource addObject:model4];
    
    HKVipPrivilegeModel *model5 = [[HKVipPrivilegeModel alloc] init];
    model5.header = @"ic_vip_logo_v2_2";
    model5.name = @"VIP标识";
    model5.des = @"更尊贵更瞩目";
    [vipPrivilegeDataSource addObject:model5];
    
    HKVipPrivilegeModel *model6 = [[HKVipPrivilegeModel alloc] init];
    model6.header = @"ic_teacher_comment_v2_2";
    model6.name = @"名师评改作品";
    model6.des = @"一对一点评";
    [vipPrivilegeDataSource addObject:model6];
    
    HKVipPrivilegeModel *model7 = [[HKVipPrivilegeModel alloc] init];
    model7.header = @"ic_video_comment_v2_2";
    model7.name = @"作品评改教程";
    model7.des = @"专属权限";
    [vipPrivilegeDataSource addObject:model7];
    
    HKVipPrivilegeModel *model8 = [[HKVipPrivilegeModel alloc] init];
    model8.header = @"ic_week_comment_v2_2";
    model8.name = @"周练优先点评";
    model8.des = @"优先提高";
    [vipPrivilegeDataSource addObject:model8];
    self.vipPrivilegeDataSource = vipPrivilegeDataSource;
    self.vipMorePrivilegeDataSource = vipPrivilegeDataSource;
    [self.tableView reloadData];
    
    [HKHttpTool POST:@"vip/my-vip" parameters:nil success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        if (HKReponseOK) {
            
            
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];    
}


@end
