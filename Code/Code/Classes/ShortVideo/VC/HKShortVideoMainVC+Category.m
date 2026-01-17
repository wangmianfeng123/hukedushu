//
//  HKShortVideoMainVC+Category.m
//  Code
//
//  Created by Ivan li on 2019/3/26.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HKShortVideoMainVC+Category.h"
#import "ZFHKNormalPlayer.h"
#import "AppDelegate.h"
#import "CYLTabBarController.h"
#import "UIView+SNFoundation.h"
#import "HKShortVideoModel.h"
#import "IQKeyboardManager.h"
#import "HKPlaytipByWWANTool.h"

@implementation HKShortVideoMainVC (Category)

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    //[self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.player.viewControllerDisappear = NO;
}





- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController.navigationBar lt_reset];
    //[self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
    self.player.viewControllerDisappear = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
}


/**
 播放时 移动流量 提醒
 
 @param sure (确定按钮 回调)
 */
- (void)playtipByWWAN:(void(^)())sureAction  cancelAction: (void(^)())cancelAction {
    
    [HKPlaytipByWWANTool shortVideoPlaytipByWWAN:sureAction cancelAction:cancelAction];
}





/** 滑动动画 */
- (void)showScorllAnimationView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL show = [HKNSUserDefaults boolForKey:@"shortVideo_scorll_Animation"];
        
        
        if (!show && !self.showBackBtn) {
            TTVIEW_RELEASE_SAFELY(self.praiseAnimationView);
            WeakSelf;
            [self.scrollAnimationView playWithCompletion:^(BOOL animationFinished) {
                StrongSelf
                [strongSelf.scrollAnimationView playWithCompletion:^(BOOL animationFinished) {
                    [strongSelf.scrollAnimationView playWithCompletion:^(BOOL animationFinished) {
                        TTVIEW_RELEASE_SAFELY(strongSelf.scrollAnimationView);
                    }];
                }];
            }];
            
            self.scrollAnimationView.size = CGSizeMake(self.scrollAnimationView.width/2, self.scrollAnimationView.height/2);
            [self.view addSubview:self.scrollAnimationView];
            self.scrollAnimationView.center = self.view.center;
            
            [HKNSUserDefaults setBool:YES forKey:@"shortVideo_scorll_Animation"];
            [HKNSUserDefaults synchronize];
        }
    });
}


/** 双击点赞动画 */
- (void)showPraiseAnimationView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL show = [HKNSUserDefaults boolForKey:@"shortVideo_praise_Animation"];
        if (!show && !self.showBackBtn) {
            TTVIEW_RELEASE_SAFELY(self.scrollAnimationView);
            WeakSelf;
            [self.praiseAnimationView playWithCompletion:^(BOOL animationFinished) {
                StrongSelf
                [strongSelf.praiseAnimationView playWithCompletion:^(BOOL animationFinished) {
                    [strongSelf.praiseAnimationView playWithCompletion:^(BOOL animationFinished) {
                        TTVIEW_RELEASE_SAFELY(strongSelf.praiseAnimationView);
                    }];
                }];
            }];
            
            self.praiseAnimationView.size = CGSizeMake(self.praiseAnimationView.width/2, self.praiseAnimationView.height/2);
            [self.view addSubview:self.praiseAnimationView];
            self.praiseAnimationView.center = self.view.center;
            
            [HKNSUserDefaults setBool:YES forKey:@"shortVideo_praise_Animation"];
            [HKNSUserDefaults synchronize];
        }
    });
}



/** 短视频 播放记录（次数） **/
- (void)postShortVideoPlayCount:(NSString*)videoId {
    // ali log
    [[HKALIYunLogManage sharedInstance]shortVideoPlayCountLogWithVideoId:videoId];
    
    if (!isEmpty(videoId)) {
        NSDictionary *dict = @{@"video_id":videoId};
        [HKHttpTool POST:SHORT_VIDEO_PLAY_VIDEO_UP parameters:dict success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}



//
//
//#pragma mark - 滑动动画
//- (void)testScorll:(NSTimeInterval)time delay:(NSTimeInterval)delay pause:(NSTimeInterval)pause down:(NSTimeInterval)down{
//
//    [UIView animateWithDuration:0 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.tableView addSubview:self.animationIV];
//        self.animationIV.centerX = self.tableView.centerX;
//        self.animationIV.centerY = self.tableView.centerY+50;
//    } completion:^(BOOL finished) {
//        self.animationIV.hidden = NO;
//    }];
//
//    [UIView animateWithDuration:time delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.tableView.y = - self.tableView.height/2 +50;
//    } completion:^(BOOL finished) {
//    }];
//
//    [UIView animateWithDuration:down delay:time+delay+pause options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.tableView.y = 0;
//    } completion:^(BOOL finished) {
//
//    }];
//
//    [UIView animateWithDuration:time delay:down+time+delay+pause options:UIViewAnimationOptionCurveEaseInOut animations:^{
//
//        self.tableView.y = - self.tableView.height/2 +50;
//    } completion:^(BOOL finished) {
//    }];
//
//
//    [UIView animateWithDuration:down delay:down+2*time+delay+pause options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.tableView.y = 0;
//    } completion:^(BOOL finished) {
//        TTVIEW_RELEASE_SAFELY(self.animationIV);
//    }];
//}
//
//
//
//- (void)removeTableViewAnimation {
//    [self.tableView.layer removeAllAnimations];
//    TTVIEW_RELEASE_SAFELY(self.animationIV);
//}
//
//
//
//- (UIImageView*)animationIV {
//    if (!_animationIV) {
//        _animationIV = [[UIImageView alloc]initWithImage:imageName(@"ic_finger_up_v2_10")];
//        _animationIV.hidden = YES;
//    }
//    return _animationIV;
//}


- (void)setShortVideoUpdateCountPerDay {
    
    // 当天第一次打开 显示提示
    
    BOOL isFirstDay = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString = [dateformatter stringFromDate:[NSDate date]];
    if (![locationString isEqualToString:[defaults objectForKey:@"HKUpdatePerDayFirstOpen"]]) {
        //当天第一次启动
        [defaults setValue:locationString forKey:@"HKUpdatePerDayFirstOpen"];
        [defaults synchronize];
        isFirstDay = YES;
    }
    
    if (isFirstDay && ![CommonFunction isReadBookGuideView]) {
        
        UIWindow *tempWindow = [AppDelegate sharedAppDelegate].window;
        CYLTabBarController *tabBarController = (CYLTabBarController*)tempWindow.rootViewController;
        CGRect barRect = [tabBarController.viewControllers[2].tabBarItem.cyl_tabButton convertRect:tempWindow.bounds toView:tempWindow];
        
        UIImageView *updateCountView = [[UIImageView alloc] init];
        updateCountView.image = imageName(@"pic_popover_video_v2_10");
        
        CGFloat height = updateCountView.image.size.height;
        CGFloat width = updateCountView.image.size.width;
        
        CGRect rect = CGRectMake(SCREEN_WIDTH / 2.0 - width / 2.0, barRect.origin.y - height - 2, width, height);
        
        updateCountView.frame = rect;
        [self.view addSubview:updateCountView];
        
        // 2秒消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 2.0)), dispatch_get_main_queue(), ^{
            [updateCountView removeFromSuperview];
        });
    }
    [CommonFunction setReadBookGuideView:NO];
}


@end

