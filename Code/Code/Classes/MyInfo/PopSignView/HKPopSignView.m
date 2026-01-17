//
//  HKPopSignView.m
//  Code
//
//  Created by Ivan li on 2017/11/16.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "HKPopSignView.h"
#import "AppDelegate.h"

static CGFloat animationTime = 0.25; //动画时间。从下面移动到上面

@interface HKPopSignView()

@property(nonatomic,strong)UIImageView *maskView; //背景视图

@property(nonatomic,strong)UIImageView *arrowView; //向下箭头

@property(nonatomic,strong)UIImageView *signView;

@property(nonatomic,assign)CGFloat bgViewHeith;

@end


@implementation HKPopSignView


- (instancetype)init {
    
    if (self = [super init]) {
        [self setUI];
        [self showPickView];
    }
    return self;
}


- (void)setUI {
    self.backgroundColor = [UIColor clearColor];//[[UIColor grayColor]colorWithAlphaComponent:0.3];
    self.frame = [self frontWindow].bounds;
    [[self frontWindow] addSubview:self];
    
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.signView];
    [self.maskView addSubview:self.arrowView];
    
}


#pragma mark - FrontWindow
- (UIWindow *)frontWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}



- (UIImageView*)maskView {
    if (!_maskView) {
        
        UIImage *image = imageName(@"sign_tip");
        UIImage *image1 = imageName(@"arrow_down");
        _bgViewHeith = image.size.height+image1.size.height;
        _maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bgViewHeith)];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}


- (UIImageView*)signView {
    if (!_signView) {
        UIImage *image = imageName(@"sign_tip");
        _signView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, image.size.height)];
        _signView.contentMode = UIViewContentModeScaleToFill;
        _signView.image = image;
        _signView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView)];
        [_signView addGestureRecognizer:tap];
    }
    return _signView;
}



- (void)hidePopView {
    self.selectBlock(@"dd");
    [self hidePickView];
}


- (UIImageView*)arrowView {
    if (!_arrowView) {
        UIImage *image = imageName(@"arrow_down");
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake([self tabitemPointX]-image.size.width/2, _signView.y+_signView.height, image.size.width, image.size.height)];
        _arrowView.image = image;
    }
    return _arrowView;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([[touches anyObject].view isKindOfClass:[UIImageView class]]){
        
    }else{
        [self hidePickView];
    }
}


//显示
- (void)showPickView {
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height - _bgViewHeith-kHeight49-PADDING_10, SCREEN_WIDTH, _bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}

//隐藏
- (void)hidePickView{
    
    [UIView animateWithDuration:animationTime animations:^{
        self.maskView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, _bgViewHeith);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


//tabitem 坐标
- (CGFloat)tabitemPointX {
    UITabBarController *tbc = [AppDelegate sharedAppDelegate].window.rootViewController;
    CGRect itemFrame = [self getTabBarItemFrameWithTabBar:tbc.tabBar index:3];
    return itemFrame.origin.x + itemFrame.size.width/2;
}



- (CGRect)getTabBarItemFrameWithTabBar:(UITabBar *)tabBar index:(NSInteger)index
{
    //遍历出tabBarItems
    NSMutableArray *tabBarItems = [NSMutableArray array];
    for (UIView *view in tabBar.subviews) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITabBarButton"]) {
            [tabBarItems addObject:view];
        }
    }
    //根据frame的X从小到大对tabBarItems进行排序
    NSArray *sortedTabBarItems= [tabBarItems sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2){
        return [@(view1.frame.origin.x) compare:@(view2.frame.origin.x)];
    }];
    //找到指定的tabBarItem 并优化其相对于屏幕的位置
    NSInteger i = 0;
    CGRect itemFrame = CGRectZero;
    for (UIView *view in sortedTabBarItems) {
        if (index == i) {
            itemFrame = view.frame;
            itemFrame.origin.y = SCREEN_HEIGHT - itemFrame.size.height;
            break;
        }
        i++;
    }
    return itemFrame;
}



- (void)dealloc {
    NSLog(@"sign dealloc");
}

@end








