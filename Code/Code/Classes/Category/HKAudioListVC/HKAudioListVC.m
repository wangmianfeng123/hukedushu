//
//  HKAudioListVC.m
//  Codeww
///
//  Created by Ivan li on 2018/3/20.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAudioListVC.h"
#import "VideoModel.h"
#import "VideoPlayVC.h"

#import "TagModel.h"
#import "HKAudioListCell.h"
#import "HKMusicPlayVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKAudioHotVC.h"
#import "HKAudioAllSortVC.h"
#import "WMPageController+Category.h"


@interface HKAudioListVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;


@end


@implementation HKAudioListVC


-(instancetype)init{
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    
    self = [super init];
    if (self) {
        [self prepareSetup];
        self.title = title;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hk_hideNavBarShadowImage = YES;
    self.navigationItem.title = self.title;
    [self setLeftBarButtonItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareSetup {
    
    self.titles = @[@"综合排序",@"最热",@"最新"];
    self.itemsMargins = @[@15,@20,@20,@20];
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = 0;
    [super prepareSetup];
    
//    self.titles = @[@"综合排序",@"最热",@"最新"];
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
        UIViewController *vc = [HKAudioAllSortVC new];
        UIViewController *vc2 = [[HKAudioHotVC alloc]initWithCategory:@"1" name:nil];
        UIViewController *vc3 = [[HKAudioHotVC alloc]initWithCategory:@"2" name:nil];
        _viewcontrollers = @[vc,vc2,vc3];
    }
    return _viewcontrollers;
}


//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = COLOR_ffffff;
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


