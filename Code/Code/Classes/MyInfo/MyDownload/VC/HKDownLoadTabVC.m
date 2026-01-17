//
//  HKDownLoadTabVC.m
//  Code
//
//  Created by eon Z on 2021/12/14.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKDownLoadTabVC.h"
#import "MyDownloadVC.h"
#import "WMPageController+Category.h"

@interface HKDownLoadTabVC ()
@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@end

@implementation HKDownLoadTabVC

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.hk_hideNavBarShadowImage = YES;
    [self setLeftBarButtonItem];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData];
}


- (void)prepareSetup {
    
    self.titles = @[@"VIP教程", @"直播"];
    self.itemMargin = 15;
    self.automaticallyCalculatesItemWidths = YES;
    //self.menuViewContentMargin = 0;
    [super prepareSetup];
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;
}


- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        MyDownloadVC *videoDownVC = [[MyDownloadVC alloc]init];
        videoDownVC.downLoadType = 1;
        
        
        MyDownloadVC *liveDownVC = [[MyDownloadVC alloc]init];
        liveDownVC.downLoadType = 2;
        
        _viewcontrollers = @[videoDownVC,liveDownVC];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
