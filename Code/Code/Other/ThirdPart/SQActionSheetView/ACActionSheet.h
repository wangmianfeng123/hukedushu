//
//  ACActionSheet.h
//  ACActionSheetDemo
//
//  Created by Zhangziyun on 16/5/3.
//  Copyright © 2016年 章子云. All rights reserved.
//
//  GitHub:     https://github.com/GardenerYun


#import <UIKit/UIKit.h>

@protocol ACActionSheetDelegate;

typedef void(^ACActionSheetBlock)(NSInteger buttonIndex);

@interface ACActionSheet : UIView

/**
 *  type delegate
 *
 *  @param title                  title            (可以为空)
 *  @param delegate               delegate
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<ACActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  type block
 *
 *  @param title                  title            (可以为空)
 *  @param delegate               delegate
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 *  @param buttonTitleColors       按钮字体颜色
 *  @param cancelTitleColor        取消按钮字体颜色
 */


- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelTitleColor:(UIColor *)cancelTitleColor destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles buttonTitleColors:(NSArray<UIColor*> *)buttonTitleColors actionSheetBlock:(ACActionSheetBlock) actionSheetBlock;

//含图片
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelTitleColor:(UIColor *)cancelTitleColor destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles otherButtonImgs:(NSArray *)buttonImgs buttonTitleColors:(NSArray<UIColor*> *)buttonTitleColors actionSheetBlock:(ACActionSheetBlock) actionSheetBlock;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<ACActionSheetDelegate> delegate;

- (void)show;

@end


#pragma mark - ACActionSheet delegate

@protocol ACActionSheetDelegate <NSObject>

@optional

- (void)actionSheet:(ACActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end
