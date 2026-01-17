//
//  HKVIPCategoryVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBaseVC.h"
#import "TBSwitchVC.h"
#import "HKBuyVipModel.h"

@interface HKVIPCategoryVC_replace : HKBaseVC

//@property (nonatomic, strong)HKBuyVipModel *selectedVipModel; // 选中需要的购买VIP

//class_type  （999 跳转全站通界面） （9999-跳转终身界面）
@property (nonatomic, strong)NSString *class_type; // 选中需要的购买VIP
@property (nonatomic, strong)NSString *button_type; // 选中需要的购买VIP

@property (nonatomic, assign)BOOL isShowDialg; // 显示弹框下载受限说明
@property (nonatomic, copy) NSString * isTabModule;  //如果是tab上需要隐藏按钮

@end







//
////
////  HKVIPCategoryVC.h
////  Code
////
////  Created by hanchuangkeji on 2017/11/27.
////  Copyright © 2017年 pg. All rights reserved.
////
//
//
//#import "HKVIPCategoryVC.h"
//#import "HKVIPOtherVC.h"
//#import "UIBarButtonItem+Extension.h"
//#import "HKVIPOneYearVC.h"
//#import "HKVIPWholeLifeVC.h"
//
//@interface HKVIPCategoryVC() <UIScrollViewDelegate, HKVIPOneYearVCDelegate>
///** 标签栏底部的红色指示器 */
//@property (nonatomic, weak) UIView *indicatorView;
///** 当前选中的按钮 */
//@property (nonatomic, weak) UIButton *selectedButton;
///** 顶部的所有标签 */
//@property (nonatomic, weak) UIView *titlesView;
///** 顶部的所有button */
//@property (nonatomic, strong) NSMutableArray<UIButton *> *titlesButtons;
///** 底部的所有内容 */
//@property (nonatomic, weak) UIScrollView *contentView;
//
//@property (nonatomic, assign)int page;
//
//@property (nonatomic, assign)int totalPage;
//@end
//
//@implementation HKVIPCategoryVC
//
//- (NSMutableArray<UIButton *> *)titlesButtons {
//    if (_titlesButtons == nil) {
//        _titlesButtons = [NSMutableArray array];
//    }
//    return _titlesButtons;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.hk_hideNavBarShadowImage = YES;
//    // 设置导航栏
//    [self setupNav];
//    
//    // 设置顶部的标签栏
//    [self getVIPList];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//}
//
///**
// * 初始化子控制器
// */
//- (void)setupChildVces
//{
//    // 分类VIP
//    HKVIPOtherVC *otherVIP = [[HKVIPOtherVC alloc] init];
//    otherVIP.title = @"分类VIP";
//    otherVIP.class_type = self.class_type;
//    otherVIP.button_type = self.button_type;
//    otherVIP.isShowDialg = self.isShowDialg;
//    [self addChildViewController:otherVIP];
//
//    // 一年全站VIP
//    HKVIPOneYearVC *all = [[HKVIPOneYearVC alloc] init];
//    all.delegate = self;
//    all.button_type = self.button_type;
//    all.isShowDialg = self.isShowDialg;
//    all.title = @"全站通VIP";
//    [self addChildViewController:all];
//    
//    // 终身全站通VIP
//    if (self.totalPage == 3) {
//        HKVIPWholeLifeVC *wholeLifeVC = [[HKVIPWholeLifeVC alloc] init];
//        wholeLifeVC.title = @"终身VIP";
//        wholeLifeVC.isShowDialg = self.isShowDialg;
//        wholeLifeVC.button_type = self.button_type;
//        [self addChildViewController:wholeLifeVC];
//    }
//
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //[self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor colorWithHexString:@"#303030"]colorWithAlphaComponent:1.0]];
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    //[self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
//}
//
///**
// * 设置顶部的标签栏
// */
//- (void)setupTitlesView
//{
//    // 标签栏整体
//    UIView *titlesView = [[UIView alloc] init];
//    titlesView.backgroundColor = HKColorFromHex(0xFFFFFF, 1.0);
//    titlesView.width = self.view.width;
//    titlesView.height = 40;
//    
//    titlesView.y = KNavBarHeight64;
//    [self.view addSubview:titlesView];
//    self.titlesView = titlesView;
//    
//    // 底部的红色指示器
//    UIView *indicatorView = [[UIView alloc] init];
//    indicatorView.backgroundColor = HKColorFromHex(0xFDDB3C, 1.0);
//    indicatorView.height = 4;
//    indicatorView.tag = -1;
//    indicatorView.y = titlesView.height - indicatorView.height;
//    self.indicatorView = indicatorView;
//    
//    // 推荐按钮
//    UIImageView *recommendIV = nil;
//    // 内部的子标签
//    CGFloat width = titlesView.width / self.childViewControllers.count;
//    CGFloat height = 30;
//    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
//        UIButton *button = [[UIButton alloc] init];
//        [self.titlesButtons addObject:button];
//        button.tag = i;
//        button.y = titlesView.height - height - 9;
//        button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//        button.height = height;
//        button.width = width;
//        button.x = i * width;
//        UIViewController *vc = self.childViewControllers[i];
//        [button setTitle:vc.title forState:UIControlStateNormal];
//        //      [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
//        [button setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateNormal];
//        [button setTitleColor:HKColorFromHex(0x27323F, 1.0) forState:UIControlStateDisabled];
//        button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
//        
//        // 文字状态
//        vc.title = vc.title.length? vc.title : @" "; // 防止为空崩溃
//        NSMutableAttributedString *attrNormal = [[NSMutableAttributedString alloc] initWithString:vc.title];
//        [attrNormal addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, vc.title.length)];
//        [attrNormal addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular] range:NSMakeRange(0, vc.title.length)];
//        [button setAttributedTitle:attrNormal forState:UIControlStateNormal];
//        NSMutableAttributedString *attrDisable = [[NSMutableAttributedString alloc] initWithString:vc.title];
//        [attrDisable addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x27323F, 1.0) range:NSMakeRange(0, vc.title.length)];
//        [attrDisable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] range:NSMakeRange(0, vc.title.length)];
//        [button setAttributedTitle:attrDisable forState:UIControlStateDisabled];
//        
//        
//        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
//        [titlesView addSubview:button];
//        
//        // 默认点击了第page个按钮
//        if (i == self.page) {
//            button.enabled = NO;
//            self.selectedButton = button;
//            
//            // 让按钮内部的label根据文字内容来计算尺寸
//            [button.titleLabel sizeToFit];
//            self.indicatorView.width = button.titleLabel.width * 0.45;
//            self.indicatorView.centerX = button.centerX;
//        }
//        
//        if ((self.totalPage == 2 && i == 0)  || (self.totalPage == 3 && i == 1))  {
//            // 让按钮内部的label根据文字内容来计算尺寸
//            [button.titleLabel sizeToFit];
//            // 为第一个添加一个推荐image
//            recommendIV = [[UIImageView alloc] init];
//            if (self.totalPage == 3) {
//                recommendIV.frame = CGRectMake(CGRectGetMaxX(button.frame) - 27, button.centerY - 7.5, 14, 14);
//                if (IS_IPHONEMORE4_7INCH) {
//                    recommendIV.x = recommendIV.x - 3;
//                }
//            } else {
//                recommendIV.frame = CGRectMake(CGRectGetMaxX(button.titleLabel.frame) - 30, button.centerY - 1.5, 14, 14);
//                if (IS_IPHONEMORE4_7INCH) {
//                    recommendIV.x = recommendIV.x - 3;
//                }
//            }
//            recommendIV.image = imageName(@"vip_recommend");
//        }
//    }
//    
//    [titlesView addSubview:recommendIV];
////    recommendIV.hidden = YES; // 2.2.0版本不要了
//    [titlesView addSubview:indicatorView];
//    
//    // 底部的scrollView
//    [self setupContentView];
//}
//
//- (void)titleClick:(UIButton *)button
//{
//    // 修改按钮状态
//    self.selectedButton.enabled = YES;
//    button.enabled = NO;
//    self.selectedButton = button;
//    
//    // 动画
//    [UIView animateWithDuration:0.25 animations:^{
//        self.indicatorView.width = button.titleLabel.width * 0.45;
//        self.indicatorView.centerX = button.centerX;
//    }];
//    
//    // 滚动
//    self.contentView.bounces = NO;//  禁止滚动View在边缘 反弹
//    CGPoint offset = self.contentView.contentOffset;
//    offset.x = button.tag * self.contentView.width;
//    [self.contentView setContentOffset:offset animated:YES];
//}
//
///**
// * 底部的scrollView
// */
//- (void)setupContentView
//{
//    // 不要自动调整inset
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIScrollView *contentView = [[UIScrollView alloc] init];
//    contentView.frame = self.view.bounds;
//    contentView.delegate = self;
//    contentView.pagingEnabled = YES;
//    [self.view insertSubview:contentView atIndex:0];
//    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 100);
//    self.contentView = contentView;
//    contentView.showsHorizontalScrollIndicator = NO;
//    contentView.bounces = YES;
//    // 添加第一个控制器的view
//    [contentView setContentOffset:CGPointMake(contentView.width * self.page, contentView.contentOffset.y)];
//    [self scrollViewDidEndScrollingAnimation:contentView];
//    // 支持侧滑
//    if (self.navigationController.interactivePopGestureRecognizer) {
//        [contentView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//    }
//}
//
///**
// * 设置导航栏1
// */
//- (void)setupNav {
//    
//    self.title = @"VIP会员";
//    [self createLeftBarButton];
//}
//
//
//
//- (void)tagClick
//{
////    HKVIPAllPlatformVC *tags = [[HKVIPAllPlatformVC alloc] init];
////    [self.navigationController pushViewController:tags animated:YES];
//}
//
//#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    // 当前的索引
//    NSInteger index = scrollView.contentOffset.x / scrollView.width;
//    
//    // 取出子控制器
//    UIViewController *vc = self.childViewControllers[index];
//    vc.view.x = scrollView.contentOffset.x;
//    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
//    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
//    [scrollView addSubview:vc.view];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self scrollViewDidEndScrollingAnimation:scrollView];
//    
//    // 点击按钮
//    NSInteger index = scrollView.contentOffset.x / scrollView.width;
//    [self titleClick:self.titlesView.subviews[index]];
//}
//
//
////- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    // 解决边缘的pop手势冲突
////    if (scrollView.contentOffset.x <= -30 ) {
////        [self backAction];
////    }
////}
//
//
//#pragma mark <Server>
//- (void)getVIPList{
//    
//    NSDictionary *param = nil;
//    if (self.class_type.length) {
//        param = @{@"class_type" : self.class_type};
//    }
//    
//    [HKHttpTool POST:@"/vip/vip-list" parameters:param success:^(id responseObject) {
//        
//        if (HKReponseOK) {
//            
//            HKBuyVipModel *wholeLifeVIP = [HKBuyVipModel mj_objectWithKeyValues:responseObject[@"data"][@"lifelong_all_vip_data"]];
//            wholeLifeVIP.is_show = YES; // 2.4默认显示
//            
//            NSMutableArray *tabArr = [HKVipTabModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tab_list"]];
//            
//            
//            // 默认选中第几个
//            NSString* page_type = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"page_type"]];
//            int page = page_type.intValue;
//            page = page >= 3? 0 : page;
//            
//            // 2.2版本对调了位置
//            if (page == 2) {
//                page = 0;
//            } else if (page == 0 && wholeLifeVIP.is_show) {
//                page = 2;
//            }
//            
//            // 当前多少页，总共多少页
//            self.page = page;
//            self.totalPage = wholeLifeVIP.is_show? 3 : 2;
//            
//            // 初始化子控制器
//            [self setupChildVces];
//            
//            [self setupTitlesView];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}
//
//
//#pragma mark <HKVIPOneYearVCDelegate>
//- (void)moveToNextVC {
//    [self titleClick:self.titlesButtons.lastObject];
//}
//
//@end
//








/****************** tab 接口可控 ******************/

//
//
////
////  HKVIPCategoryVC.h
////  Code
////
////  Created by hanchuangkeji on 2017/11/27.
////  Copyright © 2017年 pg. All rights reserved.
////
//
//
//#import "HKVIPCategoryVC.h"
//#import "HKVIPOtherVC.h"
//#import "UIBarButtonItem+Extension.h"
//#import "HKVIPOneYearVC.h"
//#import "HKVIPWholeLifeVC.h"
//
//@interface HKVIPCategoryVC() <UIScrollViewDelegate, HKVIPOneYearVCDelegate>
///** 标签栏底部的红色指示器 */
//@property (nonatomic, weak) UIView *indicatorView;
///** 当前选中的按钮 */
//@property (nonatomic, weak) UIButton *selectedButton;
///** 顶部的所有标签 */
//@property (nonatomic, weak) UIView *titlesView;
///** 顶部的所有button */
//@property (nonatomic, strong) NSMutableArray<UIButton *> *titlesButtons;
///** 底部的所有内容 */
//@property (nonatomic, weak) UIScrollView *contentView;
//
//@property (nonatomic, assign)int page;
//
//@property (nonatomic, assign)int totalPage;
//
//@property (nonatomic, strong)NSMutableArray <HKVipTabModel*> *tabArr;
//
//
//@end
//
//@implementation HKVIPCategoryVC
//
//- (NSMutableArray<UIButton *> *)titlesButtons {
//    if (_titlesButtons == nil) {
//        _titlesButtons = [NSMutableArray array];
//    }
//    return _titlesButtons;
//}
//
//
//
//- (NSMutableArray<HKVipTabModel *> *)tabArr {
//    if (_tabArr == nil) {
//        _tabArr = [NSMutableArray array];
//    }
//    return _tabArr;
//}
//
//
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.hk_hideNavBarShadowImage = YES;
//    // 设置导航栏
//    [self setupNav];
//
//    // 设置顶部的标签栏
//    [self getVIPList];
//
//    self.view.backgroundColor = [UIColor whiteColor];
//}
//
///**
// * 初始化子控制器
// */
//- (void)setupChildVces
//{
//    // 分类VIP
//    HKVIPOtherVC *otherVIP = [[HKVIPOtherVC alloc] init];
//    otherVIP.title = @"分类VIP";
//    otherVIP.class_type = self.class_type;
//    otherVIP.button_type = self.button_type;
//    otherVIP.isShowDialg = self.isShowDialg;
//    [self addChildViewController:otherVIP];
//
//    // 一年全站VIP
//    HKVIPOneYearVC *all = [[HKVIPOneYearVC alloc] init];
//    all.delegate = self;
//    all.button_type = self.button_type;
//    all.isShowDialg = self.isShowDialg;
//    all.title = @"全站通VIP";
//    [self addChildViewController:all];
//
//    // 终身全站通VIP
//    if (self.totalPage == 3) {
//        HKVIPWholeLifeVC *wholeLifeVC = [[HKVIPWholeLifeVC alloc] init];
//        wholeLifeVC.title = @"终身VIP";
//        wholeLifeVC.isShowDialg = self.isShowDialg;
//        wholeLifeVC.button_type = self.button_type;
//        [self addChildViewController:wholeLifeVC];
//    }
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //[self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor colorWithHexString:@"#303030"]colorWithAlphaComponent:1.0]];
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    //[self.navigationController.navigationBar lt_setBackgroundColor:NAVBAR_Color];
//}
//
///**
// * 设置顶部的标签栏
// */
//- (void)setupTitlesView
//{
//    // 标签栏整体
//    UIView *titlesView = [[UIView alloc] init];
//    titlesView.backgroundColor = HKColorFromHex(0xFFFFFF, 1.0);
//    titlesView.width = self.view.width;
//    titlesView.height = 40;
//
//    titlesView.y = KNavBarHeight64;
//    [self.view addSubview:titlesView];
//    self.titlesView = titlesView;
//
//    // 底部的红色指示器
//    UIView *indicatorView = [[UIView alloc] init];
//    indicatorView.backgroundColor = HKColorFromHex(0xFDDB3C, 1.0);
//    indicatorView.height = 4;
//    indicatorView.tag = -1;
//    indicatorView.y = titlesView.height - indicatorView.height;
//    self.indicatorView = indicatorView;
//
//    // 推荐按钮
//    UIImageView *recommendIV = nil;
//    // 内部的子标签
//    CGFloat width = titlesView.width / self.childViewControllers.count;
//    CGFloat height = 30;
//    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
//        UIButton *button = [[UIButton alloc] init];
//        [self.titlesButtons addObject:button];
//        button.tag = i;
//        button.y = titlesView.height - height - 9;
//        button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//        button.height = height;
//        button.width = width;
//        button.x = i * width;
//        UIViewController *vc = self.childViewControllers[i];
//        [button setTitle:vc.title forState:UIControlStateNormal];
//        //      [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
//        [button setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateNormal];
//        [button setTitleColor:HKColorFromHex(0x27323F, 1.0) forState:UIControlStateDisabled];
//        button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
//
//        // 文字状态
//        vc.title = vc.title.length? vc.title : @" "; // 防止为空崩溃
//        NSMutableAttributedString *attrNormal = [[NSMutableAttributedString alloc] initWithString:vc.title];
//        [attrNormal addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x7B8196, 1.0) range:NSMakeRange(0, vc.title.length)];
//        [attrNormal addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular] range:NSMakeRange(0, vc.title.length)];
//        [button setAttributedTitle:attrNormal forState:UIControlStateNormal];
//        NSMutableAttributedString *attrDisable = [[NSMutableAttributedString alloc] initWithString:vc.title];
//        [attrDisable addAttribute:NSForegroundColorAttributeName value:HKColorFromHex(0x27323F, 1.0) range:NSMakeRange(0, vc.title.length)];
//        [attrDisable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] range:NSMakeRange(0, vc.title.length)];
//        [button setAttributedTitle:attrDisable forState:UIControlStateDisabled];
//
//
//        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
//        [titlesView addSubview:button];
//
//        // 默认点击了第page个按钮
//        if (i == self.page) {
//            button.enabled = NO;
//            self.selectedButton = button;
//
//            // 让按钮内部的label根据文字内容来计算尺寸
//            [button.titleLabel sizeToFit];
//            self.indicatorView.width = button.titleLabel.width * 0.45;
//            self.indicatorView.centerX = button.centerX;
//        }
//
//        if ((self.totalPage == 2 && i == 0)  || (self.totalPage == 3 && i == 1))  {
//            // 让按钮内部的label根据文字内容来计算尺寸
//            [button.titleLabel sizeToFit];
//            // 为第一个添加一个推荐image
//            recommendIV = [[UIImageView alloc] init];
//            if (self.totalPage == 3) {
//                recommendIV.frame = CGRectMake(CGRectGetMaxX(button.frame) - 27, button.centerY - 7.5, 14, 14);
//                if (IS_IPHONEMORE4_7INCH) {
//                    recommendIV.x = recommendIV.x - 3;
//                }
//            } else {
//                recommendIV.frame = CGRectMake(CGRectGetMaxX(button.titleLabel.frame) - 30, button.centerY - 1.5, 14, 14);
//                if (IS_IPHONEMORE4_7INCH) {
//                    recommendIV.x = recommendIV.x - 3;
//                }
//            }
//            recommendIV.image = imageName(@"vip_recommend");
//        }
//    }
//
//    [titlesView addSubview:recommendIV];
////    recommendIV.hidden = YES; // 2.2.0版本不要了
//    [titlesView addSubview:indicatorView];
//
//    // 底部的scrollView
//    [self setupContentView];
//}
//
//- (void)titleClick:(UIButton *)button
//{
//    // 修改按钮状态
//    self.selectedButton.enabled = YES;
//    button.enabled = NO;
//    self.selectedButton = button;
//
//    // 动画
//    [UIView animateWithDuration:0.25 animations:^{
//        self.indicatorView.width = button.titleLabel.width * 0.45;
//        self.indicatorView.centerX = button.centerX;
//    }];
//
//    // 滚动
//    self.contentView.bounces = NO;//  禁止滚动View在边缘 反弹
//    CGPoint offset = self.contentView.contentOffset;
//    offset.x = button.tag * self.contentView.width;
//    [self.contentView setContentOffset:offset animated:YES];
//}
//
///**
// * 底部的scrollView
// */
//- (void)setupContentView
//{
//    // 不要自动调整inset
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIScrollView *contentView = [[UIScrollView alloc] init];
//    contentView.frame = self.view.bounds;
//    contentView.delegate = self;
//    contentView.pagingEnabled = YES;
//    [self.view insertSubview:contentView atIndex:0];
//    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 100);
//    self.contentView = contentView;
//    contentView.showsHorizontalScrollIndicator = NO;
//    contentView.bounces = YES;
//    // 添加第一个控制器的view
//    [contentView setContentOffset:CGPointMake(contentView.width * self.page, contentView.contentOffset.y)];
//    [self scrollViewDidEndScrollingAnimation:contentView];
//    // 支持侧滑
//    if (self.navigationController.interactivePopGestureRecognizer) {
//        [contentView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//    }
//}
//
///**
// * 设置导航栏1
// */
//- (void)setupNav {
//
//    self.title = @"VIP会员";
//    [self createLeftBarButton];
//}
//
//
//
//- (void)tagClick
//{
////    HKVIPAllPlatformVC *tags = [[HKVIPAllPlatformVC alloc] init];
////    [self.navigationController pushViewController:tags animated:YES];
//}
//
//#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    // 当前的索引
//    NSInteger index = scrollView.contentOffset.x / scrollView.width;
//
//    // 取出子控制器
//    UIViewController *vc = self.childViewControllers[index];
//    vc.view.x = scrollView.contentOffset.x;
//    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
//    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
//    [scrollView addSubview:vc.view];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self scrollViewDidEndScrollingAnimation:scrollView];
//
//    // 点击按钮
//    NSInteger index = scrollView.contentOffset.x / scrollView.width;
//    [self titleClick:self.titlesView.subviews[index]];
//}
//
//
////- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
////    // 解决边缘的pop手势冲突
////    if (scrollView.contentOffset.x <= -30 ) {
////        [self backAction];
////    }
////}
//
//
//#pragma mark <Server>
//- (void)getVIPList{
//
//    NSDictionary *param = nil;
//    if (self.class_type.length) {
//        param = @{@"class_type" : self.class_type};
//    }
//
//    [HKHttpTool POST:@"/vip/vip-list" parameters:param success:^(id responseObject) {
//
//        if (HKReponseOK) {
//            NSMutableArray *tabArr = [HKVipTabModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"tab_list"]];
//            self.tabArr = tabArr;
//
//            // 默认选中第几个
//            NSString* page_type = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"page_type"]];
//            int page = page_type.intValue;
//            page = page >= 3? 0 : page;
//
//            // 当前多少页，总共多少页
//            self.page = page;
//            self.totalPage = tabArr.count;
//
//            // 初始化子控制器
//            [self setupChildVces];
//
//            [self setupTitlesView];
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}
//
//
//#pragma mark <HKVIPOneYearVCDelegate>
//- (void)moveToNextVC {
//    [self titleClick:self.titlesButtons.lastObject];
//}
//
//@end
//
