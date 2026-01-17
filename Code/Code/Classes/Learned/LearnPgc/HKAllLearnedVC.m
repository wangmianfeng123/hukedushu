//
//  HKAllLearnedVC.m
//  Code
//
//  Created by Ivan li on 2018/2/27.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKAllLearnedVC.h"
#import "UIBarButtonItem+Extension.h"
#import "LearnedVC.h"
#import "HKLiveLearnedVC.h"
#import "WMPageController+Category.h"
#import "HKBookStudyRecordVC.h"
#import "HKLearnLiveVC.h"
#import "HKOverFlowCourseVC.h"


@interface HKAllLearnedVC ()

@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;

@property (nonatomic,assign) NSInteger learnedState;

@property (nonatomic,weak)LearnedVC *learnedVC;

@property (nonatomic,weak)HKLearnLiveVC *liveLearnedVC;

@property (nonatomic , strong) HKBookStudyRecordVC * bookVC;
@property (nonatomic , strong) HKOverFlowCourseVC * courseVC;
/// 选中 index
@property (nonatomic,assign) int tab_index;

@end


@implementation HKAllLearnedVC


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
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.selectIndex = self.tab_index;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self restRightBarEditBtnClick];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self reloadData];
}

- (void)restRightBarEditBtnClick{
    self.scrollEnable = YES;

    if ([self.currentViewController isKindOfClass:self.learnedVC.class]) {
        if (self.learnedVC.dataCount) {
            _rightBarEditBtn.selected = NO;
            [self.learnedVC resetEditLearnedCell];
        }

    } else if ([self.currentViewController isKindOfClass:self.bookVC.class]) {
        if (self.bookVC.dataArr) {
            _rightBarEditBtn.selected = NO;
            [self.bookVC resetEditLearnedCell];
        }
    }
}

- (void)rightBarEditBtnClick{
    
    if ([self.currentViewController isKindOfClass:self.learnedVC.class]) {
        if (self.learnedVC.dataCount) {
            _rightBarEditBtn.selected = !_rightBarEditBtn.selected;
            self.scrollEnable = !_rightBarEditBtn.selected;
            [self.learnedVC editLearnedCell];
        }
    } else if ([self.currentViewController isKindOfClass:self.bookVC.class]) {
        if (self.bookVC.dataArr) {
            _rightBarEditBtn.selected = !_rightBarEditBtn.selected;
            self.scrollEnable = !_rightBarEditBtn.selected;
            [self.bookVC editLearnedCell];
        }
    }else if ([self.currentViewController isKindOfClass:self.liveLearnedVC.class]) {
        self.scrollEnable = YES;
    }
}

- (void)prepareSetup {
    self.titles = @[@"VIP教程", @"直播",@"读书",@"超职套课"];
    self.itemMargin = 15;
    self.automaticallyCalculatesItemWidths = YES;
    [super prepareSetup];
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.titleSizeNormal = 14;
    self.titleSizeSelected = 14;
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = COLOR_27323F_EFEFF6;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.menuView.moreButton
}

- (NSArray<UIViewController *> *)viewcontrollers {
    
    if (_viewcontrollers == nil) {
        LearnedVC *vc1 = [LearnedVC new];
        self.learnedVC = vc1;
        
        HKLearnLiveVC *vc2 = [HKLearnLiveVC new];
        self.liveLearnedVC = vc2;
        
        
        HKBookStudyRecordVC *bookVC = [HKBookStudyRecordVC new];
        self.bookVC = bookVC;
        
        HKOverFlowCourseVC * vc = [HKOverFlowCourseVC new];
        self.courseVC = vc;

        _viewcontrollers = @[vc1, vc2,bookVC,vc];
    }
    return _viewcontrollers;
}


//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    self.rightBarEditBtn = menuView.moreButton;
    [_rightBarEditBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [_rightBarEditBtn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateSelected];
    [_rightBarEditBtn setTitleColor:[COLOR_27323F_EFEFF6 colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
    [_rightBarEditBtn setImage:[UIImage new] forState:UIControlStateNormal];
    [_rightBarEditBtn setTitle:@"管理" forState:UIControlStateNormal];
    [_rightBarEditBtn setTitle:@"完成" forState:UIControlStateSelected];
    _rightBarEditBtn.titleLabel.font = HK_FONT_SYSTEM(14);
    menuView.scrollView.scrollEnabled = NO;
    menuView.hiddenSeparatorLine = YES;
    return CGRectMake(0, 10, SCREEN_WIDTH, kHeight44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0,10, SCREEN_WIDTH, self.view.height);
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


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    if ([viewController isKindOfClass:[LearnedVC class]]||[viewController isKindOfClass:[HKBookStudyRecordVC class]]) {
        self.rightBarEditBtn.hidden = NO;
    } else {
        self.rightBarEditBtn.hidden = YES;
    }
}

- (void)pageController:(WMPageController *)pageController menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index
          currentIndex:(NSInteger)currentIndex{
    if (index == 1) {
        [MobClick event: @"C1703005"];
    }else if (index == 2){
        [MobClick event: @"C1703006"];
    }
}

- (BOOL)menuView:(WMMenuView *)menu shouldSelesctedIndex:(NSInteger)index {

    // 编辑状态不可点击
    if (self.rightBarEditBtn.selected) {
        showTipDialog(@"您正在编辑状态中");
        return NO;
    } else {
        return YES;
    }
}

-(void)menuView:(WMMenuView *)menu moreButtonClick:(UIButton *)button{
    [self rightBarEditBtnClick];
    [MobClick event: @"C1703003"];
}

//// 夜间模式主题模式 发生改变
- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self reloadData];
    }
}


@end



