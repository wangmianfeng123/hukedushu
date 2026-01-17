//
//  RegistereVC.m
//  Code
//
//  Created by Ivan li on 2017/8/25.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPhoneLoginVC.h"
#import "RegistereView.h"
#import "VerificationCodeButton.h"
#import "UIBarButtonItem+Extension.h"
#import "UserAagreementVC.h"
#import "HKTextField.h"
#import "BindPhoneVC.h"
#import <UMShare/UMShare.h>
#import "HKLoginTool.h"
#import "HKVerificationPhoneVC.h"
#import "HKPhoneLoginViewModel.h"
#import "HKWechatLoginShareCallback.h"
#import "HKPhoneLoginVC+HK.h"
#import "HtmlShowVC.h"
#import "UIViewController+FullScreen.h"
#import "AppDelegate.h"

@interface HKPhoneLoginVC ()<RegisterVDeletate,UITabBarControllerDelegate,WXApiDelegate>

@property(nonatomic,strong)RegistereView    *registerView;

@property(nonatomic,copy)NSString  *authCode;

@end



@implementation HKPhoneLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 18.0, *)) {
        // 针对 iOS 18 及以上的特殊处理
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [HKProgressHUD hideHUD];
}

- (void)createUI {
    [self createLeftBarButton];
    [self.view addSubview:self.registerView];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    
    self.navigationPopGestureRecognizerEnabled = NO;
}

- (void)backAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (RegistereView*)registerView {
    
    if(!_registerView) {
        _registerView = [[RegistereView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT-KNavBarHeight64)];
        _registerView.loginViewThemeType = self.loginViewThemeType;
        _registerView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSeverTapGestureAction:)];
        tap.numberOfTouchesRequired = 2;
        [_registerView addGestureRecognizer:tap];
        @weakify(self);
        _registerView.socialphoneLoginBlock = ^(UIButton *btn, UIButton *selectBtn) {
            @strongify(self);
            if (selectBtn.selected) {
                [self socialphoneLoginAction:btn];
            }else{
                //showTipDialog(ONE_LOGIN_MSG);
                [self showAlertWithBtn:btn];
            }
        };
        _registerView.agreementBtnClickBlock = ^(UIButton *agreementBtn) {
            @strongify(self);
            [self agreementBtnClick];
        };
        
        _registerView.privacyBtnClickBlock = ^(UIButton *privacyBtn) {
            @strongify(self);
            [self privacyBtnClick];
        };
    }
    return _registerView;
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
    [HKProgressHUD showEnabledHUDStatus:LMBProgressHUDStatusWaitting text:@"登录中..."];
    [AppDelegate sharedAppDelegate].showLoadMessage = YES;
    if (platformType == UMSocialPlatformType_WechatSession) {
        // 微信登录 微信原生 SDK
        NSString * platType = @"2";
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        
        [WXApi sendReq:req completion:^(BOOL success) {
            NSLog(@"====%d",success);
        }];
        
        [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = nil;
        [HKWechatLoginShareCallback sharedInstance].wechatLoginCallback = ^(NSDictionary * _Nonnull userInfoDict) {
            @strongify(self);
            NSString *name = isEmpty(userInfoDict[@"nickname"]) ? nil :userInfoDict[@"nickname"];
            NSString *openid = isEmpty(userInfoDict[@"openid"]) ? nil :userInfoDict[@"openid"];
            NSString *unionid = isEmpty(userInfoDict[@"unionid"]) ? nil :userInfoDict[@"unionid"];
            NSString *iconurl = isEmpty(userInfoDict[@"headimgurl"]) ? nil :userInfoDict[@"headimgurl"];
            NSError * parseError;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:userInfoDict options:NSJSONWritingPrettyPrinted error:&parseError];
            if (parseError) {
                //解析出错
                showTipDialog(@"授权信息解析出错");
            }
            NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[HKPhoneLoginViewModel signalLoginWithUnionId:unionid name:name openid:openid iconurl:iconurl clientType:platType registerType:platType jsonString:str] subscribeNext:^(FWServiceResponse *response) {
                if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
                    HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
                    [self loginActionWithModel:model];
                }else{
                    showTipDialog(response.msg);
                }
            } error:^(NSError * _Nullable error) {
                NSLog(@"%@====%@====%ld",error.domain,error.userInfo,(long)error.code);
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

#pragma mark 注册 验证码代理

- (void)registerWithAuthcode:(id)sender {
    UIButton * btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    if (20 == tag) {
        if (!btn.selected) {
            [self showAlertWithBtn:nil];
        }else{
            // 登录
            [self phoneLogin];
        }
    }
    else if(22 == tag){
        // 获取短信验证码
        [self getAuthCode];
    }else if(24 == tag){
        UserAagreementVC  *VC = [UserAagreementVC new];
        [self pushToOtherController:VC];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 手机号登录
- (void)phoneLogin  {
    
    // 手机号，短信验证码
    NSString *phone =  [self.registerView phoneText];
    NSString *authCode = [self.registerView authCodeText];
    // 注册登录，验证手机号码和图形验证码
    BOOL isPhone = isCorrectPhoneNo(phone);
    BOOL isPicCode = [_registerView isPicCorrect];
    BOOL isAuthCode = !isEmpty(authCode);
    
    if (NO == isPhone) {
        return;
    }
    
    if (NO == isPicCode) {
        // 图形验证码错误
        showTipDialog(@"请输入正确的图形验证码");
        return;
    }
    
    if (NO == isAuthCode) {
        showTipDialog(@"短信验证码不能为空");
        return;
    }
    [MobClick event:UM_RECORD_LOGIN_PHONE];
    // 全部正确
    [self loginWithCode:authCode phone:phone];
}



//获取验证码
- (void)getAuthCode {
    NSString *phone = [self.registerView phoneText];
    BOOL isPhone = isCorrectPhoneNo(phone);
    if (NO == isPhone) {
        return;
    }
    
    [self.registerView.getAuthCodeBtn startCountDown];
    [self getAuthCodeWithPhone:phone];
}



#pragma mark - 获得验证码
- (void)getAuthCodeWithPhone:(NSString*)phone {
    
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange getAuthCodeWithPhone:phone type:@"2" completion:^(FWServiceResponse *response) {
        
        showTipDialog(response.msg);
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
        }else{
            // 错误停止倒数
            [self.registerView.getAuthCodeBtn stopCountDown];
        }
    } failBlock:^(NSError *error) {
        showTipDialog(error.localizedDescription);
        // 错误停止倒数
        [self.registerView.getAuthCodeBtn stopCountDown];
    }];
}



#pragma mark - 验证码 登录
- (void)loginWithCode:(NSString*)Code phone:(NSString *)phone {
    
    //vip_class：5-分类限五vip 4-套餐vip 3-终身全站通 2-全站通VIP 1-分类无限VIP 0-非VIP，
    //out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录
    WeakSelf;
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange loginWithAuthCode:Code phone:phone completion:^(FWServiceResponse *response) {
        
        StrongSelf;
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            [HKLoginTool saveLastLoginPattern:@"4"];
            HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
            [strongSelf loginActionWithModel:model];
        }else{
            showTipDialog(response.msg);
        }
        
    } failBlock:^(NSError *error) {
        
    }];
}


#pragma mark - 登录成功
- (void)loginSucessWithModel:(HKUserModel *)model {
    if (!isEmpty(model.access_token)) {
        // 保存账号信息
        userDefaultsWithModel(model);
        showTipDialog(@"登录成功");
        //统计登录人数
        [CommonFunction recordUserLoginCount];
        [[HKVideoPlayAliYunConfig sharedInstance]setShowType:2];
        [HKLoginTool pushToBeforeVC:self];
    }
}


#pragma mark - 根据 out_line 进行界面跳转
- (void)loginActionWithModel:(HKUserModel *)model {
    //out_line：1-正常登陆 2-验证绑定的手机 3-请绑定手机号码 4-今天登录太频繁，已限制登录 5 -强制绑定手机号
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
                    weakSelf.registerView.selectBtn.selected = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(btn){
                            [weakSelf socialphoneLoginAction:btn];
                        }else{
                            [self phoneLogin];
                        }
                    });
                    
                };
                
            })
            .LeeHeaderColor([UIColor whiteColor])
            .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
            .LeeShow();
}
@end


