//
//  HKVerificationPhoneVC.m
//  Code
//
//  Created by Ivan li on 2018/7/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKVerificationPhoneVC.h"
#import "HKVerificationPhoneView.h"
#import "HKTextField.h"
#import "VerificationCodeButton.h"
#import "UIBarButtonItem+Extension.h"


@interface HKVerificationPhoneVC ()<HKVerificationPhoneViewDeletate>

@property(nonatomic,strong)HKVerificationPhoneView    *verificationPhoneView;

@end


@implementation HKVerificationPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarButton];
    self.title = @"验证手机号";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self.view addSubview:self.verificationPhoneView];
    [self.verificationPhoneView setWarnWithText:TOO_MANY_LOGIN phone:self.userInfoModel.phone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUserInfoModel:(HKUserModel *)userInfoModel {
    _userInfoModel = userInfoModel;
}


- (void)backAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)createLeftBarButton {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:nil
                                                                          highBackgroudImageName:nil
                                                                                          target:self
                                                                                          action:nil];
}



- (HKVerificationPhoneView*)verificationPhoneView {
    
    if(!_verificationPhoneView){
        _verificationPhoneView = [[HKVerificationPhoneView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _verificationPhoneView.delegate = self;
    }
    return _verificationPhoneView;
}



#pragma mark 绑定手机号  验证码代理
- (void)verificationPhone:(HKVerificationPhoneView *)view sender:(UIButton *)sender {
    
    NSString *phone = self.userInfoModel.phone;
    NSInteger tag = [sender tag];
    if (20 == tag) {
        //验证登录
        NSString *authCode =  view.authCodeTextField.text;
        if (!isEmpty(authCode) && !isEmpty(phone)) {
            
            [self loginWithCode:authCode phone:phone];
        }
    }else if(22 == tag){
        //验证码
        if (!isEmpty(phone)) {
            [view.getAuthCodeBtn startCountDown];
            [self getAuthCodeWithPhone:phone];
        }
    }
}



#pragma mark - 获得验证码
- (void)getAuthCodeWithPhone:(NSString*)phone {
    // type:@"1" 1-绑定手机号 2-(1-注册 2-验证手机号)
    [[FWNetWorkServiceMediator sharedInstance] getAuthCodeWithPhone:phone type:@"2" completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
        }
        showTipDialog(response.msg);
    } failBlock:^(NSError *error) {
        if (error.code >= 500) {
            showTipDialog(@"获取验证码失败");
        }
    }];
}





#pragma mark - 验证手机号登录
- (void)loginWithCode:(NSString*)code phone:(NSString *)phone {
    WeakSelf;
    [[FWNetWorkServiceMediator sharedInstance]loginWithAuthCode:code phone:phone completion:^(FWServiceResponse *response) {
        
        StrongSelf;
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            [HKLoginTool saveLastLoginPattern:@"4"];
            HKUserModel *model = [HKUserModel mj_objectWithKeyValues:response.data];
            if (!isEmpty(model.access_token)) {
                // 保存账号信息
                userDefaultsWithModel(model);
                // 发送登录通知
                [HKLoginTool pushToBeforeVC:strongSelf];
            }
        }
        showTipDialog(response.msg);
    
    } failBlock:^(NSError *error) {
        showTipDialog(error.localizedDescription);
    }];
}


@end





