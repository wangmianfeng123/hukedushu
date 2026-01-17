//
//  UIBarButtonItem+Extension.m
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+SNFoundation.h"
#import "UIImage+Extension.h"
#import "NSString+MD5.h"


@implementation UIBarButtonItem (Extension)





+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                 color:(UIColor *)color
                                action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:[color colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButtonItem;
}


/**
 *  创建一个item
 *  
 *  @param target    点击item后调用哪个对象的方法
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (instancetype)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}



+ (instancetype)BarButtonItemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title style:style target:target action:action];
}



+ (instancetype)BarButtonRightItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action
{
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageWithName:backgroudImage] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithName:highBackgroudImageName] forState:UIControlStateHighlighted];
    
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 设置按钮的尺寸为背景图片的尺寸
        button.size = button.currentBackgroundImage.size;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return [[self alloc] initWithCustomView:button];
}



#pragma mark - 自定义 右 item  默认大小（图片尺寸）

+ (instancetype)BarButtonRightItemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action size:(CGSize)size
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highImageName] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置按钮的尺寸为图片的尺寸
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        button.size =  button.currentImage.size;
    }else{
        button.size =  size;
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}




+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action
{
//    UIButton *button = [[UIButton alloc] init];
//    [button setBackgroundImage:[UIImage imageWithName:backgroudImage] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageWithName:highBackgroudImageName] forState:UIControlStateHighlighted];
//
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    // 设置按钮的尺寸为背景图片的尺寸
//    button.size = button.currentBackgroundImage.size;
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    return [[self alloc] initWithCustomView:button];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageWithName:backgroudImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highBackgroudImageName] forState:UIControlStateHighlighted];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.size = CGSizeMake(PADDING_35, PADDING_35);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 44/2)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}


#pragma mark - 设置偏移 标题的 item
+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action title:(NSString*)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageWithName:backgroudImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithName:highBackgroudImageName] forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -PADDING_30*5-PADDING_10)];
    [button setTitleColor:COLOR_ffd500 forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    button.size = button.currentBackgroundImage.size;
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}



/**
 *  设置tarbuttoonItem (固定大小)
 *
 *  @param imageName     图片名称
 *  @param highImageName 高亮图片名称
 *  @param title         标题
 *  @param target        回调对象
 *  @param action        回调方法
 *
 *  @return UIBarButtonItem
 */
+ (instancetype)BarButtonItemWithBackgroudImageName:(NSString *)backgroudImage highBackgroudImageName:(NSString *)highBackgroudImageName target:(id)target action:(SEL)action size:(CGSize)size
{
    UIButton *button = [[UIButton alloc] init];
//    [button setBackgroundImage:[UIImage imageWithName:backgroudImage] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageWithName:highBackgroudImageName] forState:UIControlStateHighlighted];

    [button setImage:[UIImage imageWithName:backgroudImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highBackgroudImageName] forState:UIControlStateHighlighted];
    // 设置按钮的尺寸为背景图片的尺寸
//    button.size = button.currentBackgroundImage.size;
    //设置固定按钮的尺寸
    button.size = size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -button.size.width/2)];
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)BarButtonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action size:(CGSize)size
{
    UIButton *button = [[UIButton alloc] init];
//    [button setBackgroundImage:[UIImage imageWithName:backgroudImage] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageWithName:highBackgroudImageName] forState:UIControlStateHighlighted];

    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    // 设置按钮的尺寸为背景图片的尺寸
//    button.size = button.currentBackgroundImage.size;
    //设置固定按钮的尺寸
    button.size = size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -button.size.width/2)];
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}



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
+ (instancetype)BarButtonItemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    
    [button setImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highImageName] forState:UIControlStateHighlighted];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:nil forState:UIControlStateHighlighted];
        button.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:10 ];
    }
    
    // 设置按钮的尺寸为背景图片的尺寸+文字大小
    button.width = [title sizeWithFont:button.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    button.height = button.currentImage.size.height+[title sizeWithFont:button.titleLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    //设置title在button上的位置（上top，左left，下bottom，右right）
    button.titleEdgeInsets = UIEdgeInsetsMake(30,-30, 0, 0);
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}




+ (instancetype)BarButtonItemWithBackgroudImage:(UIImage *)backgroudImage highBackgroudImage:(UIImage *)highBackgroudImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:backgroudImage forState:UIControlStateNormal];
    [button setImage:highBackgroudImageName forState:UIControlStateHighlighted];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.size = CGSizeMake(PADDING_35, PADDING_35);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 44/2)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}


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
+ (instancetype)BarButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action size:(CGSize)size {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    // 设置按钮的尺寸
    button.size = size;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -button.size.width/2)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}



+ (instancetype)BarButtonRightItemWithBackgroudImage:(UIImage *)backgroudImage highBackgroudImageName:(UIImage *)highBackgroudImage target:(id)target action:(SEL)action {
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:backgroudImage forState:UIControlStateNormal];
        [button setBackgroundImage:highBackgroudImage forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 设置按钮的尺寸为背景图片的尺寸
        button.size = button.currentBackgroundImage.size;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return [[self alloc] initWithCustomView:button];
}



@end
