//
//  HKVIPCategoryVC.h
//  Code
//
//  Created by hanchuangkeji on 2017/11/27.
//  Copyright © 2017年 pg. All rights reserved.
//


#import "HKProductVideoVC.h"
#import "HKProductCommentVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HKVIPOneYearVC.h"
#import "HKVIPWholeLifeVC.h"
#import "HKTitleBadegeButton.h"
#import "HKProductShortVideoCommentVC.h"
#import "HKProductBookCommentVC.h"

@interface HKProductVideoVC() <UIScrollViewDelegate, HKVIPOneYearVCDelegate>
/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 顶部的所有button */
@property (nonatomic, strong) NSMutableArray<UIButton *> *titlesButtons;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, assign)int page;

@property (nonatomic, assign)int totalPage;
@end

@implementation HKProductVideoVC

- (NSMutableArray<UIButton *> *)titlesButtons {
    if (_titlesButtons == nil) {
        _titlesButtons = [NSMutableArray array];
    }
    return _titlesButtons;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hk_hideNavBarShadowImage = YES;
    // 设置导航栏
    [self setupNav];
    
    // 初始化子控制器
    [self setupChildVces];
    
    [self setupTitlesView];
    
    self.view.backgroundColor = COLOR_F8F9FA_333D48;
}

/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    // 视频评论
    HKProductCommentVC *productCommentVC = [[HKProductCommentVC alloc] init];
    productCommentVC.index = 0;
    WeakSelf;
    productCommentVC.unread_msg_totalBlock = ^(NSString *unread_msg_total, int index) {
        HKTitleBadegeButton *button = (HKTitleBadegeButton *)weakSelf.titlesButtons[index];
        [button setBadegeCount:unread_msg_total];
    };
    productCommentVC.title = @"视频评论";
    [self addChildViewController:productCommentVC];
    
    // 作品评论
//    HKProductCommentVC *productCommentVC2 = [[HKProductCommentVC alloc] init];
//    productCommentVC2.title = @"短视频";
//    [self addChildViewController:productCommentVC2];
    
    
    HKProductShortVideoCommentVC *productShortVideoCommentVC = [[HKProductShortVideoCommentVC alloc] init];
    productShortVideoCommentVC.index = 1;
    productShortVideoCommentVC.unread_msg_totalBlock = ^(NSString *unread_msg_total, int index) {
        HKTitleBadegeButton *button = (HKTitleBadegeButton *)weakSelf.titlesButtons[index];
        [button setBadegeCount:unread_msg_total];
    };
    productShortVideoCommentVC.title = @"短视频";
    [self addChildViewController:productShortVideoCommentVC];
    
    
    //读书
    HKProductBookCommentVC *bookCommentVC = [[HKProductBookCommentVC alloc]init];
    bookCommentVC.index = 2;
    bookCommentVC.unread_msg_totalBlock = ^(NSString *unread_msg_total, int index) {
        HKTitleBadegeButton *button = (HKTitleBadegeButton *)weakSelf.titlesButtons[index];
        [button setBadegeCount:unread_msg_total];
    };
    bookCommentVC.title = @"虎课读书";
    [self addChildViewController:bookCommentVC];
    
    
    [self.contentView addSubview:productCommentVC.view];
    [self.contentView addSubview:productShortVideoCommentVC.view];
    [self.contentView addSubview:bookCommentVC.view];

}

/**
 * 设置顶部的标签栏
 */
- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = COLOR_FFFFFF_3D4752;
    titlesView.width = self.view.width;
    titlesView.height = 40;
    
    titlesView.y = KNavBarHeight64;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = HKColorFromHex(0xFDDB3C, 1.0);
    indicatorView.height = 4;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 推荐按钮
    UIImageView *recommendIV = nil;
    // 内部的子标签 特殊处理仅有一个
//    CGFloat width = self.childViewControllers.count == 1? 122 : (titlesView.width / self.childViewControllers.count);
    CGFloat height = 30;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        HKTitleBadegeButton *button = [[HKTitleBadegeButton alloc] init];
        button.tag = i;
        button.y = titlesView.height - height - 9;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        button.height = height;
        
        UIViewController *vc = self.childViewControllers[i];
        CGSize size = [vc.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
        CGFloat realWidth = size.width + 22.0 * 2;
        
        button.width = realWidth;
        button.x = CGRectGetMaxX(self.titlesButtons.lastObject.frame);
        [button setTitle:vc.title forState:UIControlStateNormal];
        //      [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:HKColorFromHex(0x7B8196, 1.0) forState:UIControlStateNormal];
        [button setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        // 文字状态
        NSMutableAttributedString *attrNormal = [[NSMutableAttributedString alloc] initWithString:vc.title];
        [attrNormal addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, vc.title.length)];
        [attrNormal addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular] range:NSMakeRange(0, vc.title.length)];
        [button setAttributedTitle:attrNormal forState:UIControlStateNormal];
        NSMutableAttributedString *attrDisable = [[NSMutableAttributedString alloc] initWithString:vc.title];
        [attrDisable addAttribute:NSForegroundColorAttributeName value:COLOR_27323F_EFEFF6 range:NSMakeRange(0, vc.title.length)];
        [attrDisable addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium] range:NSMakeRange(0, vc.title.length)];
        [button setAttributedTitle:attrDisable forState:UIControlStateDisabled];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        [self.titlesButtons addObject:button];
        
        // 默认点击了第page个按钮
        if (i == self.page) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = 18.0;
            self.indicatorView.centerX = button.centerX;
        }
        
        if ((self.totalPage == 2 && i == 0)  || (self.totalPage == 3 && i == 1))  {
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            // 为第一个添加一个推荐image
            recommendIV = [[UIImageView alloc] init];
            if (self.totalPage == 3) {
                recommendIV.frame = CGRectMake(CGRectGetMaxX(button.frame) - 27, button.centerY - 7.5, 12, 12);
            } else {
                recommendIV.frame = CGRectMake(CGRectGetMaxX(button.titleLabel.frame) - 30, button.centerY - 1.5, 12, 12);
            }
            recommendIV.image = imageName(@"vip_recommend");
        }
    }
    
    
    [titlesView addSubview:recommendIV];
    recommendIV.hidden = YES; // 2.2.0版本不要了
    [titlesView addSubview:indicatorView];
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor hkdm_colorWithColorLight:COLOR_EFEFF6 dark:COLOR_333D48];
    separator.width = SCREEN_WIDTH;
    separator.height = 0.5;
    separator.y = titlesView.height;
    [titlesView addSubview:separator];
    
    // 底部的scrollView
    [self setupContentView];
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
//        self.indicatorView.width = button.titleLabel.width * 0.45;
        self.indicatorView.width = 18.0;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动
    self.contentView.bounces = NO;//  禁止滚动View在边缘 反弹
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 100);
    self.contentView = contentView;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.bounces = YES;
    // 添加第一个控制器的view
    [contentView setContentOffset:CGPointMake(contentView.width * self.page, contentView.contentOffset.y)];
    [self scrollViewDidEndScrollingAnimation:contentView];
}

/**
 * 设置导航栏1
 */
- (void)setupNav {
    
    self.title = @"评论/回复";
    [self createLeftBarButton];
    
    [self setRightBarButtonItem];
}

- (void)setRightBarButtonItem {
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 40);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setTitle:@"一键已读" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:COLOR_27323F_EFEFF6 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(allRedBtnClickedTap) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    NSLog(@"self.navigationControlle %@", self.navigationController);
    NSLog(@"self.parentViewController.navigationController %@", self.parentViewController.navigationController);
}

- (void)allRedBtnClickedTap {
    
    // 当前的索引
    NSInteger index = self.contentView.contentOffset.x / self.contentView.width;
    
    // 点击已读
    HKProductCommentVC *productCommentVC = self.childViewControllers[index];
    [productCommentVC allRedBtnClicked];
}



- (void)tagClick
{
//    HKVIPAllPlatformVC *tags = [[HKVIPAllPlatformVC alloc] init];
//    [self.navigationController pushViewController:tags animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // 解决边缘的pop手势冲突
//    if (scrollView.contentOffset.x <= -30 ) {
//        [self backAction];
//    }
//}


#pragma mark <Server>


#pragma mark <HKVIPOneYearVCDelegate>
- (void)moveToNextVC {
    [self titleClick:self.titlesButtons.lastObject];
}

@end

