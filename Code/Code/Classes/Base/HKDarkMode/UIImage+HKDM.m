//
//  UIImage+DM.m
//  EasyInterface
//
//  Created by Elenion on 2019/8/5.
//  Copyright © 2019 Elenion. All rights reserved.
//

#import "UIImage+HKDM.h"

@implementation UIImage (HKDM)



+ (UIImage *)hkdam_lightOrDarkModeImageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage  {
    return [self hkdam_lightOrDarkModeImageWithOwner:nil lightImage:lightImage darkImage:darkImage];
}

+ (UIImage *)hkdm_imageWithNameLight:(NSString *)lightImageName darkImageName:(NSString *)darkImageName {
    
    UIImage *lightImage = [UIImage imageNamed:lightImageName];
    UIImage *darkImage= [UIImage imageNamed:darkImageName];
    UIImage *lightOrDarkImage = [UIImage hkdam_lightOrDarkModeImageWithOwner:nil lightImage:lightImage darkImage:darkImage];
    return lightOrDarkImage;
}

+ (UIImage *)hkdam_lightOrDarkModeImageWithOwner:(id<UITraitEnvironment>)owner
                 lightImageName:(NSString *)lightImageName
                  darkImageName:(NSString *)darkImageName {
    UIImage *lightImage = [UIImage imageNamed:lightImageName];
    UIImage *darkImage= [UIImage imageNamed:darkImageName];
    UIImage *lightOrDarkImage = [UIImage hkdam_lightOrDarkModeImageWithOwner:owner lightImage:lightImage darkImage:darkImage];
    return lightOrDarkImage;
}



+ (UIImage *)hkdam_lightOrDarkModeImageWithOwner:(id<UITraitEnvironment>)owner
                                    lightImage:(UIImage *)lightImage
                                     darkImage:(UIImage *)darkImage {
    if (@available(iOS 13.0, *)) {
        if (lightImage) {
            return [UIImage dm_imageWithLightImage:lightImage darkImage:darkImage];
        }else{
            return nil;
        }
    }else{
        return lightImage;
    }
}


@end
