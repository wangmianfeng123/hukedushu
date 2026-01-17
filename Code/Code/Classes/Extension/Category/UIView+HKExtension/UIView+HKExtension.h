//
//  UIView+HKExtension.h
//  FOF
//
//  Created by hanchuangkeji on 2017/5/5.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunction.h"

#define UIScreenWidth [UIScreen mainScreen].bounds.size.width

#define UIScreenHeight [UIScreen mainScreen].bounds.size.height

#define HKColorFromHex(s,a) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s & 0xFF00) >> 8))/255.0 blue:((s & 0xFF))/255.0  alpha:a]

#define HKReponseOK responseObject[@"code"] && [[NSString stringWithFormat:@"%@", responseObject[@"code"]] isEqualToString:@"1"] && [responseObject isKindOfClass:[NSDictionary class]]





@interface UIView (HKExtension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

+ (instancetype)viewFromXib;



/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;




+ (void) alertWithTitle:(NSString *)title msg:(NSString *)msg;


/**
 获取UIViewController

 @return ViewController
 */
- (UIViewController *)tb_viewController;

@end
