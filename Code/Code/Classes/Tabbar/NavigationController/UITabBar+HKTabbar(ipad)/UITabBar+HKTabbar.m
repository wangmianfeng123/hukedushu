//
//  UITabBar+HKTabbar.m
//  Code
//
//  Created by Ivan li on 2018/5/7.
//  Copyright © 2018年 pg. All rights reserved.
//

#import "UITabBar+HKTabbar.h"

@implementation UITabBar (HKTabbar)


/** 解决 iPad TabBarItem 图片文字左右排列 改为 上下排列 */
- (UITraitCollection *)traitCollection {
    UITraitCollection *trait = [super traitCollection];
    if (IS_IPAD) {
        UITraitCollection *compact = [UITraitCollection  traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassCompact];
        return [UITraitCollection traitCollectionWithTraitsFromCollections:@[trait, compact]];
    }
    return trait;
}

@end
