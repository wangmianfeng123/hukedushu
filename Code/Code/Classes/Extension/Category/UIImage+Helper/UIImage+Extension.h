//
//  UIImage+Extension.h
//  Code
//
//  Created by pg on 16/3/21.
//  Copyright © 2016年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage*) imageWithName:(NSString *) imageName;
+ (UIImage*) resizableImageWithName:(NSString *)imageName;
- (UIImage*) scaleImageWithSize:(CGSize)size;
+ (UIImage *)getLauchImage;
@end
