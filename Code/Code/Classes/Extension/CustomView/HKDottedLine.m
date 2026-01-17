//
//  FOFDottedLine.m
//  testtest
//
//  Created by hanchuangkeji on 2017/7/20.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "HKDottedLine.h"

@implementation HKDottedLine

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, [UIColor colorWithWhite:1.0 alpha:1.0].CGColor);
//    //设置虚线宽度
//    CGContextSetLineWidth(currentContext, 1);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, self.frame.size.height * 2.0);
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, 0, 0);
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, self.frame.origin.x + self.frame.size.width, 0);
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制2个点再绘制1个点
    CGFloat arr[] = {2,2};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}


@end
