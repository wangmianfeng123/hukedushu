//
//  MJRefreshAutoNormalFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshAutoNormalFooter.h"
@import FluentDarkModeKit;

@interface MJRefreshAutoNormalFooter()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MJRefreshAutoNormalFooter
#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    if (@available(iOS 13.0, *)) {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        [self updateActivityIndicatorViewStyle];
    } else {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
}


// APP主题变化
- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection {
    [self updateActivityIndicatorViewStyle];
}


// 更新 加载菊花的 类型
- (void)updateActivityIndicatorViewStyle {
    if (@available(iOS 13.0, *)) {
        DMUserInterfaceStyle style = DMTraitCollection.currentTraitCollection.userInterfaceStyle;
        if ((DMUserInterfaceStyleDark == style)) {
            [self.loadingView setColor:[UIColor whiteColor]];
        }else{
            [self.loadingView setColor:[UIColor grayColor]];
        }
    }
}


- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.mj_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= self.stateLabel.mj_textWith * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}

@end
