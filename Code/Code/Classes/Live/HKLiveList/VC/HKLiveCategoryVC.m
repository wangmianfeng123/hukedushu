//
//  HKLiveCategoryVC.m
//  Code
//
//  Created by Ivan li on 2018/2/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKLiveCategoryVC.h"
#import "UIBarButtonItem+Extension.h"
#import "LearnedVC.h"
#import "HKLearnPgcVC.h"
#import "WMPageController+Category.h"
#import "HKLiveListVC.h"

@interface HKLiveCategoryVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@end


@implementation HKLiveCategoryVC


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
    self.navigationItem.title = @"直播";
    [self setLeftBarButtonItem];
}


- (void)prepareSetup {
    
    self.titles = @[@"精彩回放",@"即将开始"];
    self.itemsMargins = @[@15,@20,@20];
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = 0;
    self.selectIndex = 1; // 默认选中 即将开始
    [super prepareSetup];
    
//    self.titles = @[@"精彩回放",@"即将开始"];
//    self.titleSizeNormal = 15;
//    self.titleSizeSelected = 15;
//    self.menuViewStyle = WMMenuViewStyleLine;
//    self.selectIndex = 1; // 默认选中 即将开始
//    self.progressColor = COLOR_fddb3c;
//    self.titleColorNormal = COLOR_A8ABBE;
//    self.titleColorSelected = COLOR_27323F;
//    self.progressWidth = PADDING_30;
//    self.progressHeight = 4;
//    self.isSelectedBold = YES;
//    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
//    self.menuItemWidth = SCREEN_WIDTH*0.25;
}


- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        HKLiveListVC *vc1 = [HKLiveListVC new];
        vc1.isPlayBack = YES;
        
        HKLiveListVC *vc2 = [HKLiveListVC new];
        
        _viewcontrollers = @[vc1,vc2];
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



