//
//  UIImage+Helper.h
//  Code
//
//  Created by pg on 16/3/21.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientType) {
    GradientFromTopToBottom = 1,            //从上到下
    GradientFromLeftToRight,                //从做到右
    GradientFromLeftTopToRightBottom,       //从上到下
    GradientFromLeftBottomToRightTop        //从上到下
};


@interface UIImage (Helper)


/*
 *
 *图片旋转
 *
 */
- (UIImage *)rotate:(CGFloat)angle;


/*
 *
 *图片旋转90C
 *
 */
- (UIImage *)rotateCW90;;



/*
 *
 *图片旋转180C
 *
 */
- (UIImage *)rotateCW180;



/*
 *
 *图片旋转270C
 *
 */
- (UIImage *)rotateCW270;



- (UIImage*)cropImageWithRect:(CGRect)cropRect;



/**
 圆形的图片
 
 @return 实例
 */
- (UIImage *)circleImage;


/**
 给图片表面添加 颜色
 
 @param maskColor
 @return
 */
- (UIImage *)maskImage:(UIColor *)maskColor;


/**
 生成image
 
 @param view 生成image 视图
 @return
 */

+ (UIImage*)imageWithUIView:(UIView*)view;


/**
 生成image
 
 @param view 生成image 视图
 @param size image size
 @return
 */
+ (UIImage *)imageWithView:(UIView *)view withSize:(CGSize)size;



/**
 获得截屏的图片
 
 @return UIImage
 */
+ (UIImage *)imageWithUIScreenShootImage;


/**
 颜色直接生成图片
 
 @param color <#color description#>
 @return <#return value description#>
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;




/**
 颜色直接生成图片
 
 @param color <#color description#>
 @param frame <#frame description#>
 @return <#return value description#>
 */
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;



/**
 *  根据给定的颜色，生成渐变色的图片
 *  @param imageSize        要生成的图片的大小
 *  @param colorArr         渐变颜色的数组
 *  @param percents          渐变颜色的占比数组
 *  @param gradientType     渐变色的类型
 */
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colorArr percentage:(NSArray *)percents gradientType:(GradientType)gradientType;


/**
 拼接上下两张图
 
 @param topImage
 @param bottomImage
 @param margin 上下图片间距
 @return
 */
+ (UIImage *) combineWithtopImage:(UIImage*)topImage bottomImage:(UIImage*)bottomImage withMargin:(NSInteger)margin;

+ (UIImage *) combineWithtopImageFill:(UIImage*)topImage bottomImage:(UIImage*)bottomImage withMargin:(NSInteger)margin;


/**
 改变一张图片的大小
 
 @param icon
 @param size
 @return
 */
+ (UIImage *)changeImageSize:(UIImage *)icon AndSize:(CGSize)size;


/**
 *
 *保持原来的长宽比，生成一个缩略图
 *
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

+(UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;


+(UIImage *)thumbnailWithImageWithoutScale_1:(UIImage *)image size:(CGSize)size;



/**
 裁剪图片中间部分
 
 @param image 裁剪的图片
 @param size 裁剪的size
 @return
 */
+ (UIImage *)imageCropCenterImage:(UIImage *)image size:(CGSize)size;

@end
