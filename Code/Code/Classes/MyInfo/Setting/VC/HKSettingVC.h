//
//  HKSettingVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/12/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"

@interface HKSettingVC : HKBaseVC

@property(nonatomic,strong)UIImage *iconImage;

@property(nonatomic,strong)HKUserModel *userModel;

@end



//
////
////  HKSettingVC.m
////  Code
////
////  Created by hanchuangkeji on 2017/12/12.
////  Copyright © 2017年 pg. All rights reserved.
////
//
//#import "HKSettingVC.h"
//#import "HKSettingCell.h"
//#import "HKSettingModel.h"
//#import "UIBarButtonItem+Extension.h"
//#import "LoginVC.h"
//#import "FeedbackVC.h"
//#import "HKAbountUsVC.h"
//
//#import "DateChange.h"
//#import <UMShare/UMShare.h>
//#import "HKSetUserIconCell.h"
//#import "HKUserInfoSettingVC.h"
//#import "HKSwitchBtn.h"
//#import "HKGPRSSwitchView.h"
//#import "NSMutableAttributedString+HKAttributed.h"
//
//
//#define HKFeedRow 0
////#define HKHelpRow 1
//#define HKClearRow 1
//#define HKScreenShotRow 2
//
//#define HKGPRSRow 3
//#define HKAboutpRow 4
//
//@interface HKSettingVC ()<UITableViewDelegate, UITableViewDataSource>
//
//@property (weak, nonatomic)IBOutlet UITableView *tableView;
//
//@property (weak, nonatomic)IBOutlet UIButton *logoutBtn;
//
//@property (copy, nonatomic)NSString *phoneNum;
//
//
//@property (nonatomic, strong)NSMutableArray<HKSettingModel *> *dataSource;
//@end
//
//@implementation HKSettingVC
//
//- (instancetype)init {
//    if (self = [super init]) {
//        // 监听注销
//        HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, updateBottomBtnTitle);
//        //用户信息改变
//        HK_NOTIFICATION_ADD(HKUserInfoChangeNotification, updateUserInfoCell);
//        // 成功登录
//        HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccessNotification);
//    }
//    return self;
//}
//
//- (NSMutableArray<HKSettingModel *> *)dataSource {
//    if (_dataSource == nil) {
//        _dataSource = [NSMutableArray array];
//        NSArray *titleArray = @[@"意见反馈",@"清除缓存",@"截屏后提示分享",@"允许3G/4G等网络运营商网络播放", @"关于虎课"];
//        //NSArray *titleArray = @[@"主题模式跟随系统外观",@"意见反馈",@"清除缓存",@"截屏后提示分享",@"允许3G/4G等网络运营商网络播放", @"关于虎课"];
//        for (int i = 0; i < titleArray.count; i++) {
//            HKSettingModel *model = [[HKSettingModel alloc] init];
//            model.titleName = titleArray[i];
//            [_dataSource addObject:model];
//        }
//    }
//    return _dataSource;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setupNav];
//    [self setupTableView];
//    if (HKIsDebug) {
//        [self setDeleteChannelDataGesture];
//    }
//    [self hkDarkModel];
//}
//
//
//- (void)hkDarkModel {
//    self.tableView.backgroundColor = COLOR_F8F9FA_333D48;
//    self.view.backgroundColor = COLOR_FFFFFF_333D48;
//}
//
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if ([HKAccountTool shareAccount]) {
//        [self setLogoutBtnUI:YES];
//    } else {
//        [self setLogoutBtnUI:NO];
//    }
//}
//
//
//- (void)dealloc {
//    HK_NOTIFICATION_REMOVE();
//}
//
//- (void)setupNav {
//    self.title = @"设置";
//    [self createLeftBarButton];
//}
//
//- (void)backAction {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    });
//}
//
//
//- (void)setupTableView {
//    
//    HKAdjustsScrollViewInsetNever(self, self.tableView);
//    [self.tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64 + 10, 0, 50, 0)];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.scrollEnabled = NO;
//    //self.tableView.backgroundColor = COLOR_F8F9FA;
//    
//    // 注册cell
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSettingCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSettingCell class])];
//    
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSetUserIconCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSetUserIconCell class])];
//}
//
//#pragma mark - 接收通知后执行方法
//- (void)updateBottomBtnTitle {
//    if ([HKAccountTool shareAccount]) {
//        [self setLogoutBtnUI:YES];
//    } else {
//        [self setLogoutBtnUI:NO];
//        //[self backAction];
//    }
//}
//
//
//#pragma mark - 登录成功
//- (void)userloginSuccessNotification {
//    if ([HKAccountTool shareAccount]) {
//        [self setLogoutBtnUI:YES];
//    }
//}
//
//
//- (void)setLogoutBtnUI:(BOOL)isLogin {
//    
//    if (isLogin) {
//        self.logoutBtn.hidden = NO;
//        self.logoutBtn.clipsToBounds = YES;
//        self.logoutBtn.layer.cornerRadius = 50 * 0.5;
//        [self.logoutBtn setBackgroundColor:HKColorFromHex(0xFF3221, 1.0)];
//        [self.logoutBtn setTitleColor:COLOR_ffffff forState:UIControlStateNormal];
//        [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    }else{
//        self.logoutBtn.hidden = YES;
//        [self.logoutBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
//    }
//}
//
//
//- (void)updateUserInfoCell {
//    if (self.tableView) {
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}
//
//
//#pragma mark <logoutBtnClick>
//- (IBAction)logoutBtnClick:(id)sender {
//    
//    if ([HKAccountTool shareAccount]) {
//        [self userSignOut];
//    } else {
//        [self setLoginVC];
//    }
//}
//
//
//
//
//#pragma mark <UITableViewDataSource>
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return (0 == section) ? 1  :self.dataSource.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return (0 == indexPath.section) ? 80  :45;
//}
//
//
////header
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return  0.01;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}
//
////footer
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    
//    return (0 == section) ? 8  :0.01;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foot"];
//    if (!footView) {
//        UIView *view = [UIView new];
//        view.backgroundColor = COLOR_F8F9FA_333D48;
//        footView = view;
//    }
//    return footView;
//}
//
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSInteger section = indexPath.section;
//    if (0 == section) {
//        
//        HKSetUserIconCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSetUserIconCell class])];
//        cell.userModel = [HKAccountTool shareAccount];
//        return cell;
//        
//    }else {
//        HKSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSettingCell class])];
//        HKSettingModel *model = self.dataSource[indexPath.row];
//        cell.model = model;
//        
//        switch (indexPath.row) {
////            case HKThemeRow:{ // 主题设置
////                cell.ArrowIV.hidden = YES;
////                cell.hiddenSwitch = NO;
////                NSInteger index = [CommonFunction hk_lastTheme];
////                BOOL on = index ?NO :YES;
////                [cell setSiwtchBtnState:on];
////                cell.switchBlock = ^(UISwitch *sender) {
////                    //[[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:HKGPRSSwitch];
////                };
////            }
//            case HKFeedRow:{
//                // 反馈意见
//            }
//                break;
//            case HKClearRow:{
//                // 清理缓存
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
//                    float cache = bytesCache/1000/1000;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        model.leftDetail = [NSString stringWithFormat:@"%.1fM",cache];
//                        cell.model = model;
//                    });
//                });
//                cell.model = model;
//            }
//                break;
//                
//            case HKScreenShotRow:{
//                cell.ArrowIV.hidden = YES;
//                cell.hiddenSwitch = NO;
//                cell.switchBlock = ^(UISwitch *sender) {
//                    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:HKScreenShotSwitch];
//                };
//            }
//                break;
//            case HKGPRSRow:{
//                // 流量
//                cell.ArrowIV.hidden = YES;
//                cell.hiddenSwitch = NO;
//                BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKGPRSSwitch];
//                [cell setSiwtchBtnState:on];
//                cell.switchBlock = ^(UISwitch *sender) {
//                    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:HKGPRSSwitch];
//                };
//            }
//                break;
//                
//            case HKAboutpRow: {
//                // 关于
//            }
//                break;
//            default:
//                break;
//        }
//        
//        return cell;
//    }
//}
//
//
//
//#pragma mark <UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
//    
//    if (0 == indexPath.section) {
//        
//        if (isLogin()) {
//            HKSetUserIconCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            HKUserInfoSettingVC *VC = [HKUserInfoSettingVC new];
//            VC.iconImage = cell.iconImage;
//            VC.userModel = [HKAccountTool shareAccount];//self.userModel;
//            [self pushToOtherController:VC];
//        }else{
//            [self setLoginVC];
//        }
//        
//    }else{
//        
//        switch (indexPath.row) {
//            case HKFeedRow:
//            {// 反馈意见
//                if (!isLogin()) {
//                    [self setLoginVC];
//                    return;
//                }
//                FeedbackVC *VC = [FeedbackVC new];
//                [self pushToOtherController:VC];
//            }
//                break;
//            case HKClearRow:
//            {// 清理缓存
//                //[self clearImageCache];
//                [self clearSDCache];
//            }
//                break;
//            case HKScreenShotRow:
//                break;
//            case HKAboutpRow:
//            {// 关于
//                HKAbountUsVC *abountUs = [[HKAbountUsVC alloc] init];
//                [self pushToOtherController:abountUs];
//            }
//                break;
//            case HKGPRSRow: {
//                
//            }
//                break;
//        }
//    }
//}
//
//
//
//
//
//- (void)clearSDCache {
//    WeakSelf;
//    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
//        showTipDialog(@"清除成功");
//        [weakSelf.tableView reloadData];
//    }];
//}
//
//#pragma mark - sever
//- (void)getServerPhoneNum {
//    
//    [HKHttpTool POST:USER_GET_PHONE parameters:nil success:^(id responseObject) {
//        if (HKReponseOK) {
//            self.phoneNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
//            [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}
//
//
//
//
//
//- (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
//    
//    [LEEAlert alert].config
//    .LeeAddTitle(^(UILabel *label) {
//        label.text = @"流量提醒";
//        label.font = HK_FONT_SYSTEM_BOLD(15);
//        label.textColor = COLOR_030303;
//    })
//    .LeeHeaderInsets(UIEdgeInsetsMake(15, 30, 10, 30))
//    .LeeAddContent(^(UILabel *label) {
//        NSString *text = @"当前为流量状态，继续播放会消耗你的流量哦~";
//        label.font = HK_FONT_SYSTEM(15);
//        label.textColor = COLOR_030303;
//        label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
//        label.textAlignment = NSTextAlignmentLeft;
//    })
//    .LeeAddCustomView(^(LEECustomView *custom) {
//        
//        HKGPRSSwitchView *view = [[HKGPRSSwitchView alloc] init];
//        view.size = CGSizeMake(SCREEN_WIDTH-60, 40);
//        custom.view = view;
//        custom.isAutoWidth = YES;
//        custom.positionType = LEECustomViewPositionTypeLeft;
//    })
//    .LeeAddAction(^(LEEAction *action) {
//        
//        action.type = LEEActionTypeCancel;
//        action.title = @"取消";
//        action.titleColor = COLOR_555555;
//        action.backgroundColor = [UIColor whiteColor];
//        action.font = HK_FONT_SYSTEM(15);
//        action.clickBlock = ^{
//            cancelAction();
//        };
//    })
//    .LeeAddAction(^(LEEAction *action) {
//        
//        action.type = LEEActionTypeDefault;
//        action.title = @"继续观看";
//        action.titleColor = COLOR_0076FF;
//        action.font = HK_FONT_SYSTEM(15);
//        action.backgroundColor = [UIColor whiteColor];
//        action.clickBlock = ^{
//            sureAction();
//        };
//    })
//    .LeeMaxWidth(318)
//    .LeeHeaderColor([UIColor whiteColor])
//    .LeeShouldAutorotate(YES)
//    .LeeCloseAnimationDuration(0)
//    .LeeSupportedInterfaceOrientations(UIInterfaceOrientationMaskAllButUpsideDown)
//    .LeeShow();
//}
//
//
//
//
//- (void)setDeleteChannelDataGesture {
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
//    tap.numberOfTouchesRequired = 3;
//    [self.view addGestureRecognizer:tap];
//}
//
//
//
////响应事件
//-(void)tapGestureAction: (UILongPressGestureRecognizer *) gesture {
//    
//        // 测试用  删除渠道
//    [HkChannelData deleteHkChannelData];
//    showTipDialog(@"测试用删除渠道");
//}
//
//
//
//@end
