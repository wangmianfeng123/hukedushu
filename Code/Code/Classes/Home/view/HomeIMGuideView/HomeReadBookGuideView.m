
//
//  HomeReadBookGuideView.m
//  Code
//
//  Created by Ivan li on 2019/3/27.
//  Copyright © 2019年 pg. All rights reserved.
//

#import "HomeReadBookGuideView.h"
#import "AppDelegate.h"
#import "CYLTabBarController.h"
#import "UIView+SNFoundation.h"


@interface HomeReadBookGuideView ()

@property (nonatomic,strong) UIImageView *topIV;

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong) UIImageView *bottomIV;

@end



@implementation HomeReadBookGuideView

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}



- (void)createUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIWindow *tempWindow = [AppDelegate sharedAppDelegate].window;
    if ([tempWindow.rootViewController isKindOfClass:[CYLTabBarController class]]) {
        CYLTabBarController *tabBarController = (CYLTabBarController*)tempWindow.rootViewController;
        
        if (tabBarController.viewControllers.count<5) {
            return;
        }
        CGRect rect = CGRectZero;
        if (tabBarController.viewControllers.count) {
            rect = [tabBarController.viewControllers[2].tabBarItem.cyl_tabButton convertRect:tempWindow.bounds toView:tempWindow];
        }
        
        CGFloat y = CGRectGetMidX(tabBarController.viewControllers[2].tabBarItem.cyl_tabButton.frame);
        
        //CGFloat H = (self.topIV.height);
        
        //self.bgViewRect = CGRectMake(rect.origin.x - self.topIV.width/2, rect.origin.y - H - 2, self.topIV.width, H);2
        
        CGFloat H = (self.topIV.height + self.bottomIV.height);
        
        self.bgViewRect = CGRectMake(32, rect.origin.y - H - 2, self.topIV.width, H);
        
        self.bgView.frame = CGRectMake(0, 0, self.topIV.width, H);
        
        self.topIV.top = 0;
        self.topIV.left = 0;
        
        self.bottomIV.top = self.topIV.bottom -1;
        self.bottomIV.centerX = self.topIV.width / 5.0 * 1.88;
        
        [self.bgView addSubview:self.topIV];
        [self.bgView addSubview:self.bottomIV];
        
        [self addSubview:self.bgView];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeIMGuideView)];
        [self addGestureRecognizer:tapGest];
    }
}


- (UIImageView*)topIV {
    if (!_topIV) {
        _topIV = [[UIImageView alloc]initWithImage:imageName(@"popover_guideline_v2_14")];
        _topIV.contentMode = UIViewContentModeScaleAspectFit;
        [_topIV sizeToFit];
        _topIV.userInteractionEnabled = YES;
    }
    return _topIV;
}


- (UIImageView*)bottomIV {
    if (!_bottomIV) {
        _bottomIV = [[UIImageView alloc]initWithImage:imageName(@"ic_triangle_v2_10")];
        _bottomIV.contentMode = UIViewContentModeScaleAspectFit;
        [_bottomIV sizeToFit];
        _bottomIV.userInteractionEnabled = YES;
    }
    return _bottomIV;
}



- (UIView*)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}


- (void)removeIMGuideView {
    [self removeFromSuperview];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //[self removeIMGuideView];
}

@end






