//
//  PPBadgeLabel.m
//  PPBadgeViewObjc
//
//  Created by AndyPang on 2017/6/17.
//  Copyright © 2017年 AndyPang. All rights reserved.
//


#import "PPBadgeLabel.h"
#import "UIView+PPBadgeView.h"
#import "UIView+SNFoundation.h"

@interface PPBadgeLabel ()

@end

@implementation PPBadgeLabel

+ (instancetype)defaultBadgeLabel
{
    // 默认为系统tabBarItem的Badge大小
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:13];
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.cornerRadius = self.height * 0.5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:1.00 green:0.17 blue:0.15 alpha:1.00];
    self.flexMode = PPBadgeViewFlexModeTail;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // 根据内容调整label的宽度
    CGFloat stringWidth = [self widthForString:text font:self.font height:self.height];
    if (self.height > stringWidth + self.height*10/18) {
        self.width = self.height;
        return;
    }
    self.width = self.height*5/18/*left*/ + stringWidth + self.height*5/18/*right*/;
}

- (CGFloat)widthForString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

@end
