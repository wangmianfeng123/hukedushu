//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import "UIView+PYSearchExtension.h"

@implementation UIView (PYSearchExtension)

- (void)setPy_x:(CGFloat)py_x
{
    CGRect frame = self.frame;
    frame.origin.x = py_x;
    self.frame = frame;
}

- (CGFloat)py_x
{
    return self.py_origin.x;
}

- (void)setPy_centerX:(CGFloat)py_centerX
{
    CGPoint center = self.center;
    center.x = py_centerX;
    self.center = center;
}

- (CGFloat)py_centerX
{
    return self.center.x;
}

-(void)setPy_centerY:(CGFloat)py_centerY
{
    CGPoint center = self.center;
    center.y = py_centerY;
    self.center = center;
}

- (CGFloat)py_centerY
{
    return self.center.y;
}

- (void)setPy_y:(CGFloat)py_y
{
    CGRect frame = self.frame;
    frame.origin.y = py_y;
    self.frame = frame;
}

- (CGFloat)py_y
{
    return self.frame.origin.y;
}

- (void)setPy_size:(CGSize)py_size
{
    CGRect frame = self.frame;
    frame.size = py_size;
    self.frame = frame;

}

- (CGSize)py_size
{
    return self.frame.size;
}

- (void)setPy_height:(CGFloat)py_height
{
    CGRect frame = self.frame;
    frame.size.height = py_height;
    self.frame = frame;
}

- (CGFloat)py_height
{
    return self.frame.size.height;
}

- (void)setPy_width:(CGFloat)py_width
{
    CGRect frame = self.frame;
    frame.size.width = py_width;
    self.frame = frame;

}

-(CGFloat)py_width
{
    return self.frame.size.width;
}

- (void)setPy_origin:(CGPoint)py_origin
{
    CGRect frame = self.frame;
    frame.origin = py_origin;
    self.frame = frame;
}

- (CGPoint)py_origin
{
    return self.frame.origin;
}


- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    //self.layer.mask = maskLayer;
    
    

    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = rect;
    borderLayer.lineWidth = 1.5f;
    //borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    // 2.19.1 修改
    borderLayer.strokeColor = [UIColor clearColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    //UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    maskLayer.path = maskPath.CGPath;
    borderLayer.path = maskPath.CGPath;
    
    [self.layer insertSublayer:borderLayer atIndex:0];
    self.layer.mask = maskLayer;
}



@end
