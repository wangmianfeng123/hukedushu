//
//  UIButton+ImageTitleSpace.m
//  Code
//
//  Created by Ivan li on 2018/5/28.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "UIButton+ImageTitleSpace.h"

@implementation UIButton (ImageTitleSpace)


- (void)layoutButtonWithEdgeInsetsStyle:(HKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    /**
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    
    switch (style) {
        case HKButtonEdgeInsetsStyleTop:
        {
            CGFloat img_W = self.imageView.frame.size.width;
            CGFloat img_H = self.imageView.frame.size.height;
            CGFloat tit_W = self.titleLabel.frame.size.width;
            CGFloat tit_H = self.titleLabel.frame.size.height;
            
            labelEdgeInsets = (UIEdgeInsets){
                .top    =   (tit_H / 2 + space / 2),
                .left   = - (img_W / 2),
                .bottom = - (tit_H / 2 + space / 2),
                .right  =   (img_W / 2),
            };
            
            imageEdgeInsets = (UIEdgeInsets){
                .top    = - (img_H / 2 + space / 2),
                .left   =   (tit_W / 2),
                .bottom =   (img_H / 2 + space / 2),
                .right  = - (tit_W / 2),
            };
            
            //imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            //labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case HKButtonEdgeInsetsStyleLeft:
        {
            //if (imageHeight) {
                imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            //}
        }
            break;
        case HKButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case HKButtonEdgeInsetsStyleRight:
        {
            //if (imageHeight) {
                imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
            //}
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}


- (void)setIconInTopWithSpacing:(CGFloat)Spacing
{
    CGFloat img_W = self.imageView.frame.size.width;
    CGFloat img_H = self.imageView.frame.size.height;
    CGFloat tit_W = self.titleLabel.frame.size.width;
    CGFloat tit_H = self.titleLabel.frame.size.height;
    
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    =   (tit_H / 2 + Spacing / 2),
        .left   = - (img_W / 2),
        .bottom = - (tit_H / 2 + Spacing / 2),
        .right  =   (img_W / 2),
    };
    
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = - (img_H / 2 + Spacing / 2),
        .left   =   (tit_W / 2),
        .bottom =   (img_H / 2 + Spacing / 2),
        .right  = - (tit_W / 2),
    };
}



+ (UIButton *)buttonWithTitle:(NSString *)title  titleColor:(UIColor *)color
                    titleFont:(NSString *)font  imageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (!isEmpty(title))
        [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:color forState:UIControlStateNormal];
    
    if (!isEmpty(font))
        [button.titleLabel setFont:[UIFont systemFontOfSize:[font floatValue]]];
    
    if (!isEmpty(imageName))
        [button setImage:imageName(imageName) forState:UIControlStateNormal];
    
    return button;
}




- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type {
    
    UIImage *backImage = [[UIImage alloc]createImageWithSize:btnSize gradientColors:clrs percentage:percent gradientType:type];
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    return self;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor
                  forState:(UIControlState)state {
    
    [self setBackgroundImage:[UIImage createImageWithColor:backgroundColor] forState:state];
}




@end







