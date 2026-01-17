//
//  HKMyLiveVC.m
//  Code
//
//  Created by Ivan li on 2020/12/25.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKMyLiveVC.h"
#import "HKMyLiveListVC.h"
#import "HKFiltrateView.h"
#import "UIView+HKLayer.h"

@interface HKMyLiveVC ()
@property (nonatomic, copy) NSArray<HKMyLiveListVC *> *viewcontrollers;
@property (nonatomic , strong) NSArray * typeArray;
@property (nonatomic , strong) NSArray * titleArray;
@property (nonatomic , strong) HKFiltrateView * filtrateV;
@property (nonatomic , strong) NSArray * tagArray;

@end

@implementation HKMyLiveVC

- (void)bottomVipBtnClick{
    self.filtrateV.hidden = NO;
    self.filtrateV.tagArray= _tagArray;
    [UIView animateWithDuration:0.15 animations:^{
        self.filtrateV.bgView.alpha = 0.3;
    } completion:^(BOOL finished) {
        self.filtrateV.rightMargin.constant = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.filtrateV layoutIfNeeded];
        }];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event: mylivestudio_view];
    // Do any additional setup after loading the view.
    self.title = @"我的直播";
    self.view.backgroundColor = COLOR_F8F9FA_3D4752;
    [self prepareSetup];
    [self createUI];
    [self createMenuView];
}

- (void)createUI {
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.size = CGSizeMake(PADDING_35, PADDING_35);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.hk_hideNavBarShadowImage = YES;
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
}

- (void)createMenuView{
    HKFiltrateView * filtrateV = [HKFiltrateView viewFromXib];
    filtrateV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.navigationController.view addSubview:filtrateV];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.filtrateV.rightMargin.constant = SCREEN_WIDTH;
    });
    
    filtrateV.hidden = YES;
    self.filtrateV = filtrateV;
    self.filtrateV.bgView.alpha = 0.0;
//    @weakify(self);
//    self.filtrateV.cancelFiltrateBlock = ^{
//
//    };
}

- (void)backClick{
    self.filtrateV.rightMargin.constant = SCREEN_WIDTH;
    [UIView animateWithDuration:0.15 animations:^{
        [self.filtrateV layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.filtrateV.bgView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.filtrateV.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)prepareSetup {
    self.typeArray = @[@"0",@"4",@"5",@"1",@"2",@"3"];
    NSMutableArray *arrayVC = [NSMutableArray array];
    for (int i  = 0; i<6; i++) {
        HKMyLiveListVC *VC =  [[HKMyLiveListVC alloc] init];
        VC.type = self.typeArray[i];
        @weakify(self);
        VC.fetchTagArrayBlock = ^(NSArray * _Nonnull tagArray) {
            @strongify(self)
            if (self.tagArray.count == 0) {
                self.tagArray = tagArray;
            }
        };
        //VC.view.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
        [arrayVC addObject:VC];
    }
    self.viewcontrollers = arrayVC;
    //self.automaticallyCalculatesItemWidths = YES;
    self.itemMargin = 5;
    self.titleArray = @[@"全部",@"免费",@"付费",@"直播中",@"即将开播",@"有回放"];
    self.titleSizeNormal = 13;
    self.titleSizeSelected = 13;
    self.menuViewStyle = WMMenuViewStyleFlood;
    self.itemsWidths = @[@55,@55,@55,@65,@75,@65];
    self.progressColor = [UIColor colorWithHexString:@"#FFEAE8"];
    self.titleColorNormal = COLOR_7B8196_A8ABBE;
    self.titleColorSelected = [UIColor colorWithHexString:@"#FF3221"];
    self.progressViewCornerRadius = 15;
    self.progressWidth = 55;
    self.progressColor = [UIColor clearColor];
    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
    
    self.menuColorNormal = COLOR_FFFFFF_3D4752;
    self.menuView.backgroundColor = COLOR_FFFFFF_3D4752;
    
    self.progressHeight = 30;
    [self reloadData];
    self.menuView.hiddenSeparatorLine = YES;
}

-(void)setTagArray:(NSArray *)tagArray{
    _tagArray = tagArray;
    self.filtrateV.tagArray= _tagArray;
}
#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.viewcontrollers.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSString * name = self.titleArray[index];
    for (int i = 0; i< pageController.menuView.scrollView.subviews.count; i++) {
        if ([pageController.menuView.scrollView.subviews[i] isKindOfClass:[WMMenuItem class]]) {
            WMMenuItem * item = pageController.menuView.scrollView.subviews[i];
            NSLog(@"%@=======%@",item.text,name);
            if ([name isEqualToString:item.text]) {
                item.backgroundColor = [UIColor colorWithHexString:@"#FFEAE8"];
            }else{
                item.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
            }
        }
    }
    return self.titleArray[index];
    
}

//- (BOOL)pageController:(WMStickyPageController *)pageController shouldScrollWithSubview:(UIScrollView *)subview {
//
//    return NO;
//}

//视图切换菜单栏 高度
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    //pageController.menuView.selItem.backgroundColor = [UIColor brownColor];
    
    //menuView.hiddenSeparatorLine = YES;
    for (int i = 0; i< pageController.menuView.scrollView.subviews.count; i++) {
        if ([pageController.menuView.scrollView.subviews[i] isKindOfClass:[WMMenuItem class]]) {
            WMMenuItem * item = pageController.menuView.scrollView.subviews[i];
            [item addCornerRadius:15];
        }
    }
    
    //menuView.backgroundColor = COLOR_ffffff;
    [menuView.moreButton setTitle:@"筛选" forState:UIControlStateNormal];
    [menuView.moreButton setTitleColor:COLOR_7B8196_A8ABBE forState:UIControlStateNormal];
    menuView.moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [menuView.moreButton setImage:imageName(@"funnel_gray") forState:UIControlStateNormal];
    return CGRectMake(0, KNavBarHeight64+10, SCREEN_WIDTH, 30);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0,KNavBarHeight64+40, SCREEN_WIDTH, SCREEN_HEIGHT-40);
}

- (void)menuView:(WMMenuView *)menu moreButtonClick:(UIButton *)button {
    [self bottomVipBtnClick];
}

- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"haveStudy"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    HK_NOTIFICATION_REMOVE();
}

@end
