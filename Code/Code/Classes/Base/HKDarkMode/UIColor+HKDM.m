
#import "UIColor+HKDM.h"

@implementation UIColor (HKDM)

+ (UIColor *)hkdm_colorWithColorLight:(UIColor *)light dark:(UIColor *)dark {
    if (@available(iOS 13.0, *)) {
        return [UIColor dm_colorWithLightColor:light darkColor:dark];
    } else {
        return light;
    }
}

@end

