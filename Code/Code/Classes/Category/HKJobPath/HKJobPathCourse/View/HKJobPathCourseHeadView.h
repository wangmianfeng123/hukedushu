//
//  HKJobPathCourseHeadView.h
//  Code
//
//  Created by Ivan li on 2019/6/5.
//  Copyright © 2019 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HKJobPathModel , HKJobPathHeadGuideModel;

@interface HKJobPathCourseHeadView : UIView


/**
 viewHeight （contentBgView bottom)   tagsContentHeight(tag 背景 bottom)
 */
@property(nonatomic,copy)void (^ heightChangeBlock)(CGFloat viewHeight,CGFloat tagsContentHeight);

@property (nonatomic,copy) void(^didVipBtnBlock)(void);

- (void)setDescrTextColor:(UIColor *)color;

/**
 ContentBgView 显示 隐藏

 @param show
 */
- (void)showContentBgView:(BOOL)show  alpha:(CGFloat)alpha;

@property (nonatomic,strong) HKJobPathModel *jobPathModel;
@property (nonatomic , strong) HKJobPathHeadGuideModel * guideModel;
@property (nonatomic,strong) UIButton *goVipBtn;

@end

NS_ASSUME_NONNULL_END

