//
//  RegistereView.h
//  Code
//
//  Created by Ivan li on 2017/8/25.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PooCodeView.h"

@class VerificationCodeButton,  HKTextField;

@protocol RegisterVDeletate <NSObject>
@optional
- (void)registerWithAuthcode:(id)sender;

@end



@interface RegistereView:UIView<UITextFieldDelegate>

@property(nonatomic,strong)HKTextField *phoneTextField;

@property(nonatomic,strong)HKTextField *safeCodeTextField;

@property(nonatomic,strong)HKTextField *authCodeTextField;

@property(nonatomic,weak)id<RegisterVDeletate>delegate;
/** 验证码 按钮 */
@property(nonatomic,strong)VerificationCodeButton   *getAuthCodeBtn;
/** 注册 按钮 */
@property(nonatomic,strong)UIButton     *registerBtn;

/** 图形验证码 */
@property (nonatomic, strong) PooCodeView *pooCodeView;

/** 电话 输入框 背景视图 */
@property(nonatomic,strong)UIView *phoneLine;

/** 图形验证码 背景 */
@property(nonatomic,strong)UIView *safeCodeLine;
/** 验证码 输入框 背景视图 */
@property(nonatomic,strong)UIView *authCodeLine;

@property(nonatomic,strong)UILabel *themeLB;

@property(nonatomic,copy) void (^socialphoneLoginBlock)(UIButton *btn,UIButton *selectBtn);

@property(nonatomic,copy) void (^privacyBtnClickBlock)(UIButton *privacyBtn);

@property(nonatomic,copy) void (^agreementBtnClickBlock)(UIButton *agreementBtn);

@property(nonatomic,assign)HKLoginViewThemeType  loginViewThemeType;

/** 注册协议 选择 按钮 */
@property(nonatomic,strong)UIButton *selectBtn;

- (NSString*)phoneText;

- (NSString*)authCodeText;

- (NSString*)safeCodeText;

- (BOOL)isPicCorrect;
@end

