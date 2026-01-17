//
//  UIButton+ImageTitleSpace.h
//  Code
//
//  Created by Ivan li on 2018/5/28.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Helper.h"
#import "UIImage+Blur.h"
//#import "UIButton+EnlargeEdge.h"

typedef NS_ENUM(NSUInteger, HKButtonEdgeInsetsStyle) {
    HKButtonEdgeInsetsStyleTop, // image在上，label在下
    HKButtonEdgeInsetsStyleLeft, // image在左，label在右
    HKButtonEdgeInsetsStyleBottom, // image在下，label在上
    HKButtonEdgeInsetsStyleRight // image在右，label在左
};


/**
 按钮 图片和标题 间距位置 设置
 */
@interface UIButton (ImageTitleSpace)


/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(HKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

/**
 按钮初始化
 
 @param title 标题
 @param color
 @param font
 @param imageName 图片名
 @return
 */
+ (UIButton *)buttonWithTitle:(NSString *)title  titleColor:(UIColor *)color titleFont:(NSString *) font  imageName:(NSString *)imageName;


/**
 *  根据给定的颜色，设置按钮的颜色
 *  @param btnSize  这里要求手动设置下生成图片的大小，防止coder使用第三方layout,没有设置大小
 *  @param clrs     渐变颜色的数组
 *  @param percent  渐变颜色的占比数组
 *  @param type     渐变色的类型
 */
- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type;


/**
 根据给定的颜色，设置按钮的背景颜色

 @param backgroundColor
 @param state
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end




