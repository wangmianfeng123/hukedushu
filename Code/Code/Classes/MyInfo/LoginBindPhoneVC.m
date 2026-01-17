//
//  LoginBindPhoneVC.m
//  Code
//
//  Created by Ivan li on 2017/9/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "LoginBindPhoneVC.h"
#import "LoginBindPhoneView.h"
#import "VerificationCodeButton.h"

@interface LoginBindPhoneVC ()<LoginBindPhoneDeletate>

@property(nonatomic,strong)LoginBindPhoneView  *loginBindPhoneView;

@end

@implementation LoginBindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)createUI {
    
    self.title = @"绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftBarButton];
    [self.view addSubview:self.loginBindPhoneView];
}



- (LoginBindPhoneView*)loginBindPhoneView {
    
    if (!_loginBindPhoneView) {
        _loginBindPhoneView = [[LoginBindPhoneView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _loginBindPhoneView.delegate = self;
    }
    return _loginBindPhoneView;
}


- (void)loginBindPhoneWithAuthcode:(id)sender {
    
    NSInteger tag = [(UIButton *)sender tag];
    
    if (20 == tag) {
        //绑定手机
        NSString *phone = _loginBindPhoneView.phoneTextField.text;
        NSString *authCode =  _loginBindPhoneView.authCodeTextField.text;
        if (isCorrectPhoneNo(phone) &&  !isEmpty(authCode)) {
            [self bindPhoneWithCode:authCode phone:phone token:[CommonFunction getUserToken]];
        }
        else{
            NSLog(@"填写的信息有误");
        }
    }
    else if(22 == tag){
        //获取验证码
        NSString *tempPhone =  _loginBindPhoneView.phoneTextField.text;
        if (isCorrectPhoneNo(tempPhone)) {
            [_loginBindPhoneView.getAuthCodeBtn startCountDown];
            [self getAuthCodeWithPhone:tempPhone];
        }
    }
}




#pragma mark - 获得验证码
- (void)getAuthCodeWithPhone:(NSString*)phone {
    // type:@"1" 绑定
    FWNetWorkServiceMediator *mange = [FWNetWorkServiceMediator sharedInstance];
    [mange getAuthCodeWithPhone:phone type:@"1" completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            showTipDialog(@"发送成功");
        }else{
            showTipDialog(response.msg);
        }
        
    } failBlock:^(NSError *error) {
        if (error.code >= 500) {
            showTipDialog(@"获取验证码失败");
        }
    }];
}


#pragma mark - 绑定手机号登录
- (void)bindPhoneWithCode:(NSString*)Code phone:(NSString *)phone  token:(NSString *)token {
    WeakSelf;
    UserInfoServiceMediator *mange = [UserInfoServiceMediator sharedInstance];
    [mange bingPhoneNum:phone token:token code:Code completion:^(FWServiceResponse *response) {
        
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
//            [[NSUserDefaults standardUserDefaults] setObject:phone forKey:LOGIN_PHONE];//记录绑定的手机号码
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [HKAccountTool shareAccount].phone = phone;
            showTipDialog(response.msg);
            //weakSelf.bindPhoneBlock();
            // 发出通知刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:HKPresentVCRefreshNotification object:nil];
            //绑定手机
            [[NSNotificationCenter defaultCenter] postNotificationName:HKBindPhoneNumNotification object:nil];
            [weakSelf backAction];
        }else{
            showTipDialog(response.msg);
        }
        
    } failBlock:^(NSError *error) {
        showTipDialog(error.localizedDescription);
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
