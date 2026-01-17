//
//  HKCollectionAlbumVC.m
//  Code
//
//  Created by Ivan li on 2017/12/2.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKCollectionAlbumVC.h"
#import "HKMyAblumVC.h"
#import "HKDefaultAlbumVC.h"
#import "CollectionVC.h"
#import "UIBarButtonItem+Extension.h"
#import "WMPageController+Category.h"

@interface HKCollectionAlbumVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@end



@implementation HKCollectionAlbumVC


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
    self.navigationItem.title = @"专辑";
    [self setLeftBarButtonItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareSetup {
    
    self.titles = @[@"我的专辑",@"收藏专辑"];
    self.itemsMargins = @[@15,@20,@20];
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = 0;
    [super prepareSetup];
    
    
//    self.titles = @[@"我的专辑",@"收藏专辑"];
//    self.titleSizeNormal = 15;
//    self.titleSizeSelected = 15;
//    self.menuViewStyle = WMMenuViewStyleLine;
//
//    self.progressColor = COLOR_fddb3c;
//    self.titleColorNormal = COLOR_A8ABBE;
//    self.titleColorSelected = COLOR_27323F;
//    self.progressWidth = PADDING_30;
//    self.progressHeight = 4;
//    self.isSelectedBold = YES;
//
//    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
//    self.menuItemWidth = SCREEN_WIDTH*0.25;
}


- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        UIViewController *vc2 = [[HKMyAblumVC alloc]init];
        UIViewController *vc3 = [HKDefaultAlbumVC new];
        _viewcontrollers = @[vc2,vc3];
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



