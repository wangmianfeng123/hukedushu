//
//  HKMyCollectionVC.m
//  Code
//
//  Created by Ivan li on 2018/3/2.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMyCollectionVC.h"
#import "CollectionVC.h"
#import "UIBarButtonItem+Extension.h"
#import "WMPageController+Category.h"
#import "HKArticleListVC.h"
#import "HKBookCollectVC.h"

@interface HKMyCollectionVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@end



@implementation HKMyCollectionVC


- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"收藏教程";
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.hk_hideNavBarShadowImage = YES;
    [self setLeftBarButtonItem];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareSetup {
    
    self.titles = @[@"VIP教程", @"文章",@"读书"];
    self.itemMargin = 15;
    self.automaticallyCalculatesItemWidths = YES;
    //self.menuViewContentMargin = 0;
    [super prepareSetup];
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;

    
    
//    self.titles = @[@"VIP教程",@"名师机构", @"文章"];
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
        CollectionVC *collectionVC = [[CollectionVC alloc]init];
        
        HKArticleListVC *articleListVC = [[HKArticleListVC alloc] init];
        articleListVC.isMyCollection = YES;
        
        HKBookCollectVC *bookVC = [HKBookCollectVC new];
        _viewcontrollers = @[collectionVC, articleListVC,bookVC];
    }
    return _viewcontrollers;
}


//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.hiddenSeparatorLine = YES;
    //menuView.backgroundColor = COLOR_ffffff;
    return CGRectMake(0, 0, SCREEN_WIDTH, kHeight44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0,0, SCREEN_WIDTH, self.view.height);
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



