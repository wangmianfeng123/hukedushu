
//
//  HKMoreClickCollectionView.m
//  Code
//
//  Created by hanchuangkeji on 2018/8/30.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKMoreClickCollectionView.h"

@implementation HKMoreClickCollectionView

/**
 重写点击区域
 
 @param point 点击点
 @param event 点击事件
 @return 返回布尔值
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    // 默认为真直接返回
    BOOL inside = [super pointInside:point withEvent:event];
    if (inside) {
        return inside;
    }
    
    // 遍历所有子控件
    for (UIView *subView in self.subviews) {
        
        // 转换point坐标系
        CGPoint subViewPoint = [subView convertPoint:point fromView:self];
        // 如果点击区域落在子控件上
        if ([subView pointInside:subViewPoint withEvent:event]) {
            return YES;
        }
    }
    return NO;
}
@end
