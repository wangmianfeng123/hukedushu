//
//  TabBarTypeTwo.m
//  gcnsxp
//
//  Created by happying on 17/3/17.
//  Copyright © 2017年 gcn. All rights reserved.
//

#import "TabBarTypeTwo.h"
#import "UITabBarItem+PPBadgeView.h"
#import "HKShortVideoHomeVC.h"
#import "HomeVideoVC.h"

@interface TabBarTypeTwo() 


@end



@implementation TabBarTypeTwo

- (instancetype)init {
    if (self = [super init]) {
        
            [self setTabBadgePointUI:self.tabBarController];
            // 注销登录
            HK_NOTIFICATION_ADD(HKLogoutSuccessNotification, userlogoutSuccessNotification);
            //我的 红点通知
            HK_NOTIFICATION_ADD(HKMineRedPointNotification, (showOrRemoveRedPoint:));
    }
    return self;
}


- (void)dealloc {
    
    HK_NOTIFICATION_REMOVE();
}


//注销
- (void)userlogoutSuccessNotification {
    
    if (self.tabBarController.viewControllers.count) {
        UIViewController *viewController = self.tabBarController.viewControllers.lastObject;
        [self showOrRemoveRedPointWithCount:0 VC:viewController];
    }
}


#pragma mark  我的tabbar 红点 样式
- (void)setTabBadgePointUI:(CYLTabBarController *)tabBarController {
    // 我的tabbar 红点
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (NSEC_PER_SEC * 0.1)), dispatch_get_main_queue(), ^{
        if (self.tabBarController.viewControllers.count) {
            UIViewController *viewController = tabBarController.viewControllers.lastObject;
            UIView *tabBadgePointView0 = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:3];
            [viewController.tabBarItem.cyl_tabButton cyl_setTabBadgePointView:tabBadgePointView0];
            [viewController cyl_setTabBadgePointViewOffset:UIOffsetMake(0, 5)];
            [viewController cyl_removeTabBadgePoint];
        }
    });
}



#pragma mark  我的tabbar 红点
- (void)showOrRemoveRedPoint:(NSNotification *)notification {
    
    NSString *countString = notification.userInfo[@"unreadCount"];
    if (self.tabBarController.viewControllers.count) {
        UIViewController *viewController = self.tabBarController.viewControllers.lastObject;
        [self showOrRemoveRedPointWithCount:countString.integerValue VC:viewController];
    }
}



- (void)showOrRemoveRedPointWithCount:(NSInteger)msgCount VC:(UIViewController *)VC {
    if (msgCount > 0) {
        [VC cyl_showTabBadgePoint];
    } else {
        [VC cyl_removeTabBadgePoint];
    }
}



+ (void)changeTabItemImage:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[HomeVideoVC class]]) {
        [MobClick event:shouye_view];
    }
    
    [TabBarControllerConfig tabBarItemTextColor:COLOR_7B8196 selectColor:COLOR_27323F_EFEFF6];
    [tabBarController.tabBar setBackgroundImage:[[UIImage alloc] init]];
    [tabBarController.tabBar setBackgroundColor:COLOR_FFFFFF_3D4752];
    //[tabBarController.tabBar setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    UIImage *darkImage = [UIImage imageWithColor:COLOR_3D4752 size:CGSizeMake(SCREEN_WIDTH, 1)];
    UIImage *lightImage = [UIImage imageNamed:@"tapbar_top_line"];
    UIImage *shadowImage = [UIImage hkdam_lightOrDarkModeImageWithLightImage:lightImage darkImage:darkImage];
    [tabBarController.tabBar setShadowImage:shadowImage];
    
    
    NSInteger count = tabBarController.tabBar.items.count;
    NSArray *itemImage = @[@"house_gray",@"category_gray",@"ic_readingbook_normal_v2_18",@"tab_study",@"tab_me"];
    NSArray *itemSelectedImage = @[@"house_yellow_select",@"category_yellow_select",@"ic_readingbook_selected_v2_18",@"tab_study_select",@"tab_me_select"];

        NSArray *itemSelectedLightImage = @[@"house_yellow_select_dark",@"category_yellow_select_dark",@"ic_readingbook_selected_v2_18_dark",@"tab_study_select_dark",@"tab_me_select_dark"];
    
    for (int i = 0; i<count; i++) {
        UITabBarItem *item = tabBarController.tabBar.items[i];
        if (@available(iOS 13.0, *)) {
            if (isFouceLight) {
                item.selectedImage = [self getImageFromImageInfo:imageName(itemSelectedImage[i])];
                //[self getImageFromImageInfo:imageName(itemSelectedLightImage[i])];
            }else{
                item.selectedImage = [self getImageFromImageInfo:imageName(itemSelectedLightImage[i])];
                //[self getImageFromImageInfo:imageName(itemSelectedImage[i])];
            }
        }else{
            item.selectedImage = [self getImageFromImageInfo:imageName(itemSelectedImage[i])];
        }
        //item.selectedImage = [self getImageFromImageInfo:imageName(itemSelectedImage[i])];
        item.image = [self getImageFromImageInfo:imageName(itemImage[i])];
    }
    
////    / 短视频 tab 显示逻辑
//        NSInteger count = tabBarController.tabBar.items.count;
//
////        if ([viewController isKindOfClass:[HKShortVideoMainVC class ]]) {
//        if ([viewController isKindOfClass:[HKShortVideoHomeVC class ]]) {
//            [tabBarController.tabBar setBackgroundImage:[[UIImage alloc] init]];
//            [tabBarController.tabBar setBackgroundColor:IS_IPHONE_X?[UIColor blackColor]:[UIColor clearColor]];
//            //[[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
//
//            if (5 == count) {
//                [TabBarControllerConfig tabBarItemTextColor:COLOR_7B8196 selectColor:[UIColor whiteColor]];
//                NSArray *itemImage = @[@"ic_home_video_v2_10",@"ic_classify_video_v2_10",@"ic_video_normal",@"ic_study_video_v2_10",@"ic_me_video_v2_10"];
//                NSArray *itemSelectedImage = @[@"ic_home_video_v2_10",@"ic_classify_video_v2_10",@"ic_video_checked",@"ic_study_video_v2_10",@"ic_me_video_v2_10"];
//
//                for (int i = 0; i<count; i++) {
//                    UITabBarItem *item = tabBarController.tabBar.items[i];
//                    item.selectedImage = [self getImageFromImageInfo:imageName(itemSelectedImage[i])];
//                    item.image = [self getImageFromImageInfo:imageName(itemImage[i])];
//                }
//            }
//        }else{
//            [TabBarControllerConfig tabBarItemTextColor:COLOR_7B8196 selectColor:COLOR_27323F];
//            [tabBarController.tabBar setBackgroundImage:[[UIImage alloc] init]];
//            [tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
//            [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
//
//            if (count <5) {
//                NSArray *itemImage = @[@"house_gray",@"category_gray",@"tab_study",@"tab_me"];
//                NSArray *itemSelectedImage = @[@"house_yellow",@"category_yellow",@"tab_study_select",@"tab_me_select"];
//                for (int i = 0; i<count; i++) {
//                    UITabBarItem *item = tabBarController.tabBar.items[i];
//                    item.selectedImage = [self getImageFromImageInfo:imageName(itemSelectedImage[i])];
//                    item.image = [self getImageFromImageInfo:imageName(itemImage[i])];
//                }
//            }else{
//                NSArray *itemImage = @[@"house_gray",@"category_gray",@"ic_video_normal",@"tab_study",@"tab_me"];
//                NSArray *itemSelectedImage = @[@"house_yellow",@"category_yellow",@"ic_video_checked",@"tab_study_select",@"tab_me_select"];
//                for (int i = 0; i<count; i++) {
//                    UITabBarItem *item = tabBarController.tabBar.items[i];
//                    item.selectedImage = [self getImageFromImageInfo:imageName(itemSelectedImage[i])];
//                    item.image = [self getImageFromImageInfo:imageName(itemImage[i])];
//                }
//            }
//        }
}



+ (UIImage *)getImageFromImageInfo:(id)imageInfo {
    UIImage *image = nil;
    if ([imageInfo isKindOfClass:[NSString class]]) {
        image = [UIImage imageNamed:imageInfo];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else if ([imageInfo isKindOfClass:[UIImage class]]) {
        image = (UIImage *)imageInfo;
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}


@end










