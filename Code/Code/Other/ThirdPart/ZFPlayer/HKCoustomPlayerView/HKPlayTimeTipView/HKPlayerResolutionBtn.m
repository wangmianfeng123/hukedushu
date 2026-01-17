//
//  HKPlayerResolutionBtn.m
//  Code
//
//  Created by Ivan li on 2018/4/3.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "HKPlayerResolutionBtn.h"

@implementation HKPlayerResolutionBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {

    CGRect bounds = self.bounds;
    // 放大点击范围
    bounds =CGRectInset(bounds, -20, -20);//注意这里是负数，扩大了之前的bounds的范围
    return CGRectContainsPoint(bounds, point);
}

@end
