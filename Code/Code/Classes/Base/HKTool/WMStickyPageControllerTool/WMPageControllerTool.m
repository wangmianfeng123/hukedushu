
//
//  WMPageControllerTool.m
//  Code
//
//  Created by Ivan li on 2018/12/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "WMPageControllerTool.h"
#import "LoginVC.h"
#import "HKNavigationController.h"
#import "HKListeningBookVC.h"
#import "HomeVideoVC.h"
#import "HKVIPOtherVC.h"
#import "HKVIPOneYearVC.h"
#import "HKVIPWholeLifeVC.h""
#import "HKBookModel.h"
#import "HKVIPCategoryVC.h"
#import "BindPhoneVC.h"
#import <OneLoginSDK/OneLoginSDK.h>

@interface WMPageControllerTool ()

@end

@implementation WMPageControllerTool

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
//    if (@available(iOS 13.0, *)) {
//        // 主题模式 发生改变
//        if (self.titles.count) {
//            [self wm_resetMenuView];
//        }
//    }
//}


- (void)prepareSetup {
    [self ordinaryUI];
}



- (void)ordinaryUI {
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 17;
    self.menuViewStyle = WMMenuViewStyleLine;
    //self.menuItemWidth = SCREEN_WIDTH * 0.25;
    self.progressColor = COLOR_fddb3c;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.progressWidth = 18;
    self.progressHeight = 4;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    self.menuColorNormal = COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
}

#pragma mark - 绑定手机号 检测
//- (void)checkBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone {
//    
//    WeakSelf;
//    NSString *phone = [HKAccountTool shareAccount].phone;
//    if (isEmpty(phone)) {
//        [HKHttpTool POST:USER_CHECK_BINDED_PHONE parameters:nil success:^(id responseObject) {
//            StrongSelf;
//            if (HKReponseOK) {
//                HKUserModel *model = [HKUserModel new];
//                if (model.bindedPhone) {
//                    //已经绑定 直接评论
//                    commentBlock();
//                }else{
//                    //未绑定 弹出绑定视图
//                    //bindPhoneBlock();
//                    [strongSelf setBindPhoneAlert:nil];
//                }
//            }else{
//                showTipDialog(responseObject[@"msg"]);
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//        
//    }else{
//        //已经绑定 直接评论
//        commentBlock();
//    }
//}

#pragma mark - 建立登录视图
- (void)setLoginVC {
    
    LoginVC * vc = [LoginVC new];
    UIViewController *topVC = [CommonFunction topViewController];
    if ([topVC isKindOfClass:[HKListeningBookVC class]]) {
        HKListeningBookVC * controller = (HKListeningBookVC *)topVC;
        vc.loginTxt =  controller.bookModel.is_free ? @"登录即享免费听" : @"登录即享每天一课免费学";
    }else if ([topVC isKindOfClass:[HomeVideoVC class]]){
        HomeVideoVC * controller = (HomeVideoVC *)topVC;
        vc.loginTxt = controller.isBottomViewLogin ? @"海量课程免费学":@"登录即享每天一课免费学";
    }else if ([topVC isKindOfClass:[HKVIPOtherVC class]]||
              [topVC isKindOfClass:[HKVIPOneYearVC class]]||
              [topVC isKindOfClass:[HKVIPWholeLifeVC class]] ||
              [topVC isKindOfClass:[HKVIPCategoryVC class]]){
        vc.loginTxt = @"会员畅学50000+专属课程";
    }else{
        vc.loginTxt = @"登录即享每天一课免费学";
    }
    
    if ([OneLogin isPreGettedTokenValidate]) {
        HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:vc];
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:loginVC animated:YES completion:nil];
        [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
    } else {
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            vc.sender = sender;
            HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:vc];
            loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:loginVC animated:YES completion:nil];
            [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
        }];
    }
    
}


#pragma mark - view controls
- (BOOL)shouldAutorotate {
    if (IS_IPAD) {
        return YES;
    }
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;

    }
    return UIInterfaceOrientationMaskPortrait;
}

@end




