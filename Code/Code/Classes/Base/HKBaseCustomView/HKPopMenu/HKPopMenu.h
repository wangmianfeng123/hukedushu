//
//  HKpopMenu.h
//  Code
//
//  Created by Ivan li on 2018/3/14.
//  Copyright © 2018年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@class HKPopMenuView, HKPopMenuItem, HKPopMenuConfiguration;

typedef void (^HKPopMenuItemAction)(HKPopMenuItem * __nullable item);

typedef UITableViewCell * __nonnull (^HKPopMenuCellConfig)(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, HKPopMenuConfiguration * _Nullable option, HKPopMenuItem * _Nullable item);

typedef NS_ENUM(NSUInteger, HKPopMenuAnimationStyle) {
    HKPopMenuAnimationStyleNone,
    HKPopMenuAnimationStyleFade,
    HKPopMenuAnimationStyleScale,
    HKPopMenuAnimationStyleWeiXin,
};

@interface HKPopMenu : NSObject

/**
 展示Menu(CGRect)
 
 @param inView      容器View 默认KeyWindow
 @param rect        触发者的rect(需根据容器View指定rect)
 @param menuItems   items
 @param options     设置
 */
+ (void)showMenuInView:(nullable UIView *)inView
              withRect:(CGRect)rect
             menuItems:(nonnull NSArray<__kindof HKPopMenuItem *> *)menuItems
           withOptions:(nullable HKPopMenuConfiguration *)options;

/**
 展示Menu
 
 @param inView      容器View 默认KeyWindow
 @param view        触发View
 @param menuItems   items
 @param options     设置
 */
+ (void)showMenuInView:(nullable UIView *)inView
              withView:(nonnull UIView *)view
             menuItems:(nonnull NSArray<__kindof HKPopMenuItem *> *)menuItems
           withOptions:(nullable HKPopMenuConfiguration *)options;


/**
 展示Menu
 
 @param view        触发View
 @param menuItems   items
 @param options     设置
 */
+ (void)showMenuWithView:(nonnull UIView *)view
               menuItems:(nonnull NSArray<__kindof HKPopMenuItem *> *)menuItems
             withOptions:(nullable HKPopMenuConfiguration *)options;


/**
 取消展示
 */
+ (void)dismissMenu;

@end





@interface HKPopMenuConfiguration : NSObject

/*********************************  菜单设置 *********************************/

/** 动画风格 */
@property (nonatomic, assign) HKPopMenuAnimationStyle style;
/** 箭头大小 */
@property (nonatomic, assign) CGFloat arrowSize;
/**手动设置箭头和目标view的距离*/
@property (nonatomic, assign) CGFloat arrowMargin;
/** 菜单圆角半径*/
@property (nonatomic, assign) CGFloat menuCornerRadius;
/** 菜单和屏幕左右的最小间距*/
@property (nonatomic, assign) CGFloat menuScreenMinLeftRightMargin;
/** 菜单和屏幕底部的最小间距 */
@property (nonatomic, assign) CGFloat menuScreenMinBottomMargin;
/**菜单最大高度 */
@property (nonatomic, assign) CGFloat menuMaxHeight;
 /** 默认:false 是否添加菜单阴影*/
@property (nonatomic, assign) BOOL shadowOfMenu;
/** 阴影颜色*/
@property (nonatomic, strong, nullable) UIColor *shadowColor;
/** 菜单的底色*/
@property (nonatomic, strong, nullable) UIColor *menuBackgroundColor;
/** 遮罩颜色*/
@property (nonatomic, strong, nullable) UIColor *maskBackgroundColor;
/** 默认:true 旋转屏幕时自动消失 注：false的时候会调用inView的layoutIfNeeded*/
@property (nonatomic, assign) BOOL dismissWhenRotationScreen;
 /** 默认:false 旋转屏幕过程中，如果设置了mask颜色，会有一块白色的区域闪现，这个属性为true时，在设置蒙层的时候直接宽高都为屏幕宽高中的最大值*/
@property (nonatomic, assign) BOOL revisedMaskWhenRotationScreen;
/** 默认:true 是否在点击背景的时候消失*/
@property (nonatomic, assign) BOOL dismissWhenClickBackground;
/**点击背景dismiss的时候会执行*/
@property (nonatomic, copy, nullable) void(^dismissBlock)(void);




/*********************************  MenuItem设置 *********************************/
/** MenuItem左右边距*/
@property (nonatomic, assign) CGFloat marginXSpacing;
/** MenuItem上下边距*/
@property (nonatomic, assign) CGFloat marginYSpacing;
/** MenuItemImage与MenuItemTitle的间距*/
@property (nonatomic, assign) CGFloat intervalSpacing;
/** 分割线左侧Insets*/
@property (nonatomic, assign) CGFloat separatorInsetLeft;
/** 分割线右侧Insets*/
@property (nonatomic, assign) CGFloat separatorInsetRight;
/** 分割线高度*/
@property (nonatomic, assign) CGFloat separatorHeight;
/** 字体大小*/
@property (nonatomic, assign) CGFloat fontSize;
/** 单行高度*/
@property (nonatomic, assign) CGFloat itemHeight;
/** 单行最大宽度*/
@property (nonatomic, assign) CGFloat itemMaxWidth;
/** 文字对齐方式*/
@property (nonatomic, assign) NSTextAlignment alignment;
/** 默认:true 是否设置分割线*/
@property (nonatomic, assign) BOOL hasSeparatorLine;
/** MenuItem字体颜色*/
@property (nonatomic, strong, nullable) UIColor *titleColor;
/** 分割线颜色*/
@property (nonatomic, strong, nullable) UIColor *separatorColor;
/** menuItem选中颜色*/
@property (nonatomic, strong, nullable) UIColor *selectedColor;

// Menu Cell 自定义
@property (nonatomic,copy, nullable) HKPopMenuCellConfig cellForRowConfig; /** MenuCell 自定义，需要自行匹配 MenuItem 的各项配置*/

+ (instancetype _Nullable )defaultConfiguration;

@end





@interface HKPopMenuItem : NSObject

@property (nonatomic, strong, nullable) NSString *title;
/** menuItem字体颜色 优先级大于Configuration的设置*/
@property (nonatomic, strong, nullable) UIColor *titleColor;
/** menuItem字体 优先级大于Configuration的设置*/
@property (nonatomic, strong, nullable) UIFont *titleFont;

@property (nonatomic, strong, nullable) UIImage *image;

@property (nonatomic, assign, nullable, readonly) SEL action;

@property (nonatomic, weak, nullable, readonly) id target;

@property (nonatomic, copy, nullable, readonly) HKPopMenuItemAction block;

- (instancetype _Nullable )initWithTitle:(nullable NSString *)title
                                   image:(nullable UIImage *)image
                                  target:(id _Nullable )target
                                  action:(SEL _Nullable )action;

- (instancetype _Nullable )initWithTitle:(nullable NSString *)title
                        image:(nullable UIImage *)image
                        block:(nullable HKPopMenuItemAction)block;

@end


