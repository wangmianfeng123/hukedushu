//
//  HKBaseVC.m
//  Code
//
//  Created by pg on 2017/3/8.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKBaseVC.h"
#import "UIBarButtonItem+Extension.h"
#import "LoginVC.h"

#import "HKNavigationController.h"
#import "BindPhoneVC.h"
#import "HtmlShowVC.h"
#import "HKBaseVC+EmptyData.h"
#import "HKListeningBookVC.h"
#import "HomeVideoVC.h"

#import "HKVIPOtherVC.h"
#import "HKVIPOneYearVC.h"
#import "HKVIPWholeLifeVC.h""
#import "HKBookModel.h"
#import "HKVIPCategoryVC.h"
#import "AppDelegate.h"
#import <OneLoginSDK/OneLoginSDK.h>


@interface HKBaseVC ()

@end

@implementation HKBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitleColor:COLOR_27323F];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //友盟页面路径统计 add 0208
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //友盟页面路径统计
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc {
    NSLog(@"控制器销毁 =%@",[self class]);
    
    HK_NOTIFICATION_REMOVE();
}


#pragma mark  导航栏上的标题
- (void)setTitle:(NSString *)title color:(UIColor*)color {
    
    UILabel* titlelabel = [UILabel labelWithTitle:CGRectMake(0, 0, 150, 30) title:title
                                       titleColor:color titleFont:nil
                                    titleAligment:NSTextAlignmentCenter];
    [titlelabel setFont:HK_FONT_SYSTEM_BOLD(18)];
    [titlelabel setAdjustsFontSizeToFitWidth:YES];
    self.navigationItem.titleView = titlelabel;
}



#pragma mark - 设置导航栏标题 颜色
- (void)setNavigationBarTitleColor:(UIColor*)color {
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor hkdm_colorWithColorLight:color dark:COLOR_EFEFF6];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];//字体大小设置
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
}

- (void)createLeftBarButton {
        
    UIImage *image = [[self class]leftBarButtonItemImage];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImage:image highBackgroudImage:image target:self action:@selector(backAction)];
}


/// 返回 baritem 图标
+ (UIImage*)leftBarButtonItemImage {
    return [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
}


- (void)createLeftBarItemWithImageName:(NSString*)imageName {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:imageName
                                                                          highBackgroudImageName:imageName
                                                                                          target:self
                                                                                          action:@selector(backAction)];
}


- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightBarButtonItemWithTitle:(NSString*)title color:(UIColor *)color  action:(SEL)action{
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem barButtonItemWithTitle:title target:self color:color action:action];
    //[UIBarButtonItem barButtonItemWithTitle:@"提交" target:self color:color action:@selector(submit:)];
}


/**
 *
 *根据图片大小 创建BarButtonItem
 *
 */

- (void)createRightBarButtonWithImage:(NSString*)image {
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonRightItemWithBackgroudImageName:image
                                                                                 highBackgroudImageName:image
                                                                                                 target:self
                                                                                                 action:@selector(rightBarBtnAction)];
}


/**
 *
 *创建固定大小的 BarButtonItem
 *
 */
- (void)createRightBarButtonWithImage:(NSString*)image size:(CGSize)size {
    
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithBackgroudImageName:image
                                                                            highBackgroudImageName:image
                                                                                            target:self
                                                                                            action:@selector(rightBarBtnAction) size:size];
}


/** 创建分享的 BarButtonItem */
- (void)createShareButtonItem {
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"share_black") darkImage:imageName(@"share_black_dark")];
    self.navigationItem.rightBarButtonItem  = [UIBarButtonItem BarButtonItemWithImage:image highImage:image target:self action:@selector(shareBtnItemAction) size:CGSizeMake(40, 40)];
}


- (void)shareBtnItemAction {
    
}



/**
 *
 *判断是否是模拟器
 *
 */
- (void)isSimulator {
    //模拟器
    if (TARGET_IPHONE_SIMULATOR == 1) {
        return ;
    }
}


- (void)pushToOtherController:(UIViewController*)VC {
    [self pushToViewController:VC animated:YES];
}


- (void)pushToViewController:(UIViewController*)VC  animated:(BOOL)animated {
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:animated];
}


- (void)rightBarBtnAction {
    
}





#pragma mark - 使用移动流量提醒

- (void)mobileTrafficNotice {
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = @"流量提醒";
        
        label.textColor = [UIColor blackColor];
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = Use_Mobile_Traffic;
        
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"稍后下载";
        action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
        
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            // 取消点击事件Block
            
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = @"继续下载";
        action.titleColor = [UIColor colorWithHexString:@"#333333"];
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            // 删除点击事件Block
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


#pragma mark - 手机空间不足提醒

- (void)mobileMemoryNotice {
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = @"存储空间不足";
        label.textColor = [UIColor blackColor];
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = Memory_Insufficient;
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"我知道了";
        
        action.titleColor = [UIColor colorWithHexString:@"#ff7c00"];
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            // 取消点击事件Block
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


#pragma mark - 登录过期,强制重新登录
- (void)resetLogin {
    WeakSelf;
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = TIME_OUT_LOGIN;
        label.textColor = [UIColor blackColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"确定";
        action.titleColor = COLOR_333333;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            signOut();
            [weakSelf setLoginVC];
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


#pragma mark - 登录过期,重新登录
- (void)resetUserLogin {
    
    WeakSelf;
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = TIME_OUT_LOGIN;
        label.textColor = [UIColor blackColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = COLOR_ff7c00;
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"确定";
        action.titleColor = COLOR_333333;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            signOut();
            [weakSelf setLoginVC];
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
}


#pragma mark - 退出登录
- (void)userSignOut {
    WeakSelf;
    BOOL isAutorotate = IS_IPAD?YES:NO;
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = @"温馨提示";//@"确定注销登录吗?";
        label.textColor = COLOR_030303;
    })
    .LeeAddContent(^(UILabel *label) {
        
        //label.text = @"确定要退出吗?";
        label.text = @"退出登录后，您将无法继续学习";
        [label setFont:[UIFont systemFontOfSize:15]];
        label.textColor = COLOR_030303;
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"残忍退出";
        action.titleColor = COLOR_555555;
        action.backgroundColor = [UIColor whiteColor];
        action.clickBlock = ^{
            [weakSelf singOutRequest];
            // 删除账号 退出
            signOut();
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"signOut" object:nil];
            //[weakSelf backAction];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        action.title = @"保持登录";
        action.titleColor = COLOR_0076FF;
        action.backgroundColor = [UIColor whiteColor];
    })

    //.LeeCornerRadius(5.0f)
    .LeeHeaderColor([UIColor whiteColor])
    
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
//    .LeeShouldAutorotate(isAutorotate)
    .LeeShow();
    
}


- (void)singOutRequest {
    [HKHttpTool POST:USER_LOGOUT parameters:nil success:^(id responseObject) {
        
        if (HKReponseOK) {
            NSLog(@" 成功 退出");
        }
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 建立登录视图
- (void)setLoginVC {
    
    LoginVC * vc = [LoginVC new];
    vc.isFromSuspensionView = self.isFromSuspensionView;
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
        [self presentViewController:loginVC animated:NO completion:nil];
        if (self.isFromSuspensionView) {
            [[HKVideoPlayAliYunConfig sharedInstance]setShowType:15];
        }else{
            [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
        }
    } else {
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            vc.sender = sender;
            HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:vc];
            loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:loginVC animated:NO completion:nil];
            if (self.isFromSuspensionView) {
                [[HKVideoPlayAliYunConfig sharedInstance]setShowType:15];
            }else{
                [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
            }
        }];
    }
}


- (void)setStudyLoginVC {
    
    if ([OneLogin isPreGettedTokenValidate]) {
        LoginVC *loginVC = [LoginVC new];
        loginVC.loginViewThemeType = HKLoginViewThemeType_study;
        HKNavigationController *navigationController = [[HKNavigationController alloc]initWithRootViewController:loginVC];
        navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:navigationController animated:NO completion:nil];
        [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
    } else {
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull sender) {
            LoginVC *loginVC = [LoginVC new];
            loginVC.sender = sender;
            loginVC.loginViewThemeType = HKLoginViewThemeType_study;
            HKNavigationController *navigationController = [[HKNavigationController alloc]initWithRootViewController:loginVC];
            navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:navigationController animated:NO completion:nil];
            [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
        }];    
    }
    
    
}


- (void)setGiftLoginVC {
    LoginVC *VC = [LoginVC new]; VC.loginViewType = HKLoginViewType_Firstload;
    
    HKNavigationController *loginVC = [[HKNavigationController alloc]initWithRootViewController:VC];
    loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:loginVC animated:YES completion:nil];
}



#pragma mark - 当前窗口控制器
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}


- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


/** 创建  管理baritem */
- (void)setRightBarEditBtn {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarEditBtn];
}


- (UIButton*)rightBarEditBtn {
    if (!_rightBarEditBtn) {
        _rightBarEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBarEditBtn.frame = CGRectMake(0, 0, 40, 40);
        [_rightBarEditBtn setTitle:@"管理" forState:UIControlStateNormal];
        _rightBarEditBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightBarEditBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
        [_rightBarEditBtn addTarget:self action:@selector(rightBarEditBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarEditBtn;
}


- (void)rightBarEditBtnClick:(UIButton*)btn {
    
}


#pragma mark - 设置 登录-退出 观察
- (void)userLoginAndLogotObserver {
    // 成功登录
    HK_NOTIFICATION_ADD(HKLoginSuccessNotification, userloginSuccessNotification);
    // 注销登录
    HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, userlogoutSuccessNotification);
}


#pragma mark - 登录后操作
- (void)userloginSuccessNotification { }

#pragma mark - 退出后操作
- (void)userlogoutSuccessNotification { }


#pragma mark 登录 IM
//- (void)loginIM {
//    [HKIMLoginTool IM_tokenRequest:^{
//        
//    } loginFail:^{
//        
//    } requestfail:^(NSError *error) {
//        
//    }];
//}



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
                [weakSelf pushToOtherController:VC];
            }
        };
    })
    .LeeCornerRadius(5)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
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

#pragma mark - 绑定手机号 检测
- (void)checkloadImgBindPhone:(void (^)())commentBlock  bindPhone:(void (^)())bindPhone {
    
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
                    [strongSelf setBindPhoneAlert:@"为了您的账号安全以及响应国家政策，请绑定手机号后再发表内容"];
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



#pragma mark - 购买VIP完成 时检测 绑定手机号 检测
- (void)buyVipCheckBindPhone:(void (^)())bindSucessBlock  bindPhoneBlock:(void (^)())bindPhoneBlock {
    
    NSString *phone = [HKAccountTool shareAccount].phone;
    if (isEmpty(phone)) {
        [HKHttpTool POST:USER_CHECK_BINDED_PHONE parameters:nil success:^(id responseObject) {
            if (HKReponseOK) {
                HKUserModel *model = [HKUserModel new];
                if (model.bindedPhone) {
                    //已经绑定
                    bindSucessBlock();
                }else{
                    //未绑定
                    bindPhoneBlock();
                }
            }else{
                bindPhoneBlock();
            }
        } failure:^(NSError *error) {
            bindPhoneBlock();
        }];
    }else{
        //已经绑定
        bindSucessBlock();
    }
}



#pragma mark - 跳转vip 购买协议html
- (void)pushToVipProtocolHtmlVC {
    NSString *webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_VIP_AGREEMENT];
    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
    [self pushToOtherController:htmlShowVC];
}




/// 禁止侧滑返回
- (void)forbidBackGestureRecognizer {
    self.navigationController.isPopGestureRecognizerEnable = NO;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
    [self.view addGestureRecognizer:pan];
}

//tabitem 坐标
- (CGFloat)tabitemPointXForIndex:(NSInteger)index{
    UITabBarController *tbc = [AppDelegate sharedAppDelegate].window.rootViewController;
    CGRect itemFrame = [self getTabBarItemFrameWithTabBar:tbc.tabBar index:index];
    return itemFrame.origin.x + itemFrame.size.width/2;
}



- (CGRect)getTabBarItemFrameWithTabBar:(UITabBar *)tabBar index:(NSInteger)index
{
    //遍历出tabBarItems
    NSMutableArray *tabBarItems = [NSMutableArray array];
    for (UIView *view in tabBar.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"]) {
            [tabBarItems addObject:view];
        }
    }
    //根据frame的X从小到大对tabBarItems进行排序
    NSArray *sortedTabBarItems= [tabBarItems sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2){
        return [@(view1.frame.origin.x) compare:@(view2.frame.origin.x)];
    }];
    //找到指定的tabBarItem 并优化其相对于屏幕的位置
    NSInteger i = 0;
    CGRect itemFrame = CGRectZero;
    for (UIView *view in sortedTabBarItems) {
        if (index == i) {
            itemFrame = view.frame;
            itemFrame.origin.y = SCREEN_HEIGHT - itemFrame.size.height;
            break;
        }
        i++;
    }
    return itemFrame;
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


#pragma mark ---- 屏幕切换
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}
@end




