//
//  HKAllOrderVC.m
//  Code
//
//  Created by Ivan li on 2018/2/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKOrderPaymentVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKPGCOrderVC.h"
#import "HKTrainOrderVC.h"
#import "WMPageController+Category.h"
#import "HKLiveingOrderVC.h"
#import "HKOverflowVC.h"

@interface HKOrderPaymentVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@end


@implementation HKOrderPaymentVC


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
    self.navigationItem.title = @"我的订单";
    [self setLeftBarButtonItem];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}



- (void)prepareSetup {
    
    //self.titles = @[@"训练营", @"名师机构"];
    self.titles = @[@"训练营",@"直播", @"名师机构", @"超职套课"];
    self.itemsMargins = @[@15,@20,@20,@20,@20];
    self.automaticallyCalculatesItemWidths = YES;
    //self.menuViewContentMargin = 15;
    [super prepareSetup];
}


- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        HKTrainOrderVC *vc1 = [HKTrainOrderVC new];
        HKLiveingOrderVC *vc2 = [ HKLiveingOrderVC new];
        HKPGCOrderVC *vc3 = [HKPGCOrderVC new];
        HKOverflowVC *vc4 = [HKOverflowVC new];
        _viewcontrollers = @[vc1,vc2,vc3,vc4];
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



