//
//  WMPageController+Category.m
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "WMPageController+Category.h"
#import "UIBarButtonItem+Extension.h"
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

@implementation WMPageController (Category)

#pragma mark  导航栏上的标题
- (void)setTitle:(NSString *)title color:(UIColor*)color {
    
    UILabel* titlelabel = [UILabel labelWithTitle:CGRectMake(0, 0, 150, 30) title:title
                                       titleColor:color titleFont:nil
                                    titleAligment:NSTextAlignmentCenter];
    [titlelabel setFont:HK_FONT_SYSTEM_BOLD(18)];
    [titlelabel setAdjustsFontSizeToFitWidth:YES];
    self.navigationItem.titleView = titlelabel;
}

- (void)setLeftBarButtonItem {
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"nac_back"
//                                                                          highBackgroudImageName:@"nac_back"
//                                                                                          target:self
//                                                                                          action:@selector(backAction)];
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:image highBackgroudImage:image target:self action:@selector(backAction)];
}

//- (void)setLeftBarButtonItem withSize:(CGSize)size{
//    UIButton * btn = [[UIButton alloc] init]
//    
//    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:image highBackgroudImage:image target:self action:@selector(backAction)];
//}


- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


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


/** 创建分享的 BarButtonItem */
- (void)setShareButtonItem {
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"share_black") darkImage:imageName(@"share_black_dark")];
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithImage:image highImage:image target:self action:@selector(shareBtnItemAction) size:CGSizeMake(40, 40)];
}


- (void)setShareButtonItemWithImageName:(NSString*)imageName {
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithBackgroudImageName:imageName
                                                                            highBackgroudImageName:imageName
                                                                                            target:self
                                                                                            action:@selector(shareBtnItemAction) size:CGSizeMake(35, 35)];
    
}


- (void)shareBtnItemAction {
    
}



/** 白色 左BarButton  */
- (void)setWhiteLeftBarButtonItem {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"nac_back_white"
                                                                          highBackgroudImageName:@"nac_back_white"
                                                                                          target:self
                                                                                          action:@selector(backAction)];
}


/** 占位 右BarButton  */
- (void)setBlankRightBarButtonItem {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"nac_back_white"
    highBackgroudImageName:@"nac_back_white"
                    target:self
                    action:nil];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)rightBarButtonItemWithTitle:(NSString*)title color:(UIColor *)color  action:(SEL)action{
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem barButtonItemWithTitle:title target:self color:color action:action];
    //[UIBarButtonItem barButtonItemWithTitle:@"提交" target:self color:color action:@selector(submit:)];
}


#pragma mark - 绑定手机号 检测
- (void)checkBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone {
    
    WeakSelf;
    NSString *phone = [HKAccountTool shareAccount].phone;
    if (isEmpty(phone)) {
        [HKHttpTool POST:USER_CHECK_BINDED_PHONE parameters:nil success:^(id responseObject) {
            StrongSelf;
            if (HKReponseOK) {
                HKUserModel *model = [HKUserModel new];
                if (model.bindedPhone) {
                    //已经绑定 直接评论
                    commentBlock();
                }else{
                    //未绑定 弹出绑定视图
                    //bindPhoneBlock();
                    [strongSelf setBindPhoneAlert:nil];
                }
            }else{
                showTipDialog(responseObject[@"msg"]);
            }
        } failure:^(NSError *error) {
            
        }];
        
    }else{
        //已经绑定 直接评论
        commentBlock();
    }
}

#pragma mark - 绑定手机 alert
- (void)setBindPhoneAlert:(NSString *)text {
    
    WeakSelf;
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"温馨提示";
        label.textColor = COLOR_27323F;
        label.font = HK_FONT_SYSTEM_BOLD(17);
    })
    .LeeAddContent(^(UILabel *label) {
        label.text = text.length ? text : @"为了您的账号安全以及响应国家政策，请绑定手机号后再发表评论";
        label.textColor = COLOR_27323F;
        label.font = HK_FONT_SYSTEM(15);
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = @"取消";
        action.titleColor = COLOR_27323F;
        action.font = HK_FONT_SYSTEM(15);
        action.type = LEEActionTypeCancel;
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = @"立即绑定";
        action.titleColor = COLOR_3D8BFF;
        action.font = HK_FONT_SYSTEM(15);
        action.clickBlock = ^{
            BindPhoneVC *VC = [BindPhoneVC new];
            VC.bindPhoneType = HKBindPhoneType_Ordinary;
            if (nil == weakSelf.navigationController) {
                UIViewController *topVC = [CommonFunction topViewController];
                topVC.hidesBottomBarWhenPushed = YES;
                [topVC.navigationController pushViewController:VC animated:YES];
            }else{
                [weakSelf.navigationController pushViewController:VC animated:YES];
                //[weakSelf pushToOtherController:VC];
            }
        };
    })
    .LeeCornerRadius(5)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


@end



