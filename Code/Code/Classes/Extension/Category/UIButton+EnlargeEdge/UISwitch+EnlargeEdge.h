//
//  UISwitch+EnlargeEdge.h
//  Code
//
//  Created by Ivan li on 2018/7/22.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (EnlargeEdge)

/**
 扩大按钮点击范围
 上下左右 同时扩大相同范围
 
 @param size 范围
 */
- (void)setHKEnlargeEdge:(CGFloat) size;

/**
 扩大按钮点击范围
 自定义 上下左右 范围
 
 @param top
 @param right
 @param bottom
 @param left
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
