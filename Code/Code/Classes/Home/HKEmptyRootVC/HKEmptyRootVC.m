//
//  HKEmptyRootVC.m
//  Code
//
//  Created by Ivan li on 2019/4/25.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKEmptyRootVC.h"
#import "HKFullScreenAdView.h"
#import "HKAuthorizationView.h"
#import "HtmlShowVC.h"
#import "HKProtoclView.h"
@interface HKEmptyRootVC ()

@end

@implementation HKEmptyRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated{
    BOOL HaveAgreeAuthView = [[NSUserDefaults standardUserDefaults] boolForKey:@"HaveAgreeAuthView"];
    BOOL isFirstLoad = [CommonFunction isUpdateAppFirstLoad];
    

    if (HaveAgreeAuthView || isFirstLoad) {
        if (isFirstLoad) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HaveAgreeAuthView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSString * IDStr = [CommonFunction getUserId];
        NSInteger show  = 0;
        if(IDStr.length){
            show = [[NSUserDefaults standardUserDefaults] integerForKey:IDStr];
        }
        
        if (isLogin()) {
            if (show) {
                if (self.agreeBtnBlock) {
                    self.agreeBtnBlock(NO);
                }
            }else{
                [HKHttpTool POST:Protocol parameters:nil success:^(id responseObject) {
                    if (HKReponseOK) {
                        int need_show = [responseObject[@"data"][@"need_show"] intValue];
                        if (need_show) {
                            [self showProtocolView];
                        }else{
                            if (self.agreeBtnBlock) {
                                self.agreeBtnBlock(NO);
                            }
                        }
                    }else{
                        if (self.agreeBtnBlock) {
                            self.agreeBtnBlock(NO);
                        }
                    }
                } failure:^(NSError *error) {
                    if (self.agreeBtnBlock) {
                        self.agreeBtnBlock(NO);
                    }
                }];
            }
            
        }else{
            if (self.agreeBtnBlock) {
                self.agreeBtnBlock(NO);
            }
        }
    }else{
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 308)];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor = [UIColor brownColor];

        HKAuthorizationView * authView = [HKAuthorizationView createView];
        [bgView addSubview:authView];
        authView.delegateClickBlock = ^(NSInteger tag) {
            [LEEAlert closeWithCompletionBlock:nil];
            NSString *webUrl = nil;
            if (tag == 1) {
                webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
            }else{
                webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
            }
            HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
            [self pushToOtherController:htmlShowVC];
        };
        authView.closeBlock = ^{
            [LEEAlert closeWithCompletionBlock:^{
                UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 270)];
                bgView.layer.cornerRadius = 10;
                bgView.layer.masksToBounds = YES;
                bgView.backgroundColor = [UIColor brownColor];

                HKAuthorizationView * authView = [HKAuthorizationView createView];
                [authView.noUseBtn setTitle:@"退出应用" forState:UIControlStateNormal];
                [authView.agreementBtn setTitle:@"同意并继续使用" forState:UIControlStateNormal];
                authView.contentTV.text = @"虎课仅会将你的信息用于提供服务和改善体验，我们将全力保障你的信息安全，请同意后使用。若你不同意本隐私政策，很遗憾我们将无法为你提供服务。";
                authView.btnWidth.constant = 120;
                [bgView addSubview:authView];
                authView.delegateClickBlock = ^(NSInteger tag) {
                    [LEEAlert closeWithCompletionBlock:nil];
                    NSString *webUrl = nil;
                    if (tag == 1) {
                        webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
                    }else{
                        webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
                    }
                    HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
                    [self pushToOtherController:htmlShowVC];
                };
                authView.closeBlock = ^{
                    exit(0);
                };
                authView.sureBlock = ^{
                    [LEEAlert closeWithCompletionBlock:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HaveAgreeAuthView"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.agreeBtnBlock) {
                            self.agreeBtnBlock(YES);
                        }
                    });
                };
                [LEEAlert alert].config
                .LeeCustomView(bgView)
                .LeeQueue(YES)
                .LeePriority(1)
                .LeeCornerRadius(0)
                .LeeHeaderColor([UIColor clearColor])
                .LeeHeaderInsets(UIEdgeInsetsZero)
                .LeeMaxWidth(320)
                .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
                .LeeShow();
            }];
//            [LEEAlert closeWithCompletionBlock:nil];
//            UIViewController * vc = [self topViewController];
//            showWaitingDialogWithView(@"您需要同意后才可继续使用虎课",vc.view);
        };
        authView.sureBlock = ^{
            [LEEAlert closeWithCompletionBlock:nil];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HaveAgreeAuthView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.agreeBtnBlock) {
                    self.agreeBtnBlock(YES);
                }
            });
        };
        [LEEAlert alert].config
        .LeeCustomView(bgView)
        .LeeQueue(YES)
        .LeePriority(1)
        .LeeCornerRadius(0)
        .LeeHeaderColor([UIColor clearColor])
        .LeeHeaderInsets(UIEdgeInsetsZero)
        .LeeMaxWidth(320)
        .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
        .LeeShow();
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [UIImageView new];
//    imageView.frame = self.view.bounds;
    imageView.backgroundColor = [UIColor whiteColor];
    // 设置背景图
    imageView.image = [HKFullScreenAdView getLaunchImage];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.7, SCREEN_WIDTH * 0.7 * 183 / 266.0));
    }];
    
    UIImageView *netIconImage = [UIImageView new];
    netIconImage.backgroundColor = [UIColor whiteColor];
    // 设置背景图
    netIconImage.image = [UIImage imageNamed:@"netIocns"];
    netIconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:netIconImage];
    [netIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(imageView.mas_width).multipliedBy(0.3);
        make.height.mas_equalTo(netIconImage.mas_width).multipliedBy(2/13.0);
        make.bottom.equalTo(self.view).offset(-TAR_BAR_XH - 10);
    }];
}

- (void)showProtocolView{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 330)];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor clearColor];
    
    HKProtoclView * authView = [HKProtoclView createView];
    authView.sureBlock = ^{
        [LEEAlert closeWithCompletionBlock:nil];
        [self readProtocol];
        if (self.agreeBtnBlock) {
            self.agreeBtnBlock(NO);
        }
    };
    
    authView.closeBlock = ^{
        exit(0);
    };
    
    authView.delegateClickBlock = ^(NSInteger tag) {
        [LEEAlert closeWithCompletionBlock:nil];
        NSString *webUrl = nil;
        if (tag == 0) {
            webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_AGREEMENT];
        }else{
            webUrl = [NSString stringWithFormat:@"%@%@",[CommonFunction HK_BaseUrl_NO_V5],SITE_PRIVACY_AGREEMENT];
        }
        HtmlShowVC *htmlShowVC = [[HtmlShowVC alloc] initWithNibName:nil bundle:nil url:webUrl];
        [self pushToOtherController:htmlShowVC];
    };
    [bgView addSubview:authView];
    LEEAlertConfig * alert = [LEEAlert alert];
    alert.config.showTopImage = YES;
    alert.config
        .LeeCustomView(bgView)
        .LeeMaxWidth(300)
        .LeeHeaderColor(COLOR_FFFFFF_3D4752)
        .LeeShouldAutorotate(NO)
        .LeeCloseAnimationDuration(0)
        .LeeOpenAnimationDuration(0)
        .LeeSupportedInterfaceOrientations( UIInterfaceOrientationMaskPortrait)
        .LeeShow();
}


// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    if (IS_IPAD) {
        return YES;
    }
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (IS_IPAD) {
        return UIInterfaceOrientationMaskLandscape;

    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)readProtocol{
    [HKHttpTool POST:read_Protocol parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            int business_code = [responseObject[@"data"][@"business_code"] intValue];
            if (business_code == 200) {
                
                NSString * IDStr = [CommonFunction getUserId];
                if(IDStr.length){
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:IDStr];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    } failure:^(NSError *error) { }];
}
    

@end
