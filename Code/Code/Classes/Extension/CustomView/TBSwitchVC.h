//
//  TBSwitchVC.h
//  TestHk
//
//  Created by hanchuangkeji on 2017/10/31.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKBaseVC.h"

@protocol TBSwitchVCExpectedScrollViewDelegate <NSObject>

@required

// 期待滚动的UIScrollView
- (UIScrollView *)tb_expectWhichScrollView;

@end

@protocol TBSwitchVCDelegate <NSObject>

@optional

// 头部的高度（不包括菜单按钮高度）
- (CGFloat)tb_headerViewHeight;

// 头部的view
- (UIView *)tb_headerView;

// 菜单选中的序列
- (void)tb_didSelected:(int)currentPage;

// 菜单的指示器（红色横线）
- (UIView *)tb_indicatorView;

// 菜单的文字
- (NSArray<NSString *> *)tb_menuTitleArray;

// 菜单的按钮
- (NSArray<UIButton *> *)tb_menuBtnArray;

@end




@interface TBSwitchVC : HKBaseVC <TBSwitchVCDelegate>

// 添加VC
- (void)tb_addViewController:(UIViewController *)vc;

// 代理
@property (nonatomic, weak)id<TBSwitchVCDelegate> delegate;

@end
