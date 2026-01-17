//
//  UIImage+Helper.m
//  Code
//
//  Created by pg on 16/3/21.
//  Copyright © 2016年 pg. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)


- (UIImage *)rotate:(CGFloat)angle
{
    UIImage *    result = nil;
    CGSize        imageSize = self.size;
    CGSize        canvasSize = CGSizeZero;
    
    angle = fmodf( angle, 360 );
    
    if ( 90 == angle || 270 == angle )
    {
        canvasSize.width = self.size.height;
        canvasSize.height = self.size.width;
    }
    else if ( 0 == angle || 180 == angle )
    {
        canvasSize.width = self.size.width;
        canvasSize.height = self.size.height;
    }
    
    UIGraphicsBeginImageContext( canvasSize );
    
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( bitmap, canvasSize.width / 2, canvasSize.height / 2 );
    CGContextRotateCTM( bitmap, M_PI / 180 * angle );
    
    CGContextScaleCTM( bitmap, 1.0, -1.0 );
    CGContextDrawImage( bitmap, CGRectMake( -(imageSize.width / 2), -(imageSize.height / 2), imageSize.width, imageSize.height), self.CGImage );
    
    result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}





- (UIImage *)rotateCW90
{
    return [self rotate:270];
}




- (UIImage *)rotateCW180
{
    return [self rotate:180];
}




- (UIImage *)rotateCW270
{
    return [self rotate:90];
}






- (UIImage*)cropImageWithRect:(CGRect)cropRect
{
    CGRect drawRect = CGRectMake(-cropRect.origin.x , -cropRect.origin.y, self.size.width * self.scale, self.size.height * self.scale);
    
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, cropRect.size.width, cropRect.size.height));
    
    [self drawInRect:drawRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}







- (UIImage *)circleImage
{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)maskImage:(UIColor *)maskColor {
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return smallImage;
}



#pragma mark 生成image
+ (UIImage*)imageWithUIView:(UIView*)view {
    
    UIGraphicsBeginImageContextWithOptions(view.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark 生成image
+ (UIImage *)imageWithView:(UIView *)view withSize:(CGSize)size {
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
    //第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


#pragma mark  获得截屏的图片
+ (UIImage *)imageWithUIScreenShootImage {
    //设置 size
    UIGraphicsBeginImageContextWithOptions((CGSize){SCREEN_WIDTH, SCREEN_HEIGHT}, YES, [UIScreen mainScreen].scale);
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    //渲染到 context中
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 获得句柄 获得想要的图片
    UIImage * createdImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return createdImage;
}


/**
 UIColor生成图片
 
 @param color
 @return
 */
+ (UIImage *)createImageWithColor:(UIColor *)color {
    //设置长宽
    CGRect rect = CGRectMake(0.0f, 0.0f, 5.0f, 5.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

//根据颜色值生成纯色图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}



#pragma mark  根据给定的颜色，生成渐变色的图片
- (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(GradientType)gradientType {
    
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
    //    NSUInteger capacity = percents.count;
    //    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientFromTopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case GradientFromLeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case GradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case GradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}





#pragma mark - 拼接上下两张图
+ (UIImage *) combineWithtopImage:(UIImage*)topImage bottomImage:(UIImage*)bottomImage withMargin:(NSInteger)margin {
    if (bottomImage == nil) {
        return topImage;
    }
    CGFloat width = topImage.size.width ;
    CGFloat height = topImage.size.height +bottomImage.size.height +margin;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    
    CGRect rectTop = CGRectMake(0, 0, width, topImage.size.height);
    [topImage drawInRect:rectTop];
    
    CGRect rectBottom = CGRectMake(0, CGRectGetMaxY(rectTop)+margin, width, bottomImage.size.height);
    [bottomImage drawInRect:rectBottom];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 拼接上下两张图
+ (UIImage *) combineWithtopImageFill:(UIImage*)topImage bottomImage:(UIImage*)bottomImage withMargin:(NSInteger)margin{
    if (bottomImage == nil) {
        return topImage;
    }
    
    CGFloat width = UIScreenWidth;
    CGFloat topImageHeight = UIScreenWidth * topImage.size.height / topImage.size.width;
    CGFloat bottomImageHeight = UIScreenWidth * bottomImage.size.height / bottomImage.size.width;
    CGFloat height = topImageHeight + bottomImageHeight + margin;
    CGSize offScreenSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(offScreenSize, NO, [UIScreen mainScreen].scale);
    
    CGRect rectTop = CGRectMake(0, 0, width, topImageHeight);
    [topImage drawInRect:rectTop];
    
    CGRect rectBottom = CGRectMake(0, CGRectGetMaxY(rectTop)+margin, width, bottomImageHeight);
    [bottomImage drawInRect:rectBottom];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




///改变一张图片的大小
+ (UIImage *)changeImageSize:(UIImage *)icon AndSize:(CGSize)size{
    CGSize itemSize = size;
    UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    return image;
}


//保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = 0;//(asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = 0;// (asize.height - rect.size.height)/2;
        }
        
        //UIGraphicsBeginImageContext(CGSizeMake(asize.width, asize.height + (44)*2));
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        //UIRectFill(CGRectMake(0, (44+34)*2, asize.width, asize.height));
        rect.size.height = rect.size.height;
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    return newimage;
}


+(UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize

{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}



/*
 * 保持原来的长宽比，生成一个缩略图
 * &-image 待传入UIImage
 * &-size 待传入UIImage要改变图像的尺寸
 * 返回处理好的UIImage
 */
+ (UIImage *)thumbnailWithImageWithoutScale_1:(UIImage *)image size:(CGSize)size
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = CGSizeMake(image.size.width/2.0,image.size.height/2.0 );
        CGRect rect;
        if (size.width/size.height > oldsize.width/oldsize.height) {
            rect.size.width = size.height*oldsize.width/oldsize.height;
            rect.size.height = size.height;
            rect.origin.x = (size.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = size.width;
            rect.size.height = size.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (size.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}





#pragma mark - 裁剪图片中间部分
+ (UIImage *)imageCropCenterImage:(UIImage *)image size:(CGSize)size {
    CGSize imageSize = image.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        rect = CGRectMake(leftMargin, 0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) * 0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
    
    CGImageRef imageRef = image.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw = CGRectMake(0, 0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tmp;
}



@end

