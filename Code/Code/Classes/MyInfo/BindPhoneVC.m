//
//  BindPhoneVC.m
//  Code
//
//  Created by Ivan li on 2017/9/1.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "BindPhoneVC.h"
#import "VerificationCodeButton.h"
#import "UserInfoRecord.h"
#import "UIBarButtonItem+Extension.h"
#import "UserAagreementVC.h"
#import "UserInfoServiceMediator.h"
#import "BindPhoneView.h"

#import "HKTextField.h"
#import "MyInfoViewController.h"
#import "AppDelegate.h"
#import "CYLTabBarController.h"



@interface BindPhoneVC ()<RegisterVDeletate>

@property(nonatomic,strong)BindPhoneView    *bindPhoneView;

@end

@implementation BindPhoneVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUserInfoModel:(HKUserModel *)userInfoModel {
    _userInfoModel = userInfoModel;
}


- (void)setBindPhoneType:(HKBindPhoneType)bindPhoneType {
    _bindPhoneType = bindPhoneType;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (HKBindPhoneType_VipUserBind == self.bindPhoneType || HKBindPhoneType_VipBuySucess_UserBind== self.bindPhoneType) {
        // 禁止侧滑返回
        self.navigationController.isPopGestureRecognizerEnable = NO;
    }
}


- (void)createUI {
    
    self.title = @"绑定手机号";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    [self createLeftBarButton];
    [self.view addSubview:self.bindPhoneView];
    if (HKBindPhoneType_VipUserBind == self.bindPhoneType || HKBindPhoneType_VipBuySucess_UserBind== self.bindPhoneType) {
        // 隐藏返回按钮
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
        [self rightBarButtonItemWithTitle:@"跳过" color:COLOR_27323F_EFEFF6 action:@selector(jumpAction)];
    }
}



- (void)jumpAction {
    if (HKBindPhoneType_VipBuySucess_UserBind== self.bindPhoneType) {
        [self popViewController];
    }else{
        [self backAction];
    }
}



- (void)backAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}


- (void)popViewController {
    UINavigationController *navigationVC = self.navigationController;
    MyInfoViewController *myInfoVC = nil;
    for (UIViewController *viewControllView in navigationVC.viewControllers) {
        // 从视频详情页过来的
        if ([viewControllView isKindOfClass:[MyInfoViewController class]]) {
            myInfoVC = (MyInfoViewController *)viewControllView;
            break;
        }
    }
    if (myInfoVC) {// 退到个人主页
        [navigationVC popToViewController:myInfoVC animated:YES];
    }else {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
            //[self popFourTab];
        }
    }
}



///选中 tabbar
- (void)popFourTab {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
            UIViewController *tabViewController = appDelegate.window.rootViewController;
            NSInteger count = tabViewController.childViewControllers.count;
        
            if ([tabViewController isKindOfClass:[CYLTabBarController class]]) {
                [(CYLTabBarController*)tabViewController setSelectedIndex:count-1];
            }else if ([tabViewController isKindOfClass:[UITabBarController class]]) {
                [(UITabBarController *)tabViewController setSelectedIndex:count-1];
            }
    });
}






- (BindPhoneView*)bindPhoneView {
    
    if(!_bindPhoneView){
        _bindPhoneView = [[BindPhoneView alloc]initWithFrame:CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bindPhoneView.delegate = self;
        _bindPhoneView.bindPhoneType = self.bindPhoneType;
    }
    return _bindPhoneView;
}




#pragma mark BindPhoneView  delegate
- (void)registerWithAuthcode:(id)sender {
    
    NSInteger tag = [(UIButton *)sender tag];
    
    if (20 == tag) {
        NSString *phone = _bindPhoneView.phoneTextField.text;
        NSString *authCode =  _bindPhoneView.authCodeTextField.text;
        if (isCorrectPhoneNo(phone) &&  !isEmpty(authCode)) {
            //NSLog(@"验证通过了");
            [self bindPhoneWithCode:authCode phone:phone token:self.userInfoModel.access_token];
        }
    }
    else if(22 == tag){
        //获取验证码
        NSString *tempPhone =  _bindPhoneView.phoneTextField.text;
        BOOL bTrue = isCorrectPhoneNo(_bindPhoneView.phoneTextField.text);
        if (bTrue) {
            [_bindPhoneView.getAuthCodeBtn startCountDown];
            [self getAuthCodeWithPhone:tempPhone];
        }
    }else if(24 == tag){
        UserAagreementVC  *VC = [UserAagreementVC new];
        [self pushToOtherController:VC];
        
    }else{
        //登录
        [self setTabBarByModel:self.userInfoModel];
    }
}



#pragma mark - 获得验证码
- (void)getAuthCodeWithPhone:(NSString*)phone {
    // type:@"1" 1-绑定手机号 2-注册
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
    [MobClick event:UM_RECORD_PERSONAL_BINDPHONE];
    @weakify(self);
    [[UserInfoServiceMediator sharedInstance] bingPhoneNum:phone token:token code:Code completion:^(FWServiceResponse *response) {
        @strongify(self);
        if ([response.code isEqualToString:SERVICE_RESPONSE_OK]) {
            
            if (HKBindPhoneType_Limit == self.bindPhoneType || HKBindPhoneType_ForceBind == self.bindPhoneType) {
                HKUserModel *model = self.userInfoModel;
                model.phone = phone;
                [self setTabBarByModel:model];
                
            }else{
                [HKAccountTool shareAccount].phone = phone;
                self.bindPhoneBlock ?self.bindPhoneBlock(phone) :nil;
                // 发出通知刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:HKPresentVCRefreshNotification object:nil];
                //绑定手机
                [[NSNotificationCenter defaultCenter] postNotificationName:HKBindPhoneNumNotification object:nil];
                [self backAction];
            }
        }
        showTipDialog(response.msg);
        
    } failBlock:^(NSError *error) {
        showTipDialog(error.localizedDescription);
    }];
}



#pragma mark - 保存用户信息 并跳转首页
- (void)setTabBarByModel:(HKUserModel *)model {
    
    if (!isEmpty(model.access_token)) {
        userDefaultsWithModel(model);
        // 发送登录通知
        HK_NOTIFICATION_POST(HKLoginSuccessNotification, nil);
    }

    [MobClick profileSignInWithPUID:model.ID];//友盟用于记录 新增用户
    [CommonFunction recordUserLoginCount];
    //[HKLoginTool pushToBeforeVC:self];
    [self backAction];
}




@end








