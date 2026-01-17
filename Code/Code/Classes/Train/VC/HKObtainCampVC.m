//
//  HKObtainCampVC.m
//  Code
//
//  Created by yxma on 2020/11/10.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKObtainCampVC.h"
#import "HKObtainCampHeaderView.h"
#import "HKObtainCampCell.h"
#import "HKHKObtainSuccessVC.h"
#import "HKNewDeviceTrainModel.h"
#import "HKHKObtainSuccessVC.h"
#import "AppDelegate.h"
#import "HKNewTaskModel.h"

@interface HKObtainCampVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)  HKObtainCampHeaderView * header ;
@property (nonatomic , strong) NSMutableArray * dataArray;
@end

@implementation HKObtainCampVC

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.zf_prefersNavigationBarHidden = YES;
    self.header = [HKObtainCampHeaderView createView];
    self.tableView.tableHeaderView = self.header;
    self.tableView.rowHeight = 85;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKObtainCampCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKObtainCampCell class])];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self loadData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 255 + STATUS_BAR_XH);
}

- (IBAction)backBtnClick {
    [self backAction];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HKObtainCampCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKObtainCampCell class])];
    HKNewDeviceTrainModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    @weakify(self)
    cell.obtainClickBlock = ^{
        [HKHttpTool POST:@"new-device-task/receive-training" parameters:@{@"training_id":model.ID} success:^(id responseObject) {
            @strongify(self);
            if (HKReponseOK) {
                AppDelegate * delegate = [AppDelegate sharedAppDelegate];
                delegate.model.status = 1;
                delegate.model.is_show = 0;
                HKHKObtainSuccessVC * vc =[[HKHKObtainSuccessVC alloc] init];
                vc.teacher_qrcode = responseObject[@"data"][@"data"][@"teacher_qrcode"];
                vc.start = responseObject[@"data"][@"data"][@"start"];
                vc.shareM = responseObject[@"data"][@"data"][@"share_data"];
                [self.navigationController pushViewController:vc animated:YES];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"obtainFreeCamp"];
                [NSUserDefaults standardUserDefaults];
                
                [MobClick event:newcamp_forfree];
            }
            showTipDialog(responseObject[@"msg"]);
        } failure:^(NSError *error) {
            NSLog(@"-----");
        }];
    };
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HKHKObtainSuccessVC * vc = [[HKHKObtainSuccessVC alloc] init];
//    [self pushToViewController:vc animated:YES];
//}

- (void)loadData{
    @weakify(self)
    [HKHttpTool POST:@"new-device-task/get-free-training-list" parameters:nil success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.dataArray = [HKNewDeviceTrainModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"-----");
    }];
}
@end
