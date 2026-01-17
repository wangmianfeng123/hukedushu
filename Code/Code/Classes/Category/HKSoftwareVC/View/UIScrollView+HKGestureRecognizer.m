//
//  UIScrollView+HKGestureRecognizer.m
//  Code
//
//  Created by eon Z on 2022/1/7.
//  Copyright © 2022 pg. All rights reserved.
//

//#import "UIScrollView+HKGestureRecognizer.h"
//
//@implementation UIScrollView (HKGestureRecognizer)
//
//@end
#import "UIScrollView+HKGestureRecognizer.h"


@implementation UIScrollView (HKGestureRecognizer)

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
//    
//    // 首先判断otherGestureRecognizer是不是系统pop手势
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//        
//        // 再判断系统手势的state是began还是fail，
//        // 同时判断scrollView的位置是不是正好在最左边
//        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan) {
//            
//            return YES;
//        }
//    }
//    
//    return NO;
//}
//是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥.
//是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
//一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//    if ([self panBack:gestureRecognizer]) {
//        return YES;
//    }
//    return NO;
//    
//}
//
////location_X可自己定义,其代表的是滑动返回距左边的有效长度
//- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
//    
//    //是滑动返回距左边的有效长度
//    int location_X = 80;
//    
//    if (gestureRecognizer ==self.panGestureRecognizer) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint point = [pan translationInView:self];
//        UIGestureRecognizerState state = gestureRecognizer.state;
//        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
//            CGPoint location = [gestureRecognizer locationInView:self];
//            
//            //这是允许每张图片都可实现滑动返回
//            int temp1 = location.x;
//            int temp2 =SCREEN_WIDTH;
//            NSInteger XX = temp1 % temp2;
//            if (point.x >0 && XX < location_X) {
//                return YES;
//            }
//            //下面的是只允许在第一张时滑动返回生效
//            //            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
//            //                return YES;
//            //            }
//        }
//    }
//    return NO;
//    
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    
//    if ([self panBack:gestureRecognizer]) {
//        return NO;
//    }
//    return YES;
//    
//}
@end
