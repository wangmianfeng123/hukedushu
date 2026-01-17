//
//  HKTaskSwapVC.m
//  Code
//
//  Created by Ivan li on 2018/7/12.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKTaskSwapVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKTaskListVC.h"
#import "WMPageController+Category.h"
#import "LEEAlert.h"

@interface HKTaskSwapVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@end


@implementation HKTaskSwapVC


- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"作品交流";
    [self setNavigationItem];
}

- (void)setNavigationItem {

    [self setLeftBarButtonItem];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonRightItemWithBackgroudImageName:@"question_black"
                                                                                highBackgroudImageName:@"question_gray"
                                                                                                target:self
                                                                                                action:@selector(rightItemAction)];
}


- (void)rightItemAction {
    [self setAlert];
}


- (void)setAlert {
    [LEEAlert alert].config
    .LeeAddContent(^(UILabel *label) {
        label.font = HK_FONT_SYSTEM(15);
        label.text = @"全站通VIP和终身VIP享有虎课网专业讲师作品评改特权，请在网站上传作品。更多精彩敬请期待";
        label.textColor = [UIColor colorWithHexString:@"#030303"];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        action.title = @"确定";
        action.font = HK_FONT_SYSTEM(15);
        action.titleColor = COLOR_0076FF;
        action.backgroundColor = [UIColor whiteColor];
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareSetup {
    
    self.titles = @[@"最新",@"最热"];
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    self.menuViewStyle = WMMenuViewStyleLine;
    
    self.progressColor = COLOR_fddb3c;
    self.titleColorNormal = COLOR_A8ABBE;
    self.titleColorSelected = COLOR_27323F;
    self.progressWidth = PADDING_30;
    self.progressHeight = 4;
    self.isSelectedBold = YES;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    self.menuItemWidth = SCREEN_WIDTH*0.25;
}


- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        UIViewController *vc1 = [HKTaskListVC new];
        UIViewController *vc2 = [HKTaskListVC new];
        _viewcontrollers = @[vc1,vc2];
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
    //return CGRectMake(0,kHeight44, SCREEN_WIDTH, SCREEN_HEIGHT -KTabBarHeight49-kHeight44);
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    // 选中字体加粗
    pageController.menuView.isSelectedBold = pageController.isSelectedBold;
    if (pageController.selectIndex == index) {
        pageController.menuView.selItem.isSelectedBold = pageController.isSelectedBold;
        [pageController.menuView.selItem setFont:[UIFont boldSystemFontOfSize:pageController.titleSizeSelected]];
    }
    return self.titles[index];
}

@end



