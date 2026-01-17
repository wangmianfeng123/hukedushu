//
//  HKLearnLiveVC.m
//  Code
//
//  Created by Ivan li on 2021/5/18.
//  Copyright © 2021 pg. All rights reserved.
//

#import "HKLearnLiveVC.h"
#import "HKLiveLearnedVC.h"
#import "UIView+HKLayer.h"
#import "HKMomentRankMenu.h"
#import "HKMonmentTypeModel.h"
#import "WMPageController+Category.h"

@interface HKLearnLiveVC ()<HKMomentRankMenuDelegate>
@property (nonatomic, copy) NSArray<HKLiveLearnedVC *> *viewcontrollers;
@property (nonatomic , strong) NSArray * titleArray;
@property (nonatomic , strong) HKMomentRankMenu * rankmenuView;
@property (nonatomic , strong) HKMonmentTagModel * selectModel;
@property (nonatomic , strong) NSMutableArray * orderArray;;
@end

@implementation HKLearnLiveVC

-(HKMomentRankMenu *)rankmenuView{
    if (_rankmenuView == nil) {
        _rankmenuView = [HKMomentRankMenu viewFromXib];
        _rankmenuView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        _rankmenuView.delegate =self;
        
        _rankmenuView.selectedTitleColor = COLOR_FF3221;
        _rankmenuView.selectedBgColor = COLOR_FFEAE8;
        _rankmenuView.typeArray = self.orderArray;
        _rankmenuView.backgroundColor = COLOR_FFFFFF_3D4752;
    }
    return _rankmenuView;
}

- (NSMutableArray *)orderArray{
    if (_orderArray == nil) {
        _orderArray = [NSMutableArray array];
        HKMonmentTagModel * model  = [HKMonmentTagModel new];
        model.name = @"全部";
        model.ID = [NSNumber numberWithInt:0];
        [_orderArray addObject:model];
        
        HKMonmentTagModel * model1  = [HKMonmentTagModel new];
        model1.name = @"免费";
        model1.ID = [NSNumber numberWithInt:1];
        [_orderArray addObject:model1];
        
        HKMonmentTagModel * model2  = [HKMonmentTagModel new];
        model2.name = @"付费";
        model2.ID = [NSNumber numberWithInt:2];
        [_orderArray addObject:model2];
    }
    return _orderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self prepareSetup];
}

- (void)prepareSetup {
    [super prepareSetup];
    NSMutableArray *arrayVC = [NSMutableArray array];

    for (int i  = 0; i<self.orderArray.count; i++) {
        HKLiveLearnedVC *vc =  [[HKLiveLearnedVC alloc] init];
        HKMonmentTagModel * model = self.orderArray[i];
        vc.payType = [NSString stringWithFormat:@"%@",model.ID];
        [arrayVC addObject:vc];
    }
    self.viewcontrollers = arrayVC;
    self.scrollEnable = NO;
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    [self reloadData];
}


#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (BOOL)pageController:(WMStickyPageController *)pageController shouldScrollWithSubview:(UIScrollView *)subview {

    return NO;
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    [pageController.menuView addSubview:self.rankmenuView];
    self.rankmenuView.isRequestion = NO;
    self.rankmenuView.needFiltrateBtn = NO;
    return CGRectMake(0,40, SCREEN_WIDTH, SCREEN_HEIGHT - KNavBarHeight64);
}

//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    self.rankmenuView.size = CGSizeMake(SCREEN_WIDTH, 40);
    self.rankmenuView.isRequestion = NO;
    self.rankmenuView.needFiltrateBtn = NO;
    return CGRectMake(0, kHeight44, SCREEN_WIDTH, 40);
}

- (void)momentRankMenuDidRankBtn:(NSInteger)tag{
    HKMonmentTagModel * model = self.rankmenuView.typeArray[tag];
    self.selectIndex = [model.ID intValue];
}

@end
