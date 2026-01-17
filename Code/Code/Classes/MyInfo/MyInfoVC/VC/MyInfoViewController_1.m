//
//  MyInfoViewController.m
//  Code
//
//  Created by pg on 2017/2/13.
//  Copyright © 2017年 pg. All rights reserved.2


#import "MyInfoViewController_1.h"
#import "UserIconCell.h"
#import "OtherSetUpCell2.h"
  
#import "FeedbackVC.h"
#import "VipCell.h"
#import "HKNOVipCell.h"
#import "YHIAPpay.h"
#import "HKMyInfoNotificationVC.h"
#import "HKTeacherCourseVC.h"
#import "HKSettingVC.h"
#import "HKMyVIPVC.h"
#import "HKTeacherCourseVC.h"
#import "HKMyFollowVC.h"
#import "HKPresentVC.h"
#import "HKLuckPriceVC.h"
#import "HKVIPCategoryVC.h"
#import "HKOrderPaymentVC.h"
#import "HKGuideCommentView.h"
#import "HKCouponVC.h"
#import "HKCouponModel.h"
#import "HKIsShowCellModel.h"
#import "OtherSetUpInviteCell.h"
#import "HKUserInfoSettingVC.h"
#import "HKVersionCodeCell.h"
#import "UMpopView.h"
#import "MyInfoViewController+Category.h"
#import "HKUserInfoVC.h"
#import "HKUserOtherInfoModel.h"
#import "MyInfoCellVisibleConfig.h"
#import "HtmlShowVC.h"
#import "HKMessageCenterVC.h"




@interface MyInfoViewController_1 ()<UITableViewDelegate,UITableViewDataSource,UserIconCellDelegate,UMpopViewDelegate>


@property(nonatomic, strong)UITableView  *myInfoTableView;

@property(nonatomic, strong)NSMutableArray *textArray;

@property(nonatomic, strong)NSMutableArray *iconArray;

@property(nonatomic, strong)HKUserModel *userModel;

@property(nonatomic, strong)UIView *bgHeadView;

@property(nonatomic, strong)UIImageView *heroBigImageView;

@property(nonatomic, assign)BOOL isLatestVersion; // 最新版本

@property(nonatomic, strong)HKIsShowCellModel *cashback_data;

@property(nonatomic, strong)HKIsShowCellModel *invited_data;

@property(nonatomic, strong)ShareModel *shareModel;
/** 额外信息（客服电话等） */
@property(nonatomic, strong)HKUserOtherInfoModel *otherInfoM;

@property(nonatomic, strong)MyInfoCellVisibleConfig *cellVisibleConfig;

@end



@implementation MyInfoViewController_1



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setHeadView];
    
    //验证 VIP 购买 补单
    [[YHIAPpay instance]repairReceipt];
    [self setUserInfoObserve];
    [self refreshUI];
    [self setUserModel];
}


- (BOOL)isLatestVersion {
    _isLatestVersion = [CommonFunction isLatestVersion];
    return _isLatestVersion;
}

- (MyInfoCellVisibleConfig*)cellVisibleConfig {
    if (!_cellVisibleConfig) {
        _cellVisibleConfig = [MyInfoCellVisibleConfig new];
    }
    return _cellVisibleConfig;
}


- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self guideUserComment];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}




#pragma mark - 引导 用户去APP Store评论
- (void)guideUserComment {
    
    if([CommonFunction isSecondLoad]) {
        WeakSelf;
        HKGuideCommentView *view = [[HKGuideCommentView alloc]init];
        view.commentBlock = ^(id sender) {
            [weakSelf pushToOtherController:[FeedbackVC new]];
        };
        view.pariseBlock = ^(id sender) {
            [weakSelf pushToOtherController:[HKSettingVC new]];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    }
}





- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 请求数据额外的个人数据，比如签到
    [self getUserExtInfo];
    
    // 商城链接，服务号码
    [self getServerPhoneNum:nil];
    //刷新缓存数据
    //[self.myInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
}




- (void)setHeadView {
    self.bgHeadView = [UIView new];
    _bgHeadView.frame = CGRectMake(0, -200, SCREEN_WIDTH, 200);
    _bgHeadView.backgroundColor = COLOR_ffd500;
    [_myInfoTableView addSubview:_bgHeadView];
}


#pragma mark - 用户信息改变
- (void)setUserInfoObserve {
    HK_NOTIFICATION_ADD(HKUserInfoChangeNotification, userInfoChangeNotification);
    HK_NOTIFICATION_ADD(HKBindPhoneNumNotification, bindPhoneNumNotification);
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userInfoChangeNotification);
}

- (void)userInfoVIPChangeNotification {
    [self.myInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)userInfoChangeNotification {
    [self setUserModel];
    [self.myInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self userInfoVIPChangeNotification];
}

- (void)bindPhoneNumNotification {
    [self.myInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
}


//scrollview的代理，获取contentoffset，然后从新设置imageview的frame
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取当前活动的tableview
    CGFloat  y = scrollView.contentOffset.y;
    if (scrollView == _myInfoTableView) {
        if (y < -150) {
            CGRect frame = _bgHeadView.frame;
            frame.size.height =  - y ;
            frame.origin.y = y;
            _bgHeadView.frame = frame;
        }
    }
}



- (UITableView*)myInfoTableView {
    
    if (!_myInfoTableView) {
        _myInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                       style:UITableViewStyleGrouped];
        // 兼容iOS11
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _myInfoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            // 防止 reloadsection UI 错乱
            _myInfoTableView.estimatedRowHeight = 0;
            _myInfoTableView.estimatedSectionHeaderHeight = 0;
            _myInfoTableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _myInfoTableView.backgroundColor = COLOR_F8F9FA;
        [_myInfoTableView setContentInset:UIEdgeInsetsMake(0, 0, KTabBarHeight49, 0)];
        
        _myInfoTableView.tableFooterView = [UIView new];
        _myInfoTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        _myInfoTableView.sectionHeaderHeight = 0.01;
        _myInfoTableView.delegate = self;
        _myInfoTableView.dataSource = self;
        _myInfoTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;// NO;

        // 注册cell
        [_myInfoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OtherSetUpCell2 class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OtherSetUpCell2 class])];
        
        [_myInfoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OtherSetUpInviteCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OtherSetUpInviteCell class])];
        
        _myInfoTableView.showsVerticalScrollIndicator = NO;
        _myInfoTableView.showsHorizontalScrollIndicator = NO;
    }
    return _myInfoTableView;
}



- (NSMutableArray*)iconArray {
    if (!_iconArray) {
        _iconArray = [[NSMutableArray alloc]initWithObjects:@"my_order_gray", @"discount_icon", @"my_info_notification", nil];
    }
    return  _iconArray;
}


- (NSMutableArray*)textArray {
    if (!_textArray) {
        _textArray = [NSMutableArray arrayWithObjects:@"我的订单", @"优惠券", @"消息中心", nil];
    }
    return  _textArray;
}


- (void)createUI {
    self.view.backgroundColor = COLOR_F8F9FA;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.myInfoTableView];
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3+5;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat heightForMidCell = 0.0;
    NSString *VIPTemp =  [HKAccountTool shareAccount].vip_class;
    
    if (!VIPTemp || [VIPTemp isEqualToString:@"0"]) {
        heightForMidCell = PADDING_25 * 3;
    } else {
        heightForMidCell = 50.0;
    }
    
    CGFloat  height = 0;
    switch (indexPath.section) {
        case 0:
            height = SCREEN_HEIGHT/4;
            break;
            
        case 1:
            height = heightForMidCell;
            break;
            
        case 2:
            height = PADDING_25*2;
            break;
        case 3:
            height = PADDING_25*2;
            break;
        default:
            height = PADDING_25*2;
            break;
    }
    return height;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger  count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            count = self.textArray.count;
            break;
        case 3 :case 4 :case 5 :case 6 :case 7 :
            count = [self.cellVisibleConfig numberOfRowsInSection:section];
            break;
        default:
            break;
    }
    return count;
}



- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case 0: case 1: case 2:
            height = 8;
            break;
            
        case 3 :case 4 :case 5 :case 6 :case 7 :
            height = 0.01;
            break;
            
        default:
            break;
    }
    return height;
}


-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor whiteColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = COLOR_F8F9FA;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    UITableViewCell *_cell = nil;
    NSInteger section = [indexPath section];
    if (0 == section) {
        
        UserIconCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"UserIconCell"];
        if (!userCell ) {
            userCell = [[UserIconCell alloc] initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:@"UserIconCell"];
            userCell.delegate = self;
            // 签到有奖
            userCell.presentEntranceBlock = ^{
                if (!isLogin()) {
                    [weakSelf setLoginVC];
                    return;
                }
                HKPresentVC *VC = [[HKPresentVC alloc] init];
                [weakSelf pushToOtherController:VC];
            };
        }
        userCell.userInfoModel = self.userModel;
        _cell = userCell;
        return _cell;
        
    }else if (1 == section){
        
        NSString *VIPTemp =  [HKAccountTool shareAccount].vip_class;
        if (!VIPTemp || [VIPTemp isEqualToString:@"0"]) {
            
            HKNOVipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKNOVipCell"];
            if (!cell ) {
                cell = [[HKNOVipCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"HKNOVipCell"];
            }
            [cell setVideoCount:self.otherInfoM.vip_str];
            _cell = cell;
            
        } else {
            VipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipCell"];
            if (!cell ) {
                cell = [[VipCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"VipCell"];
            }
            // 设置VIP 提示信息
            [cell setStringVipTip:self.userModel.vip_tips_msg];
            _cell = cell;
        }
        return _cell;
    }else if (2==section){
        
        NSInteger row = indexPath.row;
        OtherSetUpCell2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OtherSetUpCell2 class])];
        cell.unreadMessage.hidden = YES;
        cell.leftLB.text = @"";
        if (1 == row) {// 优惠券
            cell.userModel = self.userModel;
        } else if (2 == row) { // 消息中心
            int count = [HKAccountTool shareAccount].unread_msg_total;
            NSString *stringCount = count > 99? @"99+" : [NSString stringWithFormat:@"%d条未读", count];
            cell.unreadMessage.hidden = count <= 0;
            [cell.unreadMessage setTitle:stringCount forState:UIControlStateNormal];
        }
        [cell.rightLB setText:self.textArray[row]];
        cell.rightIV.image = imageName(self.iconArray[row]);
        _cell = cell;
        
        return _cell;
    }else {
        
        switch (section) {
            case 3:
            {
                // 商城
                OtherSetUpCell2 *cell = [self visibleCell:tableView leftText:@"全新上线" leftImageName:@"ic_shopping" rightText:@"虎课币商城"];
                cell.leftLB.textColor = COLOR_FF6400;
                return cell;
            }
            case 4:
            {
                // 分享
                OtherSetUpInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OtherSetUpInviteCell class])];
                cell.rightIV.image = imageName(@"invited_icon");
                return cell;
            }
            case 5:
            {
                OtherSetUpCell2 *cell = [self visibleCell:tableView leftText:nil leftImageName:@"bind_phone" rightText:@"联系客服"];
                return cell;
            }
            case 6:
            {
                OtherSetUpCell2 *cell = [self visibleCell:tableView leftText:nil leftImageName:@"my_set_gray" rightText:@"设置"];
                return cell;
            }
            case 7:
            {
                HKVersionCodeCell *vCell = [HKVersionCodeCell initCellWithTableView:tableView];
                vCell.hidden = self.isLatestVersion;
                return vCell;
            }
        }
    }
    return _cell;
}



- (OtherSetUpCell2 *)visibleCell:(UITableView *)tableView
                        leftText:(NSString*)leftText
                   leftImageName:(NSString*)leftImageName
                       rightText:(NSString*)rightText{
    
    OtherSetUpCell2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OtherSetUpCell2 class])];
    cell.unreadMessage.hidden = YES;
    cell.leftLB.text = isEmpty(leftText) ?@"" : leftText;
    [cell.rightLB setText:(isEmpty(rightText) ?@"" : rightText)];
    cell.rightIV.image = isEmpty(leftImageName) ? nil : imageName(leftImageName);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = [indexPath section];
    [self performSelector:@selector(deleselect) withObject:nil afterDelay:0.5f];
    
    if (1 == section) {
        [MobClick event:UM_RECORD_MYINFO_VIP];
        if (!isLogin() || ![HKAccountTool shareAccount].vip_class || [[HKAccountTool shareAccount].vip_class isEqualToString:@"0"]) {
            HKVIPCategoryVC *VC = [[HKVIPCategoryVC alloc] init];
            VC.class_type = self.otherInfoM.class_type;
            [self pushToOtherController:VC];
        }else{
            [self pushToOtherController:[HKMyVIPVC new]];
        }
    }
    
    if (2 == section) {
        NSInteger row = indexPath.row;
        if (!isLogin()) {
            [self setLoginVC];
            return;
        }
        switch (row) {
            case 0:
                [self pushToOtherController:[HKOrderPaymentVC new]];
                [MobClick event:UM_RECORD_PERSONAL_CENTER_MY_ORDER];
                break;
                
            case 1:
                //[MobClick event:UM_RECORD_PERSONAL_CENTER_COUPON];
                [self pushToOtherController:[HKCouponVC new]];
                break;
                
            case 2:
                if (self.cashback_data.is_show) {
                    
                    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:self.cashback_data.url];
                    [self pushToOtherController:htmlShowVC];
                } else {
                    [self pushToOtherController:[HKMessageCenterVC new]];
                }
                break;
            case 3:
                [self pushToOtherController:[HKMessageCenterVC new]];
                break;
                
            default:
                break;
        }
    }else {
        
        switch (section) {
            case 3:
            {
                [MobClick event:UM_RECORD_PERSONAL_CENTER_MALL];
                //商城
                NSString *url = self.otherInfoM.mall_data.url;
                if (isEmpty(url)) { return; }
                
                HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:url];
                [self pushToOtherController:htmlShowVC];
                break;
            }
            case 4:
                //分享
                [MobClick event:UM_RECORD_PERSONALCENTER_RECOMMEND];
                [self shareWithUI:self.shareModel];
                break;
            case 5:
                // 客服
                [self contactServiceWithPhone:self.otherInfoM.phone];
                //[MobClick event:UM_RECORD_PERSONAL_CENTER_CONTACTUS];
                break;
            case 6:
                // 设置
                [self pushToOtherController:[HKSettingVC new]];
                //[self pushToOtherController:[HKVIPCategoryVC new]];
                [MobClick event:UM_RECORD_PERSONAL_CENTER_SET];
                break;
            case 7:
                // 版本
                [MobClick event:UM_RECORD_PERSONAL_CENTER_VERSION];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
                break;
        }
    }
}



- (void) deleselect {
    [self.myInfoTableView deselectRowAtIndexPath:[self.myInfoTableView indexPathForSelectedRow] animated:YES];
}






- (HKUserModel*)userModel{
    if (!_userModel) {
        _userModel = [HKUserModel new];
    }
    return _userModel;
}

#pragma mark - 获取用户信息
- (void)setUserModel {
    self.userModel = [HKAccountTool shareAccount];
}




#pragma mark - user delegate
- (void)userIconCellAction:(id)sender image:(UIImage *)image model:(HKUserModel *)model {
    if (!isLogin()) {
        [self setLoginVC];
    }else{
        
        HKUserInfoVC *VC = [HKUserInfoVC new];
        VC.userId = model.ID;
        [self pushToOtherController:VC];
    }
}



- (void)nameLabelAction:(id)sender {
    if (!isLogin()) {
        [self setLoginVC];
    }
}


- (void)openVipAction:(id)sender {
    
    [self pushToOtherController:[[HKVIPCategoryVC alloc] init]];
    [MobClick event:UM_RECORD_PERSONAL_CENTER_OPEN_VIP];
}


#pragma mark - 获取额外个人数据
- (void)getUserExtInfo {
    
    if (!isLogin()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.myInfoTableView.mj_header endRefreshing];
        });
        return;
    }
    WeakSelf;
    [[UserInfoServiceMediator sharedInstance] getUserExtInfoCompletion:^(FWServiceResponse *response) {
        [weakSelf.myInfoTableView.mj_header endRefreshing];
        //vip_type:0-非VIP 1-分类VIP 2-全站通VIP 3-全站通
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            if (response.data != nil) {
                
                if (isLogin()) {
                    
                    NSString *sign_type =[NSString stringWithFormat:@"%@",[response.data objectForKey:@"sign_type"]];
                    NSString *sign_continue_num =[NSString stringWithFormat:@"%@",[response.data objectForKey:@"sign_continue_num"]];
                    NSString *unread_msg_total =[NSString stringWithFormat:@"%@",[response.data objectForKey:@"unread_msg_total"]];
                    //NSString *vip_type = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"vip_type"]];
                    NSString *vip_class = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"vip_class"]];
                    NSString *vip_tips_msg = [NSString stringWithFormat:@"%@",[response.data objectForKey:@"vip_tips_msg"] == nil? @"" : [response.data objectForKey:@"vip_tips_msg"]];
                    
                    NSString *phone = [response.data objectForKey:@"phone"];
                    NSString *username = [response.data objectForKey:@"username"];
                    
                    id data = [response.data objectForKey:@"coupon_data"];
                    //HKCouponModel *couponModel = [HKCouponModel mj_objectWithKeyValues:data];
                    HKCouponModel *couponModel = [HKCouponModel mj_objectWithKeyValues:isEmpty(data)? nil :data];
                    
                    // 更新天数
                    self.userModel.sign_continue_num = sign_continue_num;
                    self.userModel.vip_tips_msg = vip_tips_msg;
                    self.userModel.sign_type = sign_type;
                    self.userModel.coupon_data = couponModel;
                    self.userModel.unread_msg_total = [unread_msg_total intValue];
                    
                    self.userModel.vip_class = vip_class;
                    //self.userModel.vip_type = vip_type;
                    self.userModel.username = username;
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HKSignStatusChange" object:@{@"sign_type" : sign_type, @"sign_continue_num" : sign_continue_num}];
                    
                    // 查询并且更新签到的情况
                    //                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    //                    [defaults setObject:sign_type forKey:SING_TYPE];
                    //                    [defaults setObject:sign_continue_num forKey:SING_CONTINUE_NUM];
                    //                    // 电话
                    //                    [defaults setObject:phone forKey:LOGIN_PHONE];
                    //                    [defaults synchronize];
                    
                    //分享
                    self.shareModel = [ShareModel mj_objectWithKeyValues:[response.data objectForKey:@"share_data"]];
                    
                    // 更新账号
                    [HKAccountTool shareAccount].username = username;
                    [HKAccountTool shareAccount].coupon_data = couponModel;
                    [HKAccountTool shareAccount].phone = phone;
                    [HKAccountTool shareAccount].vip_tips_msg = vip_tips_msg;
                    //[HKAccountTool shareAccount].vip_type = vip_type;
                    [HKAccountTool shareAccount].vip_class = vip_class;
                    
                    [HKAccountTool shareAccount].sign_type = sign_type;
                    [HKAccountTool shareAccount].sign_continue_num = sign_continue_num;
                    [HKAccountTool shareAccount].unread_msg_total = [unread_msg_total intValue];
                    [HKAccountTool saveOrUpdateAccount:[HKAccountTool shareAccount]];
                    [self.myInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    
                    // 发出红点消息
                    [[NSNotificationCenter defaultCenter] postNotificationName:HKMineRedPointNotification object:nil userInfo:@{@"unreadCount" : unread_msg_total}];
                }
                
                // 我的返现
                self.cashback_data = [HKIsShowCellModel mj_objectWithKeyValues:response.data[@"cashback_data"]];
                //                self.cashback_data.is_show = YES;
                if (self.cashback_data.is_show && ![self.textArray containsObject:@"我的返现"]) {
                    [self.textArray insertObject:@"我的返现" atIndex:2];
                    [self.iconArray insertObject:@"cashback_icon" atIndex:2];
                } else if (!self.cashback_data.is_show && [self.textArray containsObject:@"我的返现"]) {
                    [self.textArray removeObjectAtIndex:2];
                    [self.iconArray removeObjectAtIndex:2];
                }
                
                // 我的邀请
                self.invited_data = [HKIsShowCellModel mj_objectWithKeyValues:response.data[@"invited_data"]];
                if (self.invited_data.is_show) {
                    self.cellVisibleConfig.isShareCellVisible = YES;
                }
                [self.myInfoTableView reloadData];
            }
        }
    } failBlock:^(NSError *error) {
        [weakSelf.myInfoTableView.mj_header endRefreshing];
    }];
}


#pragma mark - 刷新 sever
- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.myInfoTableView completion:^{
        StrongSelf
        [strongSelf getUserExtInfo];
    }];
    //[self getServerPhoneNum:nil];
}


/** 联系客服 cell 点击 */
- (void)contactServiceWithPhone:(NSString*)phone {
    if (isEmpty(phone)) {
        [self getServerPhoneNum:@selector(contactService)];
    }else{
        [self contactService];
    }
}

- (void)contactService {
    //[self contactService:self.otherInfoM.phone qq:self.otherInfoM.qq];
}

/**
 获取 客服联系方式

 @param action 方法名 （传入方法名，后台返回结果后执行该方法 ）
 */
- (void)getServerPhoneNum:(SEL)action {
    
    [HKHttpTool POST:USER_GET_MY_INFO baseUrl:BaseUrl parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            HKUserOtherInfoModel *otherInfoM = [HKUserOtherInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.otherInfoM = otherInfoM;
            if (otherInfoM.mall_data.is_show) {
                self.cellVisibleConfig.isHkShopCellVisible = YES;
                [self.myInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            //无VIP 未登录 显示视频数量
            UITableViewCell *cell = [self.myInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            if ([cell isKindOfClass:[HKNOVipCell class]]) {
                [self.myInfoTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
            if (action) {
                [self performSelector:action withObject:nil afterDelay:0];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}



/** 友盟分享 */
- (void)shareWithUI:(ShareModel*)model {
    
    UMpopView *popView = [UMpopView sharedInstance];
    [popView createUIWithModel:model];
    popView.delegate = self;
}



#pragma mark - UMpopView 代理
- (void)uMShareWebSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}


#pragma mark - 分享网页成功 回调 后台
- (void)shareSucessWithModel:(ShareModel*)model {
    
    if (!isLogin()) {
        showTipDialog(Share_Sucess);
        return;
    }
    [HKCommonRequest shareDataSucess:model success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}




- (void)uMShareImageSucess:(id)sender {
    if ([sender isKindOfClass:[ShareModel class]]) {
        ShareModel *model = (ShareModel*)sender;
        [self shareSucessWithModel:model];
    }
}

- (void)uMShareImageFail:(id)sender {
    
}

@end


