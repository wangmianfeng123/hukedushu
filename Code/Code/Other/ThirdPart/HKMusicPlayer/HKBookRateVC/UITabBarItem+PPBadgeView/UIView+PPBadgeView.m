//
//  UIView+PPBadgeView.m
//  PPBadgeViewObjc
//
//  Created by AndyPang on 2017/6/17.
//  Copyright © 2017年 AndyPang. All rights reserved.
//


#import "UIView+PPBadgeView.h"
#import "PPBadgeLabel.h"
#import <objc/runtime.h>
#import "UIView+SNFoundation.h"
#import "UIView+DragBlast.h"


static NSString *const kBadgeLabel = @"kBadgeLabel";

static NSString const *kTapBlastKey = @"kTapBlastKey";

@interface UIView ()

@property (nonatomic, strong) PPBadgeLabel *badgeLabel;

@end

@implementation UIView (PPBadgeView)

- (void)pp_setBadgeFont:(CGFloat)font
{
    self.badgeLabel.font = [UIFont systemFontOfSize:font weight:UIFontWeightSemibold];
}


- (void)pp_addBadgeWithText:(NSString *)text
{
    [self pp_showBadge];
    self.badgeLabel.text = text;
}

- (void)pp_addBadgeWithNumber:(NSInteger)number
{
    NSString *text = nil;
    if (number <= 0) {
        [self pp_addBadgeWithText:@"0"];
        [self pp_hiddenBadge];
        return;
    }else{
        if (number >= 100) {
            text = [NSString stringWithFormat:@"99+"];
        }else{
            text = [NSString stringWithFormat:@"%ld",number];
        }
    }
    [self pp_addBadgeWithText:text];
    //[self pp_addBadgeWithText:[NSString stringWithFormat:@"%ld",number]];
}

- (void)pp_addDotWithColor:(UIColor *)color
{
    [self pp_addBadgeWithText:nil];
    [self pp_setBadgeHeight:8];
    if (color) {
        self.badgeLabel.backgroundColor = color;
    }
}

- (void)pp_moveBadgeWithX:(CGFloat)x Y:(CGFloat)y
{
    self.badgeLabel.offset = CGPointMake(x, y);
    
    self.badgeLabel.y = -self.badgeLabel.height*0.5/*badge的y坐标*/ + y;
    
    switch (self.badgeLabel.flexMode) {
        case PPBadgeViewFlexModeHead: // 1. 左伸缩  <==●
            self.badgeLabel.right = self.badgeLabel.superview.width + self.badgeLabel.height*0.5 + x;
            break;
        case PPBadgeViewFlexModeTail: // 2. 右伸缩 ●==>
            self.badgeLabel.x = (self.width - self.badgeLabel.height*0.5)/*badge的x坐标*/ + x;
            break;
        case PPBadgeViewFlexModeMiddle: // 3. 左右伸缩  <=●=>
            self.badgeLabel.center = CGPointMake(self.width+x, y);
            break;
    }
}

- (void)pp_setBadgeFlexMode:(PPBadgeViewFlexMode)flexMode
{
    self.badgeLabel.flexMode = flexMode;
    [self pp_moveBadgeWithX:self.badgeLabel.offset.x Y:self.badgeLabel.offset.y];
}

- (void)pp_setBadgeLabelAttributes:(void (^)(PPBadgeLabel *))badgeLabelBlock
{
    badgeLabelBlock ? badgeLabelBlock(self.badgeLabel) : nil;
}

- (void)pp_setBadgeHeight:(CGFloat)height
{
    CGFloat scale = height / self.badgeLabel.height;
    self.badgeLabel.transform = CGAffineTransformScale(self.badgeLabel.transform, scale, scale);
}

- (void)pp_showBadge
{
    self.badgeLabel.hidden = NO;
}

- (void)pp_hiddenBadge
{
    self.badgeLabel.hidden = YES;
}

- (void)pp_increase
{
    [self pp_increaseBy:1];
}

- (void)pp_increaseBy:(NSInteger)number
{
    NSInteger result = self.badgeLabel.text.integerValue + number;
    if (result > 0) {
        [self pp_showBadge];
    }
    self.badgeLabel.text = [NSString stringWithFormat:@"%ld",result];
}

- (void)pp_decrease
{
    [self pp_decreaseBy:1];
}

- (void)pp_decreaseBy:(NSInteger)number
{
    NSInteger result = self.badgeLabel.text.integerValue - number;
    if (result <= 0) {
        [self pp_hiddenBadge];
        self.badgeLabel.text = @"0";
        return;
    }
    self.badgeLabel.text = [NSString stringWithFormat:@"%ld",result];
}

#pragma mark - setter/getter
- (PPBadgeLabel *)badgeLabel
{
    PPBadgeLabel *label = objc_getAssociatedObject(self, &kBadgeLabel);
    if (!label) {
        label = [PPBadgeLabel defaultBadgeLabel];
        label.center = CGPointMake(self.width, 0);
        
        label.isFragment = YES;
        label.tapBlast = YES;
        
        [self addSubview:label];
        [self bringSubviewToFront:label];
        [self setBadgeLabel:label];
        
    }
    return label;
}


- (void)setBadgeLabel:(PPBadgeLabel *)badgeLabel
{
    objc_setAssociatedObject(self, &kBadgeLabel, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end






