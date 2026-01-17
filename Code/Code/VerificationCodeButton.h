//
//  VerificationCodeButton.h
//  Grape-ToC-Iphone
//
//  Created by Xuehan Gong on 14-5-13.
//  Copyright (c) 2014年 Chexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerificationCodeButtonDelegate <NSObject>

- (void)timerEnd:(id)sender;

@end

@interface VerificationCodeButton : UIButton

/** 按钮圆弧度 默认 7.5 */
@property(nonatomic,assign)float cornerRadius;

/** yes - 正在计时  NO */
@property(nonatomic,assign)BOOL isTiming;

@property(nonatomic,weak) id <VerificationCodeButtonDelegate> delegate;

@property(nonatomic,copy)NSString *normalTitle;


/**
 *  开始倒计时
 */
- (void)startCountDown;

/**
 *  结束倒计时
 */
- (void)stopCountDown;

@end
