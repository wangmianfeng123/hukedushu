//
//  HKPushNoticeVC.m
//  Code
//
//  Created by Ivan li on 2021/7/22.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKPushNoticeVC.h"
#import "HKSettingCell.h"
#import "HKPushNoticeModel.h"
#import "QFTimePickerView.h"
#import "HKPushNotiCell.h"
#import "HKPushNotiTimeVC.h"

@interface HKPushNoticeVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation HKPushNoticeVC

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 70;
        UIColor *color = COLOR_F6F6F6_3D4752;
        _tableView.backgroundColor = color;
        [_tableView setSeparatorColor:color];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self,_tableView);
        _tableView.contentInset = UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0);
        // 注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSettingCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSettingCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKPushNotiCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKPushNotiCell class])];
    }
    return _tableView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息和推送通知";
    [self createLeftBarButton];
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
    [self.view addSubview:self.tableView];
    
    [MyNotification addObserver:self selector:@selector(loadData) name:HKLoginSuccessNotification object:nil];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _dataArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return PADDING_10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.05;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    HKSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSettingCell class])];
//    HKPushNoticeModel * model = self.dataArray[indexPath.row];
//    cell.noticeModel = model;
//    cell.ArrowIV.hidden = YES;
//    cell.hiddenSwitch = NO;
//    WeakSelf
//    cell.switchBlock = ^(UISwitch *sender) {
//        if (![CommonFunction isOpenNotificationSetting]){
//            [self openNotificationSetting];
//            [weakSelf.tableView reloadData];
//        }else{
//            if (isLogin()) {
//                //发起开关请求
//                [weakSelf uploadSwitchStatus:!sender.on noticeModel:model];
//
//            }else{
//                [weakSelf.tableView reloadData];
//                [weakSelf setLoginVC];
//            }
//        }
//    };
    
    HKPushNotiCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKPushNotiCell class])];
    HKPushNoticeModel * model = self.dataArray[indexPath.row];
    cell.noticeModel = model;
    WeakSelf
    cell.switchBlock = ^(UISwitch *sender) {
        if (![CommonFunction isOpenNotificationSetting]){
            [self openNotificationSetting];
            [weakSelf.tableView reloadData];
        }else{
            if (isLogin()) {
                //发起开关请求
                [weakSelf uploadSwitchStatus:!sender.on noticeModel:model];

            }else{
                [weakSelf.tableView reloadData];
                [weakSelf setLoginVC];
            }
        }
    };
    
    cell.setBtnBlock = ^{
        if (![CommonFunction isOpenNotificationSetting]){
            [self openNotificationSetting];
        }else{
            if (isLogin()) {
                //发起开关请求
                HKPushNotiTimeVC * VC = [HKPushNotiTimeVC new];
                VC.key = model.key;
                VC.j_push_hour = model.j_push_hour;
                VC.j_push_type = model.j_push_type;
                VC.j_push_hour_type = model.j_push_hour_type;
                
                [weakSelf pushToOtherController:VC];
            }else{
                [weakSelf setLoginVC];
            }
        }
        
        
        
        
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
//    [self showChooseTimeView];
}

- (void)loadData{
    @weakify(self);
    [HKHttpTool POST:@"/setting/setting-options" parameters:nil success:^(id responseObject) {
        @strongify(self);
        if (HKReponseOK) {
            self.dataArray= [HKPushNoticeModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)uploadSwitchStatus:(BOOL)status noticeModel:(HKPushNoticeModel *)model{
    //@weakify(self);
    WeakSelf
    if (model.key.length) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:model.key forKey:@"key"];
        [HKHttpTool POST:@"/setting/switch-option" parameters:dic success:^(id responseObject) {
            //@strongify(self);
            if ([CommonFunction detalResponse:responseObject]) {
                showTipDialog(responseObject[@"data"][@"business_message"]);
                model.value = !model.value;
                
                NSMutableArray * arry = [NSKeyedUnarchiver unarchiveObjectWithFile:PushNoticeModelFile];
                for (HKPushNoticeModel * noticeModel in arry) {
                    if ([noticeModel.key isEqualToString:model.key]) {
                        noticeModel.value = model.value;
                        [NSKeyedArchiver archiveRootObject:arry toFile:PushNoticeModelFile];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            [weakSelf.tableView reloadData];
        }];
    }
    
}

- (void)openNotificationSetting{
    // 检查推送开启
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel *label) {
        label.text = @"小虎发现你还没有开启推送哦，请先打开推送才能开启签到提醒哦~";
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"放弃";
        action.titleColor = COLOR_333333;
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"立即开启";
        action.titleColor = COLOR_ff7c00;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            [CommonFunction openNotificationSetting];
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}



@end
