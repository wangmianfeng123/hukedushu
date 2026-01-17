//
//  HKStudyNewVC.m
//  Code
//
//  Created by eon Z on 2021/11/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKStudyNewVC.h"
#import "HKStudyMenuVC.h"
#import "OtherSetUpCell2.h"
#import "HKMyLearningCenterModel.h"
#import "HKLearnCenterHeader.h"
#import "HkStudyCell.h"
#import "HKStudyDownloadCell.h"
#import "VideoPlayVC.h"
#import "HKJobPathCourseVC.h"
#import "LearnedVC.h"
#import "HKStudyLineChartVC.h"
#import "HKMyFollowVC.h"
#import "HKMyCollectionVC.h"
#import "HKCollectionAlbumVC.h"
#import "HKLearnCenterLoginView.h"
#import "HKAllLearnedVC.h"
#import "HKStudyCertificateVC.h"
#import "HKStudyTagVC.h"
#import "HKStudyTagSelectGuideView.h"
#import "UIView+SNFoundation.h"
//#import "HKLiveListVC.h"
#import "HKH5PushToNative.h"
#import "HtmlShowVC.h"
#import "HKMyInfoNotLoginCell.h"
#import "BannerModel.h"
#import "HKStudyLearnedMiddleCell.h"
#import "HKStudyHeaderCellModel.h"
#import "HKStudyHeaderCell.h"
#import "HKMyLikeShortVideoVC.h"
#import "HKALIYunLogManage.h"
#import "HKStudyInterestCell.h"
#import "HKDownloadManager.h"
#import "MyLoadingVC.h"
#import "HKStudyLoginView.h"
#import <UMShare/UMShare.h>
#import "HKWechatLoginShareCallback.h"
#import "HKPhoneLoginViewModel.h"
#import "HKVerificationPhoneVC.h"
#import "BindPhoneVC.h"
#import "HKPhoneLoginVC.h"
#import "HKAttentionTeacherCell.h"
#import "HKUpDateCourseCell.h"
#import "HKFollowTeacherModel.h"
#import "HKLiveCourseVC.h"
#import "HKTeacherCourseVC.h"
#import <OneLoginSDK/OneLoginSDK.h>
#import "LoginVC.h"

#import "HKNavigationController.h"
#import "WMMagicScrollView.h"
#import "HKDownLoadTabVC.h"
#import "HKPushNoticeVC.h"

@interface HKStudyNewVC ()<UITableViewDelegate,UITableViewDataSource,WXApiDelegate>
@property (nonatomic , assign) CGFloat kWMHeaderViewHeight ;
@property (nonatomic, copy) NSArray *viewcontrollers;
@property (nonatomic , strong) NSMutableArray * titleArray;
@property(nonatomic, strong)UITableView    *tableView;
@property (nonatomic,copy)NSString * defaultUserMotto;
@property (nonatomic,copy)NSString * motto;
@property (nonatomic,assign)BOOL isNewUser;
@property (nonatomic , strong) UILabel * txtLabel;
@property (nonatomic , strong) UIButton * noticeBtn;
@property (nonatomic , strong) HKAllLearnedVC * learnVC;
@property (nonatomic,assign)BOOL isChoose;
@end

@implementation HKStudyNewVC

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 推广渠道
    [self addStatusBar:COLOR_FFFFFF_3D4752];
    NSString * mottoTxt = [[NSUserDefaults standardUserDefaults] objectForKey:@"mottoTxt"];
    self.txtLabel.text = mottoTxt;
    
    if (isLogin()) {
        WeakSelf
        [HKHttpTool POST:@"/study/motto" parameters:nil success:^(id responseObject) {
            if (HKReponseOK) {
                weakSelf.defaultUserMotto = responseObject[@"data"][@"defaultUserMotto"];
                weakSelf.motto = responseObject[@"data"][@"motto"];
                weakSelf.isNewUser = [responseObject[@"data"][@"isNewUser"] boolValue];
                if (weakSelf.isNewUser) {
                    //新用户每天第一次展示defaultUserMotto
                    NSString * date = [DateChange getCurrentTime_day];
                    NSString * oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"showMotto"];
                    if ([oldDate isEqualToString:date]) {
                        self.txtLabel.text = weakSelf.motto;
                        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.motto forKey:@"mottoTxt"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        self.txtLabel.text = weakSelf.defaultUserMotto;
                        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"showMotto"];
                        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.defaultUserMotto forKey:@"mottoTxt"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }

                }else{
                    self.txtLabel.text = weakSelf.motto;
                    [[NSUserDefaults standardUserDefaults] setObject:weakSelf.motto forKey:@"mottoTxt"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        } failure:^(NSError *error) {

        }];
    }
}

#pragma mark - 添加StatusBar
static UIView *statusBar = nil;
- (void)addStatusBar:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        if(!statusBar) {
            statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
            statusBar.backgroundColor = color;
            [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
        }else{
            statusBar.backgroundColor = color;
        }
    }else{
        [self setStatusBarColor:color];
    }
}


- (void)setStatusBarColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    [self addStatusBar:[UIColor clearColor]];
    
    [statusBar removeFromSuperview];
    statusBar = nil;
}

- (UILabel *)txtLabel{
    if (_txtLabel == nil) {
        _txtLabel = [UILabel labelWithTitle:CGRectMake(55, STATUS_BAR_EH, SCREEN_WIDTH - 110, kHeight64) title:@"" titleColor:COLOR_27323F_EFEFF6 titleFont:@"18" titleAligment:NSTextAlignmentCenter];
        _txtLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _txtLabel;
}


-(UIButton *)noticeBtn{
    if (_noticeBtn == nil) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noticeBtn setImage:[UIImage hkdm_imageWithNameLight:@"ic_remind_2_40" darkImageName:@"ic_remind_dark_2_40"] forState:UIControlStateNormal];
        _noticeBtn.frame = CGRectMake(SCREEN_WIDTH - 50, STATUS_BAR_EH + (kHeight64 - 28)*0.5, 28, 28);
        [_noticeBtn addTarget:self action:@selector(noticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noticeBtn;
}

- (void)noticeBtnClick{
    [self pushToOtherController:[HKPushNoticeVC new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNotification];
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"我学过的",@"我下载的",@"我收藏的", nil];
    self.kWMHeaderViewHeight =  kHeight64 + STATUS_BAR_EH;
    [self createUI];
    [self.view addSubview:self.txtLabel];
    [self.view addSubview:self.noticeBtn];
    [self bringSubviewFrontOrBack];
}

- (void)goAllLearnedVC{
    self.selectIndex = 0;
    self.learnVC.selectIndex = 0;
}


- (void)prepareSetup {
    NSMutableArray *arrayVC = [NSMutableArray array];
    for (int i  = 0; i < self.titleArray.count; i++) {
        if (i == 0) {
            HKAllLearnedVC * learnVC = [HKAllLearnedVC new];
            [arrayVC addObject:learnVC];
            self.learnVC = learnVC;
        }else if (i == 1){
            HKDownLoadTabVC * downVC = [HKDownLoadTabVC new];
            [arrayVC addObject:downVC];
        }else{
            HKMyCollectionVC * collectionVC = [HKMyCollectionVC new];
            [arrayVC addObject:collectionVC];
        }
    }
    self.viewcontrollers = arrayVC;
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"我学过的",@"我下载的",@"我收藏的", nil];
    self.controllerType = WMStickyPageControllerType_videoDetail;
    self.menuItemWidth = 80;
    self.menuViewHeight = 40.0;
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.maximumHeaderViewHeight = self.kWMHeaderViewHeight;
    self.minimumHeaderViewHeight = STATUS_BAR_EH;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
    self.progressViewBottomSpace = 2;
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    self.bounces = NO;
    [self reloadData];
    WMMagicScrollView * contentView = (WMMagicScrollView *)self.view;
    contentView.bounces = NO;
}

- (void)dealloc {
    HK_NOTIFICATION_REMOVE();
}


- (void)setupNotification {
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, loginAndLoginOut);
    HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, loginAndLoginOut);
    HK_NOTIFICATION_ADD(HKPushAllLearnNotification, goAllLearnedVC);
}

- (void)bringSubviewFrontOrBack{
    if (NO == isLogin()) {
        [self.view bringSubviewToFront:self.tableView];
    }else{
        [self.view sendSubviewToBack:self.tableView];
    }
}

- (void)loginAndLoginOut{
    if ([HKAccountTool shareAccount]) {
        //刷新数据
        [self prepareSetup];
    }
    [self bringSubviewFrontOrBack];
    if (isLogin()) {
        WeakSelf
        [HKHttpTool POST:@"/study/motto" parameters:nil success:^(id responseObject) {
            if (HKReponseOK) {
                weakSelf.defaultUserMotto = responseObject[@"data"][@"defaultUserMotto"];
                weakSelf.motto = responseObject[@"data"][@"motto"];
                weakSelf.isNewUser = [responseObject[@"data"][@"isNewUser"] boolValue];
                if (weakSelf.isNewUser) {
                    //新用户每天第一次展示defaultUserMotto
                    NSString * date = [DateChange getCurrentTime_day];
                    NSString * oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"showMotto"];
                    if ([oldDate isEqualToString:date]) {
                        self.txtLabel.text = weakSelf.motto;
                    }else{
                        self.txtLabel.text = weakSelf.defaultUserMotto;
                        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"showMotto"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }else{
                    self.txtLabel.text = weakSelf.motto;
                }
            }
        } failure:^(NSError *error) {

        }];
    }
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
    
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleArray[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, self.maximumHeaderViewHeight+40, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_EH - 40 - KTabBarHeight49);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    menuView.hiddenSeparatorLine = YES;
    [menuView addShadowWithColor:COLOR_D2D6E4_27323F alpha:0.3 radius:5 offset:CGSizeMake(0, 6)];
    return CGRectMake(0, self.maximumHeaderViewHeight, SCREEN_WIDTH, 40);
}

- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex{
    if (index == 1) {
        [MobClick event: @"C1704001"];
    }else if (index == 2){
        [MobClick event: @"C1706001"];
    }
}


- (void)createUI {
    [self.view addSubview:self.tableView];
    [self prepareSetup];
    if (NO == isLogin()) {
        [self setStudyLogin];
    }
}

- (void)setStudyLogin {
    
    if ([OneLogin isPreGettedTokenValidate]) {
        LoginVC *loginVC = [LoginVC new];
        loginVC.loginViewThemeType = HKLoginViewThemeType_study;
        HKNavigationController *navigationController = [[HKNavigationController alloc]initWithRootViewController:loginVC];
        navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:navigationController animated:NO completion:nil];
        [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
    } else {
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            UIViewController *topVC = [CommonFunction topViewController];
            if ([topVC isKindOfClass:[HKStudyNewVC class]]) {
                if (NO == isLogin()) {
                    LoginVC *loginVC = [LoginVC new];
                    loginVC.sender = sender;
                    //loginVC.isFromStudy = YES;
                    loginVC.loginViewThemeType = HKLoginViewThemeType_study;
                    HKNavigationController *navigationController = [[HKNavigationController alloc]initWithRootViewController:loginVC];
                    navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [self presentViewController:navigationController animated:NO completion:nil];
                    [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
                }
                
            }
        }];
    }
    
    
}

- (UITableView*)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HKStudyLoginView class] forCellReuseIdentifier:NSStringFromClass([HKStudyLoginView class])];
        // 兼容iOS11
        HKAdjustsScrollViewInsetNever(self, _tableView);
        
        if (IS_IPHONE_X) {
            [_tableView setContentInset:UIEdgeInsetsMake(15, 0, KTabBarHeight49 + 20, 0)];
        } else {
            [_tableView setContentInset:UIEdgeInsetsMake(5, 0, KTabBarHeight49 + 20, 0)];
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_3C4651];
    }
    return _tableView;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.scrollEnabled = NO;
    @weakify(self);
    HKStudyLoginView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HKStudyLoginView class])];
    cell.registerBtnClickBlock = ^(UIButton *btn) {
        @strongify(self);
        [self setLoginVC];
        [MobClick event:@"C1702001"];
    };
    cell.isChose = self.isChoose;
//    cell.checkBoxClickBlock = ^(UIButton *btn) {
//        @strongify(self);
//        self.isChoose = btn.selected;
//    };
    cell.socialphoneLoginBlock = ^(UIButton *btn, UIButton *selectBtn) {
        @strongify(self);
        if (selectBtn.selected) {
            [self socialphoneLoginAction:btn];
        }else{
            [self showAlertWithBtn:btn];
        }
    };
    cell.privacyBtnClickBlock = ^(UIButton *privacyBtn) {
        @strongify(self);
        [self privacyBtnClick];
    };
    cell.agreementBtnClickBlock = ^(UIButton *agreementBtn) {
        @strongify(self);
        [self agreementBtnClick];
    };
    cell.otherPhoneBtnClickBlock = ^(UIButton *btn) {
        @strongify(self);
        [self pushToViewController:[HKPhoneLoginVC new] animated:YES];
    };
    return cell;
}

- (void)agreementBtnClick {

    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}


- (void)privacyBtnClick {
    
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}

- (void)socialphoneLoginAction:(UIButton*)btn {
    NSInteger tag = btn.tag;
    
    UMSocialPlatformType type = 0;
    if (102 == tag) {
        // QQ
        type = UMSocialPlatformType_QQ;
    }else if(104 == tag) {
        // 微信
        type = UMSocialPlatformType_WechatSession;
    }else if(106 == tag) {
        // 微博
        type = UMSocialPlatformType_Sina;
    }
    [self getUserInfoForPlatform:type currentViewController:self];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
         currentViewController:(UIViewController*)currentViewController {
    
    @weakify(self);
    //[HKProgressHUD showEnabledHUDStatus:LMBProgressHUDStatusWaitting text:@"登录中..."];
                
        if (platformType == UMSocialPlatformType_WechatSession) {
            // 微信登录 微信原生 SDK
            NSString * platType = @"2";
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            
            [WXApi sendReq:req completion:^(BOOL success) {
                
            }];
            
            [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = nil;
            [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = ^(NSDictionary * _Nonnull userInfoDict) {
                @strongify(self);
                if(![userInfoDict isKindOfClass:[NSDictionary class]]) {
                    [HKProgressHUD hideHUD];
                    showTipDialog(@"授权信息解析出错");
                    return;
                }
                NSString *name = isEmpty(userInfoDict[@"nickname"]) ? nil :userInfoDict[@"nickname"];
                NSString *iconurl = isEmpty(userInfoDict[@"headimgurl"]) ? nil :userInfoDict[@"headimgurl"];
                NSError * parseError;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:userInfoDict options:NSJSONWritingPrettyPrinted error:&parseError];
                   if (parseError) {
                     //解析出错
                    showTipDialog(@"授权信息解析出错");
                   }
                NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [[HKPhoneLoginViewModel signalLoginWithUnionId:userInfoDict[@"unionid"] name:name openid:userInfoDict[@"openid"] iconurl:iconurl clientType:platType registerType:platType jsonString:str] subscribeNext:^(FWServiceResponse *response) {
                    if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                        HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
                        [self loginActionWithModel:model];
                    }else{
                        showTipDialog(response.msg);
                    }
                } error:^(NSError * _Nullable error) {
                    
                }];
            };
            
            
        }else{
            [[HKPhoneLoginViewModel signalUMSocialLoginForPlatform:platformType currentViewController:currentViewController]subscribeNext:^(FWServiceResponse *response) {
                @strongify(self);
                if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                    HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
                    [self loginActionWithModel:model];
                }else{
                    showTipDialog(response.msg);
                    
                }
                
            } error:^(NSError * _Nullable error) {
                
            }];
        }
}

#pragma mark - 根据 out_line 进行界面跳转
- (void)loginActionWithModel:(HKUserModel *)model {
    //out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录
    NSInteger outLine = [model.out_line intValue];
    switch (outLine) {
        case 1:
        {   //登录成功
            [self loginSucessWithModel:model];
        }
            break;
            
        case 2:
        {
            HKVerificationPhoneVC *VC = [HKVerificationPhoneVC new];
            VC.userInfoModel = model;
            [self pushToOtherController:VC];
        }
            break;
            
        case 3:
        {
            BindPhoneVC *VC = [BindPhoneVC new];
            VC.bindPhoneType = HKBindPhoneType_Limit;
            VC.userInfoModel = model;
            [self pushToOtherController:VC];
        }
            break;
            
        case 4:
            [HKLoginTool forbidLoginWithContent:LIMIT_TOO_MANY_LOGIN];
            break;
            
        case 5:
        {
            BindPhoneVC *VC = [BindPhoneVC new];
            VC.bindPhoneType = HKBindPhoneType_ForceBind;
            VC.userInfoModel = model;
            [self pushToOtherController:VC];
        }
            break;
    }
}

#pragma mark - 登录成功
- (void)loginSucessWithModel:(HKUserModel *)model {
    if (!isEmpty(model.access_token)) {
        // 保存账号信息
        userDefaultsWithModel(model);
        showTipDialog(@"登录成功");
        //统计登录人数
        [CommonFunction recordUserLoginCount];
        // 发送登录成功通知
        HK_NOTIFICATION_POST(HKLoginSuccessNotification, nil);
    }
}

- (void)pushToOtherController:(UIViewController*)VC {
    [self pushToViewController:VC animated:YES];
}

- (void)pushToViewController:(UIViewController*)VC  animated:(BOOL)animated {
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:animated];
}

//// 夜间模式主题模式 发生改变
- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self reloadData];
    }
}

- (void)showAlertWithBtn:(UIButton *)btn{
    WeakSelf
        [LEEAlert alert].config
            .LeeAddTitle(^(UILabel *label) {
                label.text = @"用户协议与隐私条款";
                label.textColor = [UIColor blackColor];
                label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = @"为保障您的合法权益，请先阅读并同意《用户协议》、《隐私政策》未注册绑定的手机号验证成功后将自动注册";
                label.textColor = [UIColor blackColor];
                label.font = [UIFont systemFontOfSize:14.0];
                [UILabel changeLineSpaceForLabel:label WithSpace:3];
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeDefault;
                action.title = @"不同意";
                action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
                action.font = [UIFont systemFontOfSize:15.0];
                action.backgroundColor = [UIColor whiteColor];
                action.clickBlock = ^{
                    
                };
            })
            .LeeAddAction(^(LEEAction *action) {
                
                action.type = LEEActionTypeCancel;
                action.title = @"同意并登录";
                action.titleColor = [UIColor colorWithHexString:@"#0076FF"];
                action.backgroundColor = [UIColor whiteColor];
                action.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
                action.clickBlock = ^{
                    weakSelf.isChoose = YES;
                    [weakSelf.tableView reloadData];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf socialphoneLoginAction:btn];
                    });
                    
                };
                
            })
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
}
@end
