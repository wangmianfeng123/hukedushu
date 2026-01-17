

//
//  HKLoginVC.m
//  Code
//
//  Created by Ivan li on 2018/7/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "LoginVC.h"
#import "HKLoginView.h"
#import "UserAagreementVC.h"
#import <UMShare/UMShare.h>
#import "HKPhoneLoginVC.h"
#import "BindPhoneVC.h"
#import "HKVerificationPhoneVC.h"
#import "HKLoginTool.h"
#import "HKWaterWaveView.h"
#import <OneLoginSDK/OneLoginSDK.h>
#import "HKVersionModel.h"
#import "HKNavigationController.h"
#import "HtmlShowVC.h"
#import "HKWechatLoginShareCallback.h"
#import "HKSocialLoginView.h"
#import "HKPhoneLoginViewModel.h"
#import "VideoPlayVC.h"
#import "AppDelegate.h"
#import "UIView+HKLayer.h"

@interface LoginVC ()<HKLoginViewDeletate,OneLoginDelegate,WXApiDelegate,UITextViewDelegate>
@property (nonatomic,strong) HKLoginView *loginView;
@property (nonatomic,strong) LOTAnimationView *animation;
@property (nonatomic,strong) UIImageView *oneLoginIV;
@property (nonatomic, strong) HKSocialLoginView *customView ;
@property (nonatomic, strong) UIButton * socialBtn;
@property (nonatomic , assign) BOOL checkBoxSelected ;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    //APP status 查询
    [CommonFunction checkAPPStatus];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [HKProgressHUD hideHUD];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}


- (void)createUI {
    
    self.view.backgroundColor = [UIColor clearColor];//[COLOR_000000 colorWithAlphaComponent:0.6];
    
    [self oneLoginconfing];
    
    self.loginView.loginViewType = self.loginViewType;
    
    [self.view addSubview:self.loginView];
    [self oneLoginUIConfig];
    
    //波浪
    if ( HKLoginViewType_Firstload == self.loginView.loginViewType) {
        [self setCloseBtn];
        self.loginView.kywaterView.waveSpeed = 0.5;
        self.loginView.kywaterView.waveAmplitude = 15;
        [self.loginView.kywaterView waveWithColor:[UIColor grayColor]];
        //动画
        [self.view addSubview:self.animation];
        [self.animation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.loginView.mas_top).offset(120);
            make.centerX.equalTo(self.loginView);
            make.size.mas_equalTo(CGSizeMake(470/2, 470/2));
        }];
    }
    
    self.loginView.hidden = YES;
    
    if (self.sender == nil || ![OneLogin isPreGettedTokenValidate]) {
        WeakSelf
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            if (sender && [sender isKindOfClass:[NSDictionary class]]) {
                weakSelf.sender = sender;
            }            // 自动点击手机登录
            [weakSelf.loginView.phoneLoginBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }];
    }else{
        // 自动点击手机登录
        [self.loginView.phoneLoginBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setLoginViewThemeType:(HKLoginViewThemeType)loginViewThemeType {
    _loginViewThemeType = loginViewThemeType;
}

-  (void)oneLoginUIConfig {
    
    [self.view addSubview:self.oneLoginIV];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(IS_IPHONE5S ?-PADDING_15 :-PADDING_25).priorityLow();
        make.left.equalTo(self.view).offset(IS_IPHONE5S ?PADDING_15 :PADDING_25).priorityLow();
        make.width.mas_lessThanOrEqualTo(IS_IPHONE5S ? 325-30 :660/2).priorityHigh();
        make.center.equalTo(self.view);
        if ( HKLoginViewType_Firstload == self.loginView.loginViewType) {
            make.height.mas_equalTo(680/2);//活动
        }else{
            CGFloat H = (1 == [HKInitConfigManger sharedInstance].configModel.registerGift) ?(680/2) :315;
            make.height.mas_equalTo(H); // 非礼包 315
        }
    }];
    
    if (1 == [HKInitConfigManger sharedInstance].configModel.registerGift) {
        [self.oneLoginIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.loginView.mas_top).offset(60);
            make.centerX.equalTo(self.loginView);
        }];
        NSString *text = @"注册领百元会员大礼包";
        [self.loginView setLoginText:text isShowLoginGift:YES];
    }
}




- (void)setCloseBtn {
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:imageName(@"login_close") forState:UIControlStateNormal];
    [closeBtn setImage:imageName(@"login_close") forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KNavBarHeight64);
        make.right.equalTo(self.view).offset(-PADDING_15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


/// 弹窗关闭按钮
- (void)closeBtnClick:(void (^ __nullable)(void))completion {
    [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:0];
    [self dismissViewControllerAnimated:YES completion:completion];
}


- (void)rightBarBtnAction:(HKUserModel *)model {
    
    @weakify(self);
    [OneLogin dismissAuthViewController:^{
        [self dismissViewControllerAnimated:YES completion:^{
            @strongify(self);
            [self loginSucess];
            if (isEmpty(model.phone)) {
                //5-分类限五vip 4-套餐vip 3-终身全站通 2-全站通VIP 1-分类无限VIP 0-非VIP  （-1 过期），
                NSInteger vipClass = [model.vip_class intValue];
                if (5 == vipClass || 4 == vipClass ||3 == vipClass ||2 == vipClass ||1 == vipClass) {
                    BindPhoneVC *VC = [BindPhoneVC new];
                    VC.bindPhoneType = HKBindPhoneType_VipUserBind;
                    VC.userInfoModel = model;
                    UIViewController *topVC = [self topViewController];
                    [topVC.navigationController pushViewController:VC animated:YES];
                }
            }
        }];
    }];
}


- (void)loginSucess {
    // 发送登录成功通知
    //HK_NOTIFICATION_POST(HKLoginSuccessNotification, nil);
    if (self.isFromSuspensionView) {
        HK_NOTIFICATION_POST_DICT(HKLoginSuccessNotification, nil, @{@"type":@(1)});
    }else{
        HK_NOTIFICATION_POST_DICT(HKLoginSuccessNotification, nil, @{@"type":@(0)});
    }
    [[HKVideoPlayAliYunConfig sharedInstance]setShowType:2];
}



- (LOTAnimationView*)animation {
    if (!_animation) {
        _animation = [LOTAnimationView animationNamed:@"hkGift_login"];
        _animation.loopAnimation = YES;
        [_animation playWithCompletion:^(BOOL animationFinished) {
            
        }];
    }
    return _animation;
}


- (HKLoginView*)loginView {
    if (!_loginView) {
        _loginView = [HKLoginView new];
        _loginView.delegate = self;
    }
    return _loginView;
}



- (UIImageView*)oneLoginIV {
    if (!_oneLoginIV) {
        _oneLoginIV = [UIImageView new];
        _oneLoginIV.image = imageName(@"bg_gift_v2_16");
    }
    return _oneLoginIV;
}


#pragma mark HKLoginViewDeletate
- (void)agreementBtnClickAction:(UIButton*)sender {
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    UIViewController * vc = [OneLogin currentAuthViewController];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc presentViewController:htmlShowVC animated:YES completion:nil];
}

- (void)privacyBtnClickAction:(UIButton*)sender {
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}

- (HKPhoneLoginVC*) phoneLoginVC{
    HKPhoneLoginVC *phoneLoginVC = [HKPhoneLoginVC new];
    phoneLoginVC.loginViewThemeType = self.loginViewThemeType;
    return  phoneLoginVC;
}

- (void)thirdPlatformLogin:(UIButton*)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 100:
        {
            if (IS_IPAD) {
                //pad 使用手机登录
                [self pushToOtherController:[self phoneLoginVC]];
            }else{
                if (HKLoginViewType_ordinary == self.loginViewType) {
                    if (1 == [HKInitConfigManger sharedInstance].configModel.oneLoginStatus) {
                        //极验登录
                        [self oneLoginAction:sender];
                    }else{
                        [self pushToOtherController:[self phoneLoginVC]];
                    }
                }else{
                    //手机登录
                    [self pushToOtherController:[self phoneLoginVC]];
                }
            }
        }
            break;
        case 102:
        {   //QQ
            [MobClick event:UM_RECORD_LOGIN_QQ];
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ currentViewController:self];
        }
            break;
        case 104:
        {   //微信
            [MobClick event:UM_RECORD_LOGIN_WECHAT];
            [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession currentViewController:self];
        }
            break;
        case 106:
        {   //新浪
            [self getUserInfoForPlatform:UMSocialPlatformType_Sina currentViewController:self];
        }
            break;
    }
}


- (void)hkLoginView:(HKLoginView*)view closeButton:(UIButton*)btn {
    
    [self closeBtnClick:nil];
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
         currentViewController:(UIViewController*)currentViewController {
    
    @weakify(self);
    [HKProgressHUD showEnabledHUDStatus:LMBProgressHUDStatusWaitting text:@"登录中..."];
    [AppDelegate sharedAppDelegate].showLoadMessage = YES;
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[HKPhoneLoginViewModel signalUMSocialLoginForPlatform:platformType currentViewController:currentViewController]subscribeNext:^(FWServiceResponse *response) {
                @strongify(self);
                if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                    //[HKLoginTool saveLastLoginPattern:clientType];
                    HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
                    [self loginActionWithModel:model];
                }else{
                    showTipDialog(response.msg);
                }
            } error:^(NSError * _Nullable error) {
    
            }];
        });
    }
}

#pragma mark - 登录成功
- (void)loginSucessWithModel:(HKUserModel *)model {
    if (!isEmpty(model.access_token)) {
        // 保存账号
        userDefaultsWithModel(model);
        //统计登录人数
        [CommonFunction recordUserLoginCount];
        
        showTipDialog(@"登录成功");
        //友盟用于记录 新增用户
        [MobClick profileSignInWithPUID:model.ID];
        [self rightBarBtnAction:model];
    }
}



#pragma mark - 根据 out_line 进行界面跳转
- (void)loginActionWithModel:(HKUserModel *)model {
    //out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录  5-强制绑定手机号
    NSInteger outLine = [model.out_line intValue];
    
    switch (outLine) {
        case 1:
        {   //登录成功
            [self loginSucessWithModel:model];
        }
            break;
            
        case 2:
        {
            @weakify(self);
            [self dismissAuthVC:^{
                @strongify(self);
                HKVerificationPhoneVC *VC = [HKVerificationPhoneVC new];
                VC.userInfoModel = model;
                UIViewController *topVC = [self topViewController];
                [[HKH5PushToNative class]pushOrPresentController:topVC instance:VC];
            }];
        }
            break;
            
        case 3:
        {
            @weakify(self);
            [self dismissAuthVC:^{
                @strongify(self);
                BindPhoneVC *VC = [BindPhoneVC new];
                VC.bindPhoneType = HKBindPhoneType_Limit;
                VC.userInfoModel = model;
                UIViewController *topVC = [self topViewController];
                [[HKH5PushToNative class]pushOrPresentController:topVC instance:VC];
            }];
        }
            break;
            
        case 4:
        {
            [HKLoginTool forbidLoginWithContent:LIMIT_TOO_MANY_LOGIN];
        }
            break;
            
        case 5:
        {
            
            @weakify(self);
            [self dismissAuthVC:^{
                @strongify(self);
                BindPhoneVC *VC = [BindPhoneVC new];
                VC.bindPhoneType = HKBindPhoneType_ForceBind;
                VC.userInfoModel = model;
                UIViewController *topVC = [self topViewController];
                [[HKH5PushToNative class]pushOrPresentController:topVC instance:VC];
            }];
        }
            break;
    }
}




#pragma mark - 极验登陆
- (void)oneLoginconfing {
    [OneLogin setDelegate:self];
}


- (void)oneLoginAction:(UIButton*)btn {
    
    btn.enabled = NO;
    @weakify(self);
    if ([OneLogin isPreGettedTokenValidate]) {
        // 预取号成功
        [OneLogin requestTokenWithViewController:self.navigationController viewModel:[self oneLoginViewModel] completion:^(NSDictionary * _Nullable result) {
            @strongify(self);
            [self finishRequestingToken:result];
        }];
    } else {
        @strongify(self);
        btn.enabled = YES;
        
        NSNumber *status ;
        if ([self.sender isKindOfClass:[NSDictionary class]]) {
            status = [self.sender objectForKey:@"status"];
        }
        
        if (status && [@(200) isEqualToNumber:status]) {
            // 预取号成功
            [OneLogin requestTokenWithViewController:self.navigationController viewModel:[self oneLoginViewModel] completion:^(NSDictionary * _Nullable result) {
                [self finishRequestingToken:result];
            }];
            
        } else {
            NSString * errCode;
            NSString * msg;
            if ([[self.sender  allKeys] containsObject:@"errorCode"] ) {
                errCode = [self.sender  objectForKey:@"errorCode"];
            }
            
            if ([self.sender isKindOfClass:[NSDictionary class]]) {
                NSString *desc = [self.sender description];
                msg = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
            }
            [[HKALIYunLogManage sharedInstance] hkErrorLogWithCode:errCode message:msg];
            
            // 预取号失败
            if ([@"-20101" isEqualToString:errCode]) {
                // 未配置 AppID，请通过 registerWithAppID: 配置 AppID
                [self pushToOtherController:[self phoneLoginVC]];
            }
            else if ([@"-20102" isEqualToString:errCode]) {
                // 重复调用 preGetTokenWithCompletion:
                //[self closeBtnClick:nil];
                [self pushToOtherController:[self phoneLoginVC]];
            }
            else if ([@"-20202" isEqualToString:errCode]) {
                // 检测到未开启蜂窝网络
                [self pushToOtherController:[self phoneLoginVC]];
            }
            else if ([@"-20203" isEqualToString:errCode]) {
                // 不支持的运营商类型
                [self pushToOtherController:[self phoneLoginVC]];
            }
            else {
                // 其他错误类型
                [self pushToOtherController:[self phoneLoginVC]];
            }
        }
    }
}



- (OLAuthViewModel *)oneLoginViewModel {
    
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    viewModel.backgroundImage = nil;
    viewModel.landscapeBackgroundImage = nil;
    
    // -------------- 导航栏设置 -------------------
    
    viewModel.backgroundColor = COLOR_FFFFFF_3D4752;
    viewModel.naviBgColor = COLOR_FFFFFF_3D4752;
    UIImage *naviBackImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    viewModel.naviBackImage = naviBackImage;
    //viewModel.naviTitle = @"登录即享每天一课免费学";
    viewModel.backButtonHidden = NO;
    OLRect backButtonRect = {0, 0, 0, 0, 0, 0, {0, 0}}; // 返回按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.backButtonRect = backButtonRect;
    viewModel.closePopupTopOffset = @(15);
    viewModel.closePopupRightOffset = @(-20);
    viewModel.naviHidden = YES;
    
    // -------------- logo设置 -------------------
    viewModel.appLogo = nil;  // 自定义logo图片
    OLRect logoRect = {0, 0, 0, 20, 0, 0, {0, 0}}; // logo偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置，logo大小默认为图片大小
    viewModel.logoRect = logoRect;
    viewModel.logoHidden = YES; // 是否隐藏logo，默认不隐藏
    
    // -------------- 手机号设置 -------------------
    viewModel.phoneNumColor = COLOR_27323F_EFEFF6;
    viewModel.phoneNumFont = HK_FONT_SYSTEM_BOLD(24);
    OLRect phoneNumRect = {70, 0, 0, 0, 0, 0, {0, 0}};  // 手机号偏移设置，手机号不支持设置宽高
    viewModel.phoneNumRect = phoneNumRect;
    
    // -------------- 切换账号设置 -------------------
    viewModel.switchButtonColor = COLOR_7B8196_A8ABBE;
    viewModel.switchButtonFont = HK_FONT_SYSTEM(14);
    
    viewModel.switchButtonText = @"其他手机号";
    OLRect switchButtonRect = {250, 0, 0, 0, 0, 0, {0, 0}};  // 切换按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.switchButtonRect = switchButtonRect;
    
    // -------------- 授权登录按钮设置 -------------------
    UIImage *image = self.authButtonImage;
    viewModel.authButtonImages = @[image,image,image];
    
    viewModel.authButtonCornerRadius = 22.5;
    viewModel.authButtonTitle = [[NSAttributedString alloc] initWithString:@"本机号码一键登录"
                                                                attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
                                                                             NSFontAttributeName : HK_FONT_SYSTEM_BOLD(17)
                                                                           }];
    CGFloat btn_W = (SCREEN_WIDTH >325) ?280 :250;
    OLRect authButtonRect = {160, 0, 0, 0, 0, 0, {btn_W, 45}};  // 授权按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.authButtonRect = authButtonRect;
    
    // -------------- slogan设置 -------------------
    viewModel.sloganTextColor = [UIColor hkdm_colorWithColorLight:[UIColor colorWithHexString:@"#43AE50"] dark:COLOR_A8AFB8];
    viewModel.sloganTextFont = HK_FONT_SYSTEM(12);
    OLRect sloganRect = {213 - 100, 0, 0, 0, 0, 0, {0, 0}};  // slogan偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.sloganRect = sloganRect;
    
    // -------------- 服务条款设置 -------------------
    viewModel.defaultCheckBoxState = NO; // 是否默认选择同意服务条款，默认同意
    
    UIImage *checkedImage = [UIImage hkdm_imageWithNameLight:@"ic_agreement_sel_2_36" darkImageName:@"ic_agreement_sel_dark_2_36"];
    viewModel.checkedImage = checkedImage; // 复选框选中状态图片
    
    UIImage *uncheckedImage = [UIImage hkdm_imageWithNameLight:@"ic_agreement_2_36" darkImageName:@"ic_agreement_dark_2_36"];
    viewModel.uncheckedImage = uncheckedImage; // 复选框未选中状态图片
    viewModel.checkBoxSize = CGSizeMake(24, 50); // 复选框尺寸，默认为12*12
    WeakSelf
    viewModel.hintBlock = ^{
        [weakSelf  showAlertWithType:1];
    };
    // 隐私条款文字属性
    
    //默认为@[@"登录即同意", @"和", @"、", @"并使用本机号码登录"]
    //viewModel.auxiliaryPrivacyWords = @[@"登录即同意", @"和", @" ", @"并授权虎课网获取本机号码"];
    //我已阅读并同意《虎课网用户协议》《隐私协议》
    viewModel.auxiliaryPrivacyWords = @[@"我已阅读并同意", @"", @"", @""];
    UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_A8AFB8 dark:COLOR_7B8196];
    viewModel.termTextColor = textColor;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.33;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.paragraphSpacing = 0.0;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.firstLineHeadIndent = 0.0;
    viewModel.privacyTermsAttributes = @{
        NSForegroundColorAttributeName : textColor,
        NSParagraphStyleAttributeName : paragraphStyle,
        NSFontAttributeName : HK_FONT_SYSTEM(12)
    };
    // 额外自定义服务条款，注意index属性，默认的index为0，SDK会根据index对多条服务条款升序排列，假如想设置服务条款顺序为 自定义服务条款1 默认服务条款 自定义服务条款2，则，只需将自定义服务条款1的index设为-1，自定义服务条款2的index设为1即可
    
    //登录即同意 《中国移动认证服务条款》和《虎课用户协议》 并授权虎课网获取本机号码
    
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
    NSString *webUrl2 = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
    
    //NSString *webUrl = [[NSBundle mainBundle] pathForResource:@"zhuce_http" ofType:@"html"];
    //[NSURL fileURLWithPath:webUrl]
    OLPrivacyTermItem *item1 = [[OLPrivacyTermItem alloc] initWithTitle:@"《虎课用户协议》"
                                                                linkURL:HKURL(webUrl)
                                                                  index:0];
    
    OLPrivacyTermItem *item2 = [[OLPrivacyTermItem alloc] initWithTitle:@"《隐私协议》"
                                                                linkURL:HKURL(webUrl2)
                                                                  index:0];
    
    viewModel.additionalPrivacyTerms = @[item1,item2];
    CGFloat term_W = (SCREEN_WIDTH >325) ?330 :300;
    OLRect termsRect = {295, 0, 25, 0, 0, 0, {term_W -50, 0}};  // 服务条款偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.termsRect = termsRect;
    
    // -------------- 服务条款H5页面导航栏设置 -------------------
    viewModel.webNaviTitle = [[NSAttributedString alloc] initWithString:@"虎课用户注册协议"
                                                             attributes:@{NSForegroundColorAttributeName : COLOR_27323F_EFEFF6,
                                                                          NSFontAttributeName : [UIFont boldSystemFontOfSize:17]
                                                                        }];
    viewModel.webNaviBgColor = COLOR_FFFFFF_3D4752; // 服务条款导航栏背景色
    viewModel.webNaviHidden = NO;   // 服务条款导航栏是否隐藏
    
    // -------------- 授权页面支持的横竖屏设置 -------------------
    viewModel.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    
    // ------------- 弹窗设置 -------------------
    viewModel.isPopup =  YES;
    CGFloat H = 415;
    CGFloat Y = (SCREEN_HEIGHT - H)/2;
    CGFloat W = (SCREEN_WIDTH >325) ?330 :300;
    CGFloat left = (SCREEN_WIDTH - W)/2;
    OLRect viewRect = {Y, 0, left, 0, 0, 0, {W, H}};  // slogan偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.popupRect = viewRect;
    viewModel.popupCornerRadius = 5;
    viewModel.closePopupImage =  imageName(@"ic_close_v2_15");
    
    @weakify(self);
    viewModel.customUIHandler = ^(UIView * _Nonnull customAreaView) {
        
        UIImageView * loginedImgV = [[UIImageView alloc] init];
        //loginedImgV.backgroundColor = [UIColor redColor];
        loginedImgV.image = [UIImage imageNamed:@"toast_mobilelogin_2_33"];
        loginedImgV.frame = CGRectMake(240, 70-44 + 50 + 8 , 56, 28);//(240, 120 + 20 , 10, 50);
        [customAreaView addSubview:loginedImgV];
        NSInteger loginType = [self getLoginPath];
        if (loginType == 4) {
            loginedImgV.hidden = NO;
        }else{
            loginedImgV.hidden = YES;
        }
        
        HKSocialLoginView *customView = [[HKSocialLoginView alloc]initWithFrame:CGRectZero];
        
        customView.socialLoginViewType = HKSocialLoginViewType_oneLoginSdk;
        customView.frame =  CGRectMake(0, 280, W, 85);
        [customAreaView addSubview:customView];
        [customView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(customAreaView);
            make.height.mas_equalTo(@(80));
        }];
        customView.socialLoginBlock = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            [self socialphoneLoginAction:btn];
        };
        self.customView = customView;
        
        UIButton * socialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [socialBtn setBackgroundColor:COLOR_FFFFFF_3D4752];
        //[socialBtn setBackgroundColor:[UIColor brownColor]];
        [socialBtn setImage:imageName(@"home_my_follow_more") forState:UIControlStateNormal];
        [socialBtn setTitle:@"社交账号登录" forState:UIControlStateNormal];
        socialBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [socialBtn setTitleColor:[UIColor colorWithHexString:@"#A8ABBE"] forState:UIControlStateNormal];
        [socialBtn addTarget:self action:@selector(socialBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [socialBtn layoutButtonWithEdgeInsetsStyle:HKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [customAreaView addSubview:socialBtn];
        [socialBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(customAreaView);
            make.bottom.equalTo(customView).offset(-10);
            make.height.mas_equalTo(@(80));
        }];
        self.socialBtn = socialBtn;
        
        
        AppDelegate * delegate = [AppDelegate sharedAppDelegate];
        self.socialBtn.hidden = delegate.isFold ? NO : YES;
        
        customView.hidden = APPSTATUS ? YES : NO;
        socialBtn.hidden = APPSTATUS ? YES : NO;
        
        if (self.loginTxt.length == 0) {
            self.loginTxt = @"登录即享每天一课免费学";
        }
        UILabel *titleLB = [UILabel labelWithTitle:CGRectMake(0, -50, W, 30) title:self.loginTxt titleColor:COLOR_27323F_EFEFF6 titleFont:@"18" titleAligment:NSTextAlignmentCenter];
        titleLB.font = [UIFont boldSystemFontOfSize:18];
        [customAreaView addSubview:titleLB];
        [titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(customAreaView);
            make.top.equalTo(customAreaView).offset(IS_IPHONE_X ? -15 :10);
            make.height.mas_equalTo(@(30));
        }];
    };
    
    // -------------- 授权页面点击登录按钮之后的loading设置 -------------------
    viewModel.loadingViewBlock = ^(UIView * _Nonnull containerView) {
        
        UIActivityIndicatorViewStyle indicatorViewStyle = UIActivityIndicatorViewStyleGray;
        if (@available(iOS 13.0, *)) {
            indicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        }
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorViewStyle];
        [containerView addSubview:indicatorView];
        
        indicatorView.center = CGPointMake(containerView.width * 0.5, containerView.height * 0.5);
        [indicatorView startAnimating];
        NSLog(@"------");
    };
    viewModel.clickCheckboxBlock = ^(BOOL isChecked) {
        self.checkBoxSelected = isChecked;
    };
    
    return viewModel;
}

- (void)socialBtnClick{
    self.socialBtn.hidden = YES;
    [MobClick event:login_unfold];
}


- (void)socialphoneLoginAction:(UIButton*)btn {
    
    if (self.checkBoxSelected) {
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
    }else{
        
        NSInteger tag = btn.tag;
        
        UMSocialPlatformType PlatformType = 0;
        if (102 == tag) {
            // QQ
            [self  showAlertWithType:4];
        }else if(104 == tag) {
            // 微信
            [self  showAlertWithType:3];
        }else if(106 == tag) {
            // 微博
            [self  showAlertWithType:2];
        }
    }
}

- (UIImage *)authButtonImage {
    
    UIColor *color2 = [UIColor colorWithHexString:@"#FFB600"];
    UIColor *color1 = [UIColor colorWithHexString:@"#FFA300"];
    UIColor *color = [UIColor colorWithHexString:@"#FF8A00"];
    
    CGFloat btn_W = (SCREEN_WIDTH >325) ?280 :250;
    CGSize size = {btn_W, 45};
    UIImage *image = [[UIImage alloc]createImageWithSize:size gradientColors:@[(id)color,(id)color1,(id)color2] percentage:@[@(0.1),@(0.5),@(1)] gradientType:GradientFromLeftToRight];
    return image;
}


- (void)finishRequestingToken:(NSDictionary *)result {
    /**
     {
     appID = 8c01b4f5aaf233f37e63891bfa0c43b1;
     authcode = 8407;
     errorCode = 0;
     "expire_time" = 3580;
     gwAuth = 8407;
     msg = success;
     number = "181****1894";
     operatorType = CT;
     preGetTokenSuccessedTime = "1652950292.795645";
     "pre_token_time" = 596;
     processID = 0f00bfebf2a55426561c58bf6fe75845;
     status = 200;
     token = "CT__0__8c01b4f5aaf233f37e63891bfa0c43b1__2.7.3__0__nme9b806b7fcdd4824a2ac64c1a7f3aed8__NOTCUCC";
     }
     */
    
    if (result.count > 0 && result[@"status"] && 200 == [result[@"status"] integerValue]) {
        NSString *token = result[@"token"];
        NSString *appID = result[@"appID"];
        NSString *processID = result[@"processID"];
        NSString *authcode = result[@"authcode"];
        NSString *errorCode = result[@"errorCode"];
        
        [self validateTokenAndGetLoginInfo:token appID:appID processID:processID authcode:authcode];
        [[HKALIYunLogManage sharedInstance] hkErrorLogWithCode:errorCode message:processID];
    } else {
        //#warning 请处理获取token的错误, 更多错误码请参考错误码文档
        NSString * errCode;
        NSString * msg;
        if ([[result allKeys] containsObject:@"errorCode"] ) {
            errCode = [result objectForKey:@"errorCode"];
        }
        //        if ([[result allKeys] containsObject:@"msg"]) {
        //            msg   = [result objectForKey:@"msg"];
        //        }
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSString *desc = [result description];
            msg = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
        }
        
        [[HKALIYunLogManage sharedInstance] hkErrorLogWithCode:errCode message:msg];
        //NSString *msg       = [result objectForKey:@"msg"];
        //NSString *processID = [result objectForKey:@"processID"];
        //NSString *appID     = [result objectForKey:@"appID"];
        //NSString *operator  = [result objectForKey:@"operatorType"];
        
        //        // 获取网关token失败
        //        if ([@"-20103" isEqualToString:errCode]) {
        //            // 重复调用 requestTokenWithViewController:viewModel:completion:
        //        }
        //        else if ([@"-20202" isEqualToString:errCode]) {
        //            // 检测到未开启蜂窝网络
        //            showTipDialog(@"无可用网络");
        //            // 一键登录失败手动关闭授权页面
        //            //[OneLogin dismissAuthViewController:nil];
        //            [self userDidDismissAuthViewController];
        //            return;
        //        }
        //        else if ([@"-20203" isEqualToString:errCode]) {
        //            // 不支持的运营商类型
        //        }
        //        else if ([@"-20204" isEqualToString:errCode]) {
        //            // 未获取有效的 `accessCode`, 请确保先调用过 preGetTokenWithCompletion:
        //        }
        //        else if ([@"-20302" isEqualToString:errCode]) {
        //            // 用户点击了授权页面上的返回按钮, 授权页面将自动关闭
        //        }
        //        else if ([@"-20303" isEqualToString:errCode]) {
        //            // 用户点击了授权页面上的切换账号按钮, 授权页面不会自动给关闭。如需关闭,
        //            
        //        }
        //        else {
        //            // 其他错误类型
        //        }
        
        if ([@"-20202" isEqualToString:errCode]) {
            // 检测到未开启蜂窝网络
            showTipDialog(@"无可用网络");
        }else{
            showTipDialog([NSString stringWithFormat:@"%@",errCode]);
        }
        // 一键登录失败手动关闭授权页面
        [self userDidDismissAuthViewController];
    }
}



// 使用token获取用户的登录信息
- (void)validateTokenAndGetLoginInfo:(NSString *)token appID:(NSString *)appID processID:(NSString *)processID
                            authcode:(NSString*)authcode {
    // 根据用户自己接口构造
    if (isEmpty(token) || isEmpty(processID)) {
        return;
    }
    @weakify(self);
    NSDictionary *dict = @{@"token":token ,@"process_id":processID, @"authcode":authcode}; //极验处理ID 极验处理TOKEN
    [HKHttpTool POST:USER_PHONE_ONE_LOGIN parameters:dict success:^(id responseObject) {
        @strongify(self);
        [HKProgressHUD hideHUD];
        if (HKReponseOK) {
            HKUserModel *model = [HKUserModel mj_objectWithKeyValues:responseObject[@"data"]];
            [MobClick event:login_thisphone];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loginActionWithModel:model];
                [self dismissAuthVC:nil];
            });
            [HKLoginTool saveLastLoginPattern:@"4"];
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            if (!isEmpty(msg)) {
                showTipDialog(msg);
            }
        }
    } failure:^(NSError *error) {
        [HKProgressHUD hideHUD];
        showTipDialog(error.localizedDescription);
    }];
}




#pragma mark - OneLoginDelegate

/**
 用户点击了授权页面的"切换账户"按钮
 */
- (void)userDidSwitchAccount {
    
    @weakify(self);
    [OneLogin dismissAuthViewController:^{
        @strongify(self);
        [self pushToViewController:[self phoneLoginVC] animated:NO];
    }];
}

/**
 用户点击了授权页面的返回按钮
 */
- (void)userDidDismissAuthViewController {
    [self dismissAuthVC:nil];
}


/**
 关闭授权页面
 */
- (void)dismissAuthVC:(void (^ __nullable)(void))completion {
    @weakify(self);
    [OneLogin dismissAuthViewController:^{
        @strongify(self);
        [self closeBtnClick:completion];
    }];
}

- (NSInteger)getLoginPath{
    //登录方式 [0:手机 1:QQ,2:微信,3:微博 ]
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [defaults integerForKey:HK_LOGIN_TYPE];
    return type;
}



- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"protocol"] ) {
        
        NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
        HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
        HKNavigationController * nav = [[HKNavigationController alloc] initWithRootViewController:htmlShowVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [LEEAlert closeWithCompletionBlock:^{
            [[OneLogin currentAuthViewController] presentViewController:nav animated:YES completion:nil];
        }];
        
        return NO;
        
    }else if ([[URL scheme] isEqualToString:@"privacy"]){
        NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
        HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
        HKNavigationController * nav = [[HKNavigationController alloc] initWithRootViewController:htmlShowVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [LEEAlert closeWithCompletionBlock:^{
            [[OneLogin currentAuthViewController] presentViewController:nav animated:YES completion:nil];
        }];
        return NO;
    }
    return YES;
}

- (void)showAlertWithType:(int)type{
    
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf autoLoginWithType:type];
                });
            };
            
        })
        .LeeHeaderColor([UIColor whiteColor])
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
}

// 递归获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
            
        NSArray *subviews = [view subviews];
        if ([subviews count] == 0) return;
        for (UIView *subview in subviews) {
            if([subview isKindOfClass:[UIButton class]]){
                UIButton * btn = (UIButton *)subview;
                if(level == 1){
                    if([NSStringFromClass([btn class]) isEqualToString:@"OLCheckBox"]){
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                        self.checkBoxSelected = YES;
                        return;
                    }
                }else if (level == 2){
                    if([btn.titleLabel.text isEqualToString:@"本机号码一键登录"]){
                        [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                        return;
                    }
                }
            }
            // 打印子视图类名
            NSLog(@"%d: %@", level, subview.class);
            [self getSub:subview andLevel:level];
        }
}

- (void)autoLoginWithType:(int)type{//1手机号 2微博，3微信 , 4QQ
    UIViewController *vc = [CommonFunction topViewController];
    if([NSStringFromClass([vc class]) isEqualToString:@"OLAuthViewController"]){
        [self getSub:vc.view andLevel:1];//找到复选框
        if(type == 1){
            if([NSStringFromClass([vc class]) isEqualToString:@"OLAuthViewController"]){
                [self getSub:vc.view andLevel:2];//找到登录按钮
            }
        }else{
            UMSocialPlatformType PlatformType = 0;
            if (type == 4) {
                // QQ
                PlatformType = UMSocialPlatformType_QQ;
            }else if(type == 3) {
                // 微信
                PlatformType = UMSocialPlatformType_WechatSession;
            }else if(type == 2) {
                // 微博
                PlatformType = UMSocialPlatformType_Sina;
            }
            [self getUserInfoForPlatform:PlatformType currentViewController:self];
        }
    }
}
@end


