//
//  UIFont+HK.m
//  Code
//
//  Created by ivan on 2020/4/27.
//  Copyright © 2020 pg. All rights reserved.
//

#import "UIFont+HK.h"

@implementation UIFont (HK)


+ (UIFont*)timeFontWithFloat:(CGFloat)s {
    if (@available(iOS 9.0, *)) {
        return [UIFont monospacedDigitSystemFontOfSize:(s) weight:UIFontWeightRegular];
    }else{
        return [UIFont systemFontOfSize:(s)];
    }
}

@end
