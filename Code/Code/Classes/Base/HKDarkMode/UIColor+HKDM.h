
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HKDM)

// Create color with static light and dark colors.
+ (UIColor *)hkdm_colorWithColorLight:(UIColor *)light dark:(nullable UIColor *)dark;

@end

NS_ASSUME_NONNULL_END
