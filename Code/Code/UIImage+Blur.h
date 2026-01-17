//
//  UIImage+Blur.h
//  FranchiserMobileApp
//
//  Created by 龚雪寒 on 13-11-29.
//  Copyright (c) 2013年 dds\mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

/**
 *  图片模糊处理
 *
 *  @param blurLevel 模糊系数
 *
 *  @return 处理后的图片
 */
- (UIImage*)gaussBlur:(CGFloat)blurLevel;

/**
 *  给mongo的按钮背景图片使用，会拉伸图片
 */
+ (UIImage *)resizableImage:(NSString *)name
              withCapInsets:(UIEdgeInsets)inset;


/**
 根据尺寸裁剪图片

 @param targetSize 指定尺寸
 @param sourceImage 指定图片
 @return 处理后的图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage *)sourceImage;

@end
