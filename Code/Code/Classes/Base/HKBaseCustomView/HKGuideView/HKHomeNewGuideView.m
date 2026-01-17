//
//  HKHomeNewGuideView.m
//  Code
//
//  Created by Ivan li on 2018/1/28.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKHomeNewGuideView.h"
#import "AppDelegate.h"


@interface HKHomeNewGuideView()

@property(nonatomic,strong)UIButton  *ic1;

@property(nonatomic,strong)UIImageView  *ic2;

@property(nonatomic,strong)UIImageView  *ic3;

@property(nonatomic,strong)UIImageView  *ic4;

@end


@implementation HKHomeNewGuideView

- (instancetype)init {
    if (self = [super init]) {
        
        [self createUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBtnClick)];
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.ic1];
    [self addSubview:self.ic2];
    [self addSubview:self.ic3];
    [self addSubview:self.ic4];
    
    WeakSelf;
    [_ic4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(IS_IPHONE_X ?-34 :0);
        make.centerX.mas_equalTo([weakSelf tabitemPointX]);
    }];
    
    [_ic3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_ic4.mas_top).offset(-PADDING_5);
        make.right.equalTo(self.mas_right).offset(-80*Ratio);
    }];
    
    [_ic2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_ic3.mas_top).offset(-20);
        make.centerX.equalTo(_ic1);
    }];
    
    [_ic1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_ic2.mas_top).offset(-70);
        make.centerX.equalTo(self);
    }];
}


- (UIButton*)ic1 {
    if (!_ic1) {
        _ic1 = [UIButton new];
        [_ic1 setImage:imageName(@"home_word_know") forState:UIControlStateNormal];
        [_ic1 addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ic1;
}


- (UIImageView*)ic2 {
    if (!_ic2) {
        _ic2 = [UIImageView new];
        _ic2.image = imageName(@"home_word_detail");
        _ic2.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _ic2;
}



- (UIImageView*)ic3 {
    if (!_ic3) {
        _ic3 = [UIImageView new];
        _ic3.image = imageName(@"home_arrow_white");
        _ic3.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _ic3;
}


- (UIImageView*)ic4 {
    if (!_ic4) {
        _ic4 = [UIImageView new];
        _ic4.image = imageName(@"home_circle_white");
        _ic4.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _ic4;
}



- (void)closeBtnClick {
    
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self performSelector:@selector(removeGuidePage) withObject:nil afterDelay:0.5];
        });
    }];
}


- (void)removeGuidePage {
    //移除手势
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        [self removeGestureRecognizer:ges];
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}



//tabitem 坐标
- (CGFloat)tabitemPointX {
    UITabBarController *tbc = [AppDelegate sharedAppDelegate].window.rootViewController;
    CGRect itemFrame = [self getTabBarItemFrameWithTabBar:tbc.tabBar index:0];
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




@end
