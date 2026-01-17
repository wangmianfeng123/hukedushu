//
//  HKHomeRecomandVC.m
//  Code
//
//  Created by eon Z on 2021/11/1.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKHomeRecomandVC.h"
#import "HKTestVC.h"
#import "HKStudyTagVC.h"
#import "TagSelectorVC.h"
#import "HKRecomandSubVC.h"
#import "TagModel.h"


@interface HKHomeRecomandVC (){
    __block NSMutableArray *selectedTagArray;
    __block NSMutableArray *otherTagArray;
}
@property (nonatomic, copy) NSMutableArray *viewcontrollers;
@end

@implementation HKHomeRecomandVC

-(void)setDataArray:(NSMutableArray *)dataArray{
    
    
    _dataArray = dataArray;
    [self prepareSetup];
}

- (void)viewDidLoad {
    [self menuTabProgressUI];
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (void)menuTabProgressUI {
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    self.progressWidth = 18;
    self.progressHeight = 4;
    self.progressColor = COLOR_fddb3c;
}

- (void)prepareSetup {
    //当数据源数量减少时刷新，部分属性会有数组越界的情况
    NSMutableArray * arry = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        HKRecomandSubVC * vc = [[HKRecomandSubVC alloc] initWithNetDataRefresh:self.isNetDataRefresh];
        vc.tagM = self.dataArray[i];
        [arry addObject:vc];
    }    
    self.viewcontrollers = arry;
    if (arry.count == 0) return;
    [self reloadData];
    self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 10;
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 16;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_FFFFFF;
    self.menuColorNormal = COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
}

- (NSMutableArray *)viewcontrollers {
    if (_viewcontrollers == nil) {
        _viewcontrollers = [NSMutableArray array];
    }
    return _viewcontrollers;
}


//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    [menuView.moreButton setImage:[UIImage hkdm_imageWithNameLight:@"ic_more_homepage2_38" darkImageName:@"ic_more_homepage_dark_2_38"] forState:UIControlStateNormal];
    return CGRectMake(0, 10, SCREEN_WIDTH, kHeight44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0,0, SCREEN_WIDTH, self.view.height);
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}


- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    TagModel * tag = self.dataArray[index];
    return tag.name;
}

- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex{
}

- (void)menuView:(WMMenuView *)menu moreButtonClick:(UIButton *)button {
    //创建栏目选择器，输入已选栏目列表和备选栏目列表
    TagSelectorVC *selectorVC = [[TagSelectorVC alloc] initWithSelectedTags:nil andOtherTags:nil];
    [self pushToOtherController:selectorVC];
    [MobClick event: @"C02001"];//编辑首页分类页
}

- (void)pushToOtherController:(UIViewController*)VC {
    [self pushToViewController:VC animated:YES];
}

- (void)pushToViewController:(UIViewController*)VC  animated:(BOOL)animated {
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:animated];
}

@end
