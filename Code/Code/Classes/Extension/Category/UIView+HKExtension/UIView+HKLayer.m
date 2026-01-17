//
//  UIView+HKLayer.m
//  Code
//
//  Created by yxma on 2020/8/24.
//  Copyright © 2020 pg. All rights reserved.
//

#import "UIView+HKLayer.h"

@implementation UIView (HKLayer)

- (void)addCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)addCornerRadius:(CGFloat)cornerRadius addBoderWithColor:(UIColor *)color{
    [self addCornerRadius:cornerRadius];
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 1;
}

- (void)addCornerRadius:(CGFloat)cornerRadius addBoderWithColor:(UIColor *)color BoderWithWidth:(CGFloat)width{
    [self addCornerRadius:cornerRadius addBoderWithColor:color];
    self.layer.borderWidth = width;    
}

- (void)addGradientLayerColors:(NSArray *)colorArray{
    CAGradientLayer * layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    layer.colors = colorArray;
    layer.frame = CGRectMake(0, 0, self.width, self.height);
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)addVerticalGradientLayerColors:(NSArray *)colorArray{
    CAGradientLayer * layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.colors = colorArray;
    layer.frame = CGRectMake(0, 0, self.width, self.height);
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)addShadowCornerRadius:(CGFloat)cornerRadius shadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowOffset = offset;
    self.layer.shadowColor = COLOR_D2D6E4_27323F.CGColor;
    self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.layer.shadowRadius = radius;//阴影半径，默认3
    self.clipsToBounds = NO;
}
@end
