//
//  UILabel+Helper.h
//  Code
//
//  Created by pg on 16/3/20.
//  Copyright © 2016年 pg. All rights reserved.
//
//////

#import <UIKit/UIKit.h>

@interface UILabel (Helper)

/*
 *
 @ 初始化label;
 *
*/
+ (UILabel *) labelWithTitle:(CGRect)rect title:(NSString *)title  titleColor:(UIColor *)color
                   titleFont:(NSString *) font  titleAligment:(NSInteger)aligment;


/*
 *
 @ 自定义提示文本;
 *
 */
+ (void)showStats:(NSString *)stats atView:(UIView *)view;


+ (UILabel *) labelWithTitleAndImage:(NSString *)title  image:(NSString *)image titleColor:(UIColor *)color
                           titleFont:(NSString *) font  ;


/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;



@end
