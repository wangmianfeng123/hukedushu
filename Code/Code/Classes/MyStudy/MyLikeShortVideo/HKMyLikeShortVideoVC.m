//
//  HKMyLikeShortVideoVC.m
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyLikeShortVideoVC.h"
#import "CollectionVC.h"
#import "UIBarButtonItem+Extension.h"
#import "WMPageController+Category.h"
#import "HKArticleListVC.h"
#import "HKTeacherDouYinVC.h"

@interface HKMyLikeShortVideoVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@end



@implementation HKMyLikeShortVideoVC


- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hk_hideNavBarShadowImage = YES;
    self.navigationItem.title = @"我的点赞";
    [self setLeftBarButtonItem];
}

- (void)prepareSetup {
    
    self.titles = @[@"短视频"];
    self.itemsMargins = @[@15,@20];
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = 0;
    [super prepareSetup];
    
}


- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        HKTeacherDouYinVC *vc1 = [[HKTeacherDouYinVC alloc]init];
        vc1.isFromMyStudy = YES;
        vc1.user = [HKAccountTool shareAccount];
        _viewcontrollers = @[vc1];
    }
    return _viewcontrollers;
}


//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    //menuView.backgroundColor = COLOR_ffffff;
    return CGRectMake(0, KNavBarHeight64, SCREEN_WIDTH, kHeight44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0,kHeight44, SCREEN_WIDTH, SCREEN_HEIGHT-kHeight44);
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {

    return self.titles[index];
}


@end



