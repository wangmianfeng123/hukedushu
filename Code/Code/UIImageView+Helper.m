//
//  UIImageView+UIImageView_Helper_.m
//  Code
//
//  Created by pg on 2017/3/24.
//  Copyright © 2017年 pg. All rights reserved.
//

#import "UIImageView+Helper.h"

@implementation UIImageView (Helper)


#pragma mark - 设置圆形imageview
+ (UIImageView*)roundImageView:(CGRect)rect {
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}





@end
