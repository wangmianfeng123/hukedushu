//
//  UIBarButtonItem+Extension.h
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)


//+ (instancetype)shoppingCartIconWithTarget:(id)target action:(SEL)action;

//+ (instancetype)barButtonItemWithTitle:(NSString *)title
//                                target:(id)target
//                                action:(SEL)action;

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                 color:(UIColor *)color
                                action:(SEL)action;


+ (instancetype)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

+ (instancetype)BarButtonItemWithTitle:(NSString *) title style:(UIBarButtonItemStyle) style target:(id)target action:(SEL) action;

+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action;

/** 根据图片大小 创建图片等大小的 BarButtonItem */
+ (instancetype)BarButtonRightItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action;

+ (instancetype)BarButtonItemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName title:(NSString *)title target:(id)target action:(SEL)action;

+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action size:(CGSize)size;

+ (instancetype)BarButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action size:(CGSize)size;


#pragma mark - 设置偏移 标题的 item
+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action title:(NSString*)title;


/**
 *  自定义 右 item  默认大小（图片尺寸）
 */
+ (instancetype)BarButtonRightItemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action size:(CGSize)size;


+ (instancetype)BarButtonItemWithBackgroudImage:(UIImage *)backgroudImage highBackgroudImage:(UIImage *)highBackgroudImageName target:(id)target action:(SEL)action;

/**
 *  设置tarbuttoonItem
 *
 *  @param imageName     图片名称
 *  @param highImageName 高亮图片名称
 *  @param title         标题
 *  @param target        回调对象
 *  @param action        回调方法
 *
 *  @return UIBarButtonItem
 */
+ (instancetype)BarButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action size:(CGSize)size;



/// 根据图片大小 创建图片等大小的 BarButtonItem
/// @param backgroudImage 普通图片
/// @param highBackgroudImage 选中图片
/// @param target
/// @param action 
+ (instancetype)BarButtonRightItemWithBackgroudImage:(UIImage *)backgroudImage highBackgroudImageName:(UIImage *)highBackgroudImage target:(id)target action:(SEL)action;

@end
