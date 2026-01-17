//
//  HomeVideoVC+Category.m
//  Code
//
//  Created by Ivan li on 2018/1/11.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HomeVideoVC+Category.h"
#import "HKGuideView.h"
  
#import "HKHomeNewGuideView.h"
#import "HKVideoNewGuideView.h"
#import <JPush/JPUSHService.h>
#import "HKHomeNewPointView.h"
#import "NSString+MD5.h"
#import "HKHomeAudioGuideView.h"
#import "HKAudioGuideVC.h"
#import "HKCurrentVideoTipView.h"
#import "VideoPlayVC.h"
#import "HomeServiceMediator.h"
#import "HKHomeArticleGuideView.h"
#import "HKHomeGiftModel.h"

#import <LUKeychainAccess/LUKeychainAccess.h>
#import "BannerModel.h"
#import "HtmlShowVC.h"
#import "HKVIPCategoryVC.h"
#import "DesignTableVC.h"
#import "HKHtmlDialogVC.h"
#import "HKhtmlModel.h"
#import "HKFullScreenAdView.h"
#import "HKH5PushToNative.h"
#import "AppDelegate.h"
#import "HKAdWindow.h"
#import "HKMyInfoUserModel.h"

#import "CYLTabBarController.h"
#import "UIView+SNFoundation.h"
#import "HKHomeIMGuideView.h"
#import "HKNavigationController.h"
#import "HomeReadBookGuideView.h"
#import "HKVersionModel.h"
#import "HKShortVideoHomeVC.h"
#import "HKhomeLoginView.h"


@implementation HomeVideoVC (Category)



- (UIWindow *)getKeyWindow {
    
    if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[HKAdWindow class]]) {
        // 广告 窗口 正在显示
         return [AppDelegate sharedAppDelegate].window;
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
}


- (void)setGuideViewWithImageArray:(NSArray *)imageArray isLoadGif:(BOOL)isLoadGif {

    HKGuideView *guideView = [[HKGuideView alloc] initWithFrame:[self getKeyWindow].bounds
                                                 imageNameArray:imageArray
                                                 buttonIsHidden:NO
                                                isLoadGif:isLoadGif];
    guideView.slideInto = NO;
    [[self getKeyWindow] addSubview:guideView];
}





- (void)setNewUserGuideView {

    HKHomeNewGuideView *view = [[HKHomeNewGuideView alloc]init];
    [[self getKeyWindow] addSubview:view];
}



/**
 设置 新用户 免费观看视频次数 提示
 */
- (void)setNewUserPointView {
    HKHomeNewPointView *view = [[HKHomeNewPointView alloc]init];
    [[self getKeyWindow] addSubview:view];
}




/**
 设置 极光推送 设备别名
 */
- (void)setJpushAlias {

    if ([HKAccountTool shareAccount]) {
        [JPUSHService setAlias:[HKAccountTool shareAccount].ID completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@" 极光别名 %@",iAlias);
        } seq:10];
        [self getJpushRegistrationID];
    }
}


/**
 删除 极光推送 别名
 */
- (void)deleteJpushAlias {

    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@" 极光别名 %@",iAlias);
    } seq:10];
    //退出后 发送请求到后台 后台解绑 极光推送 绑定RegistrationID
    [self setRegistrationID];
}



/**
 获得 极光推送 RegistrationID
 */
- (void)getJpushRegistrationID {

    if ([HKAccountTool shareAccount]) {
        [self setRegistrationID];
    }
}

/** 注册 极光推送  RegistrationID */
- (void)setRegistrationID {

    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (!isEmpty(registrationID)) {
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:registrationID,@"registration_id",nil];
            [HKHttpTool POST:JPUSH_BIND parameters:parameters success:^(id responseObject) {
                if (HKReponseOK) {
                    
                }
            } failure:^(NSError *error) {

            }];
        }
    }];
}



/** 首页音频 引导 */
- (void)setHomeAudioGuideView :(CGRect)rect{

    if (rect.origin.y>0.0) {
        HKHomeAudioGuideView *view = [[HKHomeAudioGuideView alloc]initWithRect:rect];
        [[self getKeyWindow] addSubview:view];
    }

//    HKAudioGuideVC *VC = [[HKAudioGuideVC alloc]init]; //[[HKAudioGuideVC alloc]initWithRect:rect];
//    VC.rect = rect;
//    VC.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
//    [self.view addSubview:VC.view];
}


/** 首页文章 引导 */
//- (void)setHomeArticleGuideView :(CGRect)rect {
//    
//    if (rect.origin.y>0.0) {
//        if ([self.view viewWithTag:2020]) return;
//        HKHomeArticleGuideView *view = [[HKHomeArticleGuideView alloc]initWithRect:rect row:0 indexPath:nil];
//        view.tag = 2020;
//        [self.view addSubview:view];
//    }
//}




/**
 设置当前学习
 */
- (void)setCurrentVideoModelTip:(VideoModel *)video {
    __block HKCurrentVideoTipView *view = [HKCurrentVideoTipView viewFromXib];
    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view); make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-KTabBarHeight49);
//        make.height.mas_equalTo(58);
//    }];
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeHKCurrentVideoTipView:)];
    [view addGestureRecognizer:tap];
    view.model = video;

    view.x = 0;
    view.size = CGSizeMake(self.view.width, 58);
    view.y = SCREEN_HEIGHT-KTabBarHeight49-58;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            if (view) {
                view.y = SCREEN_HEIGHT;
            }
        } completion:^(BOOL finished) {
            TTVIEW_RELEASE_SAFELY(view);
        }];
    });
}


// 移除当前学习课程view提示
- (void)removeHKCurrentVideoTipView:(UITapGestureRecognizer *)tap{

    //首页-底部弹出-上次学到 统计
    [MobClick event:UM_RECORD_SHOUYE_LASTTIME_LEARN];

    HKCurrentVideoTipView *view = (HKCurrentVideoTipView *)tap.view;
    VideoModel *video = view.model;
    // 进入视频详情页
    [self enterVideoVC2:video];
    TTVIEW_RELEASE_SAFELY(view);
}



- (void)enterVideoVC2:(VideoModel *)model {
    
    [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:self];
//    
//    VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.video_url
//                                                videoName:model.video_titel
//                                         placeholderImage:model.img_cover_url
//                                               lookStatus:LookStatusInternetVideo videoId:model.video_id model:model];
//    [self pushToOtherController:VC];
}


#pragma mark - 统计banner 点击次数
- (void)recordBannerClickCount:(NSString*)bannerId {

//    [[HomeServiceMediator sharedInstance]recordBannerClickCount:bannerId completion:^(FWServiceResponse *response) {
//
//    } failBlock:^(NSError *error) {
//
//    }];
    
    [[HomeServiceMediator sharedInstance] advertisClickCount:bannerId];
}




- (void)homeBannerClick:(HKMapModel*)model {
    [HKALIYunLogManage sharedInstance].button_id = @"2";
    
    [HKH5PushToNative runtimePush:model.redirect_package.class_name arr:model.redirect_package.list currectVC:self];
}






#pragma mark - banner 点击 跳转  2.50 版本之前
// type  1-H5页面 2-视频详情页 3-列表页 4-VIP页  5-浏览器 appstore
- (void)homeBannerClick_250:(BannerModel*
                             )model {
        switch ([model.type intValue]) {
            case 1:
            {
                HtmlShowVC *VC = [[HtmlShowVC alloc]initWithNibName:nil bundle:nil model:model];
                [self pushToOtherController:VC];
            }
                break;
            case 2:
            {
                VideoPlayVC *VC = [[VideoPlayVC alloc]initWithNibName:nil bundle:nil fileUrl:model.field.video_url
                                                            videoName:model.field.video_titel
                                                     placeholderImage:model.field.img_cover_url
                                                           lookStatus:LookStatusInternetVideo videoId:model.field.msg model:model];
                [self pushToOtherController:VC];
            }
                break;
            case 3:
            {
                DesignTableVC *VC = [[DesignTableVC alloc]initWithNibName:nil bundle:nil category:model.field.msg name:model.field.video_titel];
                [self pushToOtherController:VC];
            }
                break;
            case 4:
            {
                HKVIPCategoryVC *VC = [HKVIPCategoryVC new];
                [self pushToOtherController:VC];
            }
                break;
            case 5:
            {   //跳转浏览器或APP商店
                if (!isEmpty(model.field.msg)) {
                    [[UIApplication sharedApplication] openURL:HKURL(model.field.msg)];
                }
            }
                break;
        }
}





/** html 弹窗 */
- (void)setHtmlDialogVC {
    @weakify(self);
    [HKHttpTool POST:POP_GET_POP parameters:nil success:^(id responseObject) {
        self.showoActivityed = YES;
        @strongify(self);
        if (HKReponseOK) {
            HKhtmlModel *model = [HKhtmlModel mj_objectWithKeyValues:responseObject[@"data"]];
            
//            if (DEBUG) {
//                model.h5_url =  @"http://app-test.huke88.com/app-activity/activity20190527/entry";
//                model.h5_url =  @"https://huke88.com/?sem=baidu&kw=100003&renqun_youhua=738962&bd_vid=11081059356595850802";
//            }
            
            if (!isEmpty(model.h5_url)) {
                if (self.dialogVC == nil) {
                    HKHtmlDialogVC *VC = [[HKHtmlDialogVC alloc]initWithUrl:model.h5_url];
                    VC.view.tag = 99;
                    self.dialogVC = VC;
                    
                    VC.htmlLoadFinishBlock = ^(BOOL finish, HKHtmlDialogVC *dialogVC) {
                        @strongify(self);
                        [self.navigationController.tabBarController addChildViewController:dialogVC];
                        
                        if (![[CommonFunction topViewController] isKindOfClass:[VideoPlayVC class]]) {
                            
                            if ([[CommonFunction getRootViewController] isKindOfClass:[UITabBarController class]]) {
                                UITabBarController * tabVc = (UITabBarController *)[CommonFunction getRootViewController];
                                [tabVc.view addSubview:dialogVC.view];
                            }
                        }
                    };
                    
                    VC.htmlCloseBlock = ^{
                        [self loadRemindLiveData];
                    };
                }
                
            }else{
                [self loadRemindLiveData];
            }
        }else{
            [self loadRemindLiveData];
        }
        
        
        if ([self.showTimeOutLogin isEqualToString:@"1"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                showTipDialog(TIME_OUT_LOGIN);
                self.showTimeOutLogin = @"0";
            });
        }
    } failure:^(NSError *error) {
        self.showoActivityed = YES;
        if ([self.showTimeOutLogin isEqualToString:@"1"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                showTipDialog(TIME_OUT_LOGIN);
                self.showTimeOutLogin = @"0";
            });
        }
        [self loadRemindLiveData];
    }];
}





/**
 * 发送红点 通知
 **/
- (void)postRedPointNoti:(NSMutableArray<HKMyInfoMapPushModel*> *)mapArr {
    
    if (isLogin()) {
        if (mapArr) {
            for (HKMyInfoMapPushModel *model in mapArr) {
                if ([model.key isEqualToString:@"message"]) {
                    // 发出红点消息
                    [[NSNotificationCenter defaultCenter] postNotificationName:HKMineRedPointNotification object:nil userInfo:@{@"unreadCount" :  [NSString stringWithFormat:@"%d",[model.icon_message intValue]]}];
                    break;
                }
            }
        }
    }
}



- (void)setIMGuideView {
    
    BOOL show = [HKNSUserDefaults boolForKey:@"Home_IM_Guide"];
    if (!show) {
        HKHomeIMGuideView *tempview = [[HKHomeIMGuideView alloc]init];
        tempview.frame = tempview.bgViewRect;
        self.iMGuideView = tempview;
        [self.view addSubview:tempview];
        [HKNSUserDefaults setBool:YES forKey:@"Home_IM_Guide"];
        [HKNSUserDefaults synchronize];
    }
}

- (void)removeIMGuideView {
    TTVIEW_RELEASE_SAFELY(self.iMGuideView);
}



- (void)setReadBookGuideView {
    
    BOOL show = [HKNSUserDefaults boolForKey:@"Home_ReadBook_Guide"];
    if (!show) {
        // 读书引导
//        HomeReadBookGuideView *tempview = [[HomeReadBookGuideView alloc]init];
//        tempview.frame = tempview.bgViewRect;
//        self.readBookGuideView = tempview;
//        [self.view addSubview:tempview];
        
        [HKNSUserDefaults setBool:YES forKey:@"Home_ReadBook_Guide"];
        [HKNSUserDefaults synchronize];

        // 用于记录不显示短视频的每日更新
        [CommonFunction setReadBookGuideView:YES];
    }
}

- (void)removeReadBookGuideView {
    TTVIEW_RELEASE_SAFELY(self.readBookGuideView);
}



#pragma mark -- 极验登录 配置
- (void)loginConfigData {
    
    [HKInitConfigManger sharedInstance];
    [HKHttpTool POST:INIT_CONFIGURE parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            HKInitConfigModel *configModel = [HKInitConfigModel mj_objectWithKeyValues:responseObject[@"data"][@"configList"]];
            [HKInitConfigManger sharedInstance].configModel = configModel;
        }
    } failure:^(NSError *error) {
        
    }];
    
}



- (void)webBrowserPushTargetVCWithWebUrl:(NSString*)url {
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",CLIENT_REDIRECT_REDIRECT_INFO,url];
    [HKHttpTool hk_taskPost:URL allUrl:nil isGet:YES parameters:nil success:^(id responseObject) {
        if (HKReponseOK) {
            HKMapModel *mapModel = [HKMapModel mj_objectWithKeyValues:responseObject[@"data"]];
            //mapModel.redirect_package.class_name = @"HKShortVideoHomeVC";
            [HKH5PushToNative runtimePush:mapModel.redirect_package.class_name arr:mapModel.redirect_package.list currectVC:self];
        }
    } failure:^(NSError *error) {
        
    }];
}



/**
 设置登录view
 */
- (void)setHomeLoginView {
    
    if (NO == isLogin() && [HKhomeLoginView isNeedShowHomeLoginOfDay]) {
        @weakify(self);
        HKhomeLoginView *loginView = [[HKhomeLoginView alloc]init];
        loginView.loginBtnActionBlock = ^(UIButton * _Nonnull btn) {
            @strongify(self);
            self.isBottomViewLogin = YES;
            [self setLoginVC];
            self.isBottomViewLogin = NO;
            [MobClick event:shouye_login_click];
            [[HKVideoPlayAliYunConfig sharedInstance]setBtnID:14];
            [[HKVideoPlayAliYunConfig sharedInstance]setShowType:1];
        };
        [self.view addSubview:loginView];
        [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-KTabBarHeight49);
            make.height.mas_equalTo(60);
        }];
    }
}

- (void)calculateTimeDifference:(void(^)(void))resultBlock{
    if ([HKAccountTool shareAccount].refresh_token.length) {
        CGFloat time1 = [[HKAccountTool shareAccount].access_token_expire_at doubleValue];
        CGFloat time2 = [[DateChange getNowTimeTimestamp] doubleValue];
        
        CGFloat seconde = time1 - time2 ;
        if (seconde < 7 * 24 * 3600 && time1 > 0) {
            [self needsRefreshAccess_token:resultBlock];
        }else{
            if (resultBlock) {
                resultBlock();
            }
        }
    }else{
        if (resultBlock) {
            resultBlock();
        }
    }
}

-  (void)needsRefreshAccess_token:(void(^)(void))resultBlock{
    NSLog(@"USERR_TOKEN=====");
    [HKHttpTool POST:@"user/refresh-access-token" parameters:@{@"refresh_token":[HKAccountTool shareAccount].refresh_token} success:^(id responseObject) {
        if ([CommonFunction detalResponse:responseObject]) {
            NSString * access_token = responseObject[@"data"][@"access_token"];
            NSString * refresh_token = responseObject[@"data"][@"refresh_token"];
            NSString * expire_at = responseObject[@"data"][@"access_token_expire_at"];
            if (access_token.length && refresh_token.length) {
                [HKAccountTool saveAccountToken:access_token andRefresh_token:refresh_token andAccess_token_expire:expire_at];
            }
        }
        if (resultBlock) {
            resultBlock();
        }
    } failure:^(NSError *error) {
        if (resultBlock) {
            resultBlock();
        }
    }];
}

- (void)videoCountTip:(NSString*)count {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (count.length) {
            if (self.showingTips == NO) {
                self.showingTips = YES;
                CGFloat width = [CommonFunction getTextWidth:count font:[UIFont systemFontOfSize:IS_IPHONE6PLUS ? 14:13] lineSpacing:0.0 width:0.0] + 18;
                UIColor *textColor = [UIColor hkdm_colorWithColorLight:COLOR_ffffff dark:COLOR_ffffff];
                __block UILabel *label = [UILabel labelWithTitle:CGRectMake((SCREEN_WIDTH - width)/2, 0, width, PADDING_30)  title:nil
                                                      titleColor:textColor
                                                       titleFont:(IS_IPHONE6PLUS ?@"14":@"13")
                                                   titleAligment:NSTextAlignmentCenter];
                label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
                label.clipsToBounds = YES;
                label.layer.cornerRadius = PADDING_15;
                label.text = count;
                [self.view addSubview:label];
                label.y = KNavBarHeight64-PADDING_35;
                
                [UIView animateWithDuration:1 delay:0.5 options:0 animations:^{
                    label.y = KNavBarHeight64+30;
                } completion:^(BOOL finished) {
                    
                }];
                
                [UIView animateWithDuration:1 delay:3.5 options:0 animations:^{
                    label.y = KNavBarHeight64 - PADDING_35;
                } completion:^(BOOL finished) {
                    TTVIEW_RELEASE_SAFELY(label);
                }];
            }
        }
    });
    
}


@end






