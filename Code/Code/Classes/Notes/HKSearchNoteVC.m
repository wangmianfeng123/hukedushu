//
//  HKSearchNoteVC.m
//  Code
//
//  Created by Ivan li on 2020/12/30.
//  Copyright © 2020 pg. All rights reserved.
//

#import "HKSearchNoteVC.h"
#import "WMPageController+Category.h"
#import "HKSearchCourseNoteVC.h"
#import "HKSearchScreenNoteVC.h"
#import "SearchBar.h"

@interface HKSearchNoteVC ()
@property (nonatomic, copy) NSArray<UIViewController *> *viewcontrollers;
//@property(nonatomic,strong)SearchBar *searchBar;

/** 搜索栏 */
@property (nonatomic , strong) HKSearchCourseNoteVC * vc1;
@property (nonatomic , strong) HKSearchScreenNoteVC * vc2;
@end

@implementation HKSearchNoteVC

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self prepareSetup];
    }
    return self;
}

- (NSArray<UIViewController *> *)viewcontrollers {
    if (_viewcontrollers == nil) {
        self.vc1 = [HKSearchCourseNoteVC new];
        self.vc2 = [HKSearchScreenNoteVC new];
        _viewcontrollers = @[self.vc2,self.vc1];
    }
    return _viewcontrollers;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_FFFFFF_3D4752;
    self.hk_hideNavBarShadowImage = YES;
    
    UIImage *image = [UIImage hkdam_lightOrDarkModeImageWithLightImage:imageName(@"nac_back") darkImage:imageName(@"nac_back_dark")];
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.size = CGSizeMake(18, 35);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self rightBarButtonItemWithTitle:@"搜索" color:[UIColor colorWithHexString:@"#7B8196"] action:@selector(searchBtnClick)];
    [self setSearchBar];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnClick{
    [self.searchBar resignFirstResponder];
    self.vc1.keyWord = self.searchBar.text;
    self.vc2.keyWord = self.searchBar.text;
}

- (void)setSearchBar {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH-16-30 - 56, 44);
    
    self.searchBar = [SearchBar searchBarWithPlaceholder:@"查找笔记/课程关键词" frame:rect];
    self.searchBar.searchBarBackgroundColor = COLOR_EFEFF6_333D48;
    
    if (@available(iOS 11.0, *)) {
        UIView *titleView = [[UIView alloc]initWithFrame:self.searchBar.bounds];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.clipsToBounds = YES;
        [titleView addSubview:self.searchBar];
        self.navigationItem.titleView = titleView;
    }else{
        self.navigationItem.titleView = self.searchBar;
    }
    WeakSelf;
    self.searchBar.searchBarShouldBeginEditingBlock = ^(UISearchBar *searchBar) {
        [searchBar becomeFirstResponder];
        
    };
    
    self.searchBar.searchBarDidSearchBlock = ^{
        [weakSelf searchBtnClick];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchBar becomeFirstResponder];
    });
}

- (void)prepareSetup {
    
    self.titles = @[@"笔记内容",@"课程"];
    self.itemsMargins = @[@15,@20,@20];
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = 0;
    self.selectIndex = 0; // 默认选中 即将开始
    [super prepareSetup];
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    self.titleSizeSelected = 15;
    self.titleSizeNormal = 15;

    
//    self.titles = @[@"精彩回放",@"即将开始"];
//    self.titleSizeNormal = 15;
//    self.titleSizeSelected = 15;
//    self.menuViewStyle = WMMenuViewStyleLine;
//    self.selectIndex = 1; // 默认选中 即将开始
//    self.progressColor = COLOR_fddb3c;
//    self.titleColorNormal = COLOR_A8ABBE;
//    self.titleColorSelected = COLOR_27323F;
//    self.progressWidth = PADDING_30;
//    self.progressHeight = 4;
//    self.isSelectedBold = YES;
//    self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
//    self.menuItemWidth = SCREEN_WIDTH*0.25;
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
    [MobClick event: notelist_search_class];
    return self.viewcontrollers[index];
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}
@end
