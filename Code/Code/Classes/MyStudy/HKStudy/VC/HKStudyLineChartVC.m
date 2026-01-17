//
//  HKStudyLineChartVC.m
//  Code
//
//  Created by hanchuangkeji on 2019/6/13.
//  Copyright © 2019 pg. All rights reserved.
//

#import "HKStudyLineChartVC.h"
#import "HKLearnCenterHeader.h"
#import "HKLearnCenterLoginView.h"
#import "HKStudyCertificateVC.h"

@interface HKStudyLineChartVC ()<UITableViewDelegate,UITableViewDataSource, HKLearnCenterHeaderDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property(nonatomic, weak)HKLearnCenterHeader *headerView;

@end

@implementation HKStudyLineChartVC

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = IS_IPHONE5S ? 120 :130;
        _tableView.separatorColor = COLOR_eeeeee;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64 - 20, 0, 0, 0);
        _tableView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self createUI];
    [self setupHeaderView];
    [self getServeData];
}

- (void)getServeData {
    
    [HKHttpTool POST:@"user/recently-studied-stats" parameters:nil success:^(id responseObject) {
       
        if (HKReponseOK) {
            HKMyLearningCenterModel *model = [HKMyLearningCenterModel mj_objectWithKeyValues:responseObject[@"data"]];
            //移除学习成就数量  数量为0时 自动隐藏
            model.diploma_total = @"0";
            self.headerView.model = model;
            self.model = model;
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)createUI {
    [self.view addSubview:self.tableView];
}

- (void)setupHeaderView {
    
    // 设置头部
    if ([HKAccountTool shareAccount]) {
        // 登录
        CGFloat height = IS_IPHONE_X? 253.0 + 16.0 + 20.0 : 253.0 + 16.0;
        HKLearnCenterHeader *headerView = [[HKLearnCenterHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
        headerView.learnCenterHeaderDelegate = self;
        self.headerView = headerView;
        self.tableView.tableHeaderView = headerView;
        self.tableView.mj_header.hidden = NO;
        headerView.model = self.model;
    } else {
        // 未登录
        self.tableView.mj_header.hidden = YES;
        HKLearnCenterLoginView *headerView = [HKLearnCenterLoginView viewFromXib];
        headerView.height = 254 + 25 + 11;
        WeakSelf;
        headerView.logBtnClickBlock = ^{
            [weakSelf setLoginVC];
        };
        self.tableView.tableHeaderView = headerView;
        //将未领取奖励置空
        self.model = nil;
    }
    
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    //学习兴趣引导
    //[self setStudyTagGuideView];
}

/** HKLearnCenterHeader  delegate  */
- (void)hkLearnCenterAchieveClick:(id)sender {
    
    [MobClick event:UM_RECORD_STUDY_ACHIEVEMENT];
    if (isLogin()) {
        [self pushToOtherController:[HKStudyCertificateVC new]];
    }else{
        [self setLoginVC];
    }
}


- (void)setupNav {
    self.title = @"";
    [self createLeftBarButton];
    self.emptyText = @"您还没有关注任何讲师哦~";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
