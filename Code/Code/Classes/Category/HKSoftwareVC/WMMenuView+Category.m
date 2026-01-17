//
//  WMMenuView+Category.m
//  Code
//
//  Created by Ivan li on 2019/8/1.
//  Copyright © 2019 pg. All rights reserved.
//

#import "WMMenuView+Category.h"
#import "HKDropMenu.h"

@implementation WMMenuView (Category)


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    UIView *result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    return nil;
}



@end
