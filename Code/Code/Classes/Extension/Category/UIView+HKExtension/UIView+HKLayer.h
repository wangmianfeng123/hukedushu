//
//  UIView+HKLayer.h
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HKLayer)

- (void)addCornerRadius:(CGFloat)cornerRadius;
- (void)addCornerRadius:(CGFloat)cornerRadius addBoderWithColor:(UIColor *)color;
- (void)addCornerRadius:(CGFloat)cornerRadius addBoderWithColor:(UIColor *)color BoderWithWidth:(CGFloat)width;

- (void)addGradientLayerColors:(NSArray *)colorArray;
- (void)addVerticalGradientLayerColors:(NSArray *)colorArray;


- (void)addShadowCornerRadius:(CGFloat)cornerRadius shadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
