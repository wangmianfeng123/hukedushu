//
//  WMStickyPageTool.m
//  Code
//
//  Created by Ivan li on 2018/12/5.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "WMStickyPageControllerTool.h"
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

@interface WMStickyPageControllerTool ()

@end

@implementation WMStickyPageControllerTool

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
    if (_controllerType == WMStickyPageControllerType_ordinary) {
        [self ordinaryUI];
    }else{
        [self videoDetailUI];
    }
}


- (void)setControllerType:(WMStickyPageControllerType)controllerType {
    _controllerType = controllerType;
    if (_controllerType == WMStickyPageControllerType_ordinary) {
        [self ordinaryUI];
    }else{
        [self videoDetailUI];
    }
}


- (void)ordinaryUI {
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 17;
    self.menuViewStyle = WMMenuViewStyleLine;
    //self.menuItemWidth = SCREEN_WIDTH * 0.25;
    self.progressColor = COLOR_fddb3c;
    self.titleColorNormal = COLOR_27323F_EFEFF6;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.progressWidth = 18;
    self.progressHeight = 4;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    
    self.menuColorNormal = COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
}




- (void)videoDetailUI {
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuItemWidth = SCREEN_WIDTH * 0.25;
    self.titleColorNormal = COLOR_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
    self.progressColor = COLOR_fddb3c;
    self.progressWidth = 30;
    self.progressHeight = 4;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    self.menuColorNormal = COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
}



//- (void)createLeftBarButton {
//
//    self.navigationItem.leftBarButtonItem =
//    [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"nac_back" highBackgroudImageName:@"nac_back"
//                                                  target:self
//                                                  action:@selector(backAction)];
//}
//
//- (void)backAction {
//
//    [self.navigationController popViewControllerAnimated:YES];
//}



#pragma mark - 设置详细text
- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {

    NSString *text = nil;
    if (status == TBNetworkStatusNotReachable){
        text = NETWORK_ALREADY_LOST;
    }else{
        text = @"暂无内容～";
    }
    UIFont *font = [UIFont systemFontOfSize:IS_IPHONE6PLUS ? 15:14];
    UIColor *textColor = HKColorFromHex(0xA8ABBE, 1.0);
    NSMutableDictionary *attributes = [NSMutableDictionary new];

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    if (!text) {return nil;}
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:text attributes:attributes];
    return attributedString;

}


#pragma mark - 设置提示图片
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    // 遍历找出mj_header
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITableView class]] || [subView isKindOfClass:[UICollectionView class]]) {

            if (((UITableView *)subView).mj_header) {
                [((UITableView *)subView).mj_header beginRefreshing];
                break;
            }
        }
    }
}


- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    if (status == TBNetworkStatusNotReachable){
        return imageName(NETWORK_ALREADY_LOST_IMAGE);
    }else{
        return imageName(EMPETY_DATA_IMAGE);
    }
}


- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {

    if (status == TBNetworkStatusNotReachable) {
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"重新加载" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:HK_FONT_SYSTEM(14)}];
        return str;
    }
    return nil;
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
                VC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }
        };
    })
    .LeeCornerRadius(5)
    .LeeHeaderColor([UIColor whiteColor])
    .LeeSupportedInterfaceOrientations( IS_IPAD ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait)
    .LeeShow();
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







