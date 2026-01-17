//
//  UIImage+DM.h
//  EasyInterface
//
//  Created by Elenion on 2019/8/5.
//  Copyright © 2019 Elenion. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HKDM)

//+ (nullable UIImage *)hkdm_imageWithImageLight:(UIImage *)light dark:(nullable UIImage *)dark;

//+ (nullable UIImage *)hkdm_imageWithNameLight:(NSString *)light dark:(nullable NSString *)dark;

+ (UIImage *)hkdam_lightOrDarkModeImageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage;

+ (UIImage *)hkdm_imageWithNameLight:(NSString *)lightImageName darkImageName:(NSString *)darkImageName;


@end

NS_ASSUME_NONNULL_END
