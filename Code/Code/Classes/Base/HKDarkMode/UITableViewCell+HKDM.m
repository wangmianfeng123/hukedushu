//
//  UITableViewCell+HK.m
//  Code
//
//  Created by ivan on 2020/3/12.
//  Copyright © 2020 pg. All rights reserved.
//

#import "UITableViewCell+HKDM.h"
#import <objc/runtime.h>

@implementation UITableViewCell (HKDM)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(awakeFromNib),
            @selector(init),
            @selector(initWithStyle:reuseIdentifier:)
        };

        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"hkdm_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}


- (instancetype)hkdm_init {
    UITableViewCell  *cell = [self hkdm_init];
    if (cell) {
        [self set_DMContentViewBGColor];
    }
    return cell;
}

- (void)hkdm_awakeFromNib {
    [self hkdm_awakeFromNib];
    [self set_DMContentViewBGColor];
}


- (instancetype)hkdm_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell  *cell = [self hkdm_initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (cell) {
        [self set_DMContentViewBGColor];
    }
    return cell;
}


- (void)set_DMContentViewBGColor {
    self.backgroundColor = COLOR_FFFFFF_3D4752;
//    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
    // 选中cell 颜色
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = COLOR_F8F9FA_333D48;
}

- (UIColor*)separatorLineBGColor {
    return  COLOR_F8F9FA_333D48;
}




@end









@implementation UICollectionViewCell (HKDM)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(awakeFromNib),
            @selector(initWithFrame:),
            @selector(init)
        };

        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"hkdm_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}


- (void)hkdm_awakeFromNib {
    [self hkdm_awakeFromNib];
    [self set_DMContentViewBGColor];
}

- (instancetype)hkdm_init {
    UICollectionViewCell  *cell = [self hkdm_init];
    if (cell) { [self set_DMContentViewBGColor];}
    return cell;
}

- (instancetype)hkdm_initWithFrame:(CGRect)frame {
    UICollectionViewCell *cell = [self hkdm_initWithFrame:frame];
    if (cell) { [self set_DMContentViewBGColor];}
    return cell;
}


- (void)set_DMContentViewBGColor {
    self.backgroundColor = COLOR_FFFFFF_3D4752;
    self.contentView.backgroundColor = COLOR_FFFFFF_3D4752;
}


- (UIColor*)separatorLineBGColor {
    return  COLOR_F8F9FA_333D48;
}


@end


