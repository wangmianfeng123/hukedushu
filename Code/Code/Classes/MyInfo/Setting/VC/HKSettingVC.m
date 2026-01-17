//
//  HKSettingVC.m
//  Code
//
//  Created by hanchuangkeji on 2017/12/12.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKSettingVC.h"
#import "HKSettingCell.h"
#import "HKSettingModel.h"
#import "UIBarButtonItem+Extension.h"
#import "FeedbackVC.h"
#import "HKAbountUsVC.h"

#import <UMShare/UMShare.h>
#import "HKSetUserIconCell.h"
#import "HKUserInfoSettingVC.h"
#import "HKSwitchBtn.h"
#import "HKGPRSSwitchView.h"
#import "AppDelegate.h"
#import "YHIAPpay.h"
#import "HKLoginCell.h"
#import "HKPushNoticeVC.h"

#define HKThemeRow 1
#define HKFeedRow 2
//#define HKHelpRow 1
#define HKClearRow 3

#define HKFullMakeNotesRow 4
#define HKScreenShotRow 5
#define HKAllowRecommandRow 6
#define HKGPRSRow 7
#define HKSignInRow 8
#define HKAboutpRow 9
#define HKEvaluatepRow 10

@interface HKSettingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic)IBOutlet UITableView *tableView;

//@property (weak, nonatomic)IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic)UIButton * logoutBtn;

@property (copy, nonatomic)NSString *phoneNum;


@property (nonatomic, strong)NSMutableArray<HKSettingModel *> *dataSource;
@end

@implementation HKSettingVC

- (instancetype)init {
    if (self = [super init]) {
        // 监听注销
        HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, updateBottomBtnTitle);
        //用户信息改变
        HK_NOTIFICATION_ADD(HKUserInfoChangeNotification, updateUserInfoCell);
        // 成功登录
        HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccessNotification);
    }
    return self;
}

- (NSMutableArray<HKSettingModel *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        NSArray * titleArray = @[@"夜间模式",@"问题/建议反馈",@"清除缓存",@"全屏截屏后提示记笔记",@"截屏后提示分享",@"允许虎课提供个性化推荐",@"允许3G/4G等网络运营商网络播放", @"消息和推送通知",@"关于虎课", @"喜欢我们，打分鼓励一下"];
        for (int i = 0; i < titleArray.count; i++) {
            HKSettingModel *model = [[HKSettingModel alloc] init];
            model.titleName = titleArray[i];
            [_dataSource addObject:model];
        }
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
    [self setupTableView];
    if (HKIsDebug) {
        [self setDeleteChannelDataGesture];
    }
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.tableView.backgroundColor = COLOR_F8F9FA_333D48;
    self.view.backgroundColor = COLOR_FFFFFF_333D48;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
//    if ([HKAccountTool shareAccount]) {
//        [self setLogoutBtnUI:YES];
//    } else {
//        [self setLogoutBtnUI:NO];
//    }
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (void)setupNav {
    self.title = @"设置";
    [self createLeftBarButton];
}

- (void)backAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (void)setupTableView {
    
    HKAdjustsScrollViewInsetNever(self, self.tableView);
    [self.tableView setContentInset:UIEdgeInsetsMake(KNavBarHeight64 + 10, 0, 50, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    //self.tableView.backgroundColor = COLOR_F8F9FA;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSettingCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSettingCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKSetUserIconCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKSetUserIconCell class])];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HKLoginCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HKLoginCell class])];
    
    [self.tableView reloadData];
}

#pragma mark - 接收通知后执行方法
- (void)updateBottomBtnTitle {
    [self.tableView reloadData];

//    if ([HKAccountTool shareAccount]) {
//        [self setLogoutBtnUI:YES];
//    } else {
//        [self setLogoutBtnUI:NO];
//        //[self backAction];
//    }
}


#pragma mark - 登录成功
- (void)userloginSuccessNotification {
    if ([HKAccountTool shareAccount]) {
        //[self setLogoutBtnUI:YES];
        [self.tableView reloadData];
    }
}


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


- (void)updateUserInfoCell {
    [self.tableView reloadData];
//    if (self.tableView) {
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    }
}


#pragma mark <logoutBtnClick>
- (void)logoutBtnClick {

    
    if ([HKAccountTool shareAccount]) {
        [MobClick event:UM_RECORD__PERSON_QUIT];
        [self userSignOut];
    } else {
        [self setLoginVC];
    }
}




#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 10;
    //return 11;
    return 12;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (1 == section) {
        if (@available(iOS 13.0, *)) {
            return 1;
        }else{
            return 0;
        }
    }else if (section == 11){
        if (isLogin()) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
    //return (0 == section) ? 1  :self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 11){
        return 100;
    }else{
        return 45;
    }
}


//header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

//footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }else{
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"foot"];
    if (!footView) {
        UIView *view = [UIView new];
        view.backgroundColor = COLOR_F8F9FA_333D48;
        footView = view;
    }
    return footView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (0 == section) {
        
        HKSetUserIconCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSetUserIconCell class])];
        cell.userModel = [HKAccountTool shareAccount];
        return cell;
        
    }else if (section == 11){
        HKLoginCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKLoginCell class])];
        [cell loadData];
        WeakSelf
        cell.didLoginBlock = ^{
            [weakSelf logoutBtnClick];
        };
        return cell;
    } else {
        HKSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKSettingCell class])];
        HKSettingModel *model = self.dataSource[indexPath.section-1];
        cell.model = model;
        
        switch (indexPath.section) {
            case HKThemeRow:{ // 主题设置
                cell.ArrowIV.hidden = YES;
                cell.hiddenSwitch = NO;
                NSInteger index = [HKDarkModelManger hk_lastTheme];
                BOOL on = (2 ==index) ?YES :NO;
                [cell setSiwtchBtnState:on];
                cell.switchBlock = ^(UISwitch *sender) {
                    isFouceLight = sender.isOn ? 0 :1;
                    [HKDarkModelManger hk_saveLastTheme:(isFouceLight ? 1 :2)];
                    [[HKDarkModelManger shareInstance]updateAPPUserTheme];
                };
            }
                break;
            case HKFeedRow:{
                // 反馈意见
                cell.ArrowIV.hidden = NO;
                cell.hiddenSwitch = YES;
            }
                break;
            case HKClearRow:{
                // 清理缓存
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSUInteger bytesCache = [[SDImageCache sharedImageCache] totalDiskSize];
                    float cache = bytesCache/1000/1000;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.leftDetail = [NSString stringWithFormat:@"%.1fM",cache];
                        cell.model = model;
                    });
                });
                cell.ArrowIV.hidden = NO;
                cell.hiddenSwitch = YES;
                cell.model = model;
            }
                break;
            case HKFullMakeNotesRow:{
                cell.ArrowIV.hidden = YES;
                cell.hiddenSwitch = NO;
                BOOL notAllow = [[NSUserDefaults standardUserDefaults] boolForKey:@"NotAllowScreenShot"];
                [cell setSiwtchBtnState:!notAllow];
                cell.switchBlock = ^(UISwitch *sender) {
                    [[NSUserDefaults standardUserDefaults]setBool:!sender.on forKey:@"NotAllowScreenShot"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                };
            }
                break;
            case HKScreenShotRow:{
                cell.ArrowIV.hidden = YES;
                cell.hiddenSwitch = NO;
                cell.switchBlock = ^(UISwitch *sender) {
                    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:HKScreenShotSwitch];
                };
            }
                break;
            case HKAllowRecommandRow:{
                cell.ArrowIV.hidden = YES;
                cell.hiddenSwitch = NO;
                BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKPersonalRecommandSwitch];
                [cell setSiwtchBtnState:!on];
                cell.switchBlock = ^(UISwitch *sender) {
                    [[NSUserDefaults standardUserDefaults]setBool:!sender.on forKey:HKPersonalRecommandSwitch];
                };
            }
                break;
            case HKSignInRow:{
                cell.ArrowIV.hidden = NO;
                cell.hiddenSwitch = YES;
            }
                break;
            case HKGPRSRow:{
                // 流量
                cell.ArrowIV.hidden = YES;
                cell.hiddenSwitch = NO;
                BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:HKGPRSSwitch];
                [cell setSiwtchBtnState:on];
                cell.switchBlock = ^(UISwitch *sender) {
                    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:HKGPRSSwitch];
                };
            }
                break;
                
            case HKAboutpRow: {
                cell.ArrowIV.hidden = NO;
                cell.hiddenSwitch = YES;
                // 关于
            }
                break;
            case HKEvaluatepRow: {
                // app store
            }
                break;
            default:
                break;
        }
        return cell;
    }
}



#pragma mark <UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //登录成功通知
    //HK_NOTIFICATION_POST(HKLoginSuccessNotification, nil);
    
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if (0 == indexPath.section) {
        
        if (isLogin()) {
            HKSetUserIconCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            HKUserInfoSettingVC *VC = [HKUserInfoSettingVC new];
            VC.iconImage = cell.iconImage;
            VC.userModel = [HKAccountTool shareAccount];//self.userModel;
            [self pushToOtherController:VC];
        }else{
            [self setLoginVC];
        }
        
    }else if (indexPath.section == 11){
        [self logoutBtnClick];
    }else{
        
        switch (indexPath.section) {
            case HKFeedRow:
            {// 反馈意见
                if (!isLogin()) {
                    [self setLoginVC];
                    return;
                }
                FeedbackVC *VC = [FeedbackVC new];
                [self pushToOtherController:VC];
            }
                break;
            case HKClearRow:
            {// 清理缓存
                //[self clearImageCache];
                [HKNSUserDefaults setBool:NO forKey:HKCanlendarWitch];
                [self clearSDCache:indexPath];
                
                [HKNSUserDefaults setInteger:0 forKey:@"liveRecomandTimes"];
                [HKNSUserDefaults setBool:NO forKey:@"showNoteTipLabel"];
                //是否显示评论按钮
                [HKNSUserDefaults setBool:NO forKey:@"showCommentIcon"];
                [HKNSUserDefaults setBool:NO forKey:@"showScreenshotAlert"];
                
                [HKNSUserDefaults setObject:@"0" forKey:@"flagTime"];
                [HKNSUserDefaults setBool:0 forKey:@"showdoubleTap"];
                [HKNSUserDefaults setInteger:1 forKey:HKVideoPlayerPlayLine];
                //设计教程，职业办公等分类页的引导视图
                [HKNSUserDefaults setBool:NO forKey:@"showCategoryGuidView"];

                
                NSString * IDStr = [CommonFunction getUserId];
                if(IDStr.length){
                    [HKNSUserDefaults setInteger:0 forKey:IDStr];
                    [HKNSUserDefaults synchronize];
                }
                
            }
                break;
            case HKFullMakeNotesRow:
                break;
            case HKScreenShotRow:
                break;
            case HKAboutpRow:
            {// 关于
                HKAbountUsVC *abountUs = [[HKAbountUsVC alloc] init];
                [self pushToOtherController:abountUs];
            }
                break;
            case HKGPRSRow: {
                
            }
                break;
            case HKSignInRow: {
                [self pushToOtherController:[HKPushNoticeVC new]];
                
            }
                break;
            case HKEvaluatepRow: {
                // app store
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
                [MobClick event:UM_RECORD_PERSONAL_CENTER_APPSTORE];

            }
                break;
        }
    }
}





- (void)clearSDCache:(NSIndexPath*)indexPath {
    
    @weakify(self);
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        @strongify(self);
        showTipDialog(@"清除成功");
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - sever
- (void)getServerPhoneNum {
    
    [HKHttpTool POST:USER_GET_PHONE parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            self.phoneNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        
    }];
}





- (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"流量提醒";
        label.font = HK_FONT_SYSTEM_BOLD(15);
        label.textColor = COLOR_030303;
    })
    .LeeHeaderInsets(UIEdgeInsetsMake(15, 30, 10, 30))
    .LeeAddContent(^(UILabel *label) {
        NSString *text = @"当前为流量状态，继续播放会消耗你的流量哦~";
        label.font = HK_FONT_SYSTEM(15);
        label.textColor = COLOR_030303;
        label.attributedText = [NSMutableAttributedString changeLineAndTextSpaceWithTotalString:text LineSpace:5 textSpace:0];
        label.textAlignment = NSTextAlignmentLeft;
    })
    .LeeAddCustomView(^(LEECustomView *custom) {
        
        HKGPRSSwitchView *view = [[HKGPRSSwitchView alloc] init];
        view.size = CGSizeMake(SCREEN_WIDTH-60, 40);
        custom.view = view;
        custom.isAutoWidth = YES;
        custom.positionType = LEECustomViewPositionTypeLeft;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
        action.font = HK_FONT_SYSTEM(15);
        action.clickBlock = ^{
            cancelAction();
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"继续观看";
        action.titleColor = COLOR_0076FF;
        action.font = HK_FONT_SYSTEM(15);
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            sureAction();
        };
    })
    .LeeMaxWidth(318)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShouldAutorotate(YES)
    .LeeCloseAnimationDuration(0)
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}




- (void)setDeleteChannelDataGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tap.numberOfTouchesRequired = 3;
    [self.view addGestureRecognizer:tap];
}



//响应事件
-(void)tapGestureAction: (UILongPressGestureRecognizer *) gesture {
    
    // 测试用  删除渠道
    [HkChannelData deleteHkChannelData];
    showTipDialog(@"测试用删除渠道");
    
    //是否领取了新手训练营
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasObtainVIP"];
    
    //移除本地未能校验成功的菜单
    [[YHIAPpay instance] deleteAllRecord];

    //社区页面提示我提问
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showRequestionGuidView"];

    //发布动态提示切换话题
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showpublishGuidView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
