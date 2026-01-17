//
//  HKAirPlayGuideVC.h
//  Code
//
//  Created by Ivan li on 2019/4/16.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HKPermissionVideoModel;

@interface HKAirPlayGuideVC : HKBaseVC

@property(nonatomic,copy) void(^airPlayGuideVCCallBack)(NSString *deviceName,BOOL isAirPlay);

//@property (nonatomic,strong) HKPermissionVideoModel *permissionModel;

@end

NS_ASSUME_NONNULL_END


//
////
////  HKAirPlayGuideVC.m
////  Code
////
////  Created by Ivan li on 2019/4/16.
////  Copyright © 2019年 pg. All rights reserved.
////
//
//#import "HKAirPlayGuideVC.h"
//#import "HKAirPlayGuideCell.h"
//#import "HKCustomMarginLabel.h"
//#import "HKAirPlayFailCell.h"
//#import "HKAirPlayDeviceCell.h"
//#import "NSString+MD5.h"
//#import "MYCAirplayManager.h"
//#import "HKAirPlaySearchCell.h"
//#import "MZTimerLabel.h"
//
//
//@interface HKAirPlayGuideVC ()<UITableViewDelegate,UITableViewDataSource,MYCAirplayManagerDelegate,MZTimerLabelDelegate>
//
//@property (nonatomic,strong) UILabel *titleLB;
//
//@property (nonatomic,strong) UITableView *tableView;
//
//@property (nonatomic,copy) NSArray *titleArr;
//
//@property (nonatomic,copy) NSArray *picArr;
//
//@property (nonatomic,strong) UILabel *selectLB;
//
//@property (nonatomic,strong) UILabel *wifiLB;
//
//@property (nonatomic,strong) NSMutableArray <NSString*>*deviceArr;
//
//@property (nonatomic,strong) MYCAirplayManager * airplayManager;
//
//@property (nonatomic,assign) BOOL isDelete;
//
//@property (nonatomic,strong) UIView *firstHeaderView;
//
//@property (nonatomic,strong) NSMutableArray <NSString*>*failTextArr;
//
//@property (nonatomic, strong)MZTimerLabel   *timerLabel;
//
//@property (nonatomic,strong) NSMutableArray <NSString*>*searchArr;
//
//@end
//
//
//
//@implementation HKAirPlayGuideVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self createUI];
//}
//
//
//- (void)dealloc {
//    HK_NOTIFICATION_REMOVE();
//}
//
//- (void)createUI {
//    
//    self.title = @"选择投屏设备";
//    self.picArr = @[@"pic_guideline1_v2_12",@"pic_guideline2_v2_12",@"pic_guideline3_v2_12"];
//    
//    self.titleArr = @[@"1、打开智能电视，并保持智能电视/盒子和手机在同一WiFi下",@"2、打开视频播放器页面，选择投屏图标",
//                      @"3、在列表中选择您的电视设备名称，即可将手机投屏到电视。"];
//    
//    self.searchArr = [[NSMutableArray alloc]initWithObjects:@"设备", nil];
//    
//    [self createLeftBarButton];
//    [self createRightBarButtonWithImage:@"ic_refresh_big_v2_12" size:CGSizeMake(35, 35)];
//    
//    self.view.backgroundColor = COLOR_F8F9FA;
//    [self.view addSubview:self.tableView];
//    
//    [self searchAirPlayDevice];
//    
//    [self hiddenRightBarButtonItem];
//    
//    [self.tableView reloadData];
//    
//    [self.view addSubview:self.timerLabel];
//    [self.timerLabel start];
//    
//}
//
//
//- (void)hiddenRightBarButtonItem {
//    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
//}
//
//
//
//- (void)showRightBarButtonItem {
//    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
//}
//
//
//
//- (void)rightBarBtnAction {
//    [self searchAirPlayDevice];
//    [self hiddenRightBarButtonItem];
//    
//    self.isDelete = NO;
//    self.searchArr = [[NSMutableArray alloc]initWithObjects:@"设备", nil];
//    
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//    
//    [self.timerLabel reset];
//    [self.timerLabel start];
//}
//
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.timerLabel pause];
//}
//
//
//
//- (UITableView*)tableView {
//    
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = COLOR_F8F9FA;
//        
//        _tableView.tableFooterView = [UIView new];
//        //_tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
//        //_tableView.sectionHeaderHeight = 0.005;
//        _tableView.sectionFooterHeight = 0.005;
//        
//        [_tableView registerClass:[HKAirPlayGuideCell class] forCellReuseIdentifier:NSStringFromClass([HKAirPlayGuideCell class])];
//        [_tableView registerClass:[HKAirPlayFailCell class] forCellReuseIdentifier:NSStringFromClass([HKAirPlayFailCell class])];
//        [_tableView registerClass:[HKAirPlayDeviceCell class] forCellReuseIdentifier:NSStringFromClass([HKAirPlayDeviceCell class])];
//        [_tableView registerClass:[HKAirPlaySearchCell class] forCellReuseIdentifier:NSStringFromClass([HKAirPlaySearchCell class])];
//        
//        HKAdjustsScrollViewInsetNever(self, _tableView);
//        [_tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64, 0, KTabBarHeight49, 0)];
//    }
//    return _tableView;
//}
//
//
//
//
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4;
//}
//
//
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    switch (section) {
//        case 0: {
//            return [self firstHeaderView];
//        }
//            
//        case 2: {
//            return [self headerView];
//        }
//            break;
//        default:
//            break;
//    }
//    
//    UIView *view = [UIView new];
//    view.backgroundColor = COLOR_F8F9FA;
//    return view;
//}
//
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    switch (section) {
//        case 0: {
//            return 58;
//        }
//            break;
//        case 1: {
//            return 0;
//        }
//            break;
//        case 2: {
//            return 73;
//        }
//            break;
//        case 3: {
//            return 8;
//        }
//            break;
//        default:
//            break;
//    }
//    
//    return 0;
//}
//
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    switch (section) {
//        case 0: {
//            return self.deviceArr.count ?self.deviceArr.count :self.failTextArr.count;
//        }
//            break;
//        case 1: {
//            return self.searchArr.count ? 1 : 0;
//        }
//            break;
//        case 2: {
//            return 3;
//        }
//            break;
//        case 3: {
//            return 1;
//        }
//            break;
//        default:
//            break;
//    }
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.section) {
//        case 0:
//            return 50;
//            break;
//            
//        case 1:
//            return 50;
//            break;
//            
//        case 2:{
//            NSInteger row = indexPath.row;
//            if (0 == row) {
//                return 205;
//            }else if (1 == row) {
//                return 205;
//            }else {
//                return 250;
//            }
//        }
//            break;
//        case 3:
//            return 200;
//            break;
//            
//        default:
//            break;
//    }
//    return 0;
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSInteger section = indexPath.section;
//    
//    switch (section) {
//        case 0:
//        {
//            HKAirPlayDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAirPlayDeviceCell class])];
//            
//            if (self.deviceArr.count) {
//                NSString *name = self.deviceArr[indexPath.row];
//                [cell setTitleWithText:name];
//            }else{
//                if (self.failTextArr.count) {
//                    NSString *name = self.failTextArr[indexPath.row];
//                    [cell setTitleWithText:name];
//                }
//            }
//            return cell;
//        }
//            break;
//        case 1:{
//            
//            HKAirPlaySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAirPlaySearchCell class])];
//            if (self.searchArr.count) {
//                cell.titleLb.text = self.searchArr[indexPath.row];
//            }
//            if (cell) {
//                [cell startAnimations];
//            }
//            return cell;
//        }
//        break;
//            
//        case 2:{
//            HKAirPlayGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAirPlayGuideCell class])];
//            cell.titleLB.text = self.titleArr[indexPath.row];
//            if (2 == indexPath.row) {
//                cell.detailLB.text = @"投屏成功后可将手机当做遥控器进行远程控制，如选择进度，选择章节等，还可在手机观看文章，进行其他操作等。";
//            }else{
//                cell.detailLB.text = nil;
//            }
//            cell.iconIV.image = imageName(self.picArr[indexPath.row]);
//            return cell;
//        }
//            break;
//            
//        case 3:{
//            HKAirPlayGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKAirPlayFailCell class])];
//            return cell;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return [UITableViewCell new];
//}
//
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (0 == indexPath.section) {
//        if (self.deviceArr.count) {
//            if (self.airPlayGuideVCCallBack) {
//                NSString *name = self.deviceArr[indexPath.row];
//                self.airPlayGuideVCCallBack(name);
//                [self backAction];
//            }
//        }
//    }
//}
//
//
//
//- (UIView*)headerView {
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 73)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
//    view.backgroundColor = COLOR_F8F9FA;
//    
//    [headerView addSubview:view];
//    
//    [headerView addSubview:self.titleLB];
//    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view.mas_bottom).offset(16);
//        make.left.equalTo(headerView).offset(PADDING_15);
//    }];
//    return headerView;
//}
//
//
//
//- (UIView*)firstHeaderView {
//    
//    if (!_firstHeaderView) {
//        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 58)];
//        headerView.backgroundColor = [UIColor whiteColor];
//        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
//        view.backgroundColor = COLOR_F8F9FA;
//        
//        [headerView addSubview:view];
//        [headerView addSubview:self.selectLB];
//        [headerView addSubview:self.wifiLB];
//        
//        [self.selectLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(view.mas_bottom).offset(16);
//            make.left.equalTo(headerView).offset(PADDING_15);
//        }];
//        
//        [self.wifiLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.selectLB.mas_right);
//            make.centerY.equalTo(self.selectLB);
//            make.right.equalTo(headerView);
//        }];
//        
//        [self.selectLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        _firstHeaderView = headerView;
//    }
//    return _firstHeaderView;
//}
//
//
//
//
//
//- (UILabel*)titleLB {
//    if (!_titleLB) {
//        _titleLB = [UILabel labelWithTitle:CGRectZero title:@"如何进行投屏" titleColor:COLOR_27323F titleFont:@"11" titleAligment:NSTextAlignmentLeft];
//        _titleLB.font = HK_FONT_SYSTEM_BOLD(18);
//    }
//    return _titleLB;
//}
//
//
//
//- (UILabel*)selectLB {
//    if (!_selectLB) {
//        _selectLB = [UILabel labelWithTitle:CGRectZero title:@"请选择投屏设备" titleColor:COLOR_27323F titleFont:@"13" titleAligment:NSTextAlignmentLeft];
//        [_selectLB sizeToFit];
//    }
//    return _selectLB;
//}
//
//
//- (UILabel*)wifiLB {
//    if (!_wifiLB) {
//        _wifiLB = [UILabel labelWithTitle:CGRectZero title:nil titleColor:COLOR_7B8196 titleFont:@"11" titleAligment:NSTextAlignmentLeft];
//        NSString *name = [NSString hkWifiName];
//        if (!isEmpty(name)) {
//            _wifiLB.text = [NSString stringWithFormat:@"当前WiFi：%@",[NSString hkWifiName]];
//        }else{
//            _wifiLB.text = @" ";
//        }
//        _wifiLB.hidden = YES;
//    }
//    return _wifiLB;
//}
//
//
//
//- (void)networkObserver {
//    
//    [MyNotification addObserver:self
//                       selector:@selector(networkNotification:)
//                           name:KNetworkStatusNotification
//                         object:nil];
//}
//
//- (void)networkNotification:(NSNotification *)noti {
//    
//    NSString *name = [NSString hkWifiName];
//    if (!isEmpty(name)) {
//        self.wifiLB.text = [NSString stringWithFormat:@"当前WiFi：%@",[NSString hkWifiName]];
//    }else{
//        self.wifiLB.text = @" ";
//    }
//}
//
//
//
////////////////////
//
//- (void)searchAirPlayDevice {
//    
//    [self.airplayManager searchAirplayDeviceWithTimeOut:0.3];
//}
//
//
//- (MYCAirplayManager *)airplayManager {
//    if (!_airplayManager) {
//        _airplayManager = [MYCAirplayManager new];
//        _airplayManager.delegate = self;
//    }
//    return _airplayManager;
//}
//
//
//
//- (NSMutableArray*)deviceArr {
//    if (!_deviceArr) {
//        _deviceArr = [NSMutableArray new];
//    }
//    return _deviceArr;
//}
//
//
//- (NSMutableArray*)failTextArr {
//    if (!_failTextArr) {
//        _failTextArr = [NSMutableArray new];
//    }
//    return _failTextArr;
//}
//
//
//- (NSMutableArray*)searchArr {
//    if (!_searchArr) {
//        _searchArr = [NSMutableArray array];
//    }
//    return _searchArr;
//}
//
//
//
//
//#pragma mark -- MYCAirplayManagerDelegate
//
//- (void)MYCAirplayManager:(MYCAirplayManager *)airplayManager searchedAirplayDevice:(NSMutableArray<MYCAirplayDevice *> *)deviceList
//{
//    NSLog(@"已经获取到设备列表");
//    [self.deviceArr removeAllObjects];
//    [deviceList enumerateObjectsUsingBlock:^(MYCAirplayDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (!isEmpty(obj.displayName)) {
//            [self.deviceArr addObject:obj.displayName];
//        }
//    }];
//
//    NSInteger count = self.deviceArr.count;
//    if (count) {
//        [self.deviceArr addObject:@"AirPlay"];
//    }
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    
//    NSString *text = count ?@"请选择投屏设备" :@"未发现可投屏设备";
//    self.selectLB.text = text;
//    self.wifiLB.hidden = count ?NO :YES;
//}
//
//
//
//- (void)MYCAirplayManager:(MYCAirplayManager *)airplayManager searchAirplayDeviceFinish:(NSMutableArray<MYCAirplayDevice *> *)deviceList {
//    
//    if (deviceList.count == 0) {
//        [self.deviceArr removeAllObjects];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    }
//    
//    if (self.deviceArr.count == 0) {
//        NSString *wifiName = [NSString hkWifiName];
//        if (isEmpty(wifiName)) {
//            wifiName = [NSString stringWithFormat:@"请检查可投屏设备是否连接当前WiFi"];
//        }else{
//            wifiName = [NSString stringWithFormat:@"请检查可投屏设备是否连接当前WiFi（%@）",wifiName];
//        }
//        NSString *text = ([HkNetworkManageCenter shareInstance].networkStatus == AFNetworkReachabilityStatusReachableViaWiFi) ?wifiName :@"请确认手机与投屏设备是否连接同一WiFi";
//        [self.failTextArr removeAllObjects];
//        [self.failTextArr addObject:text];
//    }
//    self.selectLB.text = self.deviceArr.count ?@"请选择投屏设备" :@"未发现可投屏设备";
//    self.wifiLB.hidden = self.deviceArr.count ?NO :YES;
//}
//
//
//
//#pragma mark - 计时器
//- (MZTimerLabel*)timerLabel {
//    if (!_timerLabel) {
//        _timerLabel = [[MZTimerLabel alloc] initWithFrame:CGRectZero];
//        _timerLabel.timerType = MZTimerLabelTypeTimer;
//        _timerLabel.backgroundColor = [UIColor clearColor];
//        _timerLabel.hidden = YES;
//        _timerLabel.delegate = self;
//        [_timerLabel setCountDownTime:10];
//    }
//    return _timerLabel;
//}
//
//
//- (void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
//    [timerLabel pause];
//    [self deleteSecondeSection];
//}
//
//
//
//- (void)deleteSecondeSection {
//    
////    [self.tableView beginUpdates];
////    self.isDelete = YES;
////    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
////    if (cell) {
////        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
////    }
////    [self.tableView endUpdates];
//
//    [self.searchArr removeAllObjects];
//    [self.tableView reloadData];
//    [self showRightBarButtonItem];
//}
//
//
//
//@end
//
//
//
//
//
//
//
//
