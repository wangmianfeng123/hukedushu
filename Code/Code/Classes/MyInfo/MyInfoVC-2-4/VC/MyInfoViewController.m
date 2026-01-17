
//
//  HKMyInfoVC.m
//  Code
//
//  Created by Ivan li on 2018/9/23.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoHeadCell.h"
#import "HKCouponModel.h"
#import "DetailModel.h"
#import "HKIsShowCellModel.h"
#import "HKMyInfoSetCell.h"
#import "HKMyInfoShareCell.h"
#import "UMpopView.h"
#import "HKMyInfoUserModel.h"
#import "BannerModel.h"
#import "HKH5PushToNative.h"
#import "HKSettingVC.h"
#import "HKVIPCategoryVC.h"
#import "HKUserInfoVC.h"
#import "HKMyVIPVC.h"
#import "HKPresentVC.h"
#import "HKUserOtherInfoModel.h"
#import "MyInfoViewController+Category.h"
#import "HKMyInfoVipAdCell.h"
#import "HKGuideCommentView.h"
#import "FeedbackVC.h"
#import "HKReplyMessageView.h"
#import "HKMyInfoNotificationVC.h"
#import "HKMyInfoLearnCell.h"
#import "HKNewTaskModel.h"
#import "AppDelegate.h"
#import "HKSuspensionView.h"
#import "HKNewTaskModel.h"
#import "HKNotesListVC.h"
#import "HKMessageCenterVC.h"
#import "HKNotiTabModel.h"
#import "HKVIPCategoryVC.h"

//#import "UnreadMessageModel.h"

@interface MyInfoViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UMpopViewDelegate,HKMyInfoSetCellDelegate,
MyInfoHeadCellDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *headBgView;

@property (nonatomic,strong) NSMutableArray *dataArray;
/** 跳转 model */
@property (nonatomic,strong) NSMutableArray <HKMyInfoMapPushModel*>*mapArr;

@property (nonatomic , strong) NSMutableArray<HKMyInfoGuideLearnModel*> * learnModelArray ;

@property (nonatomic,strong) HKUserModel    *userModel;
/** 分享 */
@property (nonatomic,strong) ShareModel     *shareModel;

@property (nonatomic,strong) HKIsShowCellModel *invited_data;

@property (nonatomic,strong) HKMyInfoVipModel *vipModel;
/** 客服 */
@property (nonatomic,strong) HKUserOtherInfoModel *serviceModel;
/** 显示 分享 cell */
@property (nonatomic,assign)BOOL isShareCellVisible;
/** 显示 vip 广告 cell */
@property (nonatomic,assign)BOOL isvipAdCellVisible;

@property (nonatomic,strong) HKMapModel  *mapModel;

@property (nonatomic, strong) HKReplyMessageView * replyView;

@end



@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserve];
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    // 推广渠道
    [HkChannelData requestHkChannelData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //APP status 查询
    [CommonFunction checkAPPStatus];
    
    [self getUserExtInfo];
    [self guideUserComment];
    AppDelegate * delegate = [AppDelegate sharedAppDelegate];
    if (delegate.model.is_show) {
        delegate.suspensionView.hidden = NO;
    }else{
        delegate.suspensionView.hidden = YES;
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate * delegate = [AppDelegate sharedAppDelegate];
    delegate.suspensionView.hidden = YES;
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
            
        };
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    }
}


- (void)loadView {
    [super loadView];
    self.userModel = [HKAccountTool shareAccount];
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.headBgView];
    [self hkDarkModel];
}


- (void)hkDarkModel {
    self.collectionView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_333D48];
}


//- (UIView*)headBgView {
//    if (!_headBgView) {
//        _headBgView = [UIView new];
//        _headBgView.frame = CGRectMake(0, -200, SCREEN_WIDTH, 200);
//        _headBgView.backgroundColor = COLOR_ffd500;
//    }
//    return _headBgView;
//}


- (HKUserModel*)userModel {
    if (!_userModel) {
        _userModel = [HKUserModel new];
    }
    return _userModel;
}


- (NSMutableArray<HKMyInfoMapPushModel*>*)mapArr {
    if (!_mapArr) {
        _mapArr = [NSMutableArray array];
    }
    return _mapArr;
}


- (void)addObserve {
    HK_NOTIFICATION_ADD(HKUserInfoChangeNotification, userInfoChangeNotification);
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginSuccessNotification);
}


- (void)userInfoChangeNotification {
    self.userModel = [HKAccountTool shareAccount];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


- (void)loginSuccessNotification {
    [self getUserExtInfo];
}


- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[MyInfoHeadCell class] forCellWithReuseIdentifier:NSStringFromClass([MyInfoHeadCell class])];
        [_collectionView registerClass:[HKMyInfoSetCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyInfoSetCell class])];
        [_collectionView registerClass:[HKMyInfoShareCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyInfoShareCell class])];
        [_collectionView registerClass:[HKMyInfoVipAdCell class] forCellWithReuseIdentifier:NSStringFromClass([HKMyInfoVipAdCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HKMyInfoLearnCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HKMyInfoLearnCell class])];
        HKAdjustsScrollViewInsetNever(self, _collectionView);
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, KTabBarHeight49+ (IS_IPHONE5S ?10 :20), 0);
    }
    return _collectionView;
}




#pragma mark <UICollectionViewDelegate>

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGFloat  y = scrollView.contentOffset.y;
//    if (scrollView == self.collectionView) {
//        //获取contentoffset   从新设置frame
//        if (y < -150) {
//            CGRect frame = _headBgView.frame;
//            frame.size.height =  - y ;
//            frame.origin.y = y;
//            _headBgView.frame = frame;
//        }
//    }
//}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3 + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return 1;
    switch (section) {
        case 0:case 1:
            return 1;
            break;
        case 2:
            return self.learnModelArray.count;
            break;
        case 3:
            return self.isvipAdCellVisible ? 1 :0;
            break;
            
        default:
            return 0;
            break;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            MyInfoHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyInfoHeadCell class]) forIndexPath:indexPath];
            cell.userInfoModel = self.userModel;
            cell.vipModel = self.vipModel;
            cell.delegate = self;
            // 签到
            WeakSelf;
            cell.presentEntranceBlock = ^{
                if (isLogin()) {
                    HKPresentVC *VC = [[HKPresentVC alloc] init];
                    [weakSelf pushToOtherController:VC];
                }else{
                    [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:5];
                    [weakSelf setLoginVC];
                }
            };
            return cell;
        }
            break;
        case 1:
        {
            HKMyInfoSetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyInfoSetCell class]) forIndexPath:indexPath];
            cell.dataArr = self.mapArr;
            cell.delegate = self;
            return cell;
        }
            break;
        case 2:
        {
            HKMyInfoLearnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyInfoLearnCell class]) forIndexPath:indexPath];
            //cell.contentView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_F8F9FA dark:COLOR_3C4651];
            cell.model = self.learnModelArray[indexPath.row];
            return cell;
        }
            break;
        case 3:
        {
            HKMyInfoVipAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKMyInfoVipAdCell class]) forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.hidden = !self.isvipAdCellVisible;
            [cell.adIV sd_setImageWithURL:HKURL([HKLoadingImageTool transitionImageUrlString:self.mapModel.img_url]) placeholderImage:imageName(HK_Placeholder)];
            return cell;
        }
            break;
        default:
            return [UICollectionViewCell new];
            break;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (3 == section) {
        //vip 广告
        if (self.isvipAdCellVisible) {
            [MobClick event:my_home_page_ad_banner];
            //广告跳转
            [HKH5PushToNative runtimePush:self.mapModel.redirect_package.className arr:self.mapModel.redirect_package.list currectVC:self];
            
            [[HomeServiceMediator sharedInstance] advertisClickCount:self.mapModel.ad_id];
            [HKALIYunLogManage sharedInstance].button_id = @"4";
            [MobClick event: personalcenter_bottom_banner];
        }
        
    }
    if (section == 2) {
        HKMyInfoGuideLearnModel * model = self.learnModelArray[indexPath.row];
        [HKH5PushToNative runtimePush:model.redirect_package.className arr:model.redirect_package.list currectVC:self];
        if (indexPath.row == 0) {
            [MobClick event:personalcenter_recommend1];
        }else if (indexPath.row == 1){
            [MobClick event:personalcenter_recommend2];
        }else if (indexPath.row == 2){
            [MobClick event:personalcenter_recommend3];
        }else if (indexPath.row == 3){
            [MobClick event:personalcenter_recommend4];
        }
    }
    //    else if (3 == section) {
    //        //分享
    //        if (self.isShareCellVisible) {
    //            [MobClick event:UM_RECORD_PERSONALCENTER_RECOMMEND];
    //            [self shareWithUI:self.shareModel];
    //        }
    //    }
}

//定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return UIEdgeInsetsMake(15, 15, 15, 15);//分别为上、左、下、右
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    CGSize size = CGSizeZero;
    
    CGFloat adHeight = 45.0 * SCREEN_WIDTH / 375.0;
    CGFloat shareHeight = 82.0 * SCREEN_WIDTH / 375.0;
    
    switch (section) {
        case 0:
            size = [self headCellSize];
            break;
        case 1:
            size = [self secondeCellSize];
            break;
        case 2:
            //size = CGSizeMake(SCREEN_WIDTH, shareHeight);
            size = CGSizeMake((SCREEN_WIDTH-40)/2.0, 65);
            break;
            
        case 3:
            size = CGSizeMake(SCREEN_WIDTH, adHeight);
            break;
            
    }
    return size;
}



- (CGSize)headCellSize {
    
    CGSize size = CGSizeZero;
    switch ([self.userModel.vip_class intValue]) {
        case HKVipType_No:
            size = CGSizeMake(SCREEN_WIDTH, 230 + (IS_IPHONE_X ?24 :0) + 18);
            break;
        default:
            size = CGSizeMake(SCREEN_WIDTH, 230 + (IS_IPHONE_X ?24 :0) + 18);
            break;
            //        case HKVipType_No:
            //            size = CGSizeMake(SCREEN_WIDTH, 535/2 + (IS_IPHONE_X ?24 :0));
            //            break;
            //        default:
            //            size = CGSizeMake(SCREEN_WIDTH, 484/2 + (IS_IPHONE_X ?24 :0));
            //            break;
    }
    return  size;
}



- (CGSize)secondeCellSize {
    
    if ([[CommonFunction getAPPStatus] isEqualToString:@"1"]) {
        HKMyInfoMapPushModel * flagM = nil;
        for (HKMyInfoMapPushModel * mdoel in self.mapArr) {
            if ([mdoel.title isEqualToString:@"优惠券"]) {
                flagM = mdoel;
            }
        }
        if (flagM) {
            [self.mapArr removeObject:flagM];
        }
    }
    
    NSInteger count = self.mapArr.count;
    if (IS_IPAD) {
        if (count) {
            CGFloat W = (SCREEN_WIDTH - 20)/count;
            return CGSizeMake(SCREEN_WIDTH, ( W<90) ?320/2 :160/2);
        }else{
            return CGSizeMake(SCREEN_WIDTH, 160/2);
        }
    }else{
        return CGSizeMake(SCREEN_WIDTH, (count >8) ?240 * Ratio :320/2 * Ratio);
        //return CGSizeMake(SCREEN_WIDTH, 320/2);
    }
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}




#pragma mark  HKMyInfoSetCell  代理
- (void)myInfoSetCellClickAction:(HKMyInfoMapPushModel*)model indexPath:(NSIndexPath*)indexPath {
    
    if ([model.key isEqualToString:@"service"]) {
        [self contactService:self.serviceModel.phone qq:self.serviceModel.qq];
        
    }else if ([model.key isEqualToString:@"appStore"]) {
        // app store
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
        
    }else if ([model.key isEqualToString:@"allSetting"]) {
        
        [self pushToOtherController:[HKSettingVC new]];
        
    }else if ([model.key isEqualToString:@"invitationFriend"]) {
        //邀请好友
        [self shareWithUI:self.shareModel];
        
    }else if ([model.key isEqualToString:@"myNotes"]) {
        if (model.need_login) {
            if (!isLogin()) {
                [self setLoginVC];
                return;
            }
        }
        //我的笔记
        [MobClick event: personalcenter_note];
        [self pushToOtherController:[[HKNotesListVC alloc]init]];
        
    }else {
        if ([model.key isEqualToString:@"coupon"]) {
            [MobClick event:UM_RECORD_PERSONAL_CENTER_COUPON];
        }else if ([model.key isEqualToString:@"mall"]){
            [MobClick event:UM_RECORD_PERSONAL_CENTER_MALL];
        }
        if (model.need_login) {
            if (!isLogin()) {
                [self setLoginVC];
                return;
            }
        }
        
        //映射跳转
        if (!isEmpty(model.redirect_package.class_name)) {
            [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:self];
        }
    }
}

#pragma mark  MyInfoHeadCell  代理
- (void)vipPushAction:(id)sender {
    
    [MobClick event:UM_RECORD_MYINFO_VIP];
    NSString *vip_class = [HKAccountTool shareAccount].vip_class;
    [HKALIYunLogManage sharedInstance].button_id = @"7";
    if (!isLogin() || !vip_class || [vip_class isEqualToString:@"0"] || [vip_class isEqualToString:@"-1"]) {
        HKVIPCategoryVC *VC = [[HKVIPCategoryVC alloc] init];
        [self pushToOtherController:VC];
    }else{
        [self pushToOtherController:[HKMyVIPVC new]];
    }
}


- (void)userIconCellAction:(id)sender image:(UIImage *)image model:(HKUserModel *)model {
    if (!isLogin()) {
        [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:6];
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



- (void)refreshUI {
    WeakSelf;
    [HKRefreshTools headerRefreshWithTableView:self.collectionView completion:^{
        StrongSelf
        [strongSelf getUserExtInfo];
    }];
    
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader*)self.collectionView.mj_header;
    // 隐藏状态 和加载图片
    header.stateLabel.hidden = YES;
    header.arrowView.image = nil;
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
}




#pragma mark - 个人数据
- (void)getUserExtInfo {
    
    [self getMapAndVipCacheData];
    
    [[UserInfoServiceMediator sharedInstance] getUserExtInfoCompletion:^(FWServiceResponse *response) {
        [self.collectionView.mj_header endRefreshing];
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            if (response.data != nil) {
                
                HKMyInfoVipModel *vipM = [HKMyInfoVipModel mj_objectWithKeyValues:[response.data objectForKey:@"vip_info"]];
                self.vipModel = vipM;
                
                if (isLogin()) {
                    
                    NSString *sign_type =[NSString stringWithFormat:@"%@",response.data[@"sign_info"][@"sign_type"]];
                    NSString *sign_continue_num =[NSString stringWithFormat:@"%@",response.data[@"sign_info"][@"sign_continue_num"]];
                    HKMyInfoUserModel *userM = [HKMyInfoUserModel mj_objectWithKeyValues:response.data];
                    userM.sign_type = sign_type;
                    userM.sign_continue_num = sign_continue_num;
                    userM.vip_class = vipM.vip_class;
                    
                    self.userModel.sign_continue_num = userM.sign_continue_num;
                    self.userModel.vip_tips_msg = userM.vip_tips_msg;
                    self.userModel.sign_type = userM.sign_type;
                    self.userModel.vip_class = userM.vip_class;
                    self.userModel.coupon_data = userM.coupon_data;
                    self.userModel.unread_msg_total = userM.unread_msg_total;
                    self.userModel.username = userM.username;
                    
                    // 更新账号
                    [self updateUserData:userM];
                    //签到状态
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HKSignStatusChange" object:@{@"sign_type" : sign_type, @"sign_continue_num" : sign_continue_num}];
                }
            }
            //客服电话
            self.serviceModel = [HKUserOtherInfoModel mj_objectWithKeyValues:[response.data objectForKey:@"service_info"]];
            //分享
            self.shareModel = [ShareModel mj_objectWithKeyValues:[response.data objectForKey:@"share_data"]];
            //跳转映射
            self.mapArr = [HKMyInfoMapPushModel mj_objectArrayWithKeyValuesArray:response.data[@"modules_list"]];
            // 我的邀请
            self.invited_data = [HKIsShowCellModel mj_objectWithKeyValues:response.data[@"invited_data"]];
            if (self.invited_data.is_show) {
                self.isShareCellVisible = YES;
            }
            // VIP 广告cell
            self.mapModel = [HKMapModel mj_objectWithKeyValues:response.data[@"advertisement"]];
            //引导学习
            self.learnModelArray = [HKMyInfoGuideLearnModel mj_objectArrayWithKeyValuesArray:response.data[@"guideAdvertisement"]];
            
            self.isvipAdCellVisible = self.mapModel.is_show;
            
            [self saveCacheData:response.data];
            [self loadData];
            
        }
    } failBlock:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
}


/**
 * 发送红点 通知
 **/
- (void)postRedPointNoti:(int) messageCount {
    
    if (isLogin()) {
        if (messageCount) {
            self.replyView.hidden = NO;
            if (messageCount>99) {
                self.replyView.messageCountLabel.text = @"99+";
            }else{
                self.replyView.messageCountLabel.text = [NSString stringWithFormat:@"%d",messageCount];
            }
            
        }else{
            self.replyView.hidden = YES;
        }
    }else{
        self.replyView.hidden = YES;
    }
}


- (HKReplyMessageView *)replyView{
    if (_replyView == nil) {
        _replyView = [HKReplyMessageView createView];
        [self.view addSubview:_replyView];
        CGFloat centerx = [self tabitemPointXForIndex:4];
        _replyView.center = CGPointMake(centerx,SCREEN_HEIGHT-KTabBarHeight49-20);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_replyView addGestureRecognizer:tap];
    }
    return _replyView;
}

- (void)tapClick{
    [MobClick event:personalcenter_news_notice];
    [self pushToOtherController:[HKMessageCenterVC new]];
}


#pragma mark 更新用户信息
- (void)updateUserData:(HKMyInfoUserModel *)userM {
    // 更新账号
    [HKAccountTool shareAccount].username = userM.username;
    [HKAccountTool shareAccount].coupon_data = userM.coupon_data;
    [HKAccountTool shareAccount].phone = userM.phone;
    [HKAccountTool shareAccount].vip_tips_msg = userM.vip_tips_msg;
    
    [HKAccountTool shareAccount].vip_class = userM.vip_class;
    [HKAccountTool shareAccount].sign_type = userM.sign_type;
    [HKAccountTool shareAccount].sign_continue_num = userM.sign_continue_num;
    [HKAccountTool shareAccount].unread_msg_total = userM.unread_msg_total;
    
    [HKAccountTool shareAccount].avator = userM.avator;
    [HKAccountTool saveOrUpdateAccount:[HKAccountTool shareAccount]];
}


#pragma mark 读取 映射  缓存
- (void)getMapAndVipCacheData {
    if (0 == self.mapArr.count) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary *dict = nil;
            NSData *data = [[NSData alloc] initWithContentsOfFile:[self cachePath]];
            if (data) {
                dict = data.mj_JSONObject;
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *mapKey = @"modules_list";
                    if([[dict allKeys] containsObject:mapKey]){
                        if ([[dict objectForKey:mapKey] isKindOfClass:[NSArray class]]) {
                            //映射
                            self.mapArr = [HKMyInfoMapPushModel mj_objectArrayWithKeyValuesArray:dict[mapKey]];
                        }
                    }
                    
                    NSString *vipKey = @"vip_info";
                    if([[dict allKeys] containsObject:vipKey]){
                        if ([[dict objectForKey:vipKey] isKindOfClass: [NSDictionary class]]) {
                            // VIP
                            HKMyInfoVipModel *vipM = [HKMyInfoVipModel mj_objectWithKeyValues:dict[vipKey]];
                            self.vipModel = vipM;
                        }
                    }
                    
                    NSString *serviceKey = @"service_info";
                    if([[dict allKeys] containsObject:serviceKey]){
                        if ([[dict objectForKey:@"service_info"] isKindOfClass: [NSDictionary class]]) {
                            //客服
                            self.serviceModel = [HKUserOtherInfoModel mj_objectWithKeyValues:dict[serviceKey]];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        });
    }
}




#pragma mark - UMpopView 友盟分享
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

#pragma makr <Server>
- (void)loadData{
    [HKHttpTool POST:@"/notice/tabs" parameters:nil success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            self.dataArray = [HKNotiTabModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tabs"]];
            int messageCount = 0;
            for (HKNotiTabModel * model in self.dataArray) {
                messageCount = messageCount + [model.unread intValue];
                
                if ([model.ID intValue] == 1 &&[model.unread intValue] > 0) {
                    [self postRedPointNoti:messageCount];
                    break;
                }else{
                    self.replyView.hidden = YES;
                }
            }
            
            for (HKMyInfoMapPushModel * model in self.mapArr) {
                if ([model.redirect_package.class_name isEqualToString:@"HKMessageCenterVC"]) {
                    model.icon_message = [NSString stringWithFormat:@"%d",messageCount];
                }
            }
            [self.collectionView reloadData];
        }else{
            [self.collectionView reloadData];
            self.replyView.hidden = YES;
        }
    } failure:^(NSError *error) {
        [self.collectionView reloadData];
    }];
}
@end






