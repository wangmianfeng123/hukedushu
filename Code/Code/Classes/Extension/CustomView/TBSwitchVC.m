//
//  TBSwitchVC.m
//  TestHk
//
//  Created by hanchuangkeji on 2017/10/31.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBSwitchVC.h"
#import "UIView+HKExtension.h"
#import <objc/runtime.h>

#define HeaderViewHeight 100// 头部的高度（不包括菜单高度）

#define MenuViewHeight 55// 菜单的高度

#define MenuBtnNormalColor [UIColor orangeColor]// 菜单按钮默认颜色

#define MenuBtnDisableColor [UIColor lightGrayColor]// 菜单按钮默认选中颜色

@interface TBSwitchVC ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIScrollView *backGroundScrollView;// containerScollrView的父控件

@property (nonatomic, weak)UIScrollView *containerScollrView;// 所有VC的view的父类view

@property (nonatomic, weak)UIView *headerContainerView;// 头部HeaderView容器

@property (nonatomic, strong)NSMutableArray<UIScrollView *> *scrollViewArray;// 期待滚动的ScrollView

@property (nonatomic, assign)CGFloat headerViewHeight;// 头部高度

@property (nonatomic, weak)UIView *menuView;// 菜单

@property (nonatomic, weak)UIButton *currentBtn;// 当前选中的按钮

@property (nonatomic, strong)NSMutableArray<UIButton *> *btnArray;// 菜单所有的按钮

@property (nonatomic, weak)UIView *indicator;// 指示器

@end

static const char TBRuntimeStoreKey = '\0';

@implementation TBSwitchVC

/**
 代理默认为自己或者子类

 @return 代理对象
 */
- (id<TBSwitchVCDelegate>)delegate {
    if (_delegate == nil) {
        return self;
    }
    return _delegate;
}

- (UIView *)menuView {
    
    if (!_menuView) {
        UIView *menuView = [[UIView alloc] init];
        menuView.frame = CGRectMake(0, self.headerContainerView.height - MenuViewHeight, self.headerContainerView.width, MenuViewHeight);
        [self.headerContainerView addSubview:menuView];
        _menuView = menuView;
    }
    return _menuView;
}

- (NSMutableArray<UIScrollView *> *)scrollViewArray {
    if (!_scrollViewArray) {
        _scrollViewArray = [NSMutableArray array];
    }
    return _scrollViewArray;
}

- (CGFloat)headerViewHeight {
    
    // 用户指定的高度
    if ([self.delegate respondsToSelector:@selector(tb_headerViewHeight)]) {
        return [self tb_headerViewHeight] + MenuViewHeight;
    }
    
    // 用户提供headerView的高度
    if ([self.delegate respondsToSelector:@selector(tb_headerView)]) {
        UIView *view = [self tb_headerView];
        return view.height + MenuViewHeight;
    }
    
    // 默认高度
    return HeaderViewHeight + MenuViewHeight;
}

- (UIScrollView *)backGroundScrollView {
    if (!_backGroundScrollView) {
        UIScrollView *backGroundScrollView = [[UIScrollView alloc] init];
        backGroundScrollView.backgroundColor = [UIColor whiteColor];
        backGroundScrollView.delegate = self;
        backGroundScrollView.frame = self.view.bounds;
        backGroundScrollView.contentSize = CGSizeMake(self.view.width, self.view.height);
        backGroundScrollView.alwaysBounceVertical = YES;
        _backGroundScrollView = backGroundScrollView;
        [self.view addSubview:backGroundScrollView];
        [backGroundScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _backGroundScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupHeaderView];
    
//    [self setupChildVC];
    
    // 兼容iOS11
    HKAdjustsScrollViewInsetNever(self, self.backGroundScrollView);
}

- (void)setupHeaderView {
    
    UIView *headerContainerView = [[UIView alloc] init];
    self.headerContainerView = headerContainerView;
    headerContainerView.frame = CGRectMake(0, 0, self.view.width, self.headerViewHeight);
    headerContainerView.backgroundColor = [UIColor whiteColor];
    [self.backGroundScrollView addSubview:headerContainerView];
    
    // 更新头部的偏移量
    self.backGroundScrollView.contentInset = UIEdgeInsetsMake(0, 0, headerContainerView.height, 0);
    
    // 添加用户指定的HeaderView
    if ([self.delegate respondsToSelector:@selector(tb_headerView)]) {
        UIView *custHeaderView = [self tb_headerView];
        custHeaderView.x = 0;
        custHeaderView.y = 0;
        custHeaderView.width = headerContainerView.width;
        [headerContainerView addSubview:custHeaderView];
    }
}

- (UIButton *)createBtn:(int)i {
    UIButton *button = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 设置样式
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    button.tag = i + 1;
    
    // 设置按钮字体
    NSString *titleString = @"";
    if ([self.delegate respondsToSelector:@selector(tb_menuTitleArray)]) {
        titleString = [self tb_menuTitleArray][i];
    }
    titleString = titleString.length? titleString : [NSString stringWithFormat:@"第%d个", i];
    
    [button setTitle:titleString forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:MenuBtnNormalColor forState:UIControlStateNormal];
    [button setTitleColor:MenuBtnDisableColor forState:UIControlStateDisabled];
    return button;
}

- (void) setupMenu {
    
    // 移除之前所有的按钮
    [self.menuView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.btnArray = [NSMutableArray array];
    
    // 添加按钮
    CGFloat buttonWidth = self.menuView.width / self.childViewControllers.count * 1.0;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        
        
        UIButton * button;
        
        // 用户自定义的按钮
        if ([self.delegate respondsToSelector:@selector(tb_menuBtnArray)]) {
            button = [self tb_menuBtnArray][i];
            
            // 添加点击事件
            button.tag = i + 1;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else {// 系统默认的按钮
            button = [self createBtn:i];
        }
        
        // 默认第一个不可点
        button.enabled = YES;
        if (i == 0) {
            self.currentBtn = button;
            button.enabled = NO;
        }
        
        // 添加到控件
        button.x = buttonWidth * i;
        button.width = buttonWidth;
        button.height = self.menuView.height;
        [self.menuView addSubview:button];
        
        // 添加都按钮总集合
        [self.btnArray addObject:button];
    }
    
    // 添加指示器 用户自定义
    if ([self.delegate respondsToSelector:@selector(tb_indicatorView)]) {
        UIView *indicator = [self tb_indicatorView];
        indicator.centerX = self.btnArray.firstObject.centerX;
        indicator.y = self.menuView.height - indicator.height;
        self.indicator = indicator;
        [self.menuView addSubview:indicator];
    }else {// 系统默认
        UIView *indicator = [[UIView alloc] init];
        indicator.backgroundColor = [UIColor redColor];
        indicator.width = buttonWidth * 0.4;
        indicator.centerX = self.btnArray.firstObject.centerX;
        indicator.height = 2.0;
        indicator.y = self.menuView.height - indicator.height;
        self.indicator = indicator;
        [self.menuView addSubview:indicator];
    }
    
    // 添加分割线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor lightGrayColor];
    separator.frame = CGRectMake(0, self.menuView.height - 0.5, self.menuView.width, 0.5);
    [self.menuView addSubview:separator];
}

- (void)btnClick:(UIButton *)button {
    
    self.currentBtn.enabled = YES;
    self.currentBtn = button;
    self.currentBtn.enabled = NO;
    
    NSInteger page = button.tag - 1;
    // 移动ContentOffset
    [self.containerScollrView setContentOffset:CGPointMake(self.containerScollrView.width * page, self.containerScollrView.contentOffset.y) animated:YES];
    
    // 移动指示器
    [UIView animateWithDuration:0.25 animations:^{
       self.indicator.centerX = button.centerX;
    }];
    
    // 执行代理
    if ([self.delegate respondsToSelector:@selector(tb_didSelected:)]) {
        [self tb_didSelected:(int)page];
    }
}


- (UIScrollView *)containerScollrView {
    if (_containerScollrView == nil) {
        UIScrollView *scollView = [[UIScrollView alloc] init];
        scollView.pagingEnabled = YES;
        scollView.showsVerticalScrollIndicator = NO;
        scollView.showsHorizontalScrollIndicator = NO;
        scollView.frame = self.view.bounds;
        scollView.height = self.backGroundScrollView.height + self.backGroundScrollView.contentInset.bottom;
        [self.backGroundScrollView addSubview:scollView];
        [self.view sendSubviewToBack:scollView];
        scollView.delegate = self;
        scollView.bounces = NO;
        _containerScollrView = scollView;
        [self.backGroundScrollView sendSubviewToBack:scollView];
        [scollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _containerScollrView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.backGroundScrollView) {
        // 代理通知contentOffset改变
        CGPoint point = [change[@"new"] CGPointValue];
        [self tb_scrollViewOffset:point];
    }else {
        
        // 子控件的UIScrllView
        for (int i = 0; i < self.scrollViewArray.count; i++) {
            if (object == self.scrollViewArray[i]) {
                UIScrollView *scrolllView = self.scrollViewArray[i];
                CGPoint point = [change[@"new"] CGPointValue];
                [self tb_scrollViewSubContentInset:point drag:scrolllView.isDragging change:change];
                break;
            }
        }
        
    }
}

- (void)tb_addViewController:(UIViewController *)vc {
    [self setupChildVC:vc];
    
    // 设置菜单按钮
    [self setupMenu];
}

- (void)setupChildVC:(UIViewController *)vc {
    [self addChildViewController:vc];
    [self.containerScollrView addSubview:vc.view];
    [self.containerScollrView sendSubviewToBack:vc.view];
    
    if ([vc respondsToSelector:@selector(tb_expectWhichScrollView)]) {
        [self addExpectWhichScrollView:[vc performSelector:@selector(tb_expectWhichScrollView)]];
    }
    
    // 更新containerScollrView contentSize
    self.containerScollrView.contentSize = CGSizeMake(self.containerScollrView.width * self.childViewControllers.count, self.containerScollrView.height);
    
    // 更新位置子控制器的view
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVC = self.childViewControllers[i];
        childVC.view.frame = CGRectMake(self.view.width * i, 0, self.containerScollrView.width, self.containerScollrView.height);
    }
}

#pragma mark <UIScroViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"contentInset %@", NSStringFromUIEdgeInsets(self.backGroundScrollView.contentInset));
    NSLog(@"contentSize %@", NSStringFromCGSize(self.backGroundScrollView.contentSize));
    NSLog(@"contentOffset %@", NSStringFromCGPoint(self.backGroundScrollView.contentOffset));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.containerScollrView) {
        int currentPage = self.containerScollrView.contentOffset.x / self.containerScollrView.width;
        
        // 移动
        [self btnClick:self.btnArray[currentPage]];
    }
    
}

#pragma mark <TBVC11Delegate>
- (void)tb_scrollViewOffset:(CGPoint)point{
    
    // 改变自身表格的offset
    CGFloat bottom = self.headerViewHeight - point.y;
    for (int i = 0; i < self.scrollViewArray.count; i++) {
        UIScrollView *scrollView = self.scrollViewArray[i];
        
        // 运行时获取原本contentInset
        NSString *contentInsetString = objc_getAssociatedObject(scrollView, &TBRuntimeStoreKey);
        UIEdgeInsets originalContentInset = UIEdgeInsetsFromString(contentInsetString);
        
        scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top, originalContentInset.left , originalContentInset.bottom + bottom, originalContentInset.right);
    }
}

- (void)tb_scrollViewSubContentInset:(CGPoint)point drag:(BOOL)isDragging change:(NSDictionary *)change {
    
    // 已经达到菜单栏限度，还继续往下拉就设置菜单栏
    if (point.y <= -self.headerViewHeight && isDragging) {
        [self.backGroundScrollView setContentOffset:CGPointMake(0, 0)];
    } else if (point.y > -self.headerViewHeight && isDragging) {
        [self.backGroundScrollView setContentOffset:CGPointMake(0, self.headerViewHeight)];
    }
}


- (void)addExpectWhichScrollView:(UIScrollView *)scrollView {
    [self.scrollViewArray addObject:scrollView];
    
    // 更新UIScrollView高度
    scrollView.height += self.headerViewHeight;
    
    // 运行时记录原本contentInset高度
    objc_setAssociatedObject(scrollView, &TBRuntimeStoreKey,
                 NSStringFromUIEdgeInsets(scrollView.contentInset), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // 更新contentInset
    scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top + self.headerViewHeight, scrollView.contentInset.left, scrollView.contentInset.bottom + self.headerViewHeight, scrollView.contentInset.right);
    
    // KVC 监听contentOffset
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}




@end
