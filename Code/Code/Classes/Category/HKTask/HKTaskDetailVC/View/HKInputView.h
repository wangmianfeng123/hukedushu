//
//  HKInputView.h
//  HKInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 it7090.com. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HKTaskCountBtn.h"

typedef NS_ENUM(NSInteger,InputViewStyle) {
    InputViewStyleDefault,
    InputViewStyleLarge,
};

@class HKInputView;
@protocol HKInputViewDelagete <NSObject>
@optional

/**
//如果你工程中有配置IQKeyboardManager,并对HKInputView造成影响,
 请在HKInputView将要显示代理方法里 将IQKeyboardManager的enableAutoToolbar及enable属性 关闭
 请在HKInputView将要消失代理方法里 将IQKeyboardManager的enableAutoToolbar及enable属性 打开
 如下:
 
//HKInputView 将要显示
-(void)HKInputViewWillShow:(HKInputView *)inputView{
 [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
 [IQKeyboardManager sharedManager].enable = NO;
}

//HKInputView 将要影藏
-(void)HKInputViewWillHide:(HKInputView *)inputView{
     [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
     [IQKeyboardManager sharedManager].enable = YES;
}
*/

/**
 HKInputView 将要显示
 
 @param inputView inputView
 */
-(void)HKInputViewWillShow:(HKInputView *)inputView;

/**
 HKInputView 将要影藏

 @param inputView inputView
 */
-(void)HKInputViewWillHide:(HKInputView *)inputView;

@end

@interface HKInputView : UIView

@property (nonatomic, assign) id<HKInputViewDelagete> delegate;

/** 最大输入字数 */
@property (nonatomic, assign) NSInteger maxCount;
/** 字体 */
@property (nonatomic, strong) UIFont * font;
/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 输入框背景颜色 */
@property (nonatomic, strong) UIColor* textViewBackgroundColor;
/** 发送按钮背景色 */
@property (nonatomic, strong) UIColor *sendButtonBackgroundColor;
/** 发送按钮Title */
@property (nonatomic, copy) NSString *sendButtonTitle;
/** 发送按钮圆角大小 */
@property (nonatomic, assign) CGFloat sendButtonCornerRadius;
/** 发送按钮字体 */
@property (nonatomic, strong) UIFont * sendButtonFont;
/** 评论数量 */
@property (nonatomic, copy) NSString *commentCount;






/**
 显示输入框

 @param style 类型
 @param configurationBlock 请在此block中设置HKInputView属性
 @param sendBlock 发送按钮点击回调
 */
+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(HKInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text))sendBlock;

@end
