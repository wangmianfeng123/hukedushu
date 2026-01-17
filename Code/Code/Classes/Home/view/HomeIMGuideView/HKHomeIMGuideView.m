
//
//  HKHomeIMGuideView.m
//  Code
//
//  Created by Ivan li on 2018/11/21.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKHomeIMGuideView.h"
#import "AppDelegate.h"
#import "CYLTabBarController.h"
#import "UIView+SNFoundation.h"


@interface HKHomeIMGuideView ()

@property (nonatomic,strong) UIImageView *topIV;

@property (nonatomic,strong) UIImageView *bottomIV;

@property (nonatomic,strong)UIView *bgView;

@end




@implementation HKHomeIMGuideView

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
        
        CGRect rect = CGRectZero;
        if (tabBarController.viewControllers.count) {
            rect = [tabBarController.viewControllers[3].tabBarItem.cyl_tabButton convertRect:tempWindow.bounds toView:tempWindow];
        }
        
        CGFloat H = (self.topIV.height + self.bottomIV.height);
        self.bgViewRect = CGRectMake(rect.origin.x- self.topIV.width/2, rect.origin.y - H - 2, self.topIV.width, H);
        
        self.bgView.frame = CGRectMake(0, 0, self.topIV.width, H);
        
        self.topIV.top = 0;
        self.topIV.left = 0;
        
        self.bottomIV.top = self.topIV.bottom;
        self.bottomIV.centerX = rect.origin.x- self.topIV.width/2;
        
        [self.bgView addSubview:self.topIV];
        [self.bgView addSubview:self.bottomIV];
        [self addSubview:self.bgView];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeIMGuideView)];
        [self addGestureRecognizer:tapGest];
    }
        
//    BOOL show = [HKNSUserDefaults boolForKey:@"Home_IM_Guide"];
//    if (!show) {
//            [HKNSUserDefaults setBool:YES forKey:@"Home_IM_Guide"];
//            [HKNSUserDefaults synchronize];
//        }
//    }
}


- (UIImageView*)topIV {
    if (!_topIV) {
        _topIV = [[UIImageView alloc]initWithImage:imageName(@"group_chat_guide_bg")];
        _topIV.contentMode = UIViewContentModeScaleAspectFit;
        [_topIV sizeToFit];
        _topIV.userInteractionEnabled = YES;
    }
    return _topIV;
}

- (UIImageView*)bottomIV {
    if (!_bottomIV) {
        _bottomIV = [[UIImageView alloc]initWithImage:imageName(@"group_chat_guide_arrow")];
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
    [self removeIMGuideView];
}

@end





