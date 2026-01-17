//
//  UIButton+EnlargeEdge.m
//  UIButton+EnlargeEdge
//
//  Created by Ivan li on 2018/5/10.
//  Copyright © 2018年 Ivan li. All rights reserved.
//
#import <objc/runtime.h>
#import "UIButton+EnlargeEdge.h"



@implementation UIButton (hkEnlargeEdge)



static char hktopNameKey;
static char hkrightNameKey;
static char hkbottomNameKey;
static char hkleftNameKey;


- (void)setHKEnlargeEdge:(CGFloat) size {
    
    objc_setAssociatedObject(self, &hktopNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hkrightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hkbottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hkleftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right
                       bottom:(CGFloat) bottom left:(CGFloat) left {
    
    objc_setAssociatedObject(self, &hktopNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hkrightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hkbottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hkleftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (CGRect)hkEnlargedRect {
    
    NSNumber* topEdge = objc_getAssociatedObject(self, &hktopNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &hkrightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &hkbottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &hkleftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else{
        return self.bounds;
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self hkEnlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)){
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}



@end







@implementation UIControl (hkEnlargeEdge)


static char hk_ctl_topNameKey;
static char hk_ctl_rightNameKey;
static char hk_ctl_bottomNameKey;
static char hk_ctl_leftNameKey;


- (void)setHKEnlargeEdge:(CGFloat) size {
    
    objc_setAssociatedObject(self, &hk_ctl_topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hk_ctl_rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hk_ctl_bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hk_ctl_leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right
                       bottom:(CGFloat) bottom left:(CGFloat) left {
    
    objc_setAssociatedObject(self, &hk_ctl_topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hk_ctl_rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hk_ctl_bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &hk_ctl_leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (CGRect)hkEnlargedRect {
    
    NSNumber* topEdge = objc_getAssociatedObject(self, &hk_ctl_topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &hk_ctl_rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &hk_ctl_bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &hk_ctl_leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else{
        return self.bounds;
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self hkEnlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)){
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}





@end


